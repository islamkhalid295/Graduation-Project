
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
   final _auth=FirebaseAuth.instance;
  late String Email;
  late String Password;
   bool showSpinner=false;
   bool pass=true;
   Icon ic=Icon(Icons.remove_red_eye_outlined,color: Colors.red);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/binary.jpg"),
              fit: BoxFit.cover)
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            width: MediaQuery.of(context).size.width,
//****SingleChildScrollView لجعل الصفحه بتسكرول
            child: SingleChildScrollView(

              child: Column(
                children: <Widget>[
              const    SizedBox(height: 150),
//*********first name**************
              const    Text(
                    ' ',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 23,
                        fontWeight: FontWeight.bold),
                  ),

                  TextField(
                    decoration: InputDecoration(
                      hintText: ' first name ',hintStyle: TextStyle(fontSize: 15,),
                      prefixIcon: Icon(Icons.email),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(color: Colors.red, width: 1.5)),
                      //----------------------
                      disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(color: Colors.red, width: 1.5)),
//------------------------
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(color: Colors.red, width: 1.5)),
                    ),
                  ),
 //---------------------
                  const SizedBox( height: 20,),
//***************Emile**************
                  TextField(
                    //-----لجعل لوحه المفتيح مخصصه لادخال الايميل زياده
                    keyboardType: TextInputType.emailAddress,
//-----
                    decoration: InputDecoration(
                      hintText: 'enter your email ',
                      labelText: "Emile",labelStyle: const TextStyle(fontSize: 15,color: Colors.red),
                      prefixIcon: const Icon(Icons.email),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(color: Colors.red, width: 1.5)),
                      disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(color: Colors.red, width: 1.5)),
//------------------------
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(color: Colors.red, width: 1.5)),
                    ),
                    onChanged: (value) {
                      Email=value;
                    },
                  ),
//****************password*****************
                  const SizedBox(height: 20),

                  TextField(
                    //لجعل الباسورد مخفي -----
                    obscureText: pass,
                    //----------------
                    decoration: InputDecoration(
                      labelText: "password",labelStyle: TextStyle(fontSize: 15,color: Colors.red),
                      hintText: "enter your password ",
                      suffixIcon: IconButton(onPressed: (){setState(() {
                        pass=!pass;
                        if(pass==false){
                          ic=const Icon(Icons.real_estate_agent_rounded,color: Colors.red);
                        }
                        else{
                          ic=const Icon(Icons.remove_red_eye_outlined,color: Colors.red);
                        }
                      });}, icon: ic),
                      prefixIcon: const Icon(Icons.password),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(color: Colors.red, width: 1.5)),
                      //----------------------
                      disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(color: Colors.red, width: 1.5)),
//------------------------
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(color: Colors.red, width: 1.5)),
                    ),
                    onChanged: (value) {
                      Password=value;
                    },
                  ),
//---login------------------------
                  const SizedBox(height: 20,),
                  MaterialButton(
                    color: Colors.blue,
                    padding: EdgeInsets.symmetric(horizontal: 80, vertical: 20),
                    shape: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(color: Colors.white10, width: 1.0)),
                    onPressed: () async{
                      setState((){
                        showSpinner=true;
                      });
                      try{
                          await _auth.createUserWithEmailAndPassword
                           (email: Email, password: Password);
                        Navigator.of(context).push(MaterialPageRoute(builder:(context) {
                          return const loginScreen();
                        }));
                          setState((){
                            showSpinner=false;
                          });
                      }
                      catch(e) {
                        setState(() {
                          showSpinner = false;
                        });
                        showDialog(
                            context: context,
                            builder: (context) =>AlertDialog(
                              title: Text('error !',style: Theme.of(context).textTheme.headline6,),
                              content: Text(e.toString(),style: Theme.of(context).textTheme.subtitle1,),
                              actions: [
                                TextButton(onPressed:() => Navigator.of(context).pop(), child:const Text('OK'))
                              ],
                            )
                        );
                        print(e);
                      }
                    },
                    child: Text(
                      'sign up',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 23,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: double.maxFinite ),

                ],
              ),
            ),
          ),
        ));
  }
}
