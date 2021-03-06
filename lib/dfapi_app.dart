import 'package:dfapi_auth/models/dfapi_user_info.dart';
import 'package:dfapi_auth/presentation/pages/login_page.dart';
import 'package:dfapi_auth/presentation/widgets/error_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'dfapi_app_functions.dart';
import 'presentation/widgets/loading_widget.dart';
import 'bloc/auth_bloc.dart';
import 'bloc/auth_event.dart';
import 'bloc/auth_state.dart';
import 'data/repositories/auth_repository.dart';
import 'data/repository_contracts/auth_repository_contract.dart';
import 'models/dfapi_auth_request.dart';

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
    authBloc = AuthBloc(authRepository: authRepository);
    authBloc.add(AuthEvent.AppStarted);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final request = widget.request;
    return Container(
      child: BlocProvider<AuthBloc>(
        create: (_) => authBloc,
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (BuildContext context, AuthState state) {
            if (state is UnInitialized)
              return request.loadingWidget ?? LoadingWidget();
            if (state is Loading) {
              if (state.showSplash && request.splashWidget != null)
                return request.splashWidget;
              return request.loadingWidget ?? LoadingWidget();
            } else if (state is UnAuthenticated)
              return request.loginWidget ?? LoginPage();
            else if (state is Authenticated) {
              DfApiApp.token = state.token;
              DfApiApp.userInfo = state.userInfo;

              if (request.callBack != null)
                request.callBack(state.token, state.userInfo);
              return request.child;
            } else if (state is AuthenticationFailed) {
              return DfApiErrorWidget(message: state.message);
            }

            return DfApiErrorWidget(message: "Unexpected error has occured!");
          },
        ),
      ),
    );
  }
}
