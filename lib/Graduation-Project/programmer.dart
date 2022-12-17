import 'package:calculator/Graduation-Project/digital_parser.dart';
import 'package:flutter/material.dart';
import 'package:number_system/number_system.dart';

class ProgrammerScreen extends StatefulWidget {
  const ProgrammerScreen({Key? key}) : super(key: key);

  @override
  State<ProgrammerScreen> createState() => _ProgrammerScreenState();
}

class _ProgrammerScreenState extends State<ProgrammerScreen> {
  String currentNumberSystem = 'dec';
  String input = "";
  String result = "";
  String binResult = "";
  String decResult = "";
  String hexResult = "";
  String octResult = "";
  MyParser p = MyParser();
  List <String> operator = ['&','|','~','(',')'];

bool isOperator (String s){
    return operator.contains(s);
  }

void check()
{
  switch (currentNumberSystem) {
    case "bin": {
      binResult = input;
      decResult = p.parse(binResult, currentNumberSystem);
      hexResult = int.parse(decResult).decToHex().toString();
      octResult = int.parse(decResult).decToOctal().toString();
    } break;
    case "dec": {
      decResult = input;
      binResult = int.parse(decResult).decToBinary().toString();
      hexResult = int.parse(decResult).decToHex().toString();
      octResult = int.parse(decResult).decToOctal().toString();
    } break;
    case "oct": {
      octResult = input;
      decResult = int.parse(octResult).octalToDec().toString();
      hexResult = int.parse(decResult).decToHex().toString();
      binResult = int.parse(decResult).decToBinary().toString();
    } break;
    case "hex": {
      hexResult = input;
      decResult = hexResult.hexToDEC().toString();
      binResult = int.parse(decResult).decToBinary().toString();
      octResult = int.parse(decResult).decToOctal().toString();
    } break;
    default: {
      //Body of default case
    } break;
  }
}
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      width: double.infinity,
      height: double.infinity,
      child: Column(children: [
        //==================================== Expression & Result ====================================//
        Expanded(
          flex: 1,
          child: Column(
            children: [
              //==================================== Expression ====================================//
              Expanded(
                flex: 1,
                child: Container(
                  alignment: AlignmentDirectional.centerEnd,
                  child: FittedBox(
                    child: SelectableText(
                      input,
                      textAlign: TextAlign.right,
                      style: Theme
                          .of(context)
                          .textTheme
                          .headline2,
                    ),
                  ),
                ),
              ),
              //==================================== Result ====================================//
              Expanded(
                flex: 2,
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text(
                        '=',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize:
                          Theme
                              .of(context)
                              .textTheme
                              .headline1!
                              .fontSize,
                          fontWeight:
                          Theme
                              .of(context)
                              .textTheme
                              .headline1!
                              .fontWeight,
                          color: Colors.teal,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: Container(
                        alignment: AlignmentDirectional.centerEnd,
                        child: FittedBox(
                          child: SelectableText(
                            result,
                            textAlign: TextAlign.right,
                            style: Theme
                                .of(context)
                                .textTheme
                                .headline1,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
        //==================================== Convert Part ====================================//
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Container(
              alignment: AlignmentDirectional.center,
              padding: const EdgeInsets.all(5),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.zero,
              ),
              child: Column(
                children: [
                  Expanded(
                    child: Material(
                      color: (currentNumberSystem == 'bin')?Colors.grey[400]:Colors.white,
                      child: InkWell(

                        onTap: () {
                          setState(() {
                            currentNumberSystem = 'bin';
                            input = binResult;
                          });
                          input="";
                        },
                        child: Container(
                          width: double.infinity,
                          child: Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: FittedBox(
                                  child: Text(
                                    'BIN\t',
                                    textAlign: TextAlign.left,
                                    style:
                                    Theme
                                        .of(context)
                                        .textTheme
                                        .headline3,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Container(
                                  alignment: AlignmentDirectional.centerStart,
                                  child: FittedBox(
                                    child: Text(
                                      binResult,
                                      style:
                                      Theme
                                          .of(context)
                                          .textTheme
                                          .headline4,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Material(
                      color: (currentNumberSystem == 'dec')?Colors.grey[400]:Colors.white,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            currentNumberSystem = 'dec';
                            input = decResult;
                          });
                          input="";
                        },
                        child: Container(
                          width: double.infinity,
                          child: Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: FittedBox(
                                  child: Text(
                                    'DEC\t',
                                    textAlign: TextAlign.left,
                                    style:
                                    Theme
                                        .of(context)
                                        .textTheme
                                        .headline3,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Container(
                                  alignment: AlignmentDirectional.centerStart,
                                  child: FittedBox(
                                    child: Text(
                                      decResult,
                                      style:
                                      Theme
                                          .of(context)
                                          .textTheme
                                          .headline4,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Material(
                      color: (currentNumberSystem == 'oct')?Colors.grey[400]:Colors.white,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            currentNumberSystem = 'oct';
                            input = octResult;
                          });
                          input="";
                        },
                        child: Container(
                          width: double.infinity,
                          child: Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: FittedBox(
                                  child: Text(
                                    'OCT\t',
                                    textAlign: TextAlign.left,
                                    style:
                                    Theme
                                        .of(context)
                                        .textTheme
                                        .headline3,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Container(
                                  alignment: AlignmentDirectional.centerStart,
                                  child: FittedBox(
                                    child: Text(
                                      octResult,
                                      style:
                                      Theme
                                          .of(context)
                                          .textTheme
                                          .headline4,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Material(
                      color: (currentNumberSystem == 'hex')?Colors.grey[400]:Colors.white,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            currentNumberSystem = 'hex';
                            input = hexResult;
                          });
                          input="";
                        },
                        child: Container(
                          width: double.infinity,
                          child: Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: FittedBox(
                                  child: Text(
                                    'HEX\t',
                                    textAlign: TextAlign.left,
                                    style:
                                    Theme
                                        .of(context)
                                        .textTheme
                                        .headline3,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Container(
                                  alignment: AlignmentDirectional.centerStart,
                                  child: FittedBox(
                                    child: Text(
                                      hexResult,
                                      style:
                                      Theme
                                          .of(context)
                                          .textTheme
                                          .headline4,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        //==================================== Keyboard Part ====================================//
        Expanded(
          flex: 4,
          child: Container(
            padding: const EdgeInsets.all(5),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.zero,
            ),
            child: LayoutBuilder(
              builder: (ctx, constraints) =>
                  GridView(
                    padding: const EdgeInsets.all(0),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5,
                      mainAxisExtent: constraints.maxHeight * (1 / 8),
                    ),
                    children: [
                      //================ 1st Row ================//
                      createButton(
                        child: 'AC',
                        color: Colors.white,
                        bgColor: Colors.blueAccent,
                        isEnabled: true,
                        onPressed: () {
                          setState(() {
                            input = '';
                            result = '0';
                            binResult = '0';
                            hexResult = '0';
                            octResult = '0';
                            decResult = '0';
                          });
                        },
                      ),
                      createButton(
                        child: Icons.backspace_outlined,
                        color: Colors.white,
                        bgColor: Colors.blueAccent,
                        isEnabled: true,
                        onPressed: () {
                          setState(() {
                            input =input.substring(0, input.length - 1);
                            check();
                          });
                        }
                      ),
                      createButton(
                        child: 'Simplify',
                        color: Colors.white,
                        bgColor: Colors.blueAccent,
                        isEnabled: false,
                      ),
                      createButton(
                        child: 'EXPL',
                        color: Colors.white,
                        bgColor: Colors.blueAccent,
                        isEnabled: false,
                      ),
                      createButton(
                        child: 'MS',
                        color: Colors.white,
                        bgColor: Colors.blueAccent,
                        isEnabled: false,
                          onPressed: (){
                            setState(() {
                            });
                          }
                      ),
                      //================ 2nd Row ================//
                      createButton(
                        child: 'A',
                        color: Colors.white,
                        bgColor: Colors.blueAccent,
                        isEnabled: (currentNumberSystem == 'hex'),
                        onPressed: (){
                          setState(() {
                            input += "A";
                            check();
                          });
                        }
                      ),
                      createButton(
                        child: 'AND',
                        color: Colors.white,
                        bgColor: Colors.teal[200],
                        isEnabled: true,
                          onPressed: (){
                            setState(() {
                              input += "&";
                            });
                          }
                      ),
                      createButton(
                        child: 'OR',
                        color: Colors.white,
                        bgColor: Colors.teal[200],
                        isEnabled: true,
                          onPressed: (){
                            setState(() {
                              input += "|";
                            });
                          }
                      ),
                      createButton(
                        child: 'XOR',
                        color: Colors.white,
                        bgColor: Colors.teal[200],
                        isEnabled: true,
                          onPressed: (){
                            setState(() {
                              input += '^';
                            });
                          }
                      ),
                      createButton(
                        child: '.',
                        color: Colors.white,
                        bgColor: Colors.teal[200],
                        isEnabled: true,
                          onPressed: (){
                            setState(() {
                              input += '.';
                            });
                          }
                      ),
                      //================ 3rd Row ================//
                      createButton(
                        child: 'B',
                        color: Colors.white,
                        bgColor: Colors.blueAccent,
                        isEnabled: (currentNumberSystem == 'hex'),
                          onPressed: (){
                            setState(() {
                              input += "B";
                              check();
                            });
                          }
                      ),
                      createButton(
                        child: 'NOT',
                        color: Colors.white,
                        bgColor: Colors.teal[200],
                        isEnabled: true,
                          onPressed: (){
                            setState(() {
                              input += '~';
                            });
                          }
                      ),
                      createButton(
                        child: 'NAND',
                        color: Colors.white,
                        bgColor: Colors.teal[200],
                        isEnabled: true,
                          onPressed: (){
                            setState(() {
                              input += "~&";
                            });
                          }
                      ),
                      createButton(
                        child: 'NOR',
                        color: Colors.white,
                        bgColor: Colors.teal[200],
                        isEnabled: true,
                          onPressed: (){
                            setState(() {
                              input += "~^";
                            });
                          }
                      ),
                      createButton(
                        child: Icons.add,
                        color: Colors.white,
                        bgColor: Colors.teal[200],
                        isEnabled: true,
                          onPressed: (){
                            setState(() {
                              input += '+';

                            });
                          }
                      ),
                      //================ 4th Row ================//
                      createButton(
                        child: 'C',
                        color: Colors.white,
                        bgColor: Colors.blueAccent,
                        isEnabled: (currentNumberSystem == 'hex'),
                          onPressed: (){
                            setState(() {
                              input += "C";
                              check();
                            });
                          }
                      ),
                      createButton(
                        child: '<<',
                        color: Colors.white,
                        bgColor: Colors.teal[200],
                        isEnabled: true,
                          onPressed: (){
                            setState(() {
                              input += '<<';
                            });
                          }
                      ),
                      createButton(
                        child: '>>',
                        color: Colors.white,
                        bgColor: Colors.teal[200],
                        isEnabled: true,
                          onPressed: (){
                            setState(() {
                              input += '>>';
                            });
                          }
                      ),
                      createButton(
                        child: '1st C',
                        color: Colors.white,
                        bgColor: Colors.teal[200],
                        isEnabled: true,
                      ),
                      createButton(
                        child: Icons.minimize,
                        color: Colors.white,
                        bgColor: Colors.teal[200],
                        isEnabled: true,
                          onPressed: (){
                            setState(() {
                              input += '-';

                            });
                          }
                      ),
                      //================ 5th Row ================//
                      createButton(
                        child: 'D',
                        color: Colors.white,
                        bgColor: Colors.blueAccent,
                        isEnabled: (currentNumberSystem == 'hex'),
                          onPressed: (){
                            setState(() {
                              input += 'D';
                              check();
                            });
                          }
                      ),
                      createButton(
                        child: '(',
                        color: Colors.white,
                        bgColor: Colors.teal[200],
                        isEnabled: true,
                          onPressed: (){
                            setState(() {
                              input += '(';
                            });
                          }
                      ),
                      createButton(
                        child: ')',
                        color: Colors.white,
                        bgColor: Colors.teal[200],
                        isEnabled: true,
                          onPressed: (){
                            setState(() {
                              input += ')';
                            });
                          }
                      ),
                      createButton(
                        child: '2nd C',
                        color: Colors.white,
                        bgColor: Colors.teal[200],
                        isEnabled: true,
                      ),
                      createButton(
                        child: Icons.close,
                        color: Colors.white,
                        bgColor: Colors.teal[200],
                        isEnabled: true,
                          onPressed: (){
                            setState(() {
                              input += '*';
                            });
                          }
                      ),
                      //================ 6th Row ================//
                      createButton(
                        child: 'E',
                        color: Colors.white,
                        bgColor: Colors.blueAccent,
                        isEnabled: (currentNumberSystem == 'hex'),
                          onPressed: (){
                            setState(() {
                              input += 'E';
                              check();
                            });
                          }
                      ),
                      createButton(
                        child: '7',
                        color: Colors.black,
                        bgColor: Colors.grey[200],
                        isEnabled: (currentNumberSystem == 'hex' ||
                            currentNumberSystem == 'oct' ||
                            currentNumberSystem == 'dec'),
                          onPressed: (){
                            setState(() {
                              input += '7';
                              check();
                            });
                          }
                      ),
                      createButton(
                        child: '8',
                        color: Colors.black,
                        bgColor: Colors.grey[200],
                        isEnabled: (currentNumberSystem == 'hex' ||
                            currentNumberSystem == 'dec'),
                          onPressed: (){
                            setState(() {
                              input += '8';
                              check();
                            });
                          }
                      ),
                      createButton(
                        child: '9',
                        color: Colors.black,
                        bgColor: Colors.grey[200],
                        isEnabled: (currentNumberSystem == 'hex' ||
                            currentNumberSystem == 'dec'),
                          onPressed: (){
                            setState(() {
                              input += '9';
                              check();
                            });
                          }
                      ),
                      createButton(
                        child: '/',
                        color: Colors.white,
                        bgColor: Colors.teal[200],
                        isEnabled: true,
                          onPressed: (){
                            setState(() {
                              input += '/';
                            });
                          }
                      ),
                      //================ 7th Row ================//
                      createButton(
                        child: 'F',
                        color: Colors.white,
                        bgColor: Colors.blueAccent,
                        isEnabled: (currentNumberSystem == 'hex'),
                          onPressed: (){
                            setState(() {
                              input += 'F';
                              check();
                            });
                          }
                      ),
                      createButton(
                        child: '4',
                        color: Colors.black,
                        bgColor: Colors.grey[200],
                        isEnabled: (currentNumberSystem == 'hex' ||
                            currentNumberSystem == 'oct' ||
                            currentNumberSystem == 'dec'),
                          onPressed: (){
                            setState(() {
                              input += '4';
                              check();
                            });
                          }
                      ),
                      createButton(
                        child: '5',
                        color: Colors.black,
                        bgColor: Colors.grey[200],
                        isEnabled: (currentNumberSystem == 'hex' ||
                            currentNumberSystem == 'oct' ||
                            currentNumberSystem == 'dec'),
                          onPressed: (){
                            setState(() {
                              input += '5';
                              check();
                            });
                          }
                      ),
                      createButton(
                        child: '6',
                        color: Colors.black,
                        bgColor: Colors.grey[200],
                        isEnabled: (currentNumberSystem == 'hex' ||
                            currentNumberSystem == 'oct' ||
                            currentNumberSystem == 'dec'),
                          onPressed: (){
                            setState(() {
                              input += '6';
                              check();
                            });
                          }
                      ),
                      createButton(
                        child: '%',
                        color: Colors.white,
                        bgColor: Colors.teal[200],
                        isEnabled: true,
                          onPressed: (){
                            setState(() {
                              input += '%';
                            });
                          }
                      ),
                      //================ 8th Row ================//
                      createButton(
                        child: '0',
                        color: Colors.black,
                        bgColor: Colors.grey[200],
                        isEnabled: true,
                          onPressed: (){
                            setState(() {
                              input += '0';
                              check();
                            });
                          }
                      ),
                      createButton(
                        child: '1',
                        color: Colors.black,
                        bgColor: Colors.grey[200],
                        isEnabled: true,
                        onPressed: (){
                          setState(() {
                            input += '1';
                            check();
                          });
                        }
                      ),
                      createButton(
                        child: '2',
                        color: Colors.black,
                        bgColor: Colors.grey[200],
                        isEnabled: (currentNumberSystem == 'hex' ||
                            currentNumberSystem == 'oct' ||
                            currentNumberSystem == 'dec'),
                          onPressed: (){
                            setState(() {
                              input += '2';
                              check();
                            });
                          }
                      ),
                      createButton(
                        child: '3',
                        color: Colors.black,
                        bgColor: Colors.grey[200],
                        isEnabled: (currentNumberSystem == 'hex' ||
                            currentNumberSystem == 'oct' ||
                            currentNumberSystem == 'dec'),
                        onPressed: (){
                          setState(() {
                            input += '3';
                            check();
                          });
                        }
                      ),
                      createButton(
                        child: '=',
                        color: Colors.white,
                        bgColor: Colors.red,
                        isEnabled: true,
                        onPressed: (){
                          setState(() {
                            MyParser p = MyParser();
                            result = p.parse(input, currentNumberSystem);
                          });
                        }
                      ),
                    ],
                  ),
            ),
          ),
        ),
      ]),
    );
  }

  Widget createButton({
    required dynamic child,
    required Color? color,
    required Color? bgColor,
    required bool isEnabled,
    Function? onPressed,
  }) {
    onPressed ??= () {};
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3 ,vertical: 3),
      child: ElevatedButton(
        onPressed: (isEnabled) ? () => onPressed!() : null,
        style: ButtonStyle(

            padding: MaterialStateProperty.all(const EdgeInsets.all(5)),
            foregroundColor: MaterialStateProperty.all((isEnabled)?color:Colors.grey),
            backgroundColor: MaterialStateProperty.all((isEnabled)?bgColor:bgColor!.withOpacity(0.5)),
            elevation: MaterialStateProperty.all(0),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(
                  color: Colors.white, width: 1, style: BorderStyle.solid),
            ))),
        child: FittedBox(
            child: (child is String)
                ? Text(
              child,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            )
                : Icon(child)),
      ),
    );
  }
}
