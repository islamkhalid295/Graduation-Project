import 'package:flutter_bloc/flutter_bloc.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(RegisterInitial());
  bool isSecured = true;
  bool isSecuredConfirm = true;

  void changePassVisibility() {
    isSecured = !isSecured;
    emit(RegisterPass());
  }

  void changeConfirmPassVisibility() {
    isSecuredConfirm = !isSecuredConfirm;
    emit(RegisterConfirmPass());
  }
}
