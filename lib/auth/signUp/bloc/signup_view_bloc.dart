import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'signup_view_event.dart';
part 'signup_view_state.dart';

class SignupViewBloc extends Bloc<SignupViewEvent, SignupViewState> {
  SignupViewBloc() : super(SignupViewInitial()) {
    on<SignupViewEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
