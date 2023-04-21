part of 'login_cubit.dart';

@immutable
abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginSuccess extends LoginState {}

class LoginFailure extends LoginState {
  Map<String, String> errors;
  LoginFailure({required this.errors}):super();
}

class LoginLoading extends LoginState {}

class LoginPass extends LoginState {}
