import 'package:flutter/material.dart';

class ProgrammerScreen extends StatefulWidget {
  const ProgrammerScreen({Key? key}) : super(key: key);

  @override
  State<ProgrammerScreen> createState() => _ProgrammerScreenState();
}

class _ProgrammerScreenState extends State<ProgrammerScreen> {
  String currentNumberSystem = 'dic';

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
                      '00000000000000000000000000000000',
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
                            '00000000000000000000000000000000',
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
                        onTap: () => setState(() {
                          currentNumberSystem = 'bin';
                        }),
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
                                      '00000000000000000000000000000000',
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
                      color: (currentNumberSystem == 'dic')?Colors.grey[400]:Colors.white,
                      child: InkWell(
                        onTap: () => setState(() {
                          currentNumberSystem = 'dic';
                        }),
                        child: Container(
                          width: double.infinity,
                          child: Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: FittedBox(
                                  child: Text(
                                    'DIC\t',
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
                                      '00000000000000000000000000000000',
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
                        onTap: () => setState(() {
                          currentNumberSystem = 'oct';
                        }),
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
                                      '00000000000000000000000000000000',
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
                        onTap: () => setState(() {
                          currentNumberSystem = 'hex';
                        }),
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
                                      '00000000000000000000000000000000',
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
                      ),
                      createButton(
                        child: Icons.backspace_outlined,
                        color: Colors.white,
                        bgColor: Colors.blueAccent,
                        isEnabled: true,
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
                      ),
                      //================ 2nd Row ================//
                      createButton(
                        child: 'A',
                        color: Colors.white,
                        bgColor: Colors.blueAccent,
                        isEnabled: (currentNumberSystem == 'hex'),
                      ),
                      createButton(
                        child: 'AND',
                        color: Colors.white,
                        bgColor: Colors.teal[200],
                        isEnabled: true,
                      ),
                      createButton(
                        child: 'OR',
                        color: Colors.white,
                        bgColor: Colors.teal[200],
                        isEnabled: true,
                      ),
                      createButton(
                        child: 'XOR',
                        color: Colors.white,
                        bgColor: Colors.teal[200],
                        isEnabled: true,
                      ),
                      createButton(
                        child: '+/-',
                        color: Colors.white,
                        bgColor: Colors.teal[200],
                        isEnabled: true,
                      ),
                      //================ 3rd Row ================//
                      createButton(
                        child: 'B',
                        color: Colors.white,
                        bgColor: Colors.blueAccent,
                        isEnabled: (currentNumberSystem == 'hex'),
                      ),
                      createButton(
                        child: 'NOT',
                        color: Colors.white,
                        bgColor: Colors.teal[200],
                        isEnabled: true,
                      ),
                      createButton(
                        child: 'NAND',
                        color: Colors.white,
                        bgColor: Colors.teal[200],
                        isEnabled: true,
                      ),
                      createButton(
                        child: 'NOR',
                        color: Colors.white,
                        bgColor: Colors.teal[200],
                        isEnabled: true,
                      ),
                      createButton(
                        child: Icons.add,
                        color: Colors.white,
                        bgColor: Colors.teal[200],
                        isEnabled: true,
                      ),
                      //================ 4th Row ================//
                      createButton(
                        child: 'C',
                        color: Colors.white,
                        bgColor: Colors.blueAccent,
                        isEnabled: (currentNumberSystem == 'hex'),
                      ),
                      createButton(
                        child: '<<',
                        color: Colors.white,
                        bgColor: Colors.teal[200],
                        isEnabled: true,
                      ),
                      createButton(
                        child: '>>',
                        color: Colors.white,
                        bgColor: Colors.teal[200],
                        isEnabled: true,
                      ),
                      createButton(
                        child: '1st C',
                        color: Colors.white,
                        bgColor: Colors.teal[200],
                        isEnabled: true,
                      ),
                      createButton(
                        child: Icons.maximize,
                        color: Colors.white,
                        bgColor: Colors.teal[200],
                        isEnabled: true,
                      ),
                      //================ 5th Row ================//
                      createButton(
                        child: 'D',
                        color: Colors.white,
                        bgColor: Colors.blueAccent,
                        isEnabled: (currentNumberSystem == 'hex'),
                      ),
                      createButton(
                        child: '(',
                        color: Colors.white,
                        bgColor: Colors.teal[200],
                        isEnabled: true,
                      ),
                      createButton(
                        child: ')',
                        color: Colors.white,
                        bgColor: Colors.teal[200],
                        isEnabled: true,
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
                      ),
                      //================ 6th Row ================//
                      createButton(
                        child: 'E',
                        color: Colors.white,
                        bgColor: Colors.blueAccent,
                        isEnabled: (currentNumberSystem == 'hex'),
                      ),
                      createButton(
                        child: '7',
                        color: Colors.black,
                        bgColor: Colors.grey[200],
                        isEnabled: (currentNumberSystem == 'hex' ||
                            currentNumberSystem == 'oct' ||
                            currentNumberSystem == 'dic'),
                      ),
                      createButton(
                        child: '8',
                        color: Colors.black,
                        bgColor: Colors.grey[200],
                        isEnabled: (currentNumberSystem == 'hex' ||
                            currentNumberSystem == 'dic'),
                      ),
                      createButton(
                        child: '9',
                        color: Colors.black,
                        bgColor: Colors.grey[200],
                        isEnabled: (currentNumberSystem == 'hex' ||
                            currentNumberSystem == 'dic'),
                      ),
                      createButton(
                        child: '/',
                        color: Colors.white,
                        bgColor: Colors.teal[200],
                        isEnabled: true,
                      ),
                      //================ 7th Row ================//
                      createButton(
                        child: 'F',
                        color: Colors.white,
                        bgColor: Colors.blueAccent,
                        isEnabled: (currentNumberSystem == 'hex'),
                      ),
                      createButton(
                        child: '4',
                        color: Colors.black,
                        bgColor: Colors.grey[200],
                        isEnabled: (currentNumberSystem == 'hex' ||
                            currentNumberSystem == 'oct' ||
                            currentNumberSystem == 'dic'),
                      ),
                      createButton(
                        child: '5',
                        color: Colors.black,
                        bgColor: Colors.grey[200],
                        isEnabled: (currentNumberSystem == 'hex' ||
                            currentNumberSystem == 'oct' ||
                            currentNumberSystem == 'dic'),
                      ),
                      createButton(
                        child: '6',
                        color: Colors.black,
                        bgColor: Colors.grey[200],
                        isEnabled: (currentNumberSystem == 'hex' ||
                            currentNumberSystem == 'oct' ||
                            currentNumberSystem == 'dic'),
                      ),
                      createButton(
                        child: '%',
                        color: Colors.white,
                        bgColor: Colors.teal[200],
                        isEnabled: true,
                      ),
                      //================ 8th Row ================//
                      createButton(
                        child: '0',
                        color: Colors.black,
                        bgColor: Colors.grey[200],
                        isEnabled: true,
                      ),
                      createButton(
                        child: '1',
                        color: Colors.black,
                        bgColor: Colors.grey[200],
                        isEnabled: true,
                      ),
                      createButton(
                        child: '2',
                        color: Colors.black,
                        bgColor: Colors.grey[200],
                        isEnabled: (currentNumberSystem == 'hex' ||
                            currentNumberSystem == 'oct' ||
                            currentNumberSystem == 'dic'),
                      ),
                      createButton(
                        child: '3',
                        color: Colors.black,
                        bgColor: Colors.grey[200],
                        isEnabled: (currentNumberSystem == 'hex' ||
                            currentNumberSystem == 'oct' ||
                            currentNumberSystem == 'dic'),
                      ),
                      createButton(
                        child: '=',
                        color: Colors.white,
                        bgColor: Colors.red,
                        isEnabled: true,
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
    if (onPressed == null) {
      onPressed = () {};
    }
    return ElevatedButton(
      onPressed: (isEnabled) ? () => onPressed!() : null,
      style: ButtonStyle(

          padding: MaterialStateProperty.all(const EdgeInsets.all(5)),
          foregroundColor: MaterialStateProperty.all((isEnabled)?color:Colors.grey),
          backgroundColor: MaterialStateProperty.all((isEnabled)?bgColor:bgColor!.withOpacity(0.5)),
          elevation: MaterialStateProperty.all(0),
          shape: MaterialStateProperty.all(const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
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
    );
  }
}
