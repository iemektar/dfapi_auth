import 'package:dfapi_auth/models/dfapi_user_info.dart';

class AuthenticationResponse {
  String token;
  DfApiUserInfo userInfo;

  AuthenticationResponse(String token, DfApiUserInfo userInfo)
      : this.token = token,
        this.userInfo = userInfo;

  AuthenticationResponse.fromJson(dynamic json);
}
