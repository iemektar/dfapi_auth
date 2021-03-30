class RefreshTokenResponse {
  String token;
  String refreshToken;
  DateTime tokenExpireDate;

  RefreshTokenResponse.fromJson(Map<String, dynamic> json) {
    if (json["isSuccess"]) {
      var data = json["data"];
      token = data["accessToken"];
      refreshToken = data["refreshToken"];
      var milliseconds = data["tokenExpireTimestamp"] as int;
      tokenExpireDate = DateTime.fromMillisecondsSinceEpoch(milliseconds);
    }
  }
}
