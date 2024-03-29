import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../Models/app_config.dart';
import '../../Models/exp_validation.dart';
import '../../Models/simpilifier.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart';
import 'dart:async';

import '../login_cubit/login_cubit.dart';

part 'simplification_state.dart';

class SimplificationCubit extends Cubit<SimplificationState> {
  SimplificationCubit() : super(SimplificationInitial()) {
    startPosition = endPosition = controller.text.length;
    userExpr = controller.text;
    testCalculatorHistory = List.empty(growable: true);
  }

  String pattern = '';
  String expr = '';
  String userExpr = '';
  String result = 'No Result';

  bool isResultExist = false;
  bool isNormal = true;

  GlobalKey pageKey = GlobalKey();
  GlobalKey historyKey = GlobalKey();
  GlobalKey resultKey = GlobalKey();
  GlobalKey keyboardKey = GlobalKey();
  GlobalKey explanationKey = GlobalKey();
  GlobalKey simplifyKey = GlobalKey();
  GlobalKey showTTKey = GlobalKey();
  GlobalKey menuKey = GlobalKey();

  late int startPosition, endPosition;
  TextEditingController controller = TextEditingController();
  FocusNode focusNode = FocusNode();
  final _auth = FirebaseAuth.instance;
  late List<Map<String, String>> testCalculatorHistory;
  SqlDbSimlification sqlDbSimlification = SqlDbSimlification();

  final _historySimp = FirebaseFirestore.instance.collection('simplification');

  Future<void> sendWhatsAppMessage(String text) async {
    final Uri _url = Uri.parse('whatsapp://send?+02?&text=$text');
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  Future<void> sendEmailMessage(String text) async {
    final Uri _url = Uri.parse('mailto:?subject=hellow&body=$text');
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  void updatehistorySimplification() async {
    int count = await sqlDbSimlification.getlenght();
    List<Map> res = await sqlDbSimlification.readData();
    if (count > 0) {
      for (int i = 0; i < count; i++) {
        addUserHistorySimlification(res[i]['operation']);
        await sqlDbSimlification.deleteData(i + 1);
      }
    }
  }

  void addHistoryLocalSimlification() async {
    int response = await sqlDbSimlification.insertData(userExpr);
  }

  Future<void> addUserHistorySimlification(xtext) {
    return _historySimp
        .add({
          'operation': xtext, // add history
          'user': _auth.currentUser?.email //currentuser
        })
        .then(
            (value) => print("User History Added ${_auth.currentUser?.email}"))
        .catchError((error) {
          print("Failed to add user History: ");
          addHistoryLocalSimlification();
        });
  }

  Future<void> deleteHistoryDataSimlification(String oper) async {
    CollectionReference HistroyData =
        FirebaseFirestore.instance.collection('simplification');
    await HistroyData.where("user", isEqualTo: _auth.currentUser?.email)
        .where("operation", isEqualTo: oper)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((docId) {
        HistroyData.doc(docId.id)
            .delete()
            .then((value) => print("operation Deleted"))
            .catchError((error) => print("Failed to delete operation: $error"));
      });
    });
  }

  Future<void> deleteHistoryLocal(String expr) async {
    List<Map> res = await sqlDbSimlification.readData();
    int count = await sqlDbSimlification.getlenght();
    for (int i = 0; i < count; i++) {
      if (res[i]['operation'] == expr) {
        await sqlDbSimlification.deleteData(res[i]['id']);
        print("dddddddddddddddddddddddddddddddddddddddd");
      }
    }
  }

  Future<void> cleareHistoryDataSimlification() async {
    CollectionReference HistroyData =
        FirebaseFirestore.instance.collection('simplification');
    await HistroyData.where("user", isEqualTo: _auth.currentUser?.email)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((docId) {
        HistroyData.doc(docId.id)
            .delete()
            .then((value) => print("operation Deleted"))
            .catchError((error) => print("Failed to delete operation: $error"));
      });
    });
  }

  Future<void> clearHistoryLocal() async {
    List<Map> res = await sqlDbSimlification.readData();
    int count = await sqlDbSimlification.getlenght();
    for (int i = 0; i < count; i++) {
      await sqlDbSimlification.deleteData(res[i]['id']);
      print("cccccccccccccccccccccccccccccccc");
    }
  }

  Future<void> getHistoryDataSimlification() async {
    testCalculatorHistory.clear();
    CollectionReference HistroyData =
        FirebaseFirestore.instance.collection('simplification');
    await HistroyData.where("user", isEqualTo: _auth.currentUser?.email)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        testCalculatorHistory.add(
          {
            'expr': element.get('operation'),
          },
        );
      });
    });
    emit(SimplificationHistoryUpdate());
  }

  Future<void> getHistoryLocal() async {
    testCalculatorHistory.clear();
    List<Map> res = await sqlDbSimlification.readData();
    for (int i = 0; i < res.length; i++) {
      testCalculatorHistory.add({
        'expr': res[i]['operation'],
      });
    }
    print("res= $res");
  }

  void updateExpr(String str, String userStr, String pattern) {
    focusNode.requestFocus();
    //if (isResultExist) clearAll();
    if (startPosition != controller.selection.start ||
        endPosition != controller.selection.end) {
      startPosition = controller.selection.start;
      endPosition = controller.selection.end;
    }
    print('(Start: $startPosition, End: $endPosition)');
    if (this.pattern.length >= 2) {
      if ((this.pattern[startPosition - 1] == 'o' &&
              this.pattern[startPosition] == 'o') ||
          startPosition != endPosition) {
        del();
      }
    }
    int pos = controller.text.length;
    String temp = controller.text.substring(endPosition);
    controller.text = controller.text.substring(0, startPosition) + userStr;
    pos = controller.text.length;
    print('text+str: ${controller.text}, ($startPosition, $endPosition)');
    controller.text += temp;
    userExpr = controller.text;
    pattern = patternGenerator(controller.text);
    startPosition = endPosition = pos;
    controller.selection =
        TextSelection.fromPosition(TextPosition(offset: endPosition));
    emit(SimplificationExprUpdate());
  }

  String patternGenerator(String s) {
    s = s.replaceAll("NAND", "oooo");
    s = s.replaceAll("AND", "ooo");
    s = s.replaceAll("XNOR", "oooo");
    s = s.replaceAll("NOR", "ooo");
    s = s.replaceAll("XOR", "ooo");
    s = s.replaceAll("OR", "oo");
    s = s.replaceAll("NOT", "ooo");
    s = s.replaceAll(">>", "oo");
    s = s.replaceAll("<<", "oo");
    s = s.replaceAll("-", "o");
    s = s.replaceAll(RegExp(r'[a-np-zA-NP-Z0-9]'), 'n');
    return s;
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
      if (_auth.currentUser?.email != null) {
        addUserHistorySimlification(controller.text);
        print("ssssssssssssss");
      } else {
        addHistoryLocalSimlification();
      }
    } else {
      result = "invalid Expression";
    }
    print('truth table: \n${simplifier.getTruthTableData(expr)}');
    print('Comparison Steps: \n${simplifier.comparisonSteps}');
    isResultExist = true;
    getHistoryLocal();
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
    if (controller.text.isEmpty) return;
    pattern = patternGenerator(controller.text);
    print('pattern: $pattern\ntext: ${controller.text}');
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
  ) async {
    if (_auth.currentUser?.email != null) {
      updatehistorySimplification();
    }
    if (_auth.currentUser?.email != null) {
      await getHistoryDataSimlification();
    } else {
      await getHistoryLocal();
    }

    showModalBottomSheet(
      context: context,
      builder: (context) =>
          BlocBuilder<SimplificationCubit, SimplificationState>(
        buildWhen: (previous, current) =>
            current is SimplificationHistoryUpdate,
        builder: (context, state) => Container(
          color: theme == 'light'
              ? ThemeColors.lightCanvas
              : ThemeColors.darkCanvas,
          child: Column(children: [
            Expanded(
              child: ListView.builder(
                itemCount: testCalculatorHistory.length,
                itemBuilder: (context, index) => Dismissible(
                  key: Key('cal$index'),
                  direction: DismissDirection.startToEnd,
                  onDismissed: (direction) =>
                      testCalculatorHistory.removeAt(index),
                  confirmDismiss: (direction) => showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      content:
                          const Text('Are you sure ,you want to delete it?'),
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
                          onPressed: () async {
                            if (_auth.currentUser?.email != null) {
                              await deleteHistoryDataSimlification(
                                  testCalculatorHistory[index]['expr']!);
                            } else {
                              await deleteHistoryLocal(
                                  testCalculatorHistory[index]['expr']!);
                            }

                            testCalculatorHistory.removeWhere((element) =>
                                element["expr"] ==
                                testCalculatorHistory[index]['expr']!);
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
            TextButton(
              onPressed: () async {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    content: Text('Are you sure ,you want to clear History?'),
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
                        onPressed: () async {
                          testCalculatorHistory.clear();
                          if (_auth.currentUser?.email != null) {
                            await cleareHistoryDataSimlification();
                          } else {
                            await clearHistoryLocal();
                          }

                          emit(SimplificationHistoryUpdate());
                          Navigator.of(context).pop();
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: ThemeColors.redColor,
                        ),
                        child: const Text('Clear'),
                      ),
                    ],
                  ),
                );
              },
              child: Text('Clear All'),
              style: TextButton.styleFrom(
                  foregroundColor: ThemeColors.redColor,
                  textStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                  )),
            ),
          ]),
        ),
      ),
    );
  }

  void showTruthTable(BuildContext context, String theme) {
    expr = expGenerator(controller.text);
    //print(expr);
    Validator v = Validator(expr, "bin");
    v.validat();
    if (v.error == false) {
      Simplifier simplifier = Simplifier(expr: expr);
      showModalBottomSheet(
          context: context,
          builder: (context) {
            List<Map<String, dynamic>> table =
                List.from(simplifier.getTruthTableData(expr)['table']!);
            return Container(
              padding: const EdgeInsets.all(5),
              child: Column(children: [
                const SizedBox(
                  height: 20,
                ),
                Text.rich(
                  TextSpan(
                      text: 'Expression:  ',
                      children: [
                        TextSpan(
                            text: controller.text,
                            style: const TextStyle(
                              color: ThemeColors.redColor,
                              fontWeight: FontWeight.bold,
                            ))
                      ],
                      style: const TextStyle(
                        fontSize: 16,
                        color: ThemeColors.blueColor,
                        fontWeight: FontWeight.bold,
                      )),
                ),
                const SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: createTT(
                    simplifier,
                    table,
                    theme,
                  ),
                ),
              ]),
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
      showModalBottomSheet(
        backgroundColor: Colors.transparent,
        barrierColor: Colors.black.withOpacity(0.9),
        context: context,
        builder: (context) => Container(
          padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.widthBlock! * 5,
            vertical: SizeConfig.heightBlock! * 2.5,
          ),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(20),
            ),
            color: theme == 'light'
                ? ThemeColors.lightCanvas
                : ThemeColors.darkCanvas,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'Explanation',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                    color: theme == 'light'
                        ? ThemeColors.lightForegroundTeal
                        : ThemeColors.darkForegroundTeal,
                  ),
                ),
              ),
              SizedBox(
                height: SizeConfig.heightBlock! * 2,
              ),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
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
                            fontSize: 18,
                          ),
                        ),
                        textAlign: TextAlign.start,
                      ),
                      SizedBox(
                        height: SizeConfig.heightBlock! * 2,
                      ),
                      Center(
                        child: createTT(simplifier, table, theme),
                      ),
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
                            fontSize: 18,
                          ),
                        ),
                      ),
                      Divider(
                        height: 40,
                        thickness: 2,
                        indent: 20,
                        endIndent: 20,
                        color: (theme == 'light')
                            ? ThemeColors.lightBlackText.withOpacity(0.25)
                            : ThemeColors.darkWhiteText.withOpacity(0.25),
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
                            fontSize: 18,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: SizeConfig.heightBlock! * 2,
                      ),
                      ...steps
                          .map(
                            (step) =>
                                Center(child: createQuineTable(step, theme)!),
                          )
                          .toList(),
                      Divider(
                        height: 40,
                        thickness: 2,
                        indent: 20,
                        endIndent: 20,
                        color: (theme == 'light')
                            ? ThemeColors.lightBlackText.withOpacity(0.25)
                            : ThemeColors.darkWhiteText.withOpacity(0.25),
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
                            fontSize: 18,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: SizeConfig.heightBlock! * 2,
                      ),
                      Center(
                        child: createDependancyTeble(
                            simplifier.comparisonSteps.last, soms, theme),
                      ),
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
                            fontSize: 18,
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
                              text: '{ ${finalTerms.join(' ,  ')} }',
                              style: TextStyle(
                                color: resultFocusedTextColor,
                              ),
                            ),
                          ],
                          style: TextStyle(
                            color: focusedTextColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      Divider(
                        height: 40,
                        thickness: 2,
                        indent: 20,
                        endIndent: 20,
                        color: (theme == 'light')
                            ? ThemeColors.lightBlackText.withOpacity(0.25)
                            : ThemeColors.darkWhiteText.withOpacity(0.25),
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
                            fontSize: 18,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: SizeConfig.heightBlock! * 2,
                      ),
                      Center(
                        child: Text(
                          BlocProvider.of<SimplificationCubit>(context).result,
                          style: TextStyle(
                            color: resultFocusedTextColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      result = "invalid Expression";
    }
  }

  Widget createTT(
      Simplifier simplifier, List<Map<String, dynamic>> table, String theme) {
    TextStyle style = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: theme == 'light'
          ? ThemeColors.lightBlackText
          : ThemeColors.darkWhiteText,
    );
    TextStyle somStyle = const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: ThemeColors.redColor,
    );
    TextStyle headerStyle = const TextStyle(
      fontSize: 18,
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
                textAlign: TextAlign.center,
                style: headerStyle,
              )),
              ...simplifier.vars
                  .map((e) => DataColumn(
                          label: Text(
                        e,
                        textAlign: TextAlign.center,
                        style: headerStyle,
                      )))
                  .toList(),
              DataColumn(
                  label: Text(
                'Result',
                textAlign: TextAlign.center,
                style: headerStyle,
              )),
            ],
            rows: table
                .map(
                  (e) => DataRow(cells: [
                    DataCell(
                      Center(
                        child: Text(
                          e['index'].toString(),
                          textAlign: TextAlign.center,
                          style: (e['functionResult'] != 1) ? style : somStyle,
                        ),
                      ),
                    ),
                    for (int i = 0; i < simplifier.vars.length; i++)
                      DataCell(Center(
                        child: Text(
                          e['bin'][i].toString(),
                          textAlign: TextAlign.center,
                          style: (e['functionResult'] != 1) ? style : somStyle,
                        ),
                      )),
                    DataCell(
                      Center(
                        child: Text(
                          e['functionResult'].toString(),
                          textAlign: TextAlign.center,
                          style: (e['functionResult'] != 1) ? style : somStyle,
                        ),
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
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: theme == 'light'
          ? ThemeColors.lightBlackText
          : ThemeColors.darkWhiteText,
    );
    TextStyle headerStyle = const TextStyle(
      fontSize: 18,
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
                      DataCell(Center(
                        child: Text(
                          e['soms'].toString(),
                          style: style,
                        ),
                      )),
                      DataCell(Center(
                        child: Text(
                          e['som'],
                          style: style,
                        ),
                      )),
                      DataCell(e['click']
                          ? const Center(
                              child: Icon(
                                Icons.check,
                                color: ThemeColors.redColor,
                              ),
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
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: theme == 'light'
          ? ThemeColors.lightBlackText
          : ThemeColors.darkWhiteText,
    );

    TextStyle headerStyle = const TextStyle(
      fontSize: 18,
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
                              ? const Icon(
                                  Icons.check,
                                  color: ThemeColors.redColor,
                                )
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

class SqlDbSimlification {
  static Database? _db;

  Future<Database?> get db async {
    if (_db == null) {
      _db = await intialDb();
      return _db;
    } else {
      return _db;
    }
  }

  intialDb() async {
    String databasepath = await getDatabasesPath();
    String path = join(databasepath, 'simplification.db');
    Database database = await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
      onOpen: (db) {
        print('table opened');
      },
    );
    return database;
  }

  _onCreate(Database db, int version) {
    db
        .execute('CREATE TABLE data(id INTEGER PRIMARY KEY ,operation TEXT)')
        .then((value) {
      print('table created');
    }).catchError((Error) {
      print('table eeeeeeeeeeeeeeeeeeeeeeeeeeee');
      print(Error.toString);
    });
  }

  readData() async {
    Database? mydb = await db;
    List<Map> response = await mydb!.rawQuery('SELECT * FROM "data"');
    return response;
  }

  insertData(String userExpr) async {
    Database? mydb = await db;
    int response = await mydb!
        .rawInsert('INSERT INTO data( operation  ) VALUES("$userExpr") ');
    return response;
  }

  deleteData(int Id) async {
    Database? mydb = await db;
    int response = await mydb!.rawDelete('DELETE  FROM "data" WHERE id=$Id');
    return response;
  }

  getlenght() async {
    Database? mydb = await db;
    int? count = Sqflite.firstIntValue(
        await mydb!.rawQuery('SELECT COUNT(*) FROM data'));
    return count;
  }
}
