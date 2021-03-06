import 'package:dfapi_auth/models/dfapi_user_info.dart';

class AuthenticationResponse {
  final String token;
  final DfApiUserInfo userInfo;

  AuthenticationResponse(this.token, this.userInfo);
}
