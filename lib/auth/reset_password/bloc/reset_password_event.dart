part of 'reset_password_bloc.dart';

@immutable
sealed class ResetPasswordEvent {}

class ResetPassword extends ResetPasswordEvent {
  final String newPassword;

  ResetPassword(this.newPassword);
}
