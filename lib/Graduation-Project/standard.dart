import 'package:flutter/material.dart';

class StandardScreen extends StatefulWidget {
  const StandardScreen({Key? key}) : super(key: key);

  @override
  State<StandardScreen> createState() => _StandardScreenState();
}

class _StandardScreenState extends State<StandardScreen> {
  String text = '20*30';
  String resultText = '600';
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
                            text,
                            cursorColor: Colors.black,
                            textAlign: TextAlign.right,
                            style: const TextStyle(fontSize: 32),
                          ),
                        ),
                      )),
                  Expanded(
                    flex: 3,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const FittedBox(
                          child: Text(
                            '=',
                            style: TextStyle(
                                color: Colors.teal,
                                fontSize: 42,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        FittedBox(
                          child: SelectableText(
                            resultText,
                            textAlign: TextAlign.right,
                            style: const TextStyle(
                                fontSize: 42, fontWeight: FontWeight.bold),
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
              decoration: const BoxDecoration(
                color: Colors.white,
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
                    textButton(
                      child: 'AC',
                      color: Colors.white,
                      bgColor: Colors.teal[200],
                      onPressed: () {},
                    ),
                    iconButton(
                        child: const Icon(Icons.backspace_outlined),
                        color: Colors.white,
                        bgColor: Colors.teal[200],
                        onPressed: () {}),
                    textButton(
                      child: '%',
                      color: Colors.white,
                      bgColor: Colors.teal[200],
                      onPressed: () {},
                    ),
                    textButton(
                      child: '/',
                      color: Colors.white,
                      bgColor: Colors.teal[200],
                      onPressed: () {},
                    ),
                    textButton(
                      child: '7',
                      color: Colors.black,
                      bgColor: Colors.grey[200],
                      onPressed: () {},
                    ),
                    textButton(
                      child: '8',
                      color: Colors.black,
                      onPressed: () {},
                      bgColor: Colors.grey[200],
                    ),
                    textButton(
                      child: '9',
                      color: Colors.black,
                      onPressed: () {},
                      bgColor: Colors.grey[200],
                    ),
                    iconButton(
                        child: const Icon(Icons.close),
                        color: Colors.white,
                        bgColor: Colors.teal[200],
                        onPressed: () {}),
                    textButton(
                      child: '4',
                      color: Colors.black,
                      onPressed: () {},
                      bgColor: Colors.grey[200],
                    ),
                    textButton(
                      child: '5',
                      color: Colors.black,
                      onPressed: () {},
                      bgColor: Colors.grey[200],
                    ),
                    textButton(
                      child: '6',
                      color: Colors.black,
                      onPressed: () {},
                      bgColor: Colors.grey[200],
                    ),
                    iconButton(
                      child: const Icon(Icons.minimize),
                      color: Colors.white,
                      bgColor: Colors.teal[200],
                      onPressed: () {},
                    ),
                    textButton(
                      child: '1',
                      color: Colors.black,
                      onPressed: () {},
                      bgColor: Colors.grey[200],
                    ),
                    textButton(
                      child: '2',
                      color: Colors.black,
                      onPressed: () {},
                      bgColor: Colors.grey[200],
                    ),
                    textButton(
                      child: '3',
                      color: Colors.black,
                      onPressed: () {},
                      bgColor: Colors.grey[200],
                    ),
                    iconButton(
                        child: const Icon(Icons.add),
                        color: Colors.white,
                        bgColor: Colors.teal[200],
                        onPressed: () {}),
                    textButton(
                      child: '0',
                      color: Colors.black,
                      onPressed: () {},
                      bgColor: Colors.grey[200],
                    ),
                    textButton(
                      child: '.',
                      color: Colors.black,
                      onPressed: () {},
                      bgColor: Colors.grey[200],
                    ),
                    textButton(
                      child: '+/-',
                      color: Colors.black,
                      onPressed: () {},
                      bgColor: Colors.grey[200],
                    ),
                    textButton(
                      child: '=',
                      color: Colors.white,
                      onPressed: () {},
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
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
