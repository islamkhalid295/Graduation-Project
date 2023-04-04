import 'package:flutter/material.dart';
import 'package:graduation_project/Cubits/calculator_cubit/calculator_cubit.dart';
import 'package:graduation_project/Cubits/register_cubit/register_cubit.dart';
import 'package:graduation_project/Cubits/theme_cubit/theme_cubit.dart';
import 'package:graduation_project/Cubits/simplification_cubit/simplification_cubit.dart';
import 'package:graduation_project/UI/calculator/calculator.dart';
import 'package:graduation_project/UI/register.dart';
import 'package:graduation_project/UI/simpllification/simplification.dart';
import 'Models/app_config.dart';
import 'Cubits/login_cubit/login_cubit.dart';
import 'UI/login.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
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
  Digeator({super.key});
  String currentTheme = 'system';
  @override
  Widget build(BuildContext context) {
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
        },
        initialRoute: '/login',
      ),
    );
  }
}
