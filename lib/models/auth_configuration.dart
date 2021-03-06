import 'package:flutter_appauth/flutter_appauth.dart';

class AuthConfiguration {
  final String issuer;
  final String clientId;
  final String redirectUrl;
  String discoveryUrl;

  final List<String> scopes;

  AuthorizationServiceConfiguration _serviceConfiguration;

  AuthConfiguration({
    this.issuer,
    this.clientId,
    this.redirectUrl,
    this.scopes,
  }) {
    _serviceConfiguration = AuthorizationServiceConfiguration(
      '$issuer/connect/authorize',
      '$issuer/connect/token',
    );

    discoveryUrl = "$issuer/.well-known/openid-configuration";
  }

  AuthorizationServiceConfiguration get serviceConfiguration =>
      _serviceConfiguration;
}
