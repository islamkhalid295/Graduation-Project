import 'package:flutter/material.dart';
import 'loginScreen.dart';
import 'standard.dart';
import 'programmer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  final _auth = FirebaseAuth.instance;
  late User signInUser;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        signInUser = user;
        print(signInUser.email);
      }
    } catch (e) {
      print(e);
    }
  }

  bool isDark = false;
  ThemeMode themeMode = ThemeMode.light;

  @override
  Widget build(BuildContext context) {
    StandardScreen standerScreen = StandardScreen(dark: isDark);
    return MaterialApp(
      title: 'Digieator',
      theme: ThemeData(
          brightness: Brightness.light,
          primarySwatch: Colors.teal,
          canvasColor: Colors.grey[100],
          textTheme: const TextTheme(
            headline1: TextStyle(
              fontSize: 42,
              fontWeight: FontWeight.bold,
            ),
            headline2: TextStyle(
              fontSize: 32,
            ),
            headline3: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            headline4: TextStyle(
              fontSize: 18,
            ),
          ),
      ),
      darkTheme: ThemeData(
          brightness: Brightness.dark,
          textTheme: const TextTheme(
            headline1: TextStyle(
              color: Colors.white,
              fontSize: 42,
              fontWeight: FontWeight.bold,
            ),
            headline2: TextStyle(
              color: Colors.white,
              fontSize: 32,
            ),
            headline3: TextStyle(
              fontSize: 18,
              color: Colors.black54,
              fontWeight: FontWeight.bold,
            ),
            headline4: TextStyle(
              color: Colors.black54,
              fontSize: 18,
            ),
          ),
          appBarTheme: const AppBarTheme(foregroundColor: Colors.tealAccent),
          ),
      themeMode: themeMode,
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
          drawer: Drawer(
            child: ListView(
              // Important: Remove any padding from the ListView.
              padding: EdgeInsets.zero,
              children: <Widget>[
                UserAccountsDrawerHeader(
                  accountName: Text(signInUser.email!
                      .substring(0, signInUser.email!.indexOf('@'))),
                  accountEmail: Text(signInUser.email!),
                  currentAccountPicture: CircleAvatar(
                    backgroundColor: Colors.orange,
                    child: Text(
                      signInUser.email![0],
                      style: const TextStyle(fontSize: 40.0),
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text("Logout"),
                  onTap: () {
                    _auth.signOut();
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return const loginScreen();
                    }));
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.settings),
                  title: const Text("About"),
                  onTap: () {
                    //Navigator.of(context).pushNamed(DrawerAbout.routename);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.contacts),
                  title: const Text("Contact Us"),
                  onTap: () {
                    //Navigator.of(context).pushNamed(DrawerContact.routename);
                  },
                ),
              ],
            ),
          ),
          appBar: AppBar(
            //backgroundColor: Colors.grey[100],
            elevation: 5,
            leading: Builder(builder: (ctx) {
              return IconButton(
                icon: const Icon(
                  Icons.menu,
                  //color: Colors.red,
                ),
                onPressed: () => Scaffold.of(ctx).openDrawer(),
              );
            }),
            actions: [
              const IconButton(
                onPressed: null,
                icon: Icon(Icons.history),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 5.0),
                child: IconButton(
                    onPressed: () {
                      setState(() {
                        if (isDark) {
                          themeMode = ThemeMode.light;
                          isDark = false;
                        } else if (!isDark) {
                          themeMode = ThemeMode.dark;
                          isDark = true;
                        }
                      });
                    },
                    icon: (isDark)
                        ? const Icon(
                            Icons.light_mode_outlined,
                          )
                        : const Icon(
                            Icons.dark_mode_outlined,
                          )),
              )
            ],
            centerTitle: true,
            title: const Text('Digieator'),
          ),
          body: const ProgrammerScreen(),
        ),
      ),
    );
  }
}
