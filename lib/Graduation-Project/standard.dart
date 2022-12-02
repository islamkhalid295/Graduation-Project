import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

class StandardScreen extends StatefulWidget {
  StandardScreen({Key? key,required this.dark}) : super(key: key);
  bool  dark;
  @override
  State<StandardScreen> createState() => _StandardScreenState(dark);
}

class _StandardScreenState extends State<StandardScreen> {


  _StandardScreenState(this.isDark);
  bool isDark ;
  String userInput = '';
  String resultText = '';
  bool flag = true;

  final List<String> buttons = [
    '0',
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    'C',
    '+/-',
    '%',
    'DEL',
    '/',
    'x',
    '-',
    '.',
    '=',
    '+',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      width: double.infinity,
      height: double.infinity,
      child: Column(
        //mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 1,
            child: Container(
              margin: const EdgeInsets.only(top: 10),
              padding: const EdgeInsets.all(10),
              //alignment: Alignment.center,
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                      flex: 2,
                      child: Container(
                        alignment: AlignmentDirectional.centerEnd,
                        width: double.infinity,
                        child: FittedBox(
                          child: SelectableText(
                            userInput,
                            cursorColor: Colors.black,
                            textAlign: TextAlign.right,
                            style: Theme.of(context).textTheme.headline2,
                          ),
                        ),
                      )),
                  Expanded(
                    flex: 3,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text(
                            '=',
                            style: TextStyle(
                              fontSize: Theme.of(context)
                                  .textTheme
                                  .headline1!
                                  .fontSize,
                              fontWeight: Theme.of(context)
                                  .textTheme
                                  .headline1!
                                  .fontWeight,
                              color: Colors.teal,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        Expanded(
                          flex: 5,
                          child: Container(
                            alignment: AlignmentDirectional.centerEnd,
                            child: FittedBox(
                              child: SelectableText(
                                resultText,
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
          ),
          Expanded(
            flex: 3,
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: isDark ? Colors.grey : Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
              ),
              child: LayoutBuilder(
                builder: (ctx, constraints) => GridView(
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(0),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisExtent: constraints.maxHeight * 0.2,
                  ),
                  children: [
                    //Row 1
                    // AC Button
                    textButton(
                      child: 'AC',
                      color: Colors.white,
                      bgColor: Colors.teal[200],
                      onPressed: () {
                        setState(() {
                          userInput = '';
                          resultText = '0';
                        });
                      },
                    ),
                    // Delete Button
                    iconButton(
                        child: const Icon(Icons.backspace_outlined),
                        color: Colors.white,
                        bgColor: Colors.teal[200],
                        onPressed: () {
                          setState(() {
                            userInput =
                                userInput.substring(0, userInput.length - 1);
                          });
                        }),
                    textButton(
                      child: '%',
                      color: Colors.white,
                      bgColor: Colors.teal[200],
                      onPressed: () {
                        setState(() {
                          userInput += '%';
                        });
                      },
                    ),
                    textButton(
                      child: '/',
                      color: Colors.white,
                      bgColor: Colors.teal[200],
                      onPressed: () {
                        setState(() {
                          userInput += '/';
                        });
                      },
                    ),
                    textButton(
                      child: '7',
                      color: Colors.black,
                      bgColor: Colors.grey[200],
                      onPressed: () {
                        setState(() {
                          userInput += '7';
                        });
                      },
                    ),
                    textButton(
                      child: '8',
                      color: Colors.black,
                      onPressed: () {
                        setState(() {
                          userInput += '8';
                        });
                      },
                      bgColor: Colors.grey[200],
                    ),
                    textButton(
                      child: '9',
                      color: Colors.black,
                      onPressed: () {
                        setState(() {
                          userInput += '9';
                        });
                      },
                      bgColor: Colors.grey[200],
                    ),
                    iconButton(
                        child: const Icon(Icons.close),
                        color: Colors.white,
                        bgColor: Colors.teal[200],
                        onPressed: () {
                          setState(() {
                            userInput += 'x';
                          });
                        }),
                    textButton(
                      child: '4',
                      color: Colors.black,
                      onPressed: () {
                        setState(() {
                          userInput += '4';
                        });
                      },
                      bgColor: Colors.grey[200],
                    ),
                    textButton(
                      child: '5',
                      color: Colors.black,
                      onPressed: () {
                        setState(() {
                          userInput += '5';
                        });
                      },
                      bgColor: Colors.grey[200],
                    ),
                    textButton(
                      child: '6',
                      color: Colors.black,
                      onPressed: () {
                        setState(() {
                          userInput += '6';
                        });
                      },
                      bgColor: Colors.grey[200],
                    ),
                    iconButton(
                      child: const Icon(Icons.minimize),
                      color: Colors.white,
                      bgColor: Colors.teal[200],
                      onPressed: () {
                        setState(() {
                          userInput += '-';
                        });
                      },
                    ),
                    textButton(
                      child: '1',
                      color: Colors.black,
                      onPressed: () {
                        setState(() {
                          userInput += '1';
                        });
                      },
                      bgColor: Colors.grey[200],
                    ),
                    textButton(
                      child: '2',
                      color: Colors.black,
                      onPressed: () {
                        setState(() {
                          userInput += '2';
                        });
                      },
                      bgColor: Colors.grey[200],
                    ),
                    textButton(
                      child: '3',
                      color: Colors.black,
                      onPressed: () {
                        setState(() {
                          userInput += '3';
                        });
                      },
                      bgColor: Colors.grey[200],
                    ),
                    iconButton(
                        child: const Icon(Icons.add),
                        color: Colors.white,
                        bgColor: Colors.teal[200],
                        onPressed: () {
                          setState(() {
                            userInput += '+';
                          });
                        }),
                    textButton(
                      child: '0',
                      color: Colors.black,
                      onPressed: () {
                        setState(() {
                          userInput += '0';
                        });
                      },
                      bgColor: Colors.grey[200],
                    ),
                    textButton(
                      child: '.',
                      color: Colors.black,
                      onPressed: () {
                        setState(() {
                          userInput += '.';
                        });
                      },
                      bgColor: Colors.grey[200],
                    ),
                    textButton(
                      child: '+/-',
                      color: Colors.black,
                      onPressed: () {
                        setState(() {
                          if (flag) {
                            userInput += '+';
                            flag = false;
                          } else {
                            userInput += '-';
                            flag = true;
                          }
                        });
                      },
                      bgColor: Colors.grey[200],
                    ),
                    textButton(
                      child: '=',
                      color: Colors.white,
                      onPressed: () {
                        setState(() {
                          String finaluserinput = userInput;
                          finaluserinput = userInput.replaceAll('x', '*');

                          Parser p = Parser();
                          try {
                            Expression exp = p.parse(finaluserinput);
                            ContextModel cm = ContextModel();
                            double eval = exp.evaluate(EvaluationType.REAL, cm);
                            resultText = eval.toString();
                          } catch (e) {
                            resultText = "Math Error";
                          }
                        });
                      },
                      bgColor: Colors.redAccent,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget textButton({
    required String child,
    required Color? color,
    required Color? bgColor,
    required Function onPressed,
  }) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: ElevatedButton(
        onPressed: () => onPressed(),
        style: ButtonStyle(
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          padding: MaterialStateProperty.all(const EdgeInsets.all(2)),
          foregroundColor: MaterialStateProperty.all(color),
          backgroundColor: MaterialStateProperty.all(bgColor),
          elevation: MaterialStateProperty.all(0),
        ),
        child: FittedBox(
            fit: BoxFit.fill,
            child: Text(
              child,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            )),
      ),
    );
  }

  Widget iconButton({
    required Icon child,
    required Color? color,
    required Color? bgColor,
    required Function onPressed,
  }) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: ElevatedButton(
        onPressed: () => onPressed(),
        style: ButtonStyle(
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          padding: MaterialStateProperty.all(const EdgeInsets.all(2)),
          foregroundColor: MaterialStateProperty.all(color),
          backgroundColor: MaterialStateProperty.all(bgColor),
          elevation: MaterialStateProperty.all(0),
        ),
        child: child,
      ),
    );
  }

}
