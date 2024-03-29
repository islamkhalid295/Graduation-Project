import 'dart:async';
import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:graduation_project/Cubits/theme_cubit/theme_cubit.dart';
import 'package:graduation_project/Models/app_config.dart';
import 'package:meta/meta.dart';
import 'package:sqflite/sqflite.dart';
import '../../Models/digital_parser.dart';
import '../../Models/functions.dart';
import 'package:path/path.dart';
import 'dart:async';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';
part 'calculator_state.dart';

class CalculatorCubit extends Cubit<CalculatorState> {
  CalculatorCubit() : super(CalculatorInitial()) {
    startPosition = endPosition = controller.text.length;
    testCalculatorHistory = List.empty(growable: true);
    explenation = List.empty(growable: true);
  }
  int noBits = 16; //values 8, 16, 32, 64
  String expr = '';
  String pattern = '';
  String result = '0';
  String binResult = '0';
  String octResult = '0';
  String decResult = '0';
  String hexResult = '0';
  String curentNumerSystem = 'bin';
  bool isResultExist = false;
  bool isSigned = true;

  GlobalKey menuKey = GlobalKey();
  GlobalKey pageKey = GlobalKey();
  GlobalKey signedKey = GlobalKey();
  GlobalKey keyboardKey = GlobalKey();
  GlobalKey resultKey = GlobalKey();
  GlobalKey explanationKey = GlobalKey();
  GlobalKey historyKey = GlobalKey();
  GlobalKey convertSysKey = GlobalKey();

  SqlDb sqlDb = SqlDb();
  late List explenation;

  late int startPosition, endPosition;
  TextEditingController controller = TextEditingController();
  FocusNode focusNode = FocusNode();
  late List<Map<String, String>> testCalculatorHistory;

  int tmp = 0;
  final _auth = FirebaseAuth.instance;
  late User signInUser; //this get current user
  final _history = FirebaseFirestore.instance.collection('history');

  void changeNoBits(int bits) {
    noBits = bits;
    emit(NoOfBitsChange());
  }

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

  Future<void> updatehistory() async {
    int count = await sqlDb.getlenght();
    List<Map> res = await sqlDb.readData();
    if (count > 0) {
      for (int i = 0; i < count; i++) {
        addUserHistory(res[i]['operation'], res[i]['type']);
        await sqlDb.deleteData(i + 1);
      }
    }
  }

  Future<void> getHistoryLocal() async {
    testCalculatorHistory.clear();
    List<Map> res = await sqlDb.readData();
    for (int i = 0; i < res.length; i++) {
      testCalculatorHistory.add({
        'expr': res[i]['operation'],
      });
    }
    print("res= $res");
  }

  void addHistoryLocal() async {
    int response = await sqlDb.insertData(controller.text, curentNumerSystem);
  }

  Future<void> deleteHistoryLocal(String expr) async {
    List<Map> res = await sqlDb.readData();
    int count = await sqlDb.getlenght();
    for (int i = 0; i < count; i++) {
      if (res[i]['operation'] == expr) {
        await sqlDb.deleteData(res[i]['id']);
      }
    }
  }

  Future<void> clearHistoryLocal() async {
    List<Map> res = await sqlDb.readData();
    int count = await sqlDb.getlenght();
    for (int i = 0; i < count; i++) {
      await sqlDb.deleteData(res[i]['id']);
    }
  }

  Future<void> addUserHistory(xtext, type) {
    return _history
        .add({
          'operation': xtext, // add history
          'user': _auth.currentUser?.email //currentuser
          ,
          'type': type
        })
        .then((value) => print(() => "User History Added"))
        .catchError((error) {
          print(() => "Failed to add user History: ");
          addHistoryLocal();
        });
  }

  Future<void> deleteHistoryData(String oper) async {
    CollectionReference HistroyData =
        FirebaseFirestore.instance.collection('history');
    await HistroyData.where("user", isEqualTo: _auth.currentUser?.email)
        .where("operation", isEqualTo: oper)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((docId) {
        HistroyData.doc(docId.id)
            .delete()
            .then((value) => print(() => "operation Deleted"))
            .catchError(
                (error) => print(() => "Failed to delete operation: $error"));
      });
    });
  }

  Future<void> cleareHistoryData() async {
    CollectionReference HistroyData =
        FirebaseFirestore.instance.collection('history');
    await HistroyData.where("user", isEqualTo: _auth.currentUser?.email)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((docId) {
        HistroyData.doc(docId.id)
            .delete()
            .then((value) => print(() => "operation Deleted"))
            .catchError(
                (error) => print(() => "Failed to delete operation: $error"));
      });
    });
  }

  Future<void> getHistoryData() async {
    testCalculatorHistory.clear();
    CollectionReference HistroyData =
        FirebaseFirestore.instance.collection('history');
    await HistroyData.where("user", isEqualTo: _auth.currentUser?.email)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        testCalculatorHistory.add(
          {
            'expr': element.get('operation'),
            'system': element.get('type'),
          },
        );
      });
    });
    emit(CalculatorExprUpdate());
  }

  void check() {
    try {
      // print(expr);
      expr = expGenerator(controller.text);
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
        } else {
          binResult = BigInt.from(tmp).toUnsigned(noBits).toRadixString(2);
          decResult = tmp.toString();
          hexResult = BigInt.from(tmp).toUnsigned(noBits).toRadixString(16);
          octResult = BigInt.from(tmp).toUnsigned(noBits).toRadixString(8);
        }
      }
    } catch (e) {
      result = e.toString();
    }
  }

  void updateExpr(String str, String userStr, String pattern) {
    focusNode.requestFocus();
    //if (isResultExist) clearAll();
    if (startPosition != controller.selection.start ||
        endPosition != controller.selection.end) {
      startPosition = controller.selection.start;
      endPosition = controller.selection.end;
    }
    if (this.pattern.length >= 2 &&
        startPosition > 0 &&
        this.pattern.length > startPosition) {
      if ((this.pattern[startPosition - 1] == 'o' &&
              this.pattern[startPosition] == 'o') ||
          startPosition != endPosition) {
        del();
      }
      pattern = patternGenerator(controller.text);
    }
    int pos = controller.text.length;
    String temp = controller.text.substring(endPosition);
    controller.text = controller.text.substring(0, startPosition) + userStr;
    pos = controller.text.length;
    print(() => 'text+str: ${controller.text}, ($startPosition, $endPosition)');
    controller.text += temp;
    pattern = patternGenerator(controller.text);
    startPosition = endPosition = pos;
    controller.selection =
        TextSelection.fromPosition(TextPosition(offset: endPosition));
    expr = expGenerator(controller.text);
    check();
    emit(CalculatorExprUpdate());
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

  void getResult() {
    focusNode.requestFocus();
    // print(() => _auth.currentUser?.email);
    Parser p = Parser(expGenerator(controller.text), curentNumerSystem);
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
      if (_auth.currentUser?.email != null) {
        addUserHistory(controller.text, curentNumerSystem);
        print("ssssssssssssss");
      } else {
        addHistoryLocal();
      }
    } else {
      result = "Math Error";
      binResult = "Math Error";
      decResult = "Math Error";
      hexResult = "Math Error";
      octResult = "Math Error";
    }

    isResultExist = true;
    explenation.clear();
    explenation = p.explan;
    explenation.removeAt(0);

    //print(explenation.join('\n'));
    emit(CalculatorResult());
    getHistoryLocal();
  }

  void clearAll() {
    focusNode.requestFocus();
    isResultExist = false;
    controller.text = '';
    expr = '';
    binResult = '0';
    octResult = '0';
    hexResult = '0';
    decResult = '0';
    pattern = '';
    startPosition = endPosition = controller.text.length;
    controller.selection =
        TextSelection.fromPosition(TextPosition(offset: endPosition));
    emit(CalculatorExprUpdate());
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
            while (pattern[end + 1] == 'o' || pattern[end + 1] == ' ') {
              if (pattern[end + 1] == ' ') {
                end++;
                break;
              }
              end++;
              if (end + 1 >= pattern.length - 1) break;
            }
            while (pattern[start - 1] == 'o' || pattern[start - 1] == ' ') {
              if (pattern[start - 1] == ' ') {
                start--;
                break;
              }
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
            result = "delete error";
          }
      }
    } else {
      if (pattern[startPosition] == " ") startPosition++;
      if (pattern[endPosition - 1] == " ") endPosition--;

      int end = endPosition - 1;
      int start = startPosition;
      if (pattern[endPosition - 1] == 'o') {
        if (end < pattern.length - 1) {
          while (pattern[end + 1] == 'o' || pattern[end + 1] == ' ') {
            if (pattern[end + 1] == ' ') {
              end++;
              break;
            }
            end++;
            if (end + 1 >= pattern.length - 1) break;
          }
        }
      }

      if (pattern[startPosition] == 'o') {
        while (pattern[start - 1] == 'o' || pattern[start - 1] == ' ') {
          if (pattern[start - 1] == ' ') {
            start--;
            break;
          }
          start--;
          if (start == 0) break;
        }
        start_t = start;
      }

      if (pattern[startPosition] == 'n') {
        start = startPosition;
      }
      if (pattern[endPosition - 1] == 'n') {
        end = endPosition - 1;
      }
      controller.text = controller.text.substring(0, start) +
          controller.text.substring(end + 1, controller.text.length);
      pattern = pattern.substring(0, start) +
          pattern.substring(end + 1, pattern.length);
    }
    expr = expGenerator(controller.text);
    check();
    emit(CalculatorExprUpdate());
    startPosition = endPosition = start_t;
    controller.selection =
        TextSelection.fromPosition(TextPosition(offset: endPosition));
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
  ) async {
    if (_auth.currentUser?.email != null) {
      await updatehistory();
    }
    if (_auth.currentUser?.email != null) {
      await getHistoryData();
    } else {
      await getHistoryLocal();
    }

    showModalBottomSheet(
      context: context,
      builder: (context) => BlocBuilder<CalculatorCubit, CalculatorState>(
        buildWhen: (previous, current) => current is CalculatorHistoryUpdate,
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
                              await deleteHistoryData(
                                  testCalculatorHistory[index]['expr']!);
                            } else {
                              await deleteHistoryLocal(
                                  testCalculatorHistory[index]['expr']!);
                            }
                            testCalculatorHistory.removeWhere((element) =>
                                element["expr"] ==
                                testCalculatorHistory[index]['expr']!);
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
                            await cleareHistoryData();
                          } else {
                            await clearHistoryLocal();
                          }
                          await cleareHistoryData();
                          emit(CalculatorHistoryUpdate());
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

  void showExplanation(BuildContext context, String theme) {
    Color textColor = theme == 'light'
        ? ThemeColors.lightBlackText
        : ThemeColors.darkWhiteText;
    Color focusedTextColor = ThemeColors.blueColor;
    Color resultFocusedTextColor = ThemeColors.redColor;
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
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (int i = 0; i < explenation.length; i++)
                        createStep(
                          i,
                          textColor,
                          focusedTextColor,
                          resultFocusedTextColor,
                          '        ',
                        ),
                      SizedBox(
                        height: SizeConfig.heightBlock! * 2,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Row(
              children: [
                TextButton(
                  onPressed: () async {
                    await Clipboard.setData(
                        ClipboardData(text: getExplinationStr()));
                  },
                  child: Text(
                    'Copy',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: theme == 'light'
                          ? ThemeColors.lightForegroundTeal
                          : ThemeColors.darkForegroundTeal,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () async =>
                      await sendEmailMessage(getExplinationStr()),
                  icon: Icon(
                    Icons.mail_outlined,
                    color: theme == 'light'
                        ? ThemeColors.lightForegroundTeal
                        : ThemeColors.darkForegroundTeal,
                  ),
                ),
                TextButton(
                  onPressed: () async =>
                      await sendWhatsAppMessage(getExplinationStr()),
                  child: Text(
                    'WhatsApp',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: theme == 'light'
                          ? ThemeColors.lightForegroundTeal
                          : ThemeColors.darkForegroundTeal,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget createStep(int index, Color textColor, Color focusedTextColor,
      Color resultFocusedTextColor, String spaces) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            text: 'Step ${index + 1}: ',
            children: <TextSpan>[
              TextSpan(
                text: explenation[index]
                    .expr
                    .substring(0, explenation[index].start),
                style: TextStyle(
                  color: textColor,
                ),
              ),
              TextSpan(
                text: explenation[index].expr.substring(
                    explenation[index].start, explenation[index].end),
                style: TextStyle(
                  color: focusedTextColor,
                ),
              ),
              TextSpan(
                text: explenation[index].expr.substring(explenation[index].end),
                style: TextStyle(
                  color: textColor,
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
        Text.rich(
          TextSpan(
            text: spaces,
            children: [
              TextSpan(
                text: explenation[index].updatedPart,
              ),
              const TextSpan(
                text: ' = ',
              ),
              TextSpan(
                text: explenation[index].result.toString(),
                style: TextStyle(
                  color: resultFocusedTextColor,
                ),
              ),
            ],
          ),
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        Text.rich(
          TextSpan(
            text: '$spaces ==> ',
            children: [
              TextSpan(
                  text: explenation[index]
                      .expr
                      .substring(0, explenation[index].start)),
              TextSpan(
                text: explenation[index].result.toString(),
                style: TextStyle(
                  color: resultFocusedTextColor,
                ),
              ),
              TextSpan(
                  text: explenation[index]
                      .expr
                      .substring(explenation[index].end)),
            ],
          ),
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        SizedBox(
          height: SizeConfig.heightBlock! * 2,
        ),
      ],
    );
  }

  String getExplinationStr() {
    String exp = '';
    for (int i = 0; i < explenation.length; i++) {
      exp += 'Step ${i + 1} : ';
      exp += explenation[i].expr.substring(0, explenation[i].start) +
          ' [ ' +
          explenation[i]
              .expr
              .substring(explenation[i].start, explenation[i].end) +
          ' ] ' +
          explenation[i].expr.substring(explenation[i].end) +
          '\n';

      exp += '\t==> ' +
          explenation[i].updatedPart +
          ' = ' +
          explenation[i].result.toString() +
          '\n';

      exp += '\t==> ' +
          explenation[i].expr.substring(0, explenation[i].start) +
          ' [ ' +
          explenation[i].result.toString() +
          ' ] ' +
          explenation[i].expr.substring(explenation[i].end) +
          '\n';
      exp += '\n';
    }
    return exp;
  }
}

class SqlDb {
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
    String path = join(databasepath, 'User.db');
    Database database = await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
      onOpen: (db) {
        //print('table opened');
      },
    );
    return database;
  }

  _onCreate(Database db, int version) {
    db
        .execute(
            'CREATE TABLE data(id INTEGER PRIMARY KEY ,operation TEXT,type TEXT)')
        .then((value) {
      //print('table created');
    }).catchError((Error) {
      // print('table eeeeeeeeeeeeeeeeeeeeeeeeeeee');
      print(Error.toString);
    });
  }

  readData() async {
    Database? mydb = await db;
    List<Map> response = await mydb!.rawQuery('SELECT * FROM "data"');
    return response;
  }

  insertData(String userExpr, String curentNumerSystem) async {
    Database? mydb = await db;
    int response = await mydb!.rawInsert(
        'INSERT INTO data( operation , type ) VALUES("$userExpr", "$curentNumerSystem" ) ');
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

/* void insertToDatabase(){
    database.transaction((txn)async{
      await txn.rawInsert('INSERT INTO data( operation , user , type ) VALUES("1+2" , "eslam@gmail.com" , "dic" ) ').then((value){
        print(()=>"$value insert succssefly");
      }).catchError((error){
        print(()=>"error when insert $error");
      });

    });
  }
  */
}
