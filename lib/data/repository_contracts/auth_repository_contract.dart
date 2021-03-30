import 'package:dfapi_auth/models/authentication_response.dart';
import 'package:custom_response/custom_response.dart';
import 'package:dfapi_auth/models/login_model.dart';

abstract class AuthRepositoryContract {
  Future<Response<AuthenticationResponse>> authenticate(LoginModel model);

  Future<Response> logOut();

  Future clearData();

  Response<LoginModel> getLoginData();

  Response<AuthenticationResponse> getAuthData();

  Future<Response<AuthenticationResponse>> refreshToken();
}
