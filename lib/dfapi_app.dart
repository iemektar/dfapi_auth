import 'dart:async';

import 'dfapi_app_functions.dart';
import 'models/dfapi_user_info.dart';
import 'models/dfapi_auth_request.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import 'presentation/pages/error_page.dart';
import 'presentation/pages/login_page.dart';
import 'presentation/widgets/loading_widget.dart';

import 'bloc/auth_bloc.dart';
import 'bloc/auth_event.dart';
import 'bloc/auth_state.dart';

import 'data/repositories/auth_repository.dart';
import 'data/repository_contracts/auth_repository_contract.dart';

class DfApiApp extends StatefulWidget {
  final DfApiAuthRequest request;

  static DfApiAppFunctions functions = DfApiAppFunctions(_DfApiApp.authBloc);
  static DfApiUserInfo userInfo;
  static String token;

  DfApiApp({
    Key key,
    this.request,
  }) : super(key: key);

  @override
  _DfApiApp createState() => _DfApiApp();
}

class _DfApiApp extends State<DfApiApp> {
  static AuthBloc authBloc;

  AuthRepository get authRepository =>
      AuthRepository(widget.request.configuration);

  _DfApiApp() : super() {
    var isRegistered = GetIt.instance.isRegistered<AuthRepositoryContract>();

    if (!isRegistered) {
      GetIt.instance
          .registerLazySingleton<AuthRepositoryContract>(() => authRepository);
    }
  }

  @override
  void initState() {
    authBloc = AuthBloc(authRepository)..add(AppStarted());
    super.initState();
  }

  @override
  void dispose() {
    authBloc.close();
    super.dispose();
  }

  Widget get loadingWidget => widget.request.loadingWidget ?? LoadingWidget();

  @override
  Widget build(BuildContext context) {
    final request = widget.request;
    return Container(
      child: BlocProvider<AuthBloc>(
        create: (_) => authBloc,
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (BuildContext context, AuthState state) {
            if (state is UnInitialized) return loadingWidget;
            if (state is Loading) {
              if (state.showSplash && request.splashWidget != null)
                return request.splashWidget;
              return loadingWidget;
            } else if (state is UnAuthenticated)
              return request.loginWidget ?? LoginPage();
            else if (state is Authenticated) {
              Timer(
                Duration(seconds: state.tokenRefreshInterval),
                () => authBloc..add(TokenExpired()),
              );
              DfApiApp.token = state.token;
              DfApiApp.userInfo = state.userInfo;

              if (request.callBack != null)
                request.callBack(state.token, state.userInfo);
              return request.child;
            } else if (state is Failed) {
              return DfApiErrorPage(message: state.message);
            }

            return DfApiErrorPage(message: "Unexpected error has occured!");
          },
        ),
      ),
    );
  }
}
