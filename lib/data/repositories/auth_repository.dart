import 'dart:convert';
import 'package:dfapi_auth/models/authentivation_response.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:http/http.dart' as http;

import '../../models/dfapi_user_info.dart';
import '../../models/response.dart';
import '../../models/auth_configuration.dart';
import '../repository_contracts/auth_repository_contract.dart';

class AuthRepository implements AuthRepositoryContract {
  final FlutterAppAuth _appAuth = FlutterAppAuth();
  final AuthConfiguration configuration;

  final String _tokenPrefKey = "DfApiAuthTokenKey";
  final String _tokenExpireDateKey = "DfApiAuthTokeExpireDateKey";
  final String _userInfoPrefKey = "DfApiAuthUserInfoKey";

  AuthRepository(this.configuration);

  ///Identity Server' ın giriş yapma ekranını açar.
  ///Eğer kullanıcı daha önceden giriş yaptıysa, giriş bilgileri tarayıcının
  /// cache' ine kaydedildiği için kullanıcı adı ve şirfe girilmeden otomatik
  /// giriş işlemini yapar.
  ///Giriş işlemi başarılı olursa token ve diğer kullanıcı bilgilerini
  ///[SharedPreferences] ile local' e kaydeder.
  @override
  Future<Response<AuthenticationResponse>> authenticate() async {
    try {
      var response = await _appAuth.authorizeAndExchangeCode(
        AuthorizationTokenRequest(
          configuration.clientId,
          configuration.redirectUrl,
          serviceConfiguration: configuration.serviceConfiguration,
          scopes: configuration.scopes,
        ),
      );

      if (response == null) throw Exception("Authorization failed!");

      //Save Token
      var prefs = await SharedPreferences.getInstance();
      prefs.setString(_tokenPrefKey, response.accessToken);

      //Save Token Expire Date
      prefs.setInt(_tokenExpireDateKey,
          response.accessTokenExpirationDateTime.millisecondsSinceEpoch);

      //Fetch User Info
      var userInfoResponse = await getUserInfo(token: response.accessToken);
      if (!userInfoResponse.isSuccess)
        throw Exception(userInfoResponse.errorMessage);

      await prefs.setString(
          _userInfoPrefKey, jsonEncode(userInfoResponse.value.asJson));

      var authenticationResponse =
          AuthenticationResponse(response.accessToken, userInfoResponse.value);
      return Response.success(authenticationResponse);
    } on Exception catch (e) {
      return Response.error(e.toString());
    }
  }

  ///Oturum açan kullanıcı ile ilgili bilgileri [.../connect/userinfo]
  ///end-point' inden getirir.
  @override
  Future<Response<DfApiUserInfo>> getUserInfo({String token}) async {
    try {
      var prefs = await SharedPreferences.getInstance();

      if (prefs.containsKey(_userInfoPrefKey)) {
        var cacheData = prefs.getString(_userInfoPrefKey);
        var userInfo = DfApiUserInfo.fromJson(jsonDecode(cacheData));
        return Response.success(userInfo);
      }

      if (token == null) {
        var tokenResponse = await getToken();
        if (!tokenResponse.isSuccess)
          return Response.fromResponse(tokenResponse);
        else
          token = tokenResponse.value;
      }

      final http.Response response =
          await http.get("${configuration.issuer}/connect/userinfo", headers: {
        'Authorization': 'Bearer $token',
      });
      if (response.statusCode != 200) {
        return Response.error("Unexpected Error Has Occured!\n" +
            "STATUS CODE: ${response.statusCode}\n" +
            "${response.reasonPhrase}");
      }

      var userInfo = DfApiUserInfo.fromJson(jsonDecode(response.body));
      return Response.success(userInfo);
    } on Exception catch (e) {
      return Response.error(e.toString());
    }
  }

  /// Oturum açan kullanıcı ile ilişkili oluşturulan token' ı getirir.
  @override
  Future<Response<String>> getToken() async {
    try {
      var prefs = await SharedPreferences.getInstance();
      if (!prefs.containsKey(_tokenPrefKey)) {
        return Response.error("Unauthorized!");
      }

      var token = prefs.getString(_tokenPrefKey);
      return Response.success(token);
    } on Exception catch (e) {
      return Response.error(e.toString());
    }
  }

  ///Oturumu sonlandırıp, kayıtlı kullanıcı bilgilerini siler.
  @override
  Future<Response> logOut() async {
    try {
      var tokenResponse = await getToken();
      if (!tokenResponse.isSuccess) return tokenResponse;

      final http.Response response = await http
          .get("${configuration.issuer}/connect/endsession", headers: {
        'Authorization': 'Bearer ${tokenResponse.value}',
      });
      if (response.statusCode != 200) {
        return Response.error('''Unexpected Error Has Occured!\n
            STATUS CODE: ${response.statusCode}\n
            ${response.reasonPhrase}''');
      }

      var prefs = await SharedPreferences.getInstance();
      prefs.remove(_tokenPrefKey);
      prefs.remove(_userInfoPrefKey);
      prefs.remove(_tokenExpireDateKey);

      return Response();
    } on Exception catch (e) {
      return Response.error(e.toString());
    }
  }

  ///Daha önce oturumun açılıp açılmadığını kontrol eder.
  @override
  Future<bool> hasAuthenticated() async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_tokenPrefKey);
  }

  ///Token süresinin dolup dolmadığını kontrol eder.
  @override
  Future<bool> hasTokenExpired() async {
    var prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey(_tokenExpireDateKey)) return true;

    var milliSeconds = prefs.getInt(_tokenExpireDateKey);
    var dateTime = DateTime.fromMillisecondsSinceEpoch(milliSeconds);

    return DateTime.now().isAfter(dateTime);
  }
}
