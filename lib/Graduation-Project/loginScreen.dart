//this screen for login user
import 'package:calculator/Graduation-Project/signUn.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:calculator/Graduation-Project/home.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class loginScreen extends StatefulWidget {
  const loginScreen({Key? key}) : super(key: key);
  @override
  State<loginScreen> createState() => _loginScreenState();
}
class _loginScreenState extends State<loginScreen> {
  TextEditingController passwordcontroller=TextEditingController();
  TextEditingController Emailcontroller=TextEditingController();
  final _auth = FirebaseAuth.instance;
  String? loginError;
  String? emailerror = null;
  String? passworderror = null;
  late String password;
  String sheckPassword = "enter password";
  bool showSpinner = false;
  bool pass = true;
  Icon ic = const Icon(
    Icons.remove_red_eye_outlined,
    color: Colors.blue,
  );
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: LayoutBuilder(builder: (context, constraint) {
          return ModalProgressHUD(
            inAsyncCall: showSpinner,
            child: Container(
              alignment: Alignment.center,
              height: double.infinity,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/images/binary.jpg"),
                      fit: BoxFit.cover)),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              width: MediaQuery.of(context).size.width,
              child: Container(
                alignment: Alignment.center,
                height: constraint.maxHeight * 0.75,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(20)),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      TextField(
                        //-----لجعل لوحه المفتيح مخصصه لادخال الايميل زياده
                        keyboardType: TextInputType.emailAddress,
                        //-----
                        decoration: InputDecoration(
                          // fillColor: Colors.black,
                          // filled: true,
                          errorText: emailerror,
                          errorStyle: const TextStyle(color: Colors.red),
                          hintText: 'enter your email ',
                          labelText: "Emile",
                          labelStyle:const TextStyle(fontSize: 15, color: Colors.blue),
                          prefixIcon: const Icon(Icons.email),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide:const BorderSide(color: Colors.blueAccent, width: 1.5)),
                          //----------------------
                          disabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide:const BorderSide(color: Colors.red, width: 1.5)),
//------------------------
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide:const BorderSide(color: Colors.red, width: 1.5)),
                        ),
                        controller: Emailcontroller,
                      ),
//--------password---------------------
                      const SizedBox(height: 30),
                      TextField(
                        //لجعل الباسورد مخفي -----
                        obscureText: pass,
                        decoration: InputDecoration(
                          labelText: "password",
                          labelStyle:const TextStyle(fontSize: 15, color: Colors.blue),
                          errorText: passworderror,
                          errorStyle: const TextStyle(color: Colors.red),
                          hintText: sheckPassword,
                          suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  pass = !pass;
                                  if (pass == false) {
                                    ic = const Icon(
                                      Icons.real_estate_agent_rounded,
                                      color: Colors.red,
                                    );
                                  } else {
                                    ic = const Icon(
                                        Icons.remove_red_eye_outlined,
                                        color: Colors.blue);
                                  }
                                });
                              },
                              icon: ic),
                          prefixIcon: const Icon(Icons.password),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: const BorderSide(
                                  color: Colors.blue, width: 1.5)),
                          //----------------------
                          disabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: const BorderSide(
                                  color: Colors.red, width: 1.5)),
//------------------------
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: const BorderSide(
                                  color: Colors.red, width: 1.5)),
                        ),
                        controller: passwordcontroller,

                      ),
//---login------------------------
                      const SizedBox(height: 20,),
                      MaterialButton(
                          color: Colors.blue,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 80, vertical: 20),
                          shape: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: const BorderSide(
                                  color: Colors.white10, width: 1.0)),
                          onPressed: ()  {
                            setState(() {
                              showSpinner = true;
                              if(passwordcontroller.text.isEmpty){
                                passworderror="password can not be empty";
                              }
                              else{
                                passworderror=null;
                              }
                              if (Emailcontroller.text.isEmpty ||
                                  !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                      .hasMatch(Emailcontroller.text)) {
                                emailerror = "Enter correct Email";
                              } else {
                                emailerror = null;
                              }
                            });
                            try {
                              final userlogin =  _auth.signInWithEmailAndPassword(
                                      email: Emailcontroller.text, password: passwordcontroller.text);
                              if (userlogin != null) {
                                setState(() {
                                  showSpinner = false;
                                });
                                Navigator.of(context)
                                    .push(MaterialPageRoute(builder: (context) {
                                  return const HomePage();
                                }));
                              }
                            } on FirebaseAuthException catch (e) {
                              setState(() {
                                showSpinner = false;
                              });
                              if (e.code == 'user-not-found') {
                               emailerror= 'No user found for that email.';
                              } else if (e.code == 'wrong-password') {
                                passworderror='Wrong password provided for that user.';
                              }

                            } catch (e) {
                              setState(() {
                                showSpinner = false;
                              });
                           }
                          },
                          child: const Text('login',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 23,
                                fontWeight: FontWeight.bold),
                          )
                      ),
                      const SizedBox(height: 20, ),
                      GestureDetector(
                        child: const Text(
                          'forget password ?',
                          style: TextStyle(
                              color: Colors.blue,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                        onTap: () {
                          // print('forget password ?');
                        },
                      ),
                      const SizedBox(height: 20,),
                      GestureDetector(
                        child: const Text(
                          'sign up ',
                          style: TextStyle(
                              color: Colors.blue,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                        onTap: () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return const appscreen();
                          }));
                        },
                      ),
                      //   const SizedBox(height: 270,)
                    ],
                  ),
                ),
              ),
            ),
          );
        }));
  }
}




