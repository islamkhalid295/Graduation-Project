import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Models/app_config.dart';
import '../../Models/simpilifier.dart';
import 'package:meta/meta.dart';

part 'simplification_state.dart';

class SimplificationCubit extends Cubit<SimplificationState> {
  SimplificationCubit() : super(SimplificationInitial()) {
    startPosition = endPosition = controller.text.length;
  }

  String expr = '';
  String userExpr = '';
  String result = 'No Result';

  bool isResultExist = false;
  bool isNormal = true;

  late int startPosition, endPosition;
  TextEditingController controller = TextEditingController();
  FocusNode focusNode = FocusNode();
  List<String> testSimplificationHistory = [
    'A AND B OR C XOR D',
    'A AND B ( OR C XOR D )',
    'A OR B OR C XOR D',
    'A AND B AND ( C XOR D )',
    'A AND B OR C XOR D',
    'A AND B OR C XOR D',
    'A AND B ( OR C XOR D )',
    'A OR B OR C XOR D',
    'A AND B AND ( C XOR D )',
    'A AND B OR C XOR D',
    'A AND B OR C XOR D',
    'A AND B ( OR C XOR D )',
    'A OR B OR C XOR D',
    'A AND B AND ( C XOR D )',
    'A AND B OR C XOR D',
    'A AND B OR C XOR D',
    'A AND B ( OR C XOR D )',
    'A OR B OR C XOR D',
    'A AND B AND ( C XOR D )',
    'A AND B OR C XOR D',
  ];

  // void updateExpr(String str, String userStr) {
  //   String temp = userExpr.substring(endPosition);
  //   isResultExist = false;
  //   result = 'No Result';
  //   //if (expr.isEmpty) userExpr = '';
  //   //expr += str;
  //   userExpr = userExpr.substring(0, startPosition);
  //   userExpr += userStr;
  //   startPosition = endPosition = userExpr.length;
  //   userExpr += temp;

  //   emit(SimplificationEprUpdate());
  //   //print('$startPosition, $endPosition');
  // }
  void updateExpr(String str, String userStr) {
    focusNode.requestFocus();
    if (isResultExist) clearAll();
    // print('user Str: $userStr');
    if (startPosition != controller.selection.start ||
        endPosition != controller.selection.end) {
      startPosition = controller.selection.start;
      endPosition = controller.selection.end;
    }
    // print('( ${controller.selection.start}, ${controller.selection.end})');
    String temp = controller.text.substring(endPosition);
    // print('temp: ${temp}, ($startPosition, $endPosition)');
    controller.text = controller.text.substring(0, startPosition) + userStr;
    // print('text+str: ${controller.text}, ($startPosition, $endPosition)');
    startPosition = endPosition = controller.text.length;
    controller.text += temp;
    controller.selection =
        TextSelection.fromPosition(TextPosition(offset: endPosition));
    // print('msg: ${controller.text}, ($startPosition, $endPosition)');
    userExpr = controller.text;
    expr += str;
    isResultExist = false;
    emit(SimplificationExprUpdate());
  }

  void getResult() {
    focusNode.requestFocus();
    //code
    // Simplifier simplifier = Simplifier(expr: expr);
    Simplifier simplifier = Simplifier(expr: expr);
    result = simplifier.simpilify();
    isResultExist = true;
    emit(SimplificationResult());
  }

  void clearAll() {
    focusNode.requestFocus();
    isResultExist = false;
    controller.text = '';
    expr = '';
    result = 'No Result';
    startPosition = endPosition = userExpr.length;
    emit(SimplificationExprUpdate());
    emit(SimplificationResult());
  }

  void del() {
    focusNode.requestFocus();
    if (expr.length >= 2) {
      switch (expr[expr.length - 2]) {
        case "<":
          {
            if ((expr[expr.length - 1]) == "<")
              expr = expr.substring(0, expr.length - 2);
            else
              expr = expr.substring(0, expr.length - 1);
          }
          break;
        case ">":
          {
            if (expr.length - 1 == ">")
              expr = expr.substring(0, expr.length - 2);
            else
              expr = expr.substring(0, expr.length - 1);
          }
          break;
        case "!":
          {
            switch (expr[expr.length - 1]) {
              case "&":
                {
                  expr = expr.substring(0, expr.length - 2);
                }
                break;
              case "|":
                {
                  expr = expr.substring(0, expr.length - 2);
                }
                break;
              case "^":
                {
                  expr = expr.substring(0, expr.length - 2);
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
    } else
      expr = expr.substring(0, expr.length - 1);
  }

  void isNormalChanger() {
    focusNode.requestFocus();
    isNormal = !isNormal;
    emit(SimplificationIsNormalChange());
  }

  void setExpr(String expr) {
    controller.text = expr;
    // call the generateExpr()
    // check();
    emit(SimplificationExprUpdate());
  }

  void showHistory(
    BuildContext context,
    String theme,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (context) =>
          BlocBuilder<SimplificationCubit, SimplificationState>(
        buildWhen: (previous, current) =>
            current is SimplificationHistoryUpdate,
        builder: (context, state) => ListView.builder(
          itemCount: testSimplificationHistory.length,
          itemBuilder: (context, index) => Dismissible(
            key: Key('cal$index'),
            direction: DismissDirection.startToEnd,
            onDismissed: (direction) =>
                testSimplificationHistory.removeAt(index),
            confirmDismiss: (direction) => showDialog(
              context: context,
              builder: (context) => AlertDialog(
                content: const Text('Are you sure ,you want to delete it?'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: theme == 'light'
                          ? ThemeColors.lightBlackText
                          : ThemeColors.darkWhiteText,
                    ),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      testSimplificationHistory.removeAt(index);
                      emit(SimplificationHistoryUpdate());
                      Navigator.of(context).pop();
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: ThemeColors.redColor,
                    ),
                    child: const Text('Delete'),
                  ),
                ],
              ),
            ),
            background: Container(
              color: ThemeColors.redColor,
              child: Row(
                children: [
                  SizedBox(
                    width: SizeConfig.widthBlock! * 2,
                  ),
                  const Icon(
                    Icons.delete,
                    color: ThemeColors.darkWhiteText,
                  ),
                ],
              ),
            ),
            secondaryBackground: Container(
              color: ThemeColors.redColor,
              child: Row(
                children: [
                  SizedBox(
                    width: SizeConfig.widthBlock! * 2,
                  ),
                  const Icon(
                    Icons.delete,
                    color: ThemeColors.darkWhiteText,
                  ),
                ],
              ),
            ),
            child: ListTile(
              onTap: () {
                setExpr(testSimplificationHistory[index]);
                Navigator.of(context).pop();
              },
              title: Text(
                testSimplificationHistory[index],
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold),
                softWrap: true,
              ),
              textColor: (theme == 'light')
                  ? ThemeColors.lightForegroundTeal
                  : ThemeColors.darkForegroundTeal,
              tileColor: (theme == 'light')
                  ? ThemeColors.lightCanvas
                  : ThemeColors.darkCanvas,
            ),
          ),
        ),
      ),
    );
  }
  // void changePosition(int start, int end) {
  //   startPosition = start;
  //   endPosition = end;
  // }
}
