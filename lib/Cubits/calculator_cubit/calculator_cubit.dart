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

  int startPosition = 0;
  int endPosition = 0;

  void updateExpr(String str, String userStr) {
    String temp = userExpr.substring(endPosition);
    isResultExist = false;
    result = 'No Result';
    //if (expr.isEmpty) userExpr = '';
    //expr += str;
    userExpr = userExpr.substring(0, startPosition);
    userExpr += userStr;
    startPosition = endPosition = userExpr.length;
    userExpr += temp;
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
    userExpr = '';
    startPosition = endPosition = userExpr.length;
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

  void changePosition(int start, int end) {
    startPosition = start;
    endPosition = end;
  }
}
