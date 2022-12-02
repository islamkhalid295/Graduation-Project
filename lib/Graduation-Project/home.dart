import 'package:flutter/material.dart';
import 'standard.dart';
import 'programmer.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Digieator',
      theme: ThemeData(
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
          unselectedLabelColor: Colors.grey[500],
          labelColor: Colors.teal,
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          drawer: const Drawer(),
          appBar: AppBar(
              backgroundColor: Colors.grey[100],
              elevation: 0,
              leading: Builder(builder: (ctx) {
                return IconButton(
                  icon: const Icon(
                    Icons.menu,
                    color: Colors.black,
                  ),
                  onPressed: () => Scaffold.of(ctx).openDrawer(),
                );
              }),
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.history,
                    color: Colors.black,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 5.0),
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.dark_mode_outlined,
                      color: Colors.black,
                    ),
                  ),
                )
              ],
              centerTitle: true,
              title: const TabBar(
                indicatorColor: Colors.teal,
                tabs: [
                  Tab(
                    text: 'Standard',
                  ),
                  Tab(
                    text: 'Programmer',
                  ),
                ],
              )),
          body: const TabBarView(
            children: [
              StandardScreen(),
              ProgrammerScreen(),
            ],
          ),
        ),
      ),
    );
  }
}
