import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final _auth = FirebaseAuth.instance;

  RegisterCubit() : super(RegisterInitial());
  bool isSecured = true;
  bool isSecuredConfirm = true;

  // void passwordValidation(String pass) {
  //   if (pass.isEmpty) {
  //     emit(RegisterFailure(errorField: 'pass', errorMsg: "password can not be empty"));
  //   }
  // }
  // void emailValidation(String email) {
  //   if (email.isEmpty ||
  //       !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[gmail]+\.[com]+")
  //           .hasMatch(email)) {
  //     emit(RegisterFailure(errorField: 'email', errorMsg: "Enter correct Email"));
  //   }
  // }

  // void  confirmPasswordValidation(String confirmPass) {
  //   if (confirmPass.isEmpty) {
  //     emit(RegisterFailure(errorField: 'confirm', errorMsg: "enter confirm password"));
  //   }
  // }

  // void checkPass(String pass, String confirmPass) {
  //   if (pass != confirmPass) {
  //     emit(RegisterFailure(errorField: 'pass,confirm', errorMsg:"not equal password" ));
  //   }
  // }

  void changePassVisibility() {
    isSecured = !isSecured;
    emit(RegisterPass());
  }

  void firebaseAuth(

      String email, String pass, String confirmPass,BuildContext context) async {
    Map<String, String> errors = {
      'email': '',
      'pass': '',
      'confirm': '',
    };
    emit(RegisterLoading());
    bool flag = true;
    if (email.isEmpty) {
      errors['email'] = 'Required Field';
      flag = false;
    } else if(!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[gmail]+\.[com]+")
        .hasMatch(email)){
      errors['email'] = 'Not valid email';
      flag = false;
    }
    if (pass.isEmpty) {
      errors['pass'] = 'Required Field';
      flag = false;
    }
    if (confirmPass.isEmpty) {
      errors['confirm'] = 'Required Field';
      flag = false;
    }
    if (pass != confirmPass) {
      if (errors['pass']!.isEmpty) {
        errors['pass'] = 'Not equal password';
        flag = false;
      } else {
        errors['pass'] = '${errors['pass']!}\nNot equal password';
        flag = false;
      }
      if (errors['confirm']!.isEmpty) {
        errors['confirm'] = 'Not equal password';
        flag = false;
      } else {
        errors['confirm'] = '${errors['confirm']!}\nNot equal password';
        flag = false;
      }
    }
    if (flag) {
      try {
        await _auth.createUserWithEmailAndPassword(
            email: email, password: pass);
        emit(RegisterSuccess());
        Navigator.of(context).pushReplacementNamed('/calculator');
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          if (errors['pass']!.isEmpty) {
            errors['pass'] = 'The password provided is too weak.';
          } else {
            errors['pass'] =
            '${errors['pass']!}\nThe password provided is too weak.';
          }
        } else if (e.code == 'email-already-in-use') {
          if (errors['pass']!.isEmpty) {
            errors['pass'] = 'The account already exists for that email.';
          } else {
            errors['pass'] =
            '${errors['pass']!}\nThe account already exists for that email.';
          }
        }
        emit(RegisterFailure(errors: errors));
      } catch (e) {
        print(e);
      }
    } else {
      emit(RegisterFailure(errors: errors));
    }
  }
  void changeConfirmPassVisibility() {
    isSecuredConfirm = !isSecuredConfirm;
    emit(RegisterConfirmPass());
  }
}
