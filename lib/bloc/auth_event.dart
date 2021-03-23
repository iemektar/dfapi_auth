import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {}

class AppStarted extends AuthEvent {
  @override
  List<Object> get props => [];
}

class LogIn extends AuthEvent {
  final String username;
  final String password;

  LogIn(this.username, this.password);

  @override
  List<Object> get props => [username, password];
}

class LogOut extends AuthEvent {
  @override
  List<Object> get props => [];
}
