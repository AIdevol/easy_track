// forgot_password_bloc.dart
import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'forgot_password_event.dart';
part 'forgot_password_state.dart';

class ForgotPasswordBloc extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  Timer? _timer;

  ForgotPasswordBloc() : super(const ForgotPasswordInitial()) {
    on<SendResetEmail>(_onSendResetEmail);
    on<VerifyOTP>(_onVerifyOTP);
    on<TimerTick>(_onTimerTick);
    on<ResendOTP>(_onResendOTP);
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(
      const Duration(seconds: 1),
          (timer) {
        if (state is ForgotPasswordOTPSent) {
          final currentState = state as ForgotPasswordOTPSent;
          if (currentState.remainingSeconds > 0) {
            add(TimerTick(currentState.remainingSeconds - 1));
          } else {
            timer.cancel();
          }
        }
      },
    );
  }

  Future<void> _onSendResetEmail(
      SendResetEmail event,
      Emitter<ForgotPasswordState> emit,
      ) async {
    emit(ForgotPasswordLoading());
    try {
      // TODO: Implement actual email sending logic
      await Future.delayed(const Duration(seconds: 1)); // Simulate API call
      emit(const ForgotPasswordOTPSent(remainingSeconds: 30));
      _startTimer();
    } catch (e) {
      emit(ForgotPasswordError(e.toString()));
    }
  }

  Future<void> _onVerifyOTP(
      VerifyOTP event,
      Emitter<ForgotPasswordState> emit,
      ) async {
    emit(ForgotPasswordLoading());
    try {
      // TODO: Implement actual OTP verification logic
      await Future.delayed(const Duration(seconds: 1)); // Simulate API call
      if (event.otp == '123456') { // Replace with actual verification
        emit(ForgotPasswordSuccess());
      } else {
        emit(const ForgotPasswordError('Invalid OTP'));
      }
    } catch (e) {
      emit(ForgotPasswordError(e.toString()));
    }
  }

  void _onTimerTick(
      TimerTick event,
      Emitter<ForgotPasswordState> emit,
      ) {
    emit(ForgotPasswordOTPSent(remainingSeconds: event.remainingSeconds));
  }

  Future<void> _onResendOTP(
      ResendOTP event,
      Emitter<ForgotPasswordState> emit,
      ) async {
    emit(ForgotPasswordLoading());
    try {
      // TODO: Implement actual resend logic
      await Future.delayed(const Duration(seconds: 1)); // Simulate API call
      emit(const ForgotPasswordOTPSent(remainingSeconds: 30));
      _startTimer();
    } catch (e) {
      emit(ForgotPasswordError(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}