import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'calculator_state.dart';

class CalculatorCubit extends Cubit<CalculatorState> {
  CalculatorCubit() : super(CalculatorInitial());

  String expr = '';
  String userExpr = '0';
  String result = '0';
  String binResult = '0';
  String octResult = '0';
  String decResult = '0';
  String hexResult = '0';
  String curentNumerSystem = 'bin';

  bool isResultExist = false;
  bool isSigned = true;

  void updateExpr(String str, String userStr) {
    isResultExist = false;
    if (expr.isEmpty) userExpr = '';
    expr += str;
    userExpr += userStr;
    emit(CalculatorEprUpdate());
  }

  void getResult() {
    //code
    isResultExist = true;
    emit(CalculatorResult());
  }

  void clearAll() {
    isResultExist = false;
    expr = '';
    userExpr = '0';
    emit(CalculatorEprUpdate());
  }

  void del() {}

  void changeNumberSystem(String system) {
    if (system == 'bin') {
      curentNumerSystem = 'bin';
      result = binResult;
    } else if (system == 'oct') {
      curentNumerSystem = 'oct';
      result = octResult;
    } else if (system == 'dec') {
      curentNumerSystem = 'dec';
      result = decResult;
    } else {
      curentNumerSystem = 'hex';
      result = hexResult;
    }
    emit(CalculatorNumberSystemChange());
    emit(CalculatorResult());
  }

  void isSignedChanger() {
    isSigned = !isSigned;
    emit(CalculatorIsSignedChange());
  }
}
