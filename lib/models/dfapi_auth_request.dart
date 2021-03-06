import 'package:dfapi_auth/models/dfapi_user_info.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'auth_configuration.dart';

class DfApiAuthRequest {
  final Widget child;
  final AuthConfiguration configuration;
  final Widget loginWidget;
  final Widget loadingWidget;
  final Widget splashWidget;
  Function(String, DfApiUserInfo) callBack;

  DfApiAuthRequest({
    @required this.child,
    @required this.configuration,
    this.loginWidget,
    this.loadingWidget,
    this.splashWidget,
    Function(String, DfApiUserInfo) callBack,
  }) : this.callBack = callBack;
}
