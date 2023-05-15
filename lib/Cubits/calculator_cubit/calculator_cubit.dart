import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:sqflite/sqflite.dart';

import '../../Models/digital_parser.dart';
import '../../Models/functions.dart';
import 'package:path/path.dart';
import 'dart:async';
part 'calculator_state.dart';


class CalculatorCubit extends Cubit<CalculatorState> {
  CalculatorCubit() : super(CalculatorInitial());
  //  late Database database;
  String expr = '';
  String userExpr = '';
  String pattern = '';
  String result = '0';
  String binResult = '0';
  String octResult = '0';
  String decResult = '0';
  String hexResult = '0';
  // rmove bin
  String curentNumerSystem = '';

  bool isResultExist = false;
  bool isSigned = true;

  int startPosition = 0;
  int endPosition = 0;

  int tmp = 0;
  SqlDb sqlDb=SqlDb();int id=1;
  final _auth=FirebaseAuth.instance;
  late User signInUser; //this get current user
  final  _history = FirebaseFirestore.instance.collection('history');
  @override

  /*void getCurrentUser(){
    try {
      final user = _auth.currentUser;
      if (user != null) {
        signInUser = user;
        print(user.email);
      }
    }catch(e){
      print(e);
    }
  }
   */
  Future<void> addUserHistory(xtext) {
        return _history
            .add({
          'operation': xtext, // add history
          'user': _auth.currentUser?.email //currentuser
          , 'type': curentNumerSystem,
          'id':id++

        })
            .then((value) => print("User History Added"))
            .catchError((error) => print("Failed to add user History: $error"));
      }
  void getHistoryData()async{
    CollectionReference HistroyData=  FirebaseFirestore.instance.collection('history');
   await HistroyData.where("user",isEqualTo:_auth.currentUser?.email ).get().then((value) {
     value.docs.forEach((element) {
       print(element.data());
     });
   });
  }

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

  void getResult()async {
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
      addUserHistory(expr);
     // sheckData();
    } else
      result = "Math Error";

    isResultExist = true;
    emit(CalculatorResult());

   // createData();
   // insertToDatabase();
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

  /* void createData()async {

     database = await openDatabase(
      join(await getDatabasesPath(), 'history.db'),
      version: 1,
      onCreate: (db, version) {
        db.execute(
            'CREATE TABLE data(id INTEGER PRIMARY KEY ,operation TEXT,user TEXT,type TEXT)')
            .then((value) {
          print('table created');
        }).catchError((Error) {
          print(Error.toString);
        });
      },
      onOpen: (db) {
        print('table open');
      },
    );

  }
  void insertToDatabase(){
     database.transaction((txn)async{
      await txn.rawInsert('INSERT INTO data( operation , user , type ) VALUES("1+2" , "eslam@gmail.com" , "dic" ) ').then((value){
        print("$value insert succssefly");
      }).catchError((error){
        print("error when insert $error");
      });

    });
  }

   */

  void sheckData()async{

   // print(_auth.currentUser?.email);

   // int response =await sqlDb.insertData(userExpr, curentNumerSystem);

    int response =await sqlDb.deleteData(1);
    List<Map>res=await sqlDb.readData();
    print("response =$response" );
    print("response =$res" );
    print("=========================");
  }
}

class SqlDb{
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
    String path= join (databasepath, 'User.db');
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
        'CREATE TABLE data(id INTEGER PRIMARY KEY ,operation TEXT,type TEXT)')
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
  insertData(String userExpr,String curentNumerSystem)async{
    Database?mydb=await db;
    int response=await mydb!.rawInsert('INSERT INTO data( operation , type ) VALUES("$userExpr", "$curentNumerSystem" ) ');
    return response;
  }
  deleteData(int Id)async{
    Database?mydb=await db;
    int response=await mydb!.rawDelete('DELETE  FROM "data" WHERE id=$Id');
    return response;
  }

/* void insertToDatabase(){
    database.transaction((txn)async{
      await txn.rawInsert('INSERT INTO data( operation , user , type ) VALUES("1+2" , "eslam@gmail.com" , "dic" ) ').then((value){
        print("$value insert succssefly");
      }).catchError((error){
        print("error when insert $error");
      });

    });
  }


  */
}



