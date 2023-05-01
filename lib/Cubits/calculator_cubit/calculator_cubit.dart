import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import '../../Models/digital_parser.dart';
import '../../Models/functions.dart';

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

  int tmp = 0;
  void check() {
    try {
      print(expr);
      Parser p = Parser(expr, curentNumerSystem);
      tmp = p.sampleParser();
      if (p.error) {
        binResult = "Math Error";
        decResult = "Math Error";
        hexResult = "Math Error";
        octResult = "Math Error";
      } else {
        if(isSigned) {
          binResult = tmp.toRadixString(2).toString();
          decResult = tmp.toString();
          hexResult = tmp.toRadixString(16).toString();
          octResult = tmp.toRadixString(8).toString();
          print(binResult);
          print(decResult);
          print(hexResult);
          print(octResult);
        }else {
          binResult = BigInt.from(tmp).toUnsigned(32).toRadixString(2);
          decResult = tmp.toString();
          hexResult = BigInt.from(tmp).toUnsigned(32).toRadixString(16);
          octResult = BigInt.from(tmp).toUnsigned(32).toRadixString(8);
        }
      }
    } catch (e) {
      result = e.toString();
    }

  }
  
  void updateExpr(String str, String userStr) {
    String temp = userExpr.substring(endPosition);
    isResultExist = false;
    result = 'No Result';
    //if (expr.isEmpty) userExpr = '';
    expr += str;
    userExpr = userExpr.substring(0, startPosition);
    userExpr += userStr;
    startPosition = endPosition = userExpr.length;
    userExpr += temp;
    check();
    emit(CalculatorEprUpdate());
  }

  void getResult() {
    //code
    Parser p = Parser(expr, curentNumerSystem);
    tmp = p.sampleParser();
    if (!(p.error)) {
      switch (curentNumerSystem) {
        case "bin":
          {
            result = decToBinary(tmp);
          }
          break;
        case "hex":
          {
            result = decToHex(tmp);
          }
          break;
        case "oct":
          {
            result = decToOctal(tmp);
          }
          break;
        default:
          {
            result = tmp.toString();
          }
      }
    } else
      result = "Math Error";


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
            check();
          }
      }
    }else  expr = expr.substring(0, expr.length - 1);
    check();
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

  void changePosition(int start, int end) {
    startPosition = start;
    endPosition = end;
  }
}
