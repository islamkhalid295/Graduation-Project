import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:number_system/number_system.dart';
import 'home.dart';



// void main()=>runApp(const HomePage());
void main(){
  // 1100 AND 0101 OR 0111
  // print((~12).decToBinary());
  // print((~(12&5)).decToBinary());
  // print((~12&5).decToBinary());
  var x = "${12&5}";
  var resultText;
  Parser p = Parser();
  try {
    Expression exp = p.parse(x);
    ContextModel cm = ContextModel();
    double eval = exp.evaluate(EvaluationType.REAL, cm);
    resultText = eval.toString();
  } catch (e) {
    resultText = "Math Error";
  }


  print("sadsa ${x}");
  //    12&  5
  //      4
  //print(5<<2);
}




