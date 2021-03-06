import 'package:dfapi_auth/models/authentivation_response.dart';

import '../../models/dfapi_user_info.dart';
import '../../models/response.dart';

abstract class AuthRepositoryContract {
  ///Identity Server' ın giriş yapma ekranını açar.
  ///Eğer kullanıcı daha önceden giriş yaptıysa, giriş bilgileri tarayıcının
  /// cache' ine kaydedildiği için kullanıcı adı ve şirfe girilmeden otomatik
  /// giriş işlemini yapar.
  ///Giriş işlemi başarılı olursa token ve diğer kullanıcı bilgilerini
  ///[SharedPreferences] ile local' e kaydeder.
  Future<Response<AuthenticationResponse>> authenticate();

  ///Oturum açan kullanıcı ile ilgili bilgileri [.../connect/userinfo]
  ///end-point' inden getirir.
  Future<Response<DfApiUserInfo>> getUserInfo({String token});

  /// Oturum açan kullanıcı ile ilişkili oluşturulan token' ı getirir.
  Future<Response<String>> getToken();

  ///Oturumu sonlandırıp, kayıtlı kullanıcı bilgilerini siler.
  Future<Response> logOut();

  ///Daha önce oturumun açılıp açılmadığını kontrol eder.
  Future<bool> hasAuthenticated();

  ///Token süresinin dolup dolmadığını kontrol eder.
  Future<bool> hasTokenExpired();
}
