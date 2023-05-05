import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import '../../Models/digital_parser.dart';
import '../../Models/functions.dart';

part 'calculator_state.dart';

class CalculatorCubit extends Cubit<CalculatorState> {
  CalculatorCubit() : super(CalculatorInitial());

  String expr = '';
  String userExpr = '';
  String pattern = '';
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
        if (isSigned) {
          binResult = tmp.toRadixString(2).toString();
          decResult = tmp.toString();
          hexResult = tmp.toRadixString(16).toString();
          octResult = tmp.toRadixString(8).toString();
          print(binResult);
          print(decResult);
          print(hexResult);
          print(octResult);
        } else {
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

  void updateExpr(String str, String userStr, String pattern) {
    String temp = userExpr.substring(endPosition);
    isResultExist = false;
    result = 'No Result';
    //if (expr.isEmpty) userExpr = '';
    expr += str;
    userExpr = userExpr.substring(0, startPosition);
    userExpr += userStr;
    this.pattern += pattern;
    startPosition = endPosition = userExpr.length;
    userExpr += temp;
    check();
    emit(CalculatorExprUpdate());
  }

  void getResult() {
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
    pattern = '';
    userExpr = '';
    startPosition = endPosition = userExpr.length;
    emit(CalculatorExprUpdate());
  }

  void del() {
    if (startPosition == endPosition) {
      if (pattern[startPosition - 1] == " ") startPosition--;
      switch (pattern[startPosition - 1]) {
        case "o":
          {
            int end = startPosition - 1;
            int start = startPosition - 1;
            while (pattern[end + 1] == 'o') {
              end++;
              if (end + 1 >= pattern.length - 1) break;
            }
            while (pattern[start - 1] == 'o') {
              start--;
              if (start == 0) break;
            }
            userExpr = userExpr.substring(0, start - 1) +
                userExpr.substring(end + 2, userExpr.length);
            pattern = pattern.substring(0, start - 1) +
                pattern.substring(end + 2, pattern.length);
          }
          break;
        case "n":
          {
            if (pattern[startPosition - 1] == " ") startPosition--;

            userExpr = userExpr.substring(0, startPosition - 1) +
                userExpr.substring(startPosition, userExpr.length);
            pattern = pattern.substring(0, startPosition - 1) +
                pattern.substring(startPosition, pattern.length);
          }
          break;
        default:
          {
            expr = expr.substring(0, expr.length - 1);
            check();
          }
      }
    } else {
      if (pattern[startPosition] == " ") startPosition++;
      if (pattern[endPosition - 1] == " ") endPosition--;

      int end = endPosition - 1;
      int start = startPosition;
      if (pattern[endPosition - 1] == 'o') {
        if (end < pattern.length - 1) {
          while (pattern[end + 1] == 'o') {
            end++;
            if (end + 1 >= pattern.length - 1) break;
          }
        }
      }
      if (pattern[startPosition] == 'o') {
        while (pattern[start - 1] == 'o') {
          start--;
          if (start == 0) break;
        }
      }

      if (pattern[startPosition] == 'n') {
        start= startPosition;
      }
      if(pattern[endPosition - 1] == 'n'){
        end = endPosition-2;
      }
      userExpr = userExpr.substring(0, start) +
          userExpr.substring(end + 2, userExpr.length);
      pattern = pattern.substring(0, start) +
          pattern.substring(end + 2, pattern.length);
    }

    emit(CalculatorExprUpdate());
    check();
    startPosition = endPosition = userExpr.length;
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
