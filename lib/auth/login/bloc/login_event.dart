part of 'login_bloc.dart';

@immutable
sealed class LoginEvent {}

class LoginEmail extends LoginEvent {
  final String email;
  LoginEmail(this.email);
}

class LogInPassword extends LoginEvent {
  final String password;
  LogInPassword(this.password);
}
