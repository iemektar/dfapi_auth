import 'dart:convert';
import 'package:dfapi_auth/models/dfapi_user_info.dart';
import 'package:dfapi_auth/models/login_model.dart';
import 'package:dfapi_auth/models/refresh_token_response.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:custom_response/custom_response.dart';

import '../../models/auth_configuration.dart';
import '../../models/authentication_response.dart';
import '../repository_contracts/auth_repository_contract.dart';

class AuthRepository implements AuthRepositoryContract {
  final AuthConfig config;

  final String _tokenKey = "DfApiAuthTokenKey";
  final String _refreshTokenKey = "DfApiAuthRefreshTokenKey";
  final String _tokenExpireDateKey = "DfApiAuthTokeExpireDateKey";
  final String _userInfoKey = "DfApiAuthUserInfoKey";

  final String _usernameKey = "DfApiAuthUsernameKey";
  final String _passwordKey = "DfApiAuthPasswordKey";

  SharedPreferences _pref;

  AuthRepository(this.config) : _pref = GetIt.I<SharedPreferences>();

  @override
  Future<Response<AuthenticationResponse>> authenticate(
      LoginModel model) async {
    try {
      var data = {
        "Username": model.username,
        "Password": model.password,
      };
      final http.Response loginResponse = await http.post(
        config.loginUrl,
        headers: {"content-type": "application/json"},
        body: jsonEncode(data),
      );

      if (loginResponse.statusCode != 200)
        return Response.error(
          "Unexpected Error Has Occured!\n" +
              "STATUS CODE: ${loginResponse.statusCode}\n" +
              "${loginResponse.reasonPhrase}",
        );

      var response =
          AuthenticationResponse.fromJson(jsonDecode(loginResponse.body));

      if (!response.isSuccess) return Response.error(response.errorMessage);

      await _pref.setString(_tokenKey, response.token);
      await _pref.setString(_refreshTokenKey, response.refreshToken);
      await _pref.setInt(
        _tokenExpireDateKey,
        response.tokenExpireDate.millisecondsSinceEpoch,
      );
      await _pref.setString(_userInfoKey, jsonEncode(response.userInfo.asJson));
      await _pref.setString(_usernameKey, model.username);
      await _pref.setString(_passwordKey, model.password);

      return Response.success(response);
    } catch (e) {
      return Response.error(
        "Unexpected error has occured while authetication ... \n\n" +
            e.toString(),
      );
    }
  }

  @override
  Future<Response> logOut() async {
    try {
      var token = _pref.getString(_tokenKey);

      await clearData();

      if (!config.isRootPath(config.logutUrl)) {
        await http.get(
          config.logutUrl,
          headers: {"Authorization": "Bearer $token"},
        );
      }
      return Response();
    } catch (e) {
      return Response.error(
        "Unexpected error has occured while logout ... \n\n" + e.toString(),
      );
    }
  }

  @override
  Future clearData() async {
    await _pref.remove(_tokenKey);
    await _pref.remove(_userInfoKey);
    await _pref.remove(_tokenExpireDateKey);
    await _pref.remove(_refreshTokenKey);
    await _pref.remove(_usernameKey);
    await _pref.remove(_passwordKey);
  }

  @override
  Response<AuthenticationResponse> getAuthData() {
    if (!_pref.containsKey(_tokenExpireDateKey))
      return Response.error("Token expire date not found!");

    var tokenExpireDate = DateTime.fromMillisecondsSinceEpoch(
      _pref.getInt(_tokenExpireDateKey),
    );

    if (DateTime.now().isAfter(tokenExpireDate))
      return Response.error("Token Expired");

    if (!_pref.containsKey(_tokenKey))
      return Response.error("Unauthorized User!");

    var token = _pref.getString(_tokenKey);

    if (!_pref.containsKey(_refreshTokenKey))
      return Response.error("Refresh token not found! ");

    var refreshToken = _pref.getString(_refreshTokenKey);

    if (!_pref.containsKey(_userInfoKey))
      return Response.error("User data not found!");

    var userInfo = DfApiUserInfo.fromJson(
      jsonDecode(_pref.getString(_userInfoKey)),
    );

    return Response.success(
      AuthenticationResponse(
        token,
        userInfo,
        refreshToken,
        tokenExpireDate,
      ),
    );
  }

  @override
  Future<Response<AuthenticationResponse>> refreshToken() async {
    try {
      var authDataResponse = getAuthData();
      if (!authDataResponse.isSuccess)
        return Response.error(authDataResponse.errorMessage);

      var data = {"RefreshToken": authDataResponse.value.refreshToken};

      final http.Response refreshTokenResponse = await http.post(
        config.refreshTokenUrl,
        headers: {
          "content-type": "application/json",
          "Authorization": "Bearer ${authDataResponse.value.token}"
        },
        body: jsonEncode(data),
      );

      if (refreshTokenResponse.statusCode != 200)
        return Response.error(
          "Unexpected Error Has Occured!\n" +
              "STATUS CODE: ${refreshTokenResponse.statusCode}\n" +
              "${refreshTokenResponse.reasonPhrase}",
        );

      var response = RefreshTokenResponse.fromJson(
        jsonDecode(refreshTokenResponse.body),
      );

      await _pref.setString(_tokenKey, response.token);
      await _pref.setString(_refreshTokenKey, response.refreshToken);
      await _pref.setInt(
        _tokenExpireDateKey,
        response.tokenExpireDate.millisecondsSinceEpoch,
      );

      authDataResponse.value.token = response.token;
      authDataResponse.value.refreshToken = response.refreshToken;
      authDataResponse.value.tokenExpireDate = response.tokenExpireDate;

      return authDataResponse;
    } catch (e) {
      return Response.error(e.toString());
    }
  }

  @override
  Response<LoginModel> getLoginData() {
    if (!_pref.containsKey(_usernameKey) || !_pref.containsKey(_passwordKey))
      return Response.error("User data not found!");

    var username = _pref.getString(_usernameKey);
    var password = _pref.getString(_passwordKey);

    return Response.success(LoginModel(username, password));
  }
}
