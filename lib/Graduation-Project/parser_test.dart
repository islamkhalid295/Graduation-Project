
/*
1100&1101 + 1111
<E> -> <E> weak <T> | <T>
\\<E> -> e<T> x<E'>
\\x<E'> -> # | weak e<T> x<E'>
<T> -> <T> strong <F> | <F>
//<T> -> <F> <T'>
//<T'> -> # | strong <F> <T'>
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

enum Token {
  PLUS_SY, minus_SY ,SL_SY, SR_SY,AND_SY,OR_SY,NOT_SY ,NUMBER_SY, END_SOURCE_SY, ERROR_SY

  /*PROGRAM_SY, IS_SY, BEGIN_SY, END_SY, VAR_SY, INTEGER_SY, BOOL_SY, SKIP_SY, READ_SY, WRITE_SY, WHILE_SY, DO_SY, IF_SY, THEN_SY
	, ELSE_SY, LPARN_SY, RPARN_SY, OR_SY, AND_SY, TRUE_SY, FALSE_SY, NOT_SY, ID, LEQ_SY, LTHAN_SY, EQUAL_SY, COLON_SY, GTHAN_SY, GEQ_SY, NOTEQ_SY, PLUS_SY, MINUS_SY, SL_SY
	, DIV_SY, NUMBER_SY, SEMICOLON_SY, COMMA_SY, COMMENT_SY, END_SOURCE_SY, ERROR_SY*/
}
class MyToken {

  Token? name;
  double? value;

  MyToken(this.name, {this.value});


// MyToken (){}
// MyToken(Token s) {
//   name = s;
// }MyToken(Token s, double d) {
//   name = s;
//   value = d;
// }

}
class Parser {

  String input="";
  MyToken? current_token;
  List <String> operator = ['&','|','~','(',')'];
  RuneIterator? iter;
  Parser(this.input) {
    iter = input.runes.iterator;
  }

  /*Token checkReserved(String s) {
		if (s == "program")
			return PROGRAM_SY;
		else if (s == "is")
			return IS_SY;
		else if (s == "begin")
			return BEGIN_SY;
		else if (s == "end")
			return END_SY;
		else if (s == "var")
			return VAR_SY;
		else if (s == "integer")
			return INTEGER_SY;
		else if (s == "boolean")
			return BOOL_SY;
		else if (s == "skip")
			return SKIP_SY;
		else if (s == "read")
			return READ_SY;
		else if (s == "write")
			return WRITE_SY;
		else if (s == "while")
			return WHILE_SY;
		else if (s == "do")
			return DO_SY;
		else if (s == "if")
			return IF_SY;
		else if (s == "then")
			return THEN_SY;
		else if (s == "else")
			return ELSE_SY;
		else if (s == "or")
			return OR_SY;
		else if (s == "and")
			return AND_SY;
		else if (s == "true")
			return TRUE_SY;
		else if (s == "false")
			return FALSE_SY;
		else
			return ID;
	}*/


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

  MyToken getToken() {
    String ch;
    String s = "";

    bool eof = !(iter!.moveNext());
    ch = iter!.currentAsString;
    if (eof) {
      return MyToken(Token.END_SOURCE_SY);
    }

    else if (ch == '&') {
      return MyToken(Token.AND_SY);
    }
    else if (ch == '|') {
      return MyToken(Token.OR_SY);
    }
    else if (ch == '<<') {
      return MyToken(Token.SL_SY);
    } else if (ch == '>>') {
      return MyToken(Token.SR_SY);
    }else if (isDigit(ch)) {
      s = ch;
      iter!.moveNext();
      ch = iter!.currentAsString;
      while (isDigit(ch)) {

        if (iter!.rawIndex==input.length-1) {
          break;
        }
        else {
          s += ch;
          iter!.moveNext();
          ch = iter!.currentAsString;
        }
      }
      if (!(iter!.rawIndex==input.length-1))
        iter!.movePrevious();
      else {
        iter!.moveNext();
        ch = iter!.currentAsString;
      }
      return MyToken(Token.NUMBER_SY,value: double.parse(s));

    }
    else {
      return MyToken(Token.ERROR_SY);
    }
  }
  String? name(MyToken t) {
    String s;
    switch (t.name)
    {
      case Token.PLUS_SY:
        return "+";
      case Token.minus_SY:
        return "-";
      case Token.AND_SY:
        return "&";
      case Token.OR_SY:
        return "|";
      case Token.NOT_SY:
        return "~";
      case Token.SR_SY:
        return "/";
      case Token.SL_SY:
        return "*";
      case Token.NUMBER_SY:
        return "number";
      case Token.ERROR_SY:
        return "Lexical Error\n";
      default:
        break;
    }
    if (t.name == Token.END_SOURCE_SY) {
      return "End of program";
    }
  }
  void syntax_error(MyToken t) {
    print("${name(t)} is not expected\n");
  }
  void match(MyToken t) {
    if (t.name == current_token?.name) {
      print("${name(t)}  is matched\n");
    }
    else {
      syntax_error(current_token!);
    }
    current_token = getToken();
  }
  // sampleParser : s EOF
  void sampleParser() {
    current_token = getToken();
    s();
    match(MyToken(Token.END_SOURCE_SY));
  }
  // s: s + e | e
  //1 s: e x
  void s() {

    e();
    x();
  }
  //2 x: ‘+’e x | €
  void x() {
    while (current_token?.name == Token.AND_SY || current_token?.name == Token.OR_SY)
    {
      if(current_token?.name == Token.AND_SY) {
        match(MyToken(Token.AND_SY));
        x();
      }else{
        match(MyToken(Token.OR_SY));
        x();
      }
    }
    if(current_token?.name == Token.NUMBER_SY)
      e();
  }
  // e: e * t | t
  // e: t w
  void e() {
    t();
    w();
  }
  //w: * t w | #
  void w() {
    while (current_token?.name == Token.SL_SY || current_token?.name == Token.SR_SY)
    {
      if(current_token?.name == Token.SL_SY) {
        match(MyToken(Token.SL_SY));
      } else {
        match(MyToken(Token.SR_SY));
      }
      t();
    }

  }
  // <t> -> ~ E | <Q>
  // <Q> -> (<E>) | <digit>
  // t: C B t    | D B t  | '-'  B t | B |€  ;
  void t() {
    if (current_token?.name == Token.NOT_SY) e();
    else q();
  }

  void q() {
    if (current_token?.name == Token.NUMBER_SY)
    {
      match(MyToken(Token.NUMBER_SY));
    }
    else
    {
      syntax_error(current_token!);
    }

  }

}
// int main() {
//   String filename = "data.txt";
//   Parser p(filename);
//   p.sampleParser();
//   system("pause");
//   return 0;
// }
void main ()
{
  Parser p = Parser("10&&&&10|101&10&&|101");
  p.sampleParser();
  // String q = p.parse("1010|10110&101","bin");// 10010<<2 01000  1001000
  // //print(p.isAlpha('q'));
  // print(p.isDigit('p'));
  //String r ="1100&1010", intBuffer = "1100" ;
  //String x="1100".binaryToDec().toString();
  //String r = "q;
  //String u = r.replaceFirst(intBuffer,x);
  // q="\$\{${q}\}";
  // String w = "10|22&5";
  // print(q);
  // print(10|22&5);
}