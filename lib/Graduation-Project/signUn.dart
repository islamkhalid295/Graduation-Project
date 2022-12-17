//this screen for sign Up new user
import 'package:flutter/material.dart';
import 'package:calculator/Graduation-Project/signUn.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'loginScreen.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class appscreen extends StatefulWidget {
  const appscreen({Key? key}) : super(key: key);

  @override
  State<appscreen> createState() => _appscreenState();
}

class _appscreenState extends State<appscreen> {
  final _auth = FirebaseAuth.instance;
  late String Email;
  late String Password;
  late String confirmPassword;
  bool showSpinner = false;
  bool pass = true;
  Icon ic = const Icon(Icons.remove_red_eye_outlined, color: Colors.red);

  @override
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
//****SingleChildScrollView لجعل الصفحه بتسكرول

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
//***************Emile**************
                      TextField(
                        //-----لجعل لوحه المفتيح مخصصه لادخال الايميل زياده
                        keyboardType: TextInputType.emailAddress,
//-----
                        decoration: InputDecoration(
                          hintText: 'enter your email ',
                          labelText: "Emile",
                          labelStyle:
                              const TextStyle(fontSize: 15, color: Colors.red),
                          prefixIcon: const Icon(Icons.email),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: const BorderSide(
                                  color: Colors.red, width: 1.5)),
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
                        onChanged: (value) {
                          Email = value;
                        },
                      ),
//****************password*****************
                      const SizedBox(height: 20),

                      TextField(
                        //لجعل الباسورد مخفي -----
                        obscureText: pass,
                        textInputAction: TextInputAction.search,
                        //----------------
                        decoration: InputDecoration(
                          labelText: "password",
                          labelStyle:
                              TextStyle(fontSize: 15, color: Colors.red),
                          hintText: "enter your password ",
                          suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  pass = !pass;
                                  if (pass == false) {
                                    ic = const Icon(
                                        Icons.real_estate_agent_rounded,
                                        color: Colors.red);
                                  } else {
                                    ic = const Icon(
                                        Icons.remove_red_eye_outlined,
                                        color: Colors.red);
                                  }
                                });
                              },
                              icon: ic),
                          prefixIcon: const Icon(Icons.password),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: const BorderSide(
                                  color: Colors.red, width: 1.5)),
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
                        onChanged: (value) {
                          Password = value;
                        },
                      ),
                      const SizedBox(height: 20),
//*************confirm password************
                      TextField(
                        //لجعل الباسورد مخفي -----
                        obscureText: pass,
                        textInputAction: TextInputAction.search,
                        //----------------
                        decoration: InputDecoration(
                          labelText: "confirm password",
                          labelStyle:
                              TextStyle(fontSize: 15, color: Colors.red),
                          hintText: "enter your cofirm password ",
                          suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  pass = !pass;
                                  if (pass == false) {
                                    ic = const Icon(
                                        Icons.real_estate_agent_rounded,
                                        color: Colors.red);
                                  } else {
                                    ic = const Icon(
                                        Icons.remove_red_eye_outlined,
                                        color: Colors.red);
                                  }
                                });
                              },
                              icon: ic),
                          prefixIcon: const Icon(Icons.password),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: const BorderSide(
                                  color: Colors.red, width: 1.5)),
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
                        onChanged: (value) {
                          confirmPassword = value;
                        },
                      ),
//---login------------------------
                      const SizedBox(
                        height: 20,
                      ),
                      MaterialButton(
                          color: Colors.blue,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 80, vertical: 20),
                          child: Text(
                            'sign up',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 23,
                                fontWeight: FontWeight.bold),
                          ),
                          shape: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: const BorderSide(
                                  color: Colors.white10, width: 1.0)),
                          onPressed: () async {
                            setState(() {
                              showSpinner = true;
                            });
                              try {
                                await _auth.createUserWithEmailAndPassword
                                  (email: Email, password: Password);
                                Navigator.of(context).push(
                                    MaterialPageRoute(builder: (context) {
                                      return const loginScreen();
                                    }));
                                setState(() {
                                  showSpinner = false;
                                });
                              }
                              catch (e) {
                                setState(() {
                                  showSpinner = false;
                                });
                                showDialog(
                                    context: context,
                                    builder: (context) =>
                                        AlertDialog(
                                          title: Text('error !', style: Theme
                                              .of(context)
                                              .textTheme
                                              .headline6,),
                                          content: Text(
                                            e.toString(), style: Theme
                                              .of(context)
                                              .textTheme
                                              .subtitle1,),
                                          actions: [
                                            TextButton(onPressed: () =>
                                                Navigator.of(context).pop(),
                                                child: const Text('OK'))
                                          ],
                                        )
                                );
                                print(e);
                              }
                            }
                            ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }));
  }
}
