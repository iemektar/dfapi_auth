import 'package:dfapi_auth/models/dfapi_user_info.dart';

class AuthenticationResponse {
  String token;
  DfApiUserInfo userInfo;

  AuthenticationResponse(String token, DfApiUserInfo userInfo)
      : this.token = token,
        this.userInfo = userInfo;

  AuthenticationResponse.fromJson(Map<String, dynamic> json) {
    if (json["isSuccess"]) {
      var data = json["data"];
      token = data["accessToken"];
      userInfo = DfApiUserInfo.fromJson(data);
    }
  }
}
