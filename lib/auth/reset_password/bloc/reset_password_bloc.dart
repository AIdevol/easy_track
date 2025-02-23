import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'reset_password_event.dart';
part 'reset_password_state.dart';

class ResetPasswordBloc extends Bloc<ResetPasswordEvent, ResetPasswordState> {
  ResetPasswordBloc() : super(ResetPasswordInitial()) {
    on<ResetPassword>(_onResetPassword);
  }

  Future<void> _onResetPassword(
      ResetPassword event,
      Emitter<ResetPasswordState> emit,
      ) async {
    try {
      emit(ResetPasswordLoading());

      // Simulate API call with delay
      await Future.delayed(const Duration(seconds: 2));

      // Add your actual API call here
      // await authRepository.resetPassword(event.newPassword);

      emit(ResetPasswordSuccess());
    } catch (e) {
      emit(ResetPasswordError(
        message: e.toString(),
      ));
    }
  }
}