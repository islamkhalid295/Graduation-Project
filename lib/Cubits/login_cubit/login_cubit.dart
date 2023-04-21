import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final _auth = FirebaseAuth.instance;
  LoginCubit() : super(LoginInitial());
  bool isSecured = true;
  void changePassVisibility() {
    isSecured = !isSecured;
    emit(LoginPass());
  }
  void firebaseAuth(

      String email, String pass,BuildContext context) async {
    Map<String, String> errors = {
      'email': '',
      'pass': '',
    };
    emit(LoginLoading());
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

    if (flag) {
      try {
        final userlogin =await  _auth.signInWithEmailAndPassword(
            email: email, password: pass);

        emit(LoginSuccess());
        if (userlogin != null) {
          Navigator.of(context).pushReplacementNamed('/calculator');
        }

      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          if (errors['email']!.isEmpty) {
            errors['email'] = 'User Not found';
          }
        }
        if (e.code == 'wrong-password') {
          if (errors['pass']!.isEmpty) {
            errors['pass'] = 'Wrong password.';
          }
          // Not Provided Yet.
          // else if(e.code=='too-many-requests'){
          //   errors['pass']='too many requests';
          // }
        }
        emit(LoginFailure(errors: errors));
      } catch (e) {
        print(e);
      }
    } else {
      emit(LoginFailure(errors: errors));
    }
  }
}
