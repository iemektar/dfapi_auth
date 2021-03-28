import 'package:dfapi_auth/models/login_model.dart';
import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {}

class AppStarted extends AuthEvent {
  @override
  List<Object> get props => [];
}

class LogIn extends AuthEvent {
  final LoginModel model;
  LogIn(this.model);

  @override
  List<Object> get props => [model.username, model.password];
}

class LogOut extends AuthEvent {
  @override
  List<Object> get props => [];
}
