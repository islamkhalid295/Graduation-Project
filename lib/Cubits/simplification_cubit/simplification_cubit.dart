import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'simplification_state.dart';

class SimplificationCubit extends Cubit<SimplificationState> {
  SimplificationCubit() : super(SimplificationInitial()) {
    startPosition = expr.length;
    endPosition = expr.length;
  }

  String expr = '';
  String userExpr = '';
  String result = 'No Result';

  bool isResultExist = false;
  bool isNormal = true;

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

    emit(SimplificationEprUpdate());
    //print('$startPosition, $endPosition');
  }

  void getResult() {
    //code
    isResultExist = true;
    emit(SimplificationResult());
  }

  void clearAll() {
    isResultExist = false;
    expr = '';
    userExpr = '';
    startPosition = endPosition = userExpr.length;
    emit(SimplificationEprUpdate());
  }

  void del() {
    if(expr.length>=2) {
      switch (expr[expr.length - 2]) {
        case "<":
          {
            if((expr[expr.length - 1]) == "<")
              expr = expr.substring(0, expr.length - 2);
            else expr = expr.substring(0, expr.length - 1);
          }
          break;
        case ">":
          {
            if(expr.length - 1 == ">")
              expr = expr.substring(0, expr.length - 2);
            else expr = expr.substring(0, expr.length - 1);

          }
          break;
        case "!":
          {
            switch (expr[expr.length - 1]) {
              case "&":
                {
                  expr = expr.substring(
                      0, expr.length - 2);
                }
                break;
              case "|":
                {
                  expr = expr.substring(
                      0, expr.length - 2);
                }
                break;
              case "^":
                {
                  expr = expr.substring(
                      0, expr.length - 2);
                }
                break;
            }
          }
          break;
        default:
          {
            expr = expr.substring(0, expr.length - 1);

          }
      }
    }else  expr = expr.substring(0, expr.length - 1);

  }

  void isNormalChanger() {
    isNormal = !isNormal;
    emit(SimplificationIsNormalChange());
  }

  void changePosition(int start, int end) {
    startPosition = start;
    endPosition = end;
  }
}
