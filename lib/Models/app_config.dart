import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/Cubits/theme_cubit/theme_cubit.dart';

class SizeConfig {
  MediaQueryData? mediaQueryData;
  static double? height;
  static double? width;
  static double? widthBlock;
  static double? heightBlock;
  static String fontName = 'RobotoCondensed';

  void init(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
    width = mediaQueryData!.size.width;
    height = mediaQueryData!.size.height;
    widthBlock = width! / 100;
    heightBlock = height! / 100;
  }
}

class ThemeColors {
  static const Color lightCanvas = Colors.white;
  static const Color darkCanvas = Color.fromRGBO(23, 23, 23, 1);
  static const Color lightForegroundTeal = Colors.teal;
  static const Color darkForegroundTeal = Colors.tealAccent;
  static const Color lightUnfocused = Color.fromRGBO(0, 0, 0, 0.4);
  static const Color darkUnfocused = Color.fromRGBO(255, 255, 255, 0.4);
  static const Color lightBlackText = Color.fromRGBO(5, 5, 5, 1);
  static const Color darkWhiteText = Color.fromRGBO(245, 245, 245, 1);
  static const MaterialColor tealAc = MaterialColor(0xFF64FFDA, <int, Color>{
    50: Color.fromRGBO(240, 255, 240, 1),
    100: Color.fromRGBO(200, 255, 235, 1),
    200: Color.fromRGBO(180, 255, 222, 1),
    300: Color.fromRGBO(160, 255, 219, 1),
    400: Color.fromRGBO(140, 255, 218, 1),
    500: Color(0xFF64FFDA),
    600: Color.fromRGBO(100, 245, 218, 1),
    700: Color.fromRGBO(100, 225, 218, 1),
    800: Color.fromRGBO(100, 205, 218, 1),
    900: Color.fromRGBO(100, 180, 218, 1),
  });

  static const Color lightElemBG = Color.fromRGBO(232, 232, 232, 1);
  static const Color darkElemBG = Color.fromRGBO(41, 41, 41, 1);
  static const Color lightSelectedSystemBG = Color.fromRGBO(209, 209, 209, 1);
  static const Color darkSelectedSystemBG = Color.fromRGBO(96, 96, 96, 1);
  static const Color blueColor = Color.fromRGBO(68, 138, 255, 1);
  static const Color redColor = Color.fromRGBO(255, 82, 82, 1);
}

String checkTheme(String theme, BuildContext context) {
  if (theme == 'light')
    return 'light';
  else if (theme == 'dark')
    return 'dark';
  else {
    if (Theme.of(context).brightness == Brightness.light)
      return 'light';
    else
      return 'dark';
  }
}
