import 'package:meta/meta.dart';

class AuthConfig {
  String _address;
  String _loginPath;
  String _refreshTokenPath;
  String _logoutPath;

  AuthConfig({
    @required String address,
    String loginPath = "auth/login",
    String refreshTokenPath = "auth/refreshToken",
    String logoutPath = "",
  }) : assert(address.length > 0) {
    _address = address.trim();
    _loginPath = loginPath.trim();
    _refreshTokenPath = refreshTokenPath.trim();
    _logoutPath = logoutPath.isNotEmpty ? logoutPath.trim() : "";

    if (_address[_address.length - 1] != '/') _address += "/";
    if (_loginPath[0] == "/") _loginPath = _loginPath.substring(1);
    if (_refreshTokenPath[0] == "/")
      _refreshTokenPath = _refreshTokenPath.substring(1);

    if (_logoutPath != null && _logoutPath.isNotEmpty && _logoutPath[0] == "/")
      _logoutPath = _logoutPath.substring(1);
  }

  String get loginUrl => (_address + _loginPath);
  String get refreshTokenUrl => (_address + _refreshTokenPath);
  String get logutUrl => (_address + _logoutPath);
  bool isRootPath(String path) => path == _address;
}
