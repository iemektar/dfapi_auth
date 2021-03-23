import 'package:meta/meta.dart';

class AuthConfig {
  String _address;
  String _loginPath;
  String _logoutPath;

  AuthConfig({
    @required String address,
    String loginPath = "auth/login",
    String logoutPath = "auth/logout",
  })  : _address = address,
        _loginPath = loginPath,
        _logoutPath = logoutPath;

  String get address => _address;
  String get loginPath => _loginPath;
  String get logoutPath => _logoutPath;

  String get loginUrl => (_address + "/" + _loginPath).replaceAll("//", "/");
  String get logutUrl => (_address + "/" + _logoutPath).replaceAll("//", "/");
}
