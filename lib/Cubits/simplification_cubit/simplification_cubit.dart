import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'simplification_state.dart';

class SimplificationCubit extends Cubit<SimplificationState> {
  SimplificationCubit() : super(SimplificationInitial());

  String expr = '';
  String userExpr = '0';
  String result = 'No Result';

  bool isResultExist = false;
  bool isNormal = true;

  void updateExpr(String str, String userStr) {
    isResultExist = false;
    result = 'No Result';
    if (expr.isEmpty) userExpr = '';
    expr += str;
    userExpr += userStr;
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
    userExpr = '0';
    emit(SimplificationEprUpdate());
  }

  void del() {}

  void isNormalChanger() {
    isNormal = !isNormal;
    emit(SimplificationIsNormalChange());
  }
}
