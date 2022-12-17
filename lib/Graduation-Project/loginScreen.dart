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
  final _auth = FirebaseAuth.instance;
  late String email;
  late String sheckEmail;
  String? emailerror = null;
  late String password;
  String sheckPassword = "enter password";
  bool showSpinner = false;
  bool pass = true;
  Icon ic = const Icon(
    Icons.remove_red_eye_outlined,
    color: Colors.red,
  );
  final _formkey = GlobalKey<FormState>();

  Widget build(BuildContext context) {
    return Scaffold(
        key: _formkey,
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
                      TextFormField(
                        //-----لجعل لوحه المفتيح مخصصه لادخال الايميل زياده
                        keyboardType: TextInputType.emailAddress,
                        //-----
                        validator: (value) {
                          if (value!.isEmpty ||
                              !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(value!)) {
                            emailerror = "Enter correct Email";
                            //  return "Enter correct Email";
                          } else {
                            emailerror = null;
                            //return null;
                          }
                        },
                        decoration: InputDecoration(
                          // fillColor: Colors.black,
                          // filled: true,
                          errorText: emailerror,
                          errorStyle: const TextStyle(color: Colors.red),
                          hintText: 'enter your email ',
                          labelText: "Emile",
                          labelStyle:
                              TextStyle(fontSize: 15, color: Colors.red),
                          prefixIcon: const Icon(Icons.email),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide:
                                  BorderSide(color: Colors.red, width: 1.5)),
                          //----------------------
                          disabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide:
                                  BorderSide(color: Colors.red, width: 1.5)),
//------------------------
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide:
                                  BorderSide(color: Colors.red, width: 1.5)),
                        ),
                        onChanged: (Value) {
                          email = Value;
                        },
                      ),
//--------password---------------------
                      const SizedBox(height: 30),
                      TextFormField(
                        //لجعل الباسورد مخفي -----
                        obscureText: pass,
                        //----------------

                        // validator: (value) => value.length< 6?'password must be larger than 6 characters':null,
                        validator: (value) {
                          if (value!.length < 6) {
                            return 'password must be larger than 6 characters';
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                          labelText: "password",
                          labelStyle:
                              TextStyle(fontSize: 15, color: Colors.red),
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
                          password = value;
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
                          child: const Text(
                            'login',
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
                              final userlogin = await FirebaseAuth.instance
                                  .signInWithEmailAndPassword(
                                      email: email, password: password);
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
                              showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                        title: Text(
                                          'error !',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline6,
                                        ),
                                        content: Text(
                                          e.code,
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle1,
                                        ),
                                        actions: [
                                          TextButton(
                                              onPressed: () =>
                                                  Navigator.of(context).pop(),
                                              child: const Text('OK'))
                                        ],
                                      ));
                            } catch (e) {
                              setState(() {
                                showSpinner = false;
                              });
                              showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                        title: Text(
                                          'error !',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline6,
                                        ),
                                        content: Text(
                                          e.toString(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle1,
                                        ),
                                        actions: [
                                          TextButton(
                                              onPressed: () =>
                                                  Navigator.of(context).pop(),
                                              child: const Text('OK'))
                                        ],
                                      ));
                            }
                          }),
                      const SizedBox(
                        height: 20,
                      ),

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
                      const SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        child: const Text(
                          'SIGN UP ',
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
