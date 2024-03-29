import 'package:flutter/material.dart';
import 'package:graduation_project/Models/documentation_element_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

class UserConfig {
  static SharedPreferences? pref;

  static late bool? calculatorG;
  static late bool? simplificationG;
  static late String? pageRoute;
  Future<void> init() async {
    pref = await SharedPreferences.getInstance();
    // pageRoute = await getLastPage();
    // calculatorG = await getCalculatorGuidance();
    // simplificationG = await getSimplificationGuidance();
  }

  static void setTheme(String theme) {
    pref!.setString('theme', theme);
  }

  static String? getTheme() {
    return pref!.getString('theme');
  }

  static void setLastPage(String theme) {
    pref!.setString('lastPage', theme);
  }

  static String? getLastPage() {
    return pref!.getString('lastPage');
  }

  static void setCalculatorGuidance(bool val) {
    pref!.setBool('calculatorG', val);
  }

  static void setSimplificationGuidance(bool val) {
    pref!.setBool('simplificationG', val);
  }

  static bool? getCalculatorGuidance() {
    return pref!.getBool('calculatorG');
  }

  static bool? getSimplificationGuidance() {
    return pref!.getBool('simplificationG');
  }
}

/*List<String> testSimplificationHistory = [
  'A AND B OR C XOR D',
  'A AND B ( OR C XOR D )',
  'A OR B OR C XOR D',
  'A AND B AND ( C XOR D )',
  'A AND B OR C XOR D',
  'A AND B OR C XOR D',
  'A AND B ( OR C XOR D )',
  'A OR B OR C XOR D',
  'A AND B AND ( C XOR D )',
  'A AND B OR C XOR D',
  'A AND B OR C XOR D',
  'A AND B ( OR C XOR D )',
  'A OR B OR C XOR D',
  'A AND B AND ( C XOR D )',
  'A AND B OR C XOR D',
  'A AND B OR C XOR D',
  'A AND B ( OR C XOR D )',
  'A OR B OR C XOR D',
  'A AND B AND ( C XOR D )',
  'A AND B OR C XOR D',
];


 */
List<DocumentationElement> documentation = [
  DocumentationElement(
    title: "AND Operator",
    description:
        "If both expressions evaluate to True, the AND operator returns True. If either or both expressions evaluate to False, the AND operator returns False",
    example: [
      Example(num1: "001", num2: "011", operation: "AND", result: "001")
    ],
    truthTable:
        TruthTable(zeroZero: '0', zeroOne: '0', oneZero: '0', oneOne: '1'),
  ),
  DocumentationElement(
    title: "OR Operator",
    description:
        "The logical OR operator, The result of the expression is true if either or both of the expressions are true. If both expressions are false, the result is false.",
    example: [
      Example(num1: "001", num2: "011", operation: "OR", result: "011")
    ],
    truthTable:
        TruthTable(zeroZero: '0', zeroOne: '1', oneZero: '1', oneOne: '1'),
  ),
  DocumentationElement(
    title: "NOT Operator",
    description:
        "The logical NOT operator  if the expression is true, the NOT operator will return false, and if the expression is false, the NOT operator will return true.",
    example: [Example(num1: "001", num2: "", operation: "NOT", result: "110")],
    truthTable: UnariTruthTable(zero: '0', one: '1'),
  ),
  DocumentationElement(
    title: "NAND Operator",
    description:
        "The NAND operator is a logical operator that combines two Boolean expressions. The result of the expression is false if both expressions are true. If either expression is false, the result is true.",
    example: [
      Example(num1: "001", num2: "011", operation: "NAND", result: "110")
    ],
    truthTable:
        TruthTable(zeroZero: '1', zeroOne: '1', oneZero: '1', oneOne: '0'),
  ),
  DocumentationElement(
    title: "NOR Operator",
    description:
        "The NOR operator is a logical operator that combines two Boolean expressions. The result of the expression is true if both expressions are false. If either expression is true, the result is false.",
    example: [
      Example(num1: "001", num2: "011", operation: "NOR", result: "100")
    ],
    truthTable:
        TruthTable(zeroZero: '1', zeroOne: '0', oneZero: '0', oneOne: '0'),
  ),
  DocumentationElement(
    title: "XOR Operator",
    description:
        "The XOR operator is a logical operator that combines two Boolean expressions. The result of the expression is true if and only if exactly one of the expressions is true. If both expressions are true or both expressions are false, the result is false.",
    example: [
      Example(num1: "001", num2: "011", operation: "XOR", result: "010")
    ],
    truthTable:
        TruthTable(zeroZero: '0', zeroOne: '1', oneZero: '1', oneOne: '0'),
  ),
  DocumentationElement(
    title: "XNOR Operator",
    description:
        "The XNOR operator is a logical operator that combines two Boolean expressions. The result of the expression is true if and only if both expressions are equal. If the expressions are not equal, the result is false.",
    example: [
      Example(num1: "001", num2: "011", operation: "XNOR", result: "101")
    ],
    truthTable:
        TruthTable(zeroZero: '1', zeroOne: '0', oneZero: '0', oneOne: '1'),
  ),
  DocumentationElement(
      title: "LSH Operator",
      description:
          "The LSH operator is a bitwise operator that performs a left shift on a binary number. The LSH operator takes two operands: the number to be shifted and the number of bits to shift by. The LSH operator works by shifting the bits of the number to the left by the specified number of bits. The bits that are shifted off the end of the number are discarded. Shifting to the left makes the number larger, effectively multiplying the number by pow(2, shiftAmount). ",
      example: [
        Example(num1: "1010", num2: "1", operation: "LSH", result: "10100")
      ]),
  DocumentationElement(
      title: "RSH Operator",
      description:
          "The RSH operator is a bitwise operator that performs a right shift on a binary number. The RSH operator takes two operands: the number to be shifted and the number of bits to shift by. The RSH operator works by shifting the bits of the number to the right by the specified number of bits. The bits that are shifted off the end of the number are discarded. The RSH operator can be used to divide a number by a power of 2. ",
      example: [
        Example(num1: "1010", num2: "1", operation: "RSH", result: "101")
      ]),
];
