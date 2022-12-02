import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'standard.dart';
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
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
  ThemeMode themeMode=ThemeMode.light;
  @override
  Widget build(BuildContext context) {
    StandardScreen standerScreen = StandardScreen(dark: isDark);
    return MaterialApp(
      title: 'Digieator',
      theme: ThemeData(
          brightness: Brightness.light,
        primarySwatch: Colors.teal,
        canvasColor: Colors.grey[100],
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
          drawer: const Drawer(),
          appBar: AppBar(
              //backgroundColor: Colors.grey[100],
              elevation: 5,
              leading: Builder(
                builder: (ctx) {
                  return IconButton(
                    icon: const Icon(Icons.menu,
                    //color: Colors.red,
                    ),
                    onPressed: ()=>Scaffold.of(ctx).openDrawer(),
                  );
                }
              ),
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.history,),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 5.0),
                  child: IconButton(
                    onPressed: () {
                      setState(() {

                        if (isDark){
                          themeMode = ThemeMode.light;
                          isDark = false;
                        }else if(!isDark) {
                          themeMode = ThemeMode.dark;
                          isDark = true;
                        }
                      });
                    },
                    icon: const Icon(Icons.dark_mode_outlined,),
                  ),
                )
              ],
              centerTitle: true,

              title: const TabBar(
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
              Text('This Is Programmer'),
            ],
          ),
        ),
      ),
    );
  }
}
