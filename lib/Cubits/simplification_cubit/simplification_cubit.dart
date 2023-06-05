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

  void updateExpr(String str, String userStr, String pattern) {
    focusNode.requestFocus();
    if (isResultExist) clearAll();
    if (startPosition != controller.selection.start ||
        endPosition != controller.selection.end) {
      startPosition = controller.selection.start;
      endPosition = controller.selection.end;
    }
    if (this.pattern.length >= 2) {
      if ((this.pattern[startPosition - 1] == 'o' &&
              this.pattern[startPosition] == 'o') ||
          startPosition != endPosition) {
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
    emit(SimplificationExprUpdate());
  }

  String expGenerator(String s) {
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
    expr = expGenerator(controller.text);
    Simplifier simplifier = Simplifier(expr: expr);
    Validator v = Validator(expr, "bin");
    v.validat();
    if (v.error == false) {
      result = simplifier.simpilify();
    } else {
      result = "invalid Expression";
    }
    print('truth table: \n${simplifier.getTruthTableData(expr)}');
    print('Comparison Steps: \n${simplifier.comparisonSteps}');
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
    int start_t = 0;
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
            while (pattern[start - 1] == 'o' || pattern[start] == 'o') {
              start--;
              if (start == 0) break;
            }
            start_t = start;
            controller.text = controller.text.substring(0, start) +
                controller.text.substring(end + 1, controller.text.length);
            this.pattern = this.pattern.substring(0, start) +
                this.pattern.substring(end + 1, pattern.length);
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
        while (pattern[start - 1] == 'o') {
          start--;
          if (start == 0) break;
        }
        start--;
        start_t = start;
      }

      if (pattern[startPosition] == 'n') {
        start = startPosition;
        start_t = start;
      }
      if (pattern[endPosition - 1] == 'n') {
        end = endPosition - 1;
        start_t = start;
      }
      controller.text = controller.text.substring(0, start) +
          controller.text.substring(end + 1, controller.text.length);
      pattern = pattern.substring(0, start) +
          pattern.substring(end + 1, pattern.length);
      expr = expGenerator(controller.text);
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

  void showTruthTable(BuildContext context, String theme) {
    expr = expGenerator(controller.text);
    print(expr);
    Validator v = Validator(expr, "bin");
    v.validat();
    if (v.error == false) {
      Simplifier simplifier = Simplifier(expr: expr);
      showModalBottomSheet(
          context: context,
          builder: (context) {
            List<Map<String, dynamic>> table =
                List.from(simplifier.getTruthTableData(expr)['table']!);
            return createTT(
              simplifier,
              table,
              theme,
            );
          },
          backgroundColor: theme == 'light'
              ? ThemeColors.lightCanvas
              : ThemeColors.darkCanvas);
    } else {
      result = "invalid Expression";
    }
  }

  void showExplanation(BuildContext context, String theme) {
    Color textColor = theme == 'light'
        ? ThemeColors.lightBlackText
        : ThemeColors.darkWhiteText;
    Color focusedTextColor = ThemeColors.blueColor;
    Color resultFocusedTextColor = ThemeColors.redColor;
    expr = expGenerator(controller.text);
    print(expr);
    Validator v = Validator(expr, "bin");
    v.validat();
    if (v.error == false) {
      Simplifier simplifier = Simplifier(expr: expr);
      simplifier.simpilify();
      List<Map<String, dynamic>> table =
          List.from(simplifier.getTruthTableData(expr)['table']!);
      List<int> soms = List.from(simplifier.getTruthTableData(expr)['soms']!);
      List<List<Map<String, dynamic>>> steps = List.from(simplifier
          .comparisonSteps
          .sublist(0, simplifier.comparisonSteps.length - 1));
      List<String> finalTerms = List.empty(growable: true);
      simplifier.comparisonSteps.last.forEach(
        (element) => finalTerms.add(element['som']),
      );
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          scrollable: true,
          backgroundColor: theme == 'light'
              ? ThemeColors.lightCanvas
              : ThemeColors.darkCanvas,
          title: Text(
            'Explanation',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: theme == 'light'
                  ? ThemeColors.lightForegroundTeal
                  : ThemeColors.darkForegroundTeal,
            ),
          ),
          titleTextStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: textColor,
          ),
          content: SizedBox(
            height: SizeConfig.heightBlock! * 50,
            width: SizeConfig.widthBlock! * 75,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text.rich(
                    TextSpan(
                      text: "First: ",
                      children: [
                        TextSpan(
                          text: "We Calculate the Truth Table",
                          style: TextStyle(
                            color: textColor,
                          ),
                        ),
                      ],
                      style: TextStyle(
                        color: focusedTextColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: SizeConfig.heightBlock! * 2,
                  ),
                  createTT(simplifier, table, theme),
                  SizedBox(
                    height: SizeConfig.heightBlock! * 2,
                  ),
                  Text.rich(
                    TextSpan(
                      text: "The Sum Of Minterms (SOM) is: ",
                      children: [
                        TextSpan(
                          text: soms.join(', '),
                          style: TextStyle(
                            color: resultFocusedTextColor,
                          ),
                        ),
                      ],
                      style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: SizeConfig.heightBlock! * 2,
                  ),
                  Text.rich(
                    TextSpan(
                      text: "Second: ",
                      children: [
                        TextSpan(
                          text: "We Apply the tabular method:-",
                          style: TextStyle(
                            color: textColor,
                          ),
                        ),
                      ],
                      style: TextStyle(
                        color: focusedTextColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: SizeConfig.heightBlock! * 2,
                  ),
                  ...steps
                      .map((step) => createQuineTable(step, theme)!)
                      .toList(),
                  SizedBox(
                    height: SizeConfig.heightBlock! * 2,
                  ),
                  Text.rich(
                    TextSpan(
                      text: "Third: ",
                      children: [
                        TextSpan(
                          text: "We choose only the independent rows:-",
                          style: TextStyle(
                            color: textColor,
                          ),
                        ),
                      ],
                      style: TextStyle(
                        color: focusedTextColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: SizeConfig.heightBlock! * 2,
                  ),
                  createDependancyTeble(
                      simplifier.comparisonSteps.last, soms, theme),
                  SizedBox(
                    height: SizeConfig.heightBlock! * 2,
                  ),
                  Text.rich(
                    TextSpan(
                      text: "Third: ",
                      children: [
                        TextSpan(
                          text: "We choose only the independent rows",
                          style: TextStyle(
                            color: textColor,
                          ),
                        ),
                      ],
                      style: TextStyle(
                        color: focusedTextColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: SizeConfig.heightBlock! * 2,
                  ),
                  Text.rich(
                    TextSpan(
                      text: "We have The terms: ",
                      children: [
                        TextSpan(
                          text: '{${finalTerms.join(' ,  ')}}',
                          style: TextStyle(
                            color: resultFocusedTextColor,
                          ),
                        ),
                      ],
                      style: TextStyle(
                        color: focusedTextColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: SizeConfig.heightBlock! * 2,
                  ),
                  Text.rich(
                    TextSpan(
                      text: "Fourth: ",
                      children: [
                        TextSpan(
                          text:
                              "We convert theas terms into a new simplified expression (ignore -, 0 is the complement):",
                          style: TextStyle(
                            color: textColor,
                          ),
                        ),
                      ],
                      style: TextStyle(
                        color: focusedTextColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: SizeConfig.heightBlock! * 2,
                  ),
                  Text(BlocProvider.of<SimplificationCubit>(context).result,
                      style: TextStyle(
                        color: resultFocusedTextColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      )),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            )
          ],
        ),
      );
    } else {
      result = "invalid Expression";
    }
  }

  Widget createTT(
      Simplifier simplifier, List<Map<String, dynamic>> table, String theme) {
    TextStyle style = TextStyle(
      fontSize: SizeConfig.heightBlock! * 2.5,
      fontWeight: FontWeight.bold,
      color: theme == 'light'
          ? ThemeColors.lightBlackText
          : ThemeColors.darkWhiteText,
    );
    TextStyle somStyle = TextStyle(
      fontSize: SizeConfig.heightBlock! * 2.5,
      fontWeight: FontWeight.bold,
      color: ThemeColors.redColor,
    );
    TextStyle headerStyle = TextStyle(
      fontSize: SizeConfig.heightBlock! * 2.75,
      fontWeight: FontWeight.bold,
      color: ThemeColors.blueColor,
    );
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: DataTable(
            border: TableBorder.all(
                borderRadius: BorderRadius.circular(5),
                color: theme == 'light'
                    ? ThemeColors.lightElemBG
                    : ThemeColors.darkElemBG,
                width: 2),
            columns: [
              DataColumn(
                  label: Text(
                'Index',
                style: headerStyle,
              )),
              ...simplifier.vars
                  .map((e) => DataColumn(
                          label: Text(
                        e,
                        style: headerStyle,
                      )))
                  .toList(),
              DataColumn(
                  label: Text(
                'Fun Value',
                style: headerStyle,
              )),
            ],
            rows: table
                .map(
                  (e) => DataRow(cells: [
                    DataCell(
                      Text(
                        e['index'].toString(),
                        style: (e['functionResult'] != 1) ? style : somStyle,
                      ),
                    ),
                    for (int i = 0; i < simplifier.vars.length; i++)
                      DataCell(Text(
                        e['bin'][i].toString(),
                        style: (e['functionResult'] != 1) ? style : somStyle,
                      )),
                    DataCell(
                      Text(
                        e['functionResult'].toString(),
                        style: (e['functionResult'] != 1) ? style : somStyle,
                      ),
                    ),
                  ]),
                )
                .toList(),
          ),
        ),
      ),
    );
  }

  Widget? createQuineTable(List<Map<String, dynamic>> step, String theme) {
    TextStyle style = TextStyle(
      fontSize: SizeConfig.heightBlock! * 2.5,
      fontWeight: FontWeight.bold,
      color: theme == 'light'
          ? ThemeColors.lightBlackText
          : ThemeColors.darkWhiteText,
    );
    // TextStyle somStyle = TextStyle(
    //   fontSize: SizeConfig.heightBlock! * 2.5,
    //   fontWeight: FontWeight.bold,
    //   color: ThemeColors.redColor,
    // );
    TextStyle headerStyle = TextStyle(
      fontSize: SizeConfig.heightBlock! * 2.75,
      fontWeight: FontWeight.bold,
      color: ThemeColors.blueColor,
    );
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: DataTable(
            border: TableBorder.all(
                borderRadius: BorderRadius.circular(5),
                color: theme == 'light'
                    ? ThemeColors.lightElemBG
                    : ThemeColors.darkElemBG,
                width: 2),
            columns: [
              DataColumn(
                label: Text(
                  '',
                  style: headerStyle,
                ),
              ),
              DataColumn(
                label: Text(
                  'SOM',
                  style: headerStyle,
                ),
              ),
              DataColumn(
                label: Text(
                  'Click',
                  style: headerStyle,
                ),
              ),
            ],
            rows: step
                .map(
                  (e) => DataRow(
                    cells: [
                      DataCell(Text(
                        e['soms'].toString(),
                        style: style,
                      )),
                      DataCell(Text(
                        e['som'],
                        style: style,
                      )),
                      DataCell(e['click']
                          ? const Icon(
                              Icons.check,
                              color: ThemeColors.redColor,
                            )
                          : const Text('')),
                    ],
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }

  Widget createDependancyTeble(
      List<Map<String, dynamic>> finalStep, List<int> soms, String theme) {
    TextStyle style = TextStyle(
      fontSize: SizeConfig.heightBlock! * 2.5,
      fontWeight: FontWeight.bold,
      color: theme == 'light'
          ? ThemeColors.lightBlackText
          : ThemeColors.darkWhiteText,
    );
    TextStyle somStyle = TextStyle(
      fontSize: SizeConfig.heightBlock! * 2.5,
      fontWeight: FontWeight.bold,
      color: ThemeColors.redColor,
    );
    TextStyle headerStyle = TextStyle(
      fontSize: SizeConfig.heightBlock! * 2.75,
      fontWeight: FontWeight.bold,
      color: ThemeColors.blueColor,
    );
    List<Set<int>> finalSoms = List.empty(growable: true);
    finalStep.forEach((element) {
      finalSoms.add(element['soms']);
    });
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: DataTable(
            border: TableBorder.all(
                borderRadius: BorderRadius.circular(5),
                color: theme == 'light'
                    ? ThemeColors.lightElemBG
                    : ThemeColors.darkElemBG,
                width: 2),
            columns: [
              const DataColumn(
                label: Text(''),
              ),
              ...soms
                  .map((e) => DataColumn(
                          label: Text(
                        e.toString(),
                        style: headerStyle,
                      )))
                  .toList(),
            ],
            rows: finalStep
                .map(
                  (e) => DataRow(
                    cells: [
                      DataCell(Text(
                        e['som'],
                        style: style,
                      )),
                      ...soms
                          .map((v) => DataCell((e['soms'] as Set).contains(v)
                              ? const Icon(Icons.check)
                              : const Text('')))
                          .toList()
                    ],
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}
