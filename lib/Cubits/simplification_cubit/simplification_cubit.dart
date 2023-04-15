import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'simplification_state.dart';

class SimplificationCubit extends Cubit<SimplificationState> {
  String expr = '';
  String userExpr = '0';
  String result = 'No Result';

  bool isResultExist = false;
  bool isNormal = true;

  int startIndex = 0;
  int endIndex = 0;

  SimplificationCubit() : super(SimplificationInitial()) {
    startIndex = userExpr.length;
    endIndex = userExpr.length;
  }

  void updateExpr(String str, String userStr) {
    isResultExist = false;
    String temp = userExpr.substring(endIndex);
    userExpr = userExpr.substring(0, startIndex);
    userExpr = userExpr + userStr;
    startIndex = endIndex = userExpr.length;
    userExpr = userExpr + temp;
    emit(SimplificationEprUpdate());
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
    startIndex = userExpr.length;
    endIndex = userExpr.length;
    emit(SimplificationEprUpdate());
  }

  void del() {
    // build body
  }

  void isNormalChanger() {
    isNormal = !isNormal;
    emit(SimplificationIsNormalChange());
  }

  void changeIndex({required int start, required int end}) {
    startIndex = start;
    endIndex = end;
  }
}
