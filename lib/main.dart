import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:graduation_project/Cubits/calculator_cubit/calculator_cubit.dart';
import 'package:graduation_project/Cubits/register_cubit/register_cubit.dart';
import 'package:graduation_project/Cubits/theme_cubit/theme_cubit.dart';
import 'package:graduation_project/Cubits/simplification_cubit/simplification_cubit.dart';
import 'package:graduation_project/UI/calculator/calculator.dart';
import 'package:graduation_project/UI/documentation/documentation.dart';
import 'package:graduation_project/UI/register.dart';
import 'package:graduation_project/UI/simpllification/simplification.dart';
import 'Models/app_config.dart';
import 'Cubits/login_cubit/login_cubit.dart';
import 'UI/login.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await UserConfig().init();

  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(
        create: (context) => RegisterCubit(),
      ),
      BlocProvider(
        create: (context) => LoginCubit(),
      ),
      BlocProvider(
        create: (context) => ThemeCubit(),
      ),
      BlocProvider(
        create: (context) => CalculatorCubit(),
      ),
      BlocProvider(
        create: (context) => SimplificationCubit(),
      ),
    ],
    child: Digeator(),
  ));
}

// ignore: must_be_immutable
class Digeator extends StatelessWidget {
  late String? routeName;
  Digeator({super.key});
  String currentTheme = 'system';
  @override
  Widget build(BuildContext context) {
    final _auth = FirebaseAuth.instance;
    routeName = UserConfig.getLastPage();
    return BlocConsumer<ThemeCubit, ThemeState>(
      listener: (context, state) {
        if (state is ThemeStateLight)
          currentTheme = 'light';
        else if (state is ThemeStateDark)
          currentTheme = 'dark';
        else
          currentTheme = 'system';
      },
      builder: (context, state) => MaterialApp(
        title: 'Digeator',
        //home: Login(),
        theme: ThemeData(
          brightness: Brightness.light,
          fontFamily: 'RobotoCondensed',
          primarySwatch: Colors.teal,
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          fontFamily: 'RobotoCondensed',
          primarySwatch: ThemeColors.tealAc,
        ),
        themeMode: currentTheme == 'system'
            ? ThemeMode.system
            : currentTheme == 'light'
                ? ThemeMode.light
                : ThemeMode.dark,
        routes: {
          '/login': (ctx) => Login(),
          '/register': (ctx) => Register(),
          '/calculator': (ctx) => Calculator(),
          '/simplification': (ctx) => Simplification(),
          '/documentation': (ctx) => Documentation(),
        },
        initialRoute: routeName == null ? '/login' : routeName!,
        // initialRoute: _auth.currentUser != null ? '/calculator' : '/login',
      ),
    );
  }
}
