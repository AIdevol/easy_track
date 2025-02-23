// forgot_password_event.dart
part of 'forgot_password_bloc.dart';

sealed class ForgotPasswordEvent extends Equatable {
  const ForgotPasswordEvent();

  @override
  List<Object> get props => [];
}

class SendResetEmail extends ForgotPasswordEvent {
  final String email;

  const SendResetEmail(this.email);

  @override
  List<Object> get props => [email];
}

class VerifyOTP extends ForgotPasswordEvent {
  final String otp;

  const VerifyOTP(this.otp);

  @override
  List<Object> get props => [otp];
}

class TimerTick extends ForgotPasswordEvent {
  final int remainingSeconds;

  const TimerTick(this.remainingSeconds);

  @override
  List<Object> get props => [remainingSeconds];
}

class ResendOTP extends ForgotPasswordEvent {
  const ResendOTP();
}