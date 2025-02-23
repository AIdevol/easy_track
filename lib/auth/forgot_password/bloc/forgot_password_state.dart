// forgot_password_state.dart
part of 'forgot_password_bloc.dart';

sealed class ForgotPasswordState extends Equatable {
  const ForgotPasswordState();

  @override
  List<Object> get props => [];
}

class ForgotPasswordInitial extends ForgotPasswordState {
  const ForgotPasswordInitial();
}

class ForgotPasswordLoading extends ForgotPasswordState {}

class ForgotPasswordOTPSent extends ForgotPasswordState {
  final int remainingSeconds;

  const ForgotPasswordOTPSent({required this.remainingSeconds});

  @override
  List<Object> get props => [remainingSeconds];
}

class ForgotPasswordSuccess extends ForgotPasswordState {}

class ForgotPasswordError extends ForgotPasswordState {
  final String message;

  const ForgotPasswordError(this.message);

  @override
  List<Object> get props => [message];
}