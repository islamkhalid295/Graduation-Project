import 'package:calculator/Graduation-Project/home.dart';
import 'package:calculator/Graduation-Project/signUn.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'loginScreen.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  final _auth=FirebaseAuth.instance;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      initialRoute:_auth.currentUser!=null?'Home_Screen':'login_Screen' ,
      routes: {
        'login_Screen':(context) => loginScreen(),
        'signUP_Screen':(context) => appscreen(),
        'Home_Screen':(context) => HomePage()
        },
    );
  }
}
