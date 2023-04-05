import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());
  bool isSecured = true;
  void changePassVisibility() {
    isSecured = !isSecured;
    emit(LoginPass());
  }
}
