/*
Precedence	Operator	Associativity
0 (  )
1	~(Bitwise negation)	Right to left
2	<<(Bitwise LeftShift) , >>(Bitwise RightShift)	Left to Right
3	& (Bitwise AND)	Left to Right
4	^(Bitwise XOR)	Left to Right
5	| (Bitwise Or)	Left to Right


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

import 'functions.dart';

enum Token {
  PLUS_SY,
  minus_SY,
  SL_SY,
  SR_SY,
  AND_SY,
  NAND_SY,
  OR_SY,
  NOR_SY,
  NOT_SY,
  NUMBER_SY,
  END_SOURCE_SY,
  ERROR_SY,
  LB_SY,
  RB_SY,
  XOR_SY,
  XNOR_SY
}

class MyToken {
//data members
  Token? name;
  int? value;

//constractor
  MyToken(this.name, {this.value});
}
class explanationStep {
  String expr = "";
  String updatedPart = "";
  int result = 0;
  String exprAfter = "";
  int start = 0;
  int end = 0;

  explanationStep(this.expr, this.updatedPart, this.result, this.exprAfter, this.start, this.end);

  @override
  String toString() {
    return 'explanationStep{expr: $expr, updatedPart: $updatedPart, result: $result, exprAfter: $exprAfter, start: $start, end: $end}';
  }

}
class Parser {
  //data members
  String input = "";
  String userExp= "";
  String currentNumberSystem = "";
  MyToken? current_token;
  MyToken? previous_token;
  bool error = false;
  List<String> operator = ['&', '|', '~', '(', ')', '<<', '>>','!|','!&','!^'];
  RuneIterator? iter;
  explanationStep init = new explanationStep("expr", "updatedPart", 0, "", 0, 0);
  List<explanationStep>explan = [];
  int myRadix=0;


  //Constructor
  Parser(this.input, this.currentNumberSystem) {
    iter = input.runes.iterator;
    userExp= expGenerator(input.toLowerCase());
    init = new explanationStep("", "", 0, userExp, 0, 0);
    explan.add(init);
    switch (this.currentNumberSystem) {
      case "bin":
        {
          myRadix=2;
        }
        break;
      case "hex":
        {
          myRadix = 16;
        }
        break;
      case "oct":
        {
          myRadix = 8;
        }
        break;
      default:
        {
          myRadix = 10;
        }
    }

  }

  //Functions
  // bool isOperator(String s) {
  //   return operator.contains(s);
  // }
  String expGenerator(String s){
    s = s.replaceAll("!&" , " NAND ");
    s = s.replaceAll("&" , " AND ");
    s = s.replaceAll("!^" , " XNOR ");
    s = s.replaceAll("!|", " NOR ");
    s = s.replaceAll("^" , " XOR ");
    s = s.replaceAll("|" , " OR ");
    s = s.replaceAll("~" , "NOT ");
    //s = s.replaceAll(" ", "");
    return s;
  }
  bool isDigit(String ch) {
    bool isAlpha(String ch) {
      return ((ch.codeUnitAt(0) >= 'a'.codeUnitAt(0) &&
          ch.codeUnitAt(0) <= 'f'.codeUnitAt(0)) ||
          (ch.codeUnitAt(0) >= 'A'.codeUnitAt(0) &&
              ch.codeUnitAt(0) <= 'F'.codeUnitAt(0)));
    }

    bool isNum(String ch) {
      return ((ch.codeUnitAt(0) >= '0'.codeUnitAt(0) &&
          ch.codeUnitAt(0) <= '9'.codeUnitAt(0)));
    }

    return (isAlpha(ch) || isNum(ch));
  }

  MyToken getToken() {
    String ch;
    String s = "";
    previous_token = current_token;
    bool eof = !(iter!.moveNext());
    ch = iter!.currentAsString;
    if (eof) {
      return MyToken(Token.END_SOURCE_SY);
    } else if (ch == '&') {
      return MyToken(Token.AND_SY);
    } else if (ch == '^') {
      return MyToken(Token.XOR_SY);
    } else if (ch == '|') {
      return MyToken(Token.OR_SY);
    } else if (ch == '~') {
      return MyToken(Token.NOT_SY);
    } else if (ch == '(') {
      return MyToken(Token.LB_SY);
    } else if (ch == ')') {
      return MyToken(Token.RB_SY);
    } else if (ch == '<') {
      iter!.moveNext();
      ch = iter!.currentAsString;
      if (ch == '<') {
        return MyToken(Token.SL_SY);
      } else {
        iter!.movePrevious();
        return MyToken(Token.ERROR_SY);
      }
    } else if (ch == '>') {
      iter!.moveNext();
      ch = iter!.currentAsString;
      if (ch == '>') {
        return MyToken(Token.SR_SY);
      } else {
        iter!.movePrevious();
        return MyToken(Token.ERROR_SY);
      }
    } else if (ch == '!') {
      iter!.moveNext();
      ch = iter!.currentAsString;
      switch (ch) {
        case '&':
          return MyToken(Token.NAND_SY);
        case '|':
          return MyToken(Token.NOR_SY);
        case '^':
          return MyToken(Token.XNOR_SY);
        default:
          iter!.movePrevious();
          return MyToken(Token.ERROR_SY);
      }}
    else if (isDigit(ch)) {
      s = ch;
      if (iter!.moveNext()) {
        ch = iter!.currentAsString;
        while (isDigit(ch)) {
          if (iter!.rawIndex == input.length - 1) {
            s += ch;
            break;
          } else {
            s += ch;
            iter!.moveNext();
            ch = iter!.currentAsString;
          }
        }
        if (!isDigit(ch)) iter!.movePrevious();
      }
      return MyToken(Token.NUMBER_SY, value: int.parse(s, radix: myRadix));
    } else {
      return MyToken(Token.ERROR_SY);
    }
  }

  String? name(MyToken t) {
    switch (t.name) {
      case Token.AND_SY:
        return "&";
      case Token.NAND_SY:
        return "!&";
      case Token.OR_SY:
        return "|";
      case Token.NOR_SY:
        return "!|";
      case Token.NOT_SY:
        return "~";
      case Token.XOR_SY:
        return "^";
      case Token.XNOR_SY:
        return "!^";
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
      //print("${name(t)}  is matched\n");
    } else if (t.name == current_token?.name && (t.name == Token.NUMBER_SY)) {
      //print("${name(t)}  is matched with value ${current_token?.value}\n");
    } else {
      syntax_error(current_token!);
      error = true;
    }
    current_token = getToken();
  }

  // sampleParser : s EOF
  int sampleParser() {

    current_token = getToken();
    int tmp = z();
    match(MyToken(Token.END_SOURCE_SY));
    for(int i = 0 ; i < explan.length ; i++){
      print("${i} : ${explan[i].toString()}");
    }
    //print(explan);
    return tmp;
  }

  // s: s + e | e
  //1 s: e x
  //2 x: ‘+’e x | €
  //
  int z() {
    int tmp = o(); //2
    while (current_token?.name == Token.OR_SY || current_token?.name == Token.NOR_SY) {
      if(current_token?.name == Token.OR_SY) {
        match(MyToken(Token.OR_SY));
        int tmp2 = o();
        String s="${tmp.toRadixString(myRadix)} OR ${tmp2.toRadixString(myRadix)}";
        tmp = tmp | tmp2;
        explanationStep step = new explanationStep(explan.last.exprAfter, s, int.parse(tmp.toRadixString(myRadix)), explan.last.exprAfter.replaceFirst(s, tmp.toRadixString(myRadix)),explan.last.exprAfter.indexOf(s), s.length + explan.last.exprAfter.indexOf(s));
        explan.add(step);

      }else if(current_token?.name == Token.NOR_SY){
        match(MyToken(Token.NOR_SY));
        int tmp2 = o();
        String s = "${tmp.toRadixString(myRadix)} NOR ${tmp2.toRadixString(myRadix)}";
        tmp = ~(tmp | tmp2);
        explanationStep step = new explanationStep(explan.last.exprAfter, s, int.parse(tmp.toRadixString(myRadix)), explan.last.exprAfter.replaceFirst(s, tmp.toRadixString(myRadix)),explan.last.exprAfter.indexOf(s), s.length + explan.last.exprAfter.indexOf(s));
        explan.add(step);
      }
    }
    return tmp;
  }

  int o() {
    int tmp = s(); //2
    int tmp2;
    while (current_token?.name == Token.XOR_SY || current_token?.name == Token.XNOR_SY) {
      if(current_token?.name == Token.XOR_SY) {
        match(MyToken(Token.XOR_SY));
        tmp2 = s();
        String ss = "${tmp.toRadixString(myRadix)} XOR ${tmp2.toRadixString(myRadix)}";
        tmp = tmp ^ tmp2;
        explanationStep step = new explanationStep(explan.last.exprAfter, ss, int.parse(tmp.toRadixString(myRadix)), explan.last.exprAfter.replaceFirst(ss, tmp.toRadixString(myRadix)),explan.last.exprAfter.indexOf(ss), ss.length + explan.last.exprAfter.indexOf(ss));
        explan.add(step);
      }else if(current_token?.name == Token.XNOR_SY){
        match(MyToken(Token.XNOR_SY));
        tmp2 = s();
        String ss = "${tmp.toRadixString(myRadix)} XNOR ${tmp2.toRadixString(myRadix)}";
        tmp = ~(tmp ^ tmp2);
        explanationStep step = new explanationStep(explan.last.exprAfter, ss, int.parse(tmp.toRadixString(myRadix)), explan.last.exprAfter.replaceFirst(ss, tmp.toRadixString(myRadix)),explan.last.exprAfter.indexOf(ss), ss.length + explan.last.exprAfter.indexOf(ss));
        explan.add(step);
      }
    }
    return tmp;
  }

  int s() {
    int tmp = e(); //2
    while (current_token?.name == Token.AND_SY || current_token?.name == Token.NAND_SY ) {
      if(current_token?.name == Token.AND_SY) {
        match(MyToken(Token.AND_SY));
        int tmp2 = e();
        String s ="${tmp.toRadixString(myRadix)} AND ${tmp2.toRadixString(myRadix)}";
        tmp = tmp & tmp2 ;
        explanationStep step = new explanationStep(explan.last.exprAfter, s, int.parse(tmp.toRadixString(myRadix)), explan.last.exprAfter.replaceFirst(s, tmp.toRadixString(myRadix)),explan.last.exprAfter.indexOf(s), s.length + explan.last.exprAfter.indexOf(s));
        explan.add(step);
      }else if (current_token?.name == Token.NAND_SY){
        match(MyToken(Token.NAND_SY));
        int tmp2 = e();
        String s = "${tmp.toRadixString(myRadix)} NAND ${tmp2.toRadixString(myRadix)}";
        tmp = ~(tmp & tmp2);
        explanationStep step = new explanationStep(explan.last.exprAfter, s, int.parse(tmp.toRadixString(myRadix)), explan.last.exprAfter.replaceFirst(s, tmp.toRadixString(myRadix)),explan.last.exprAfter.indexOf(s), s.length + explan.last.exprAfter.indexOf(s));
        explan.add(step);

      }
    }
    return tmp;
  }

  // e: e << t | t
  // e: t w
  //w: << t w | #
  int e() {
    int tmp = t();
    while (current_token?.name == Token.SL_SY ||
        current_token?.name == Token.SR_SY) {
      if (current_token?.name == Token.SL_SY) {
        match(MyToken(Token.SL_SY));
        String s = "${tmp.toRadixString(myRadix)} << ${t().toRadixString(myRadix)}";
        tmp = tmp << t();
        explanationStep step = new explanationStep(explan.last.exprAfter, s, int.parse(tmp.toRadixString(myRadix)), explan.last.exprAfter.replaceFirst(s, tmp.toRadixString(myRadix)),explan.last.exprAfter.indexOf(s), s.length + explan.last.exprAfter.indexOf(s));
        explan.add(step);
      } else {
        match(MyToken(Token.SR_SY));
        String s = "${tmp.toRadixString(myRadix)} >> ${t().toRadixString(myRadix)}";
        tmp = tmp >> t();
        explanationStep step = new explanationStep(explan.last.exprAfter, s, int.parse(tmp.toRadixString(myRadix)), explan.last.exprAfter.replaceFirst(s, tmp.toRadixString(myRadix)),explan.last.exprAfter.indexOf(s), s.length + explan.last.exprAfter.indexOf(s));
        explan.add(step);
      }
    }
    return tmp;
  }

  // <t> -> ~ E | <Q>
  int t() {
    if (current_token?.name == Token.NOT_SY) {
      match(MyToken(Token.NOT_SY));
      int tmp = e();
      String s = "NOT ${tmp.toRadixString(myRadix)}";
      explanationStep step = new explanationStep(explan.last.exprAfter, s, int.parse((~tmp).toRadixString(myRadix)), explan.last.exprAfter.replaceFirst(s, (~tmp).toRadixString(myRadix)),explan.last.exprAfter.indexOf(s), s.length + explan.last.exprAfter.indexOf(s));
      explan.add(step);
      return ~tmp;
    } else
      return q();
  }

// <Q> -> (<S>) | <digit>
  int q() {
    if (current_token?.name == Token.LB_SY) {
      match(MyToken(Token.LB_SY));
      int tmp = z();
      String s = "(${tmp.toRadixString(myRadix)})";
      explanationStep step = new explanationStep(explan.last.exprAfter, s, int.parse(tmp.toRadixString(myRadix)), explan.last.exprAfter.replaceFirst(s, tmp.toRadixString(myRadix)),explan.last.exprAfter.indexOf(s), s.length + explan.last.exprAfter.indexOf(s));
      explan.add(step);
      match(MyToken(Token.RB_SY));
      return tmp;
    } else {
      match(MyToken(Token.NUMBER_SY));
      return previous_token?.value ?? 0;
    }
  }
}

void main() {



  //print(~5);

  //print((5).toRadixString(10));
  String input = "30";
  int s = 5;
 // int.parse("7", radix: 2);
  //print(int.parse(s.toRadixString(2)));
  //print(tmp.toRadixString(2).);

  //print(BigInt.from(~1).toUnsigned(1).toRadixString(2));
  //print((6).toRadixString(2));
  //print((BigInt.from(-5).toUnsigned(64).decToBinary()));
  //print("999999999999999999".length); //18 int
  // | ^ & << >> ~ ( )
  //Parser p = Parser("51|(2&6>>(5|(6<<7)))");
  //Parser p = Parser("9<<~8","dec");
  // try {
   Parser p = Parser("F!&36|E8", "hex");
   //Parser p = Parser("7!&2|5", "oct");
   //Parser p = Parser("101!&110|~11&1001!|(111!^1010)", "bin");
  //   //   //                 101!&110|~11&1001!|-14
  //   //   //                 101!&110|-4&1001!|-14
  //   //   //                 -5|-5!|-14
  //   //   //                 -5!|-14
  //   //   //                 4
  print(p.sampleParser());
  // } catch (e) {
  //   print("Result not defined");
  // }
  //print(p.expGenerator("45 AND 74 NAND 7 XOR (NOT 88 OR 65)"));
  //Result not defined
  //Parser p = Parser("1001|0110&101<<10","bin");
  //print(5 ^ 8);
}
