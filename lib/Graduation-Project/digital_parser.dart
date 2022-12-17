import 'package:number_system/number_system.dart';
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
*/

class MyParser {
  // <fields>
  String input = "";
  String currentNumberSystem = "";
  List <String> operator = ['&','|','~','(',')','<<','>>'];
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
  PLUS_SY, minus_SY ,SL_SY, SR_SY,AND_SY,OR_SY,NOT_SY ,NUMBER_SY, END_SOURCE_SY, ERROR_SY, LB_SY, RB_SY
}
class MyToken {
//data members
  Token? name;
  double? value;
//constractor
  MyToken(this.name, {this.value});
}
class Parser {
  //data members
  String input="";
  MyToken? current_token;
  MyToken? previous_token;
  bool error = false;
  List <String> operator = ['&','|','~','(',')','<<','>>'];
  RuneIterator? iter;

  //Constractor
  Parser(this.input) {
    iter = input.runes.iterator;
  }

  //Functions
  bool isOperator (String s){
    return operator.contains(s);
  }
  bool isDigit(String ch){
    bool isAlpha(String ch){
      return( (ch.codeUnitAt(0) >= 'a'.codeUnitAt(0) && ch.codeUnitAt(0) <= 'z'.codeUnitAt(0)) || (ch.codeUnitAt(0) >= 'A'.codeUnitAt(0) && ch.codeUnitAt(0) <= 'Z'.codeUnitAt(0)));
    }
    bool isNum(String ch){
      return( (ch.codeUnitAt(0) >= '0'.codeUnitAt(0) && ch.codeUnitAt(0) <= '9'.codeUnitAt(0)));
    }
    return(isAlpha(ch)||isNum(ch));
  }
  MyToken getToken() {
    String ch;
    String s = "";
    previous_token = current_token;
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
    else if (ch == '~') {
      return MyToken(Token.NOT_SY);
    }
    else if (ch == '(') {
      return MyToken(Token.LB_SY);
    }
    else if (ch == ')') {
      return MyToken(Token.RB_SY);
    }
    else if (ch == '<') {
      iter!.moveNext();
      ch = iter!.currentAsString;
      if(ch == '<'){
        return MyToken(Token.SL_SY);
      }else{
        iter!.movePrevious();
        return MyToken(Token.ERROR_SY);
      }
    } else if (ch == '>') {
      iter!.moveNext();
      ch = iter!.currentAsString;
      if(ch == '>'){
        return MyToken(Token.SR_SY);
      }else{
        iter!.movePrevious();
        return MyToken(Token.ERROR_SY);
      }
    }else if (isDigit(ch)) {
      s = ch;
      if(iter!.moveNext()) {
        ch = iter!.currentAsString;
        while (isDigit(ch)) {
          if (iter!.rawIndex == input.length - 1) {
            break;
          } else {
            s += ch;
            iter!.moveNext();
            ch = iter!.currentAsString;
          }
        }
        if (!isDigit(ch))
          iter!.movePrevious();

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
        return ">>";
      case Token.SL_SY:
        return "<<";
      case Token.LB_SY:
        return "(";
      case Token.RB_SY:
        return ")";
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
    if (t.name == current_token?.name && !(t.name == Token.NUMBER_SY)) {
      print("${name(t)}  is matched\n");
    }else if(t.name == current_token?.name && (t.name == Token.NUMBER_SY)) {
      print("${name(t)}  is matched with value ${current_token?.value}\n");
    }
    else {
      syntax_error(current_token!);
      error = true;
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
  //2 x: ‘+’e x | €
  //
  void s() {
    e();
    while (current_token?.name == Token.AND_SY || current_token?.name == Token.OR_SY)
    {
      if (current_token?.name == Token.AND_SY) {
        match(MyToken(Token.AND_SY));
      } else {
        match(MyToken(Token.OR_SY));
      }
      e();
    }
  }
  // e: e << t | t
  // e: t w
  //w: << t w | #
  void e() {
    t();
    while (current_token?.name == Token.SL_SY || current_token?.name == Token.SR_SY)
    {
      if(current_token?.name == Token.SL_SY) {
        match(MyToken(Token.SL_SY));
      } else {
        match(MyToken(Token.SR_SY));
      }
      t();
    }
    // if(current_token?.name == Token.NUMBER_SY)
    //   e();

  }
  // <t> -> ~ E | <Q>
  void t() {
    if (current_token?.name == Token.NOT_SY) {
      match(MyToken(Token.NOT_SY));
      e();
    } else q();
  }
// <Q> -> (<E>) | <digit>
  void q() {
    if(current_token?.name == Token.LB_SY)
    {
      match(MyToken(Token.LB_SY));
      s();
      match(MyToken(Token.RB_SY));
    }else
      match(MyToken(Token.NUMBER_SY));
  }
  void o(){
    match(MyToken(Token.NUMBER_SY));
  }

}
void main ()
{
  //& | ^ << >> ~ ( )
  //Parser p = Parser("51|(2&6>>(5|(6<<7)))");
  Parser p = Parser("12|(14|~15&5<<2)");
  p.sampleParser();

}