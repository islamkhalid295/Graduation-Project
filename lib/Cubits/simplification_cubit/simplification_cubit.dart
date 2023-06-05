import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../Models/app_config.dart';
import '../../Models/simpilifier.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart';
import 'dart:async';

part 'simplification_state.dart';

class SimplificationCubit extends Cubit<SimplificationState> {
  SimplificationCubit() : super(SimplificationInitial()) {
    startPosition = endPosition = controller.text.length;
    userExpr = controller.text;
    testCalculatorHistory = List.empty(growable: true);

  }

  String expr = '';
  String userExpr = '';
  String result = 'No Result';

  bool isResultExist = false;
  bool isNormal = true;

  late int startPosition, endPosition;
  TextEditingController controller = TextEditingController();
  FocusNode focusNode = FocusNode();
  final _auth = FirebaseAuth.instance;
  late List<Map<String, String>> testCalculatorHistory;
  SqlDbSimlification sqlDbSimlification=SqlDbSimlification() ;
  final _historySimp = FirebaseFirestore.instance.collection('simplification');

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

  Future<void> sendWhatsAppMessage(  String text) async {
    final Uri _url = Uri.parse('whatsapp://send?+02?&text=$text');
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }
  Future<void> sendEmailMessage( String text ) async {
    final Uri _url = Uri.parse('mailto:?subject=hellow&body=$text');
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }
  void updatehistorySimplification()async{
    int count=await sqlDbSimlification.getlenght();
    List<Map>res=await sqlDbSimlification.readData();
    if(count>0){
      for(int i=0;i<count;i++){
        addUserHistorySimlification(res[i]['operation']);
        await sqlDbSimlification.deleteData(i+1);
      }
    }
  }
  void addHistoryLocalSimlification()async{
    int response =await sqlDbSimlification.insertData(userExpr);
  }
  Future<void> addUserHistorySimlification(xtext) {
    return _historySimp
        .add({
      'operation': xtext, // add history
      'user': _auth.currentUser?.email //currentuser

    })
        .then((value) => print("User History Added"))
        .catchError((error) {
      print("Failed to add user History: ");
      addHistoryLocalSimlification();
    }
    );
  }
  Future<void> deleteHistoryDataSimlification(String oper) async {
    CollectionReference HistroyData =
    FirebaseFirestore.instance.collection('simplification');
    await HistroyData.where("user", isEqualTo:_auth.currentUser?.email).where("operation",isEqualTo: oper	)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((docId) {
        HistroyData.doc(docId.id).delete().then((value) => print("operation Deleted"))
            .catchError((error) => print("Failed to delete operation: $error"));
      });
    });
  }
  Future<void> cleareHistoryDataSimlification() async {
    CollectionReference HistroyData =
    FirebaseFirestore.instance.collection('simplification');
    await HistroyData.where("user", isEqualTo: _auth.currentUser?.email)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((docId) {
        HistroyData.doc(docId.id).delete().then((value) => print("operation Deleted"))
            .catchError((error) => print("Failed to delete operation: $error"));
      });
    });
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
    addUserHistorySimlification(controller.text);
    updatehistorySimplification();
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
class SqlDbSimlification{
  static Database? _db;

  Future<Database?> get db async{
    if(_db==null){
      _db=await intialDb();
      return _db;
    }
    else{
      return _db;
    }
  }
  intialDb()async{

    String databasepath=await getDatabasesPath();
    String path= join (databasepath, 'simplification.db');
    Database database = await openDatabase(
      path, version: 1,
      onCreate: _onCreate
      ,onOpen: (db) {
      print('table opened');
    },
    );
    return database;
  }
  _onCreate(Database db,int version) {

    db.execute(
        'CREATE TABLE data(id INTEGER PRIMARY KEY ,operation TEXT)')
        .then((value) {
      print('table created');
    }).catchError((Error) {
      print('table eeeeeeeeeeeeeeeeeeeeeeeeeeee');
      print(Error.toString);
    });
  }

  readData()async{
    Database?mydb=await db;
    List<Map>response=await mydb!.rawQuery('SELECT * FROM "data"');
    return response;
  }
  insertData(String userExpr)async{
    Database?mydb=await db;
    int response=await mydb!.rawInsert('INSERT INTO data( operation  ) VALUES("$userExpr") ');
    return response;
  }
  deleteData(int Id)async{
    Database?mydb=await db;
    int response=await mydb!.rawDelete('DELETE  FROM "data" WHERE id=$Id');
    return response;
  }
  getlenght()async{
    Database?mydb=await db;
    int? count = Sqflite
        .firstIntValue(await mydb!.rawQuery('SELECT COUNT(*) FROM data'));
    return count;
  }



}