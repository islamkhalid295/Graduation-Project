import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'calculator_state.dart';

class CalculatorCubit extends Cubit<CalculatorState> {
  String expr = '';
  String userExpr = '';
  String result = '0';
  String binResult = '0';
  String octResult = '0';
  String decResult = '0';
  String hexResult = '0';
  String curentNumerSystem = 'bin';

  bool isResultExist = false;
  bool isSigned = true;

  int startIndex = 0;
  int endIndex = 0;

  CalculatorCubit() : super(CalculatorInitial()) {
    startIndex = userExpr.length;
    endIndex = userExpr.length;
  }

  void updateExpr(String userStr) {
    isResultExist = false;
    String temp = userExpr.substring(endIndex);
    userExpr = userExpr.substring(0, startIndex);
    userExpr = userExpr + userStr;
    startIndex = endIndex = userExpr.length;
    userExpr = userExpr + temp;
    emit(CalculatorEprUpdate());
  }

  // void generateParserExpr() {
  //   // build body
  // }

  void getResult() {
    //generateParserExpr();
    //code
    isResultExist = true;
    emit(CalculatorResult());
  }

  void clearAll() {
    isResultExist = false;
    expr = '';
    userExpr = '';
    startIndex = userExpr.length;
    endIndex = userExpr.length;
    emit(CalculatorEprUpdate());
  }

  void del() {
    // build body
  }

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

  void changeIndex({required int start, required int end}) {
    startIndex = start;
    endIndex = end;
  }
}
