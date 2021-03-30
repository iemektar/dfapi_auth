import 'package:dfapi_auth/models/dfapi_user_info.dart';

class AuthenticationResponse {
  String token;
  String refreshToken;
  DateTime tokenExpireDate;
  DfApiUserInfo userInfo;

  AuthenticationResponse(
    String token,
    DfApiUserInfo userInfo,
    String refreshToken,
    DateTime tokenExpireDate,
  )   : this.token = token,
        this.userInfo = userInfo,
        this.refreshToken = refreshToken,
        this.tokenExpireDate = tokenExpireDate;

  AuthenticationResponse.fromJson(Map<String, dynamic> json) {
    if (json["isSuccess"]) {
      var data = json["data"];
      token = data["accessToken"];
      refreshToken = data["refreshToken"];
      var milliseconds = data["tokenExpireTimestamp"] as int;
      tokenExpireDate = DateTime.fromMillisecondsSinceEpoch(milliseconds);
      userInfo = DfApiUserInfo.fromJson(data);
    }
  }
}
