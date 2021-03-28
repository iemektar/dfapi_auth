class DfApiUserInfo {
  final String name;
  final String familyName;
  final String givenName;
  final String email;
  final String role;
  final List<String> businessItems;

  Map<String, dynamic> _asJson;

  DfApiUserInfo({
    this.name,
    this.familyName,
    this.givenName,
    this.email,
    this.role,
    this.businessItems,
  });

  factory DfApiUserInfo.fromJson(Map<String, dynamic> json) {
    var userInfo = DfApiUserInfo(
      name: json["name"],
      familyName: json["familyName"],
      givenName: json["givenName"],
      email: json["email"],
      role: json["role"],
      businessItems:
          (json["businessItems"] as List<dynamic>).cast<String>().toList(),
    );

    userInfo._asJson = json;

    return userInfo;
  }

  Map<String, dynamic> get asJson => _asJson;
}
