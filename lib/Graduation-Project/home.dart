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
  final _auth=FirebaseAuth.instance;
  late User signInUser;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
  }
  void getCurrentUser(){
    try {
      final user = _auth.currentUser;
      if (user != null) {
        signInUser = user;
        print(signInUser.email);
      }
    }catch(e){
      print(e);
    }
  }

  /*Brightness? _brightness;

  @override
  void initState() {
    WidgetsBinding.instance?.addObserver(this);
    _brightness = WidgetsBinding.instance?.window.platformBrightness;
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangePlatformBrightness() {
    if (mounted) {
      setState(() {
        _brightness = WidgetsBinding.instance?.window.platformBrightness;
      });
    }

    super.didChangePlatformBrightness();
  }

  CupertinoThemeData get _lightTheme =>
      CupertinoThemeData(brightness: Brightness.light, /* light theme settings */);

  CupertinoThemeData get _darkTheme => CupertinoThemeData(brightness: Brightness.dark, /* dark theme settings */);
*/

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
          tabBarTheme: TabBarTheme(
            indicatorSize: TabBarIndicatorSize.label,
            unselectedLabelColor: Colors.white.withOpacity(0.8),
            labelColor: Colors.white,
          )
          /* light theme settings */
          ),

      // theme: ThemeData(
      //   brightness: _brightness,
      //   /* light theme settings */
      // ),
      darkTheme: ThemeData(
          brightness: Brightness.dark,
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
              color: Colors.black54,
              fontWeight: FontWeight.bold,
            ),
            headline4: TextStyle(
              fontSize: 18,
            ),
          ),
          appBarTheme: AppBarTheme(foregroundColor: Colors.tealAccent),
          tabBarTheme: TabBarTheme(
            indicatorSize: TabBarIndicatorSize.label,
            unselectedLabelColor: Colors.tealAccent.withOpacity(0.5),
            labelColor: Colors.tealAccent,
          )
          /* dark theme settings */
          ),
      themeMode: themeMode,
      /* ThemeMode.system to follow system theme,
         ThemeMode.light for light theme,
         ThemeMode.dark for dark theme
      */
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          drawer: Drawer(
            child: ListView(
              // Important: Remove any padding from the ListView.
              padding: EdgeInsets.zero,
              children: <Widget>[
                 UserAccountsDrawerHeader(
                  accountName: Text(signInUser.email!.substring(0,signInUser.email!.indexOf('@'))),
                  accountEmail: Text(signInUser.email!),
                  currentAccountPicture: CircleAvatar(
                    backgroundColor: Colors.orange,
                    child: Text(
                      signInUser.email![0],
                      style: TextStyle(fontSize: 40.0),
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
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.history),
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
              title: const TabBar(
                labelPadding: EdgeInsets.symmetric(horizontal: 3),
                //indicatorColor: Colors.teal,
                tabs: [
                  Tab(
                    text: 'Standard',
                  ),
                  Tab(
                    text: 'Programmer',
                  ),
                ],
              )),
          body: TabBarView(
            children: [
              standerScreen,
              ProgrammerScreen(),
            ],
          ),
        ),
      ),
    );
  }
}
