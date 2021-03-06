class DfApiUserInfo {
  final String sub;
  final String name;
  final String familyName;
  final String givenName;
  final String preferredUserName;
  final String locale;
  final String email;
  final String role;
  final dynamic businessItem;

  Map<String, dynamic> _asJson;

  DfApiUserInfo({
    this.sub,
    this.name,
    this.familyName,
    this.givenName,
    this.preferredUserName,
    this.locale,
    this.email,
    this.role,
    this.businessItem,
  });

  factory DfApiUserInfo.fromJson(Map<String, dynamic> json) {
    var userInfo = DfApiUserInfo(
      sub: json["sub"],
      name: json["name"],
      familyName: json["family_name"],
      givenName: json["given_name"],
      preferredUserName: json["preferred_username"],
      locale: json["locale"],
      email: json["email"],
      role: json["role"],
      businessItem: json["BusinessItem"],
    );

    userInfo._asJson = json;

    return userInfo;
  }

  Map<String, dynamic> get asJson => _asJson;
}
