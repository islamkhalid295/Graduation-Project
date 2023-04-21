part of 'register_cubit.dart';

abstract class RegisterState {}

class RegisterInitial extends RegisterState {}

class RegisterSuccess extends RegisterState {}

class RegisterFailure extends RegisterState {
  Map<String, String> errors;
  RegisterFailure({required this.errors}):super();
}

class RegisterLoading extends RegisterState {}

class RegisterPass extends RegisterState {}

class RegisterConfirmPass extends RegisterState {}
