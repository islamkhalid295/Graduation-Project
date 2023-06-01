import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Models/app_config.dart';
import '../../Models/exp_validation.dart';
import '../../Models/simpilifier.dart';
import 'package:meta/meta.dart';

part 'simplification_state.dart';

class SimplificationCubit extends Cubit<SimplificationState> {
  SimplificationCubit() : super(SimplificationInitial()) {
    startPosition = endPosition = controller.text.length;
  }
  String pattern = '';
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
  void updateExpr(String str, String userStr, String pattern) {
    focusNode.requestFocus();
    if (isResultExist) clearAll();
    if (startPosition != controller.selection.start ||
        endPosition != controller.selection.end) {
      startPosition = controller.selection.start;
      endPosition = controller.selection.end;
    }
    if(this.pattern.length>=2) {
      if ((this.pattern[startPosition - 1] == 'o' && this.pattern[startPosition] == 'o') || startPosition != endPosition) {
        del();
      }
    }
    String temp = controller.text.substring(endPosition);
    controller.text = controller.text.substring(0, startPosition) + userStr;
    print('text+str: ${controller.text}, ($startPosition, $endPosition)');
    controller.text += temp;
    userExpr = controller.text;
    // 0110
    this.pattern = this.pattern.substring(0, startPosition) +
        pattern +
        this.pattern.substring(endPosition);
    startPosition = endPosition = pattern.length + endPosition;
    controller.selection =
        TextSelection.fromPosition(TextPosition(offset: endPosition));
    expr = expGenerator(userExpr);
    emit(SimplificationExprUpdate());
  }
  String expGenerator(String s){
    s = s.replaceAll("NAND", "!&");
    s = s.replaceAll("AND", "&");
    s = s.replaceAll("XNOR", "!^");
    s = s.replaceAll("NOR", "!|");
    s = s.replaceAll("XOR", "^");
    s = s.replaceAll("OR", "|");
    s = s.replaceAll("NOT", "~");
    s = s.replaceAll(" ", "");
    return s;
  }

  void getResult() {
    focusNode.requestFocus();
    //code
    // Simplifier simplifier = Simplifier(expr: expr);
    Simplifier simplifier = Simplifier(expr: expr);
    Validator v = Validator(expr, "bin");
    v.validat();
    if(v.error == false) {
      result = simplifier.simpilify();
    }else
      {
        result = "invalid Expression";
      }
    isResultExist = true;
    emit(SimplificationResult());
  }

  void clearAll() {
    focusNode.requestFocus();
    isResultExist = false;
    controller.text = '';
    expr = '';
    pattern = '';
    userExpr = '';
    startPosition = endPosition = userExpr.length;
    controller.selection =
        TextSelection.fromPosition(TextPosition(offset: endPosition));
    emit(SimplificationExprUpdate());
  }

  void del() {
    focusNode.requestFocus();
    int start_t= 0;
    if (startPosition != controller.selection.start ||
        endPosition != controller.selection.end) {
      startPosition = controller.selection.start;
      endPosition = controller.selection.end;
    }
    if (startPosition == endPosition) {
      if (pattern[startPosition - 1] == " ") startPosition--;
      switch (pattern[startPosition - 1]) {
        case "o":
          {
            int end = startPosition - 1;
            int start = startPosition - 1;
            while (pattern[end + 1] == 'o' || pattern[end] == 'o') {
              end++;
              if (end + 1 >= pattern.length - 1) break;
            }
            while (pattern[start - 1] == 'o' || pattern[start ] == 'o') {
              start--;
              if (start == 0) break;
            }
            start_t=start;
            controller.text = controller.text.substring(0, start ) + controller.text.substring(end+1, controller.text.length);
            this.pattern = this.pattern.substring(0, start ) + this.pattern.substring(end+1, pattern.length);
          }
          break;
        case "n":
          {
            if (pattern[startPosition - 1] == " ") startPosition--;

            controller.text = controller.text.substring(0, startPosition - 1) +
                controller.text
                    .substring(startPosition, controller.text.length);
            pattern = pattern.substring(0, startPosition - 1) +
                pattern.substring(startPosition, pattern.length);
            start_t = startPosition - 1;
          }
          break;
        default:
          {
            expr = expr.substring(0, expr.length - 1);
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
          end++;
        }
      }

      if (pattern[startPosition] == 'o') {
        while (pattern[start - 1] == 'o' ) {
          start--;
          if (start == 0) break;
        }
        start--;
        start_t=start;
      }

      if (pattern[startPosition] == 'n') {
        start = startPosition;
        start_t=start;
      }
      if (pattern[endPosition - 1] == 'n') {
        end = endPosition - 1;
        start_t=start;
      }
      controller.text = controller.text.substring(0, start) +
          controller.text.substring(end+1, controller.text.length);
      pattern = pattern.substring(0, start) +
          pattern.substring(end+1, pattern.length);
      expr= expGenerator(controller.text);
    }

    emit(SimplificationExprUpdate());
    startPosition = endPosition = start_t;
    controller.selection =
        TextSelection.fromPosition(TextPosition(offset: endPosition));
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
