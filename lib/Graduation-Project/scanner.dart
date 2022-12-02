
/*

<E> -> <E> weak <T> | <T>
<T> -> <T> strong <F> | <F>
<F> -> ~ E | <Q>
<Q> -> (<E>) | <digit>
<digit> = 1 ~ 9 , a ~ f

*/

import 'package:calculator/Graduation-Project/scanner.dart';

class MyParser {
  // <fields>
  // String input = "";

  // <constructors>
  MyParser();

  // <functions>
  bool isAlpha(String ch){
    return( (ch.codeUnitAt(0) >= 'a'.codeUnitAt(0) && ch.codeUnitAt(0) <= 'z'.codeUnitAt(0)) || (ch.codeUnitAt(0) >= 'A'.codeUnitAt(0) && ch.codeUnitAt(0) <= 'Z'.codeUnitAt(0)));
  }
  bool isDigit(String ch){
    return( (ch.codeUnitAt(0) >= '0'.codeUnitAt(0) && ch.codeUnitAt(0) <= '9'.codeUnitAt(0)));
  }

  String bitEval (String input)
  {
    String result="";

    // while(!(input.isEmpty)){
    //   if(input[1].)
    //
    // }
    return result;
  }
}
void main ()
{
  MyParser p = new MyParser();
  //print(p.isAlpha('q'));
  print(p.isDigit('p'));
}