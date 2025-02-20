part of 'signup_view_bloc.dart';

sealed class SignupViewState extends Equatable {
  const SignupViewState();
  
  @override
  List<Object> get props => [];
}

final class SignupViewInitial extends SignupViewState {}
