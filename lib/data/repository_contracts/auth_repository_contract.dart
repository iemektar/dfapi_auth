import 'package:dfapi_auth/models/authentication_response.dart';
import 'package:dfapi_auth/models/response.dart';

abstract class AuthRepositoryContract {
  Future<Response<AuthenticationResponse>> authenticate(
      String username, String password);

  Future<Response> logOut();

  Future clearData();

  Response<AuthenticationResponse> getAuthData();
}
