// ignore_for_file: constant_identifier_names, non_constant_identifier_names

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

class Validator {
  //data members
  String input = "";
  String currentNumberSystem = "";
  MyToken? current_token;
  MyToken? previous_token;
  bool error = false;
  List<String> operator = ['&', '|', '~', '(', ')', '<<', '>>'];
  RuneIterator? iter;

  //Constractor
  Validator(this.input, this.currentNumberSystem) {
    iter = input.runes.iterator;
  }

  //Functions
  bool isOperator(String s) {
    return operator.contains(s);
  }

  bool isAlpha(String ch) {
    return ((ch.codeUnitAt(0) >= 'a'.codeUnitAt(0) &&
            ch.codeUnitAt(0) <= 'z'.codeUnitAt(0)) ||
        (ch.codeUnitAt(0) >= 'A'.codeUnitAt(0) &&
            ch.codeUnitAt(0) <= 'Z'.codeUnitAt(0)));
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
      }
    } else if (isAlpha(ch)) {
      s = ch;
      if (iter!.moveNext()) {
        ch = iter!.currentAsString;
        if (isAlpha(ch)) return MyToken(Token.ERROR_SY);
        if (!isAlpha(ch)) iter!.movePrevious();
      }
      return MyToken(Token.NUMBER_SY);
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
      print("${name(t)}  is matched\n");
    } else if (t.name == current_token?.name && (t.name == Token.NUMBER_SY)) {
      print("${name(t)}  is matched with value ${current_token?.value}\n");
    } else {
      syntax_error(current_token!);
      error = true;
    }
    current_token = getToken();
  }

  // sampleValidator : s EOF
  int validat() {
    current_token = getToken();
    int tmp = z();
    match(MyToken(Token.END_SOURCE_SY));
    return tmp;
  }

  // s: s + e | e
  //1 s: e x
  //2 x: ‘+’e x | €
  //
  int z() {
    int tmp = o(); //2
    while (current_token?.name == Token.OR_SY ||
        current_token?.name == Token.NOR_SY) {
      if (current_token?.name == Token.OR_SY) {
        match(MyToken(Token.OR_SY));
        tmp = tmp | o();
      } else if (current_token?.name == Token.NOR_SY) {
        match(MyToken(Token.NOR_SY));
        tmp = ~(tmp | o());
      }
    }
    return tmp;
  }

  int o() {
    int tmp = s(); //2
    while (current_token?.name == Token.XOR_SY ||
        current_token?.name == Token.XNOR_SY) {
      if (current_token?.name == Token.XOR_SY) {
        match(MyToken(Token.XOR_SY));
        tmp = tmp ^ s();
      } else if (current_token?.name == Token.XNOR_SY) {
        match(MyToken(Token.XNOR_SY));
        tmp = ~(tmp ^ s());
      }
    }
    return tmp;
  }

  int s() {
    int tmp = e(); //2
    while (current_token?.name == Token.AND_SY ||
        current_token?.name == Token.NAND_SY) {
      if (current_token?.name == Token.AND_SY) {
        match(MyToken(Token.AND_SY));
        tmp = tmp & e();
      } else if (current_token?.name == Token.NAND_SY) {
        match(MyToken(Token.NAND_SY));
        tmp = ~(tmp & e());
      }
    }
    return tmp;
  }

  // e: e << t | t
  // e: t w
  //w: << t w | #
  int e() {
    int tmp1 = t();
    while (current_token?.name == Token.SL_SY ||
        current_token?.name == Token.SR_SY) {
      if (current_token?.name == Token.SL_SY) {
        match(MyToken(Token.SL_SY));
        tmp1 = tmp1 << t();
      } else {
        match(MyToken(Token.SR_SY));
        tmp1 = tmp1 >> t();
      }
    }
    return tmp1;
  }

  // <t> -> ~ E | <Q>
  int t() {
    if (current_token?.name == Token.NOT_SY) {
      match(MyToken(Token.NOT_SY));
      int tmp = e();
      if (tmp == 1)
        return 0;
      else
        return 1;
    } else
      return q();
  }

// <Q> -> (<S>) | <digit>
  int q() {
    if (current_token?.name == Token.LB_SY) {
      match(MyToken(Token.LB_SY));
      int tmp = z();
      match(MyToken(Token.RB_SY));
      return tmp;
    } else {
      match(MyToken(Token.NUMBER_SY));
      return previous_token?.value ?? 0;
    }
  }
}

void main() {
  //print((BigInt.from(-5).toUnsigned(64).decToBinary()));
  //print("999999999999999999".length); //18 int
  // | ^ & << >> ~ ( )
  Validator p = Validator("A&b|C&~(k!&c>>p!|m^o!^y)", "bin");
  p.validat();
  print(p.error);
}
