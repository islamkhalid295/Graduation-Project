import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:graduation_project/Cubits/theme_cubit/theme_cubit.dart';
import 'package:graduation_project/Models/app_config.dart';
import 'package:meta/meta.dart';

import '../../Models/digital_parser.dart';
import '../../Models/functions.dart';

part 'calculator_state.dart';

class CalculatorCubit extends Cubit<CalculatorState> {
  CalculatorCubit() : super(CalculatorInitial()) {
    startPosition = endPosition = controller.text.length;
    userExpr = controller.text;
  }

  String expr = '';
  late String userExpr;
  String result = '0';
  String binResult = '0';
  String octResult = '0';
  String decResult = '0';
  String hexResult = '0';
  String curentNumerSystem = 'bin';
  bool isResultExist = false;
  bool isSigned = true;

  late int startPosition, endPosition;

  TextEditingController controller = TextEditingController();
  FocusNode focusNode = FocusNode();
  List<Map<String, String>> testCalculatorHistory = [
    {
      'expr': '1 AND 2 OR 3',
      'system': 'dec',
    },
    {
      'expr': '1 AND 2 OR 3',
      'system': 'oct',
    },
    {
      'expr': '11 AND 10 OR 101',
      'system': 'bin',
    },
    {
      'expr': '1 AND 2 OR 3',
      'system': 'dec',
    },
    {
      'expr': '1 AND F OR A1',
      'system': 'hex',
    },
    {
      'expr': '1 AND 2 OR 3',
      'system': 'dec',
    },
    {
      'expr': '1 AND 2 OR 3',
      'system': 'oct',
    },
    {
      'expr': '11 AND 10 OR 101',
      'system': 'bin',
    },
    {
      'expr': '1 AND 2 OR 3',
      'system': 'dec',
    },
    {
      'expr': '1 AND F OR A1',
      'system': 'hex',
    },
    {
      'expr': '1 AND 2 OR 3',
      'system': 'dec',
    },
    {
      'expr': '1 AND 2 OR 3',
      'system': 'oct',
    },
    {
      'expr': '11 AND 10 OR 101',
      'system': 'bin',
    },
    {
      'expr': '1 AND 2 OR 3',
      'system': 'dec',
    },
    {
      'expr': '1 AND F OR A1',
      'system': 'hex',
    },
  ];
  int tmp = 0;
  void check() {
    try {
      // print(expr);
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
          // print(binResult);
          // print(decResult);
          // print(hexResult);
          // print(octResult);
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

  // void updateExpr(String str, String userStr) {
  //   String temp = userExpr.substring(endPosition);
  //   isResultExist = false;
  //   result = 'No Result';
  //   //if (expr.isEmpty) userExpr = '';
  //   expr += str;
  //   userExpr = userExpr.substring(0, startPosition);
  //   userExpr += userStr;
  //   startPosition = endPosition = userExpr.length;
  //   userExpr += temp;
  //   check();
  //   emit(CalculatorExprUpdate());
  // }

  void updateExpr(String str, String userStr) {
    focusNode.requestFocus();
    if (isResultExist) clearAll();
    //print('user Str: $userStr');
    if (startPosition != controller.selection.start ||
        endPosition != controller.selection.end) {
      startPosition = controller.selection.start;
      endPosition = controller.selection.end;
    }
    // print('( ${controller.selection.start}, ${controller.selection.end})');
    String temp = controller.text.substring(endPosition);
    //print('temp: ${temp}, ($startPosition, $endPosition)');
    controller.text = controller.text.substring(0, startPosition) + userStr;
    print('text+str: ${controller.text}, ($startPosition, $endPosition)');
    startPosition = endPosition = controller.text.length;
    controller.text += temp;
    controller.selection =
        TextSelection.fromPosition(TextPosition(offset: endPosition));
    // print('msg: ${controller.text}, ($startPosition, $endPosition)');
    userExpr = controller.text;
    expr += str;
    check();
    emit(CalculatorExprUpdate());
  }

  void getResult() {
    focusNode.requestFocus();
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
    focusNode.requestFocus();
    isResultExist = false;
    controller.text = '';
    expr = '';
    userExpr = '';
    startPosition = endPosition = userExpr.length;
    emit(CalculatorExprUpdate());
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
            check();
          }
      }
    } else
      expr = expr.substring(0, expr.length - 1);
    userExpr = expr.replaceAll("&", " AND ").replaceAll("|", " OR ");
    emit(CalculatorExprUpdate());
    check();
    startPosition = endPosition = userExpr.length;
  }

  void changeNumberSystem(String system) {
    focusNode.requestFocus();
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
    focusNode.requestFocus();
    isSigned = !isSigned;
    emit(CalculatorIsSignedChange());
  }

  void setExpr(String expr) {
    controller.text = expr;
    // call the generateExpr()
    // check();
    emit(CalculatorExprUpdate());
  }

  void showHistory(
    BuildContext context,
    String theme,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (context) => BlocBuilder<CalculatorCubit, CalculatorState>(
        buildWhen: (previous, current) => current is CalculatorHistoryUpdate,
        builder: (context, state) => ListView.builder(
          itemCount: testCalculatorHistory.length,
          itemBuilder: (context, index) => Dismissible(
            key: Key('cal$index'),
            direction: DismissDirection.startToEnd,
            onDismissed: (direction) => testCalculatorHistory.removeAt(index),
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
                      testCalculatorHistory.removeAt(index);
                      emit(CalculatorHistoryUpdate());
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
                setExpr(testCalculatorHistory[index]['expr']!);
                Navigator.of(context).pop();
              },
              title: Text(
                testCalculatorHistory[index]['expr']!,
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
