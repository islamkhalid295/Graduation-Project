
/*
1100&1101 + 1111
<E> -> <E> weak <T> | <T>
\\<E> -> <T> <E'>
\\<E'> -> # | weak <T> <E'>
<T> -> <T> strong <F> | <F>
//<T> -> <F> <T'>
//<T'> -> # | S
<F> -> ~ E | <Q>
<Q> -> (<E>) | <digit>
<digit> = 1 ~ 9 , a ~ f


E ->

*/

import 'package:number_system/number_system.dart';

class MyParser {
  // <fields>
  String input = "";
  String currentNumberSystem = "";
  List <String> operator = ['&','|','~','(',')'];
  String intBuffer = '';

  MyParser(); // <constructors>


  // <functions>
  bool isOperator (String s){
    return operator.contains(s);
  }

  bool isAlpha(String ch){
    return( (ch.codeUnitAt(0) >= 'a'.codeUnitAt(0) && ch.codeUnitAt(0) <= 'z'.codeUnitAt(0)) || (ch.codeUnitAt(0) >= 'A'.codeUnitAt(0) && ch.codeUnitAt(0) <= 'Z'.codeUnitAt(0)));
  }
  bool isNum(String ch){
    return( (ch.codeUnitAt(0) >= '0'.codeUnitAt(0) && ch.codeUnitAt(0) <= '9'.codeUnitAt(0)));
  }
  bool isDigit(String ch){
    return(isAlpha(ch)||isNum(ch));
  }

  String parse (String input, String currentNumberSystem)
  {
    intBuffer = '';
    String clearstring = input.replaceAll(' ', '').trim();
    RuneIterator iter = input.runes.iterator;
    String result="";

    if(currentNumberSystem == "dec") return input;

    while (iter.moveNext()) {
      final String ch = iter.currentAsString;

      if(isOperator(ch) || iter.rawIndex == input.length-1){
        int? w = input.replaceFirst(intBuffer,intBuffer.binaryToDec().toString()).indexOf(ch)+1;
        if(iter.rawIndex == input.length-1) {
          intBuffer += ch;
          w = null;
        }
        switch (currentNumberSystem) {
            case "bin":
              {
                result += input.replaceFirst(intBuffer,intBuffer.binaryToDec().toString()).substring(0,w);
                if(iter.rawIndex == input.length-1) return result;
                input = input.replaceFirst(intBuffer,intBuffer.binaryToDec().toString()).substring(w??=1);
                iter = input.runes.iterator;
                intBuffer="";
              }
              break;
            case "hex":
              {
                result = input.replaceFirst(intBuffer,intBuffer.hexToDEC().toString());
                intBuffer="";
              }
              break;
            case "oct":
              {
                result = input.replaceFirst(intBuffer,int.parse(intBuffer).octalToDec().toString());
                intBuffer="";
              }
              break;

          }
      }
      else if(isDigit(ch)){
        intBuffer += ch;
      }else{
        return "enter valid expressions";
      }
    }
    // while(!(input.isEmpty)){
    //   if(input[1].)
    //
    // }
    return result;
  }
}


void main ()
{
  //Parser p = Parser("1010|10110&101");
  //p.sampleParser();
  // String q = p.parse("1010|10110&101","bin");// 10010<<2 01000  1001000
  // //print(p.isAlpha('q'));
  // print(p.isDigit('p'));
  MyParser p = MyParser();
  print(p.parse("101&110|001", "bin"));
  //String r ="1100&1010", intBuffer = "1100" ;
  //String x="1100".binaryToDec().toString();
  //String r = "q;
  //String u = r.replaceFirst(intBuffer,x);
  // q="\$\{${q}\}";
  // String w = "10|22&5";
  // print(q);
  // print(10|22&5);
}