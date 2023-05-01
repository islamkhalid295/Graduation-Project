part of 'calculator.dart';

class KeyboardKeys extends StatelessWidget {
  KeyboardKeys({super.key});
  String? theme;
  @override
  Widget build(BuildContext context) {
    theme =
        checkTheme(BlocProvider.of<ThemeCubit>(context).currentTheme, context);
    return BlocConsumer<ThemeCubit, ThemeState>(
      listener: (context, state) {
        if (state is ThemeStateLight)
          theme = 'light';
        else if (state is ThemeStateDark)
          theme = 'dark';
        else {
          if (Theme.of(context).brightness == 'light')
            theme = 'light';
          else
            theme = 'dark';
        }
      },
      builder: (context, state) => LayoutBuilder(
        builder: (context, constraints) =>
            BlocBuilder<CalculatorCubit, CalculatorState>(
          buildWhen: (previous, current) =>
              current is CalculatorNumberSystemChange,
          builder: (context, state) {
            return GridView(
              padding: EdgeInsets.zero,
              scrollDirection: Axis.vertical,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 0,
                mainAxisSpacing: 0,
                mainAxisExtent: constraints.maxHeight / 7,
              ),
              children: [
                //========================= 1st Row ================================//
                createButton(
                  child: const Text('AC'),
                  onPressed: () =>
                      BlocProvider.of<CalculatorCubit>(context).clearAll(),
                  type: 'ac',
                  isEnabled: true,
                ),
                createButton(
                  child: const Icon(Icons.backspace_outlined),
                  onPressed: BlocProvider.of<CalculatorCubit>(context).del,
                  type: 'del',
                  isEnabled: true,
                ),
                createButton(
                  child: const Text('AND'),
                  onPressed: () => BlocProvider.of<CalculatorCubit>(context)
                      .updateExpr('&', ' AND '),
                  type: 'opr',
                  isEnabled: true,
                ),
                createButton(
                  child: const Text('OR'),
                  onPressed: () => BlocProvider.of<CalculatorCubit>(context)
                      .updateExpr('|', ' OR '),
                  type: 'opr',
                  isEnabled: true,
                ),
                //========================= 2nd Row ================================//
                createButton(
                  child: const Text('F'),
                  onPressed: () => BlocProvider.of<CalculatorCubit>(context)
                      .updateExpr('F', 'F'),
                  type: 'hex',
                  isEnabled: BlocProvider.of<CalculatorCubit>(context)
                          .curentNumerSystem ==
                      'hex',
                ),
                createButton(
                  child: const Text('NOT'),
                  onPressed: () => BlocProvider.of<CalculatorCubit>(context)
                      .updateExpr('~', ' NOT '),
                  type: 'opr',
                  isEnabled: true,
                ),
                createButton(
                  child: const Text('NAND'),
                  onPressed: () => BlocProvider.of<CalculatorCubit>(context)
                      .updateExpr('!&', ' NAND '),
                  type: 'opr',
                  isEnabled: true,
                ),
                createButton(
                  child: const Text('NOR'),
                  onPressed: () => BlocProvider.of<CalculatorCubit>(context)
                      .updateExpr('!|', ' NOR '),
                  type: 'opr',
                  isEnabled: true,
                ),
                //========================= 3rd Row ================================//
                createButton(
                  child: const Text('E'),
                  onPressed: () => BlocProvider.of<CalculatorCubit>(context)
                      .updateExpr('E', 'E'),
                  type: 'hex',
                  isEnabled: BlocProvider.of<CalculatorCubit>(context)
                          .curentNumerSystem ==
                      'hex',
                ),
                createButton(
                  child: const Text('XOR'),
                  onPressed: () => BlocProvider.of<CalculatorCubit>(context)
                      .updateExpr('^', ' XOR '),
                  type: 'opr',
                  isEnabled: true,
                ),
                createButton(
                  child: const Text('XNOR'),
                  onPressed: () => BlocProvider.of<CalculatorCubit>(context)
                      .updateExpr('!^', ' XNOR '),
                  type: 'opr',
                  isEnabled: true,
                ),
                createButton(
                  child: const Text('LSH'),
                  onPressed: () => BlocProvider.of<CalculatorCubit>(context)
                      .updateExpr('<<', ' << '),
                  type: 'opr',
                  isEnabled: true,
                ),
                //========================= 4th Row ================================//
                createButton(
                  child: const Text('D'),
                  onPressed: () => BlocProvider.of<CalculatorCubit>(context)
                      .updateExpr('D', 'D'),
                  type: 'hex',
                  isEnabled: BlocProvider.of<CalculatorCubit>(context)
                          .curentNumerSystem ==
                      'hex',
                ),
                createButton(
                  child: const Text('8'),
                  onPressed: () => BlocProvider.of<CalculatorCubit>(context)
                      .updateExpr('8', '8'),
                  type: 'num',
                  isEnabled: BlocProvider.of<CalculatorCubit>(context)
                              .curentNumerSystem !=
                          'bin' &&
                      BlocProvider.of<CalculatorCubit>(context)
                              .curentNumerSystem !=
                          'oct',
                ),
                createButton(
                  child: const Text('9'),
                  onPressed: () => BlocProvider.of<CalculatorCubit>(context)
                      .updateExpr('9', '9'),
                  type: 'num',
                  isEnabled: BlocProvider.of<CalculatorCubit>(context)
                              .curentNumerSystem !=
                          'bin' &&
                      BlocProvider.of<CalculatorCubit>(context)
                              .curentNumerSystem !=
                          'oct',
                ),
                createButton(
                  child: const Text('RSH'),
                  onPressed: () => BlocProvider.of<CalculatorCubit>(context)
                      .updateExpr('>>', ' >> '),
                  type: 'opr',
                  isEnabled: true,
                ),
                //========================= 5th Row ================================//
                createButton(
                  child: const Text('C'),
                  onPressed: () => BlocProvider.of<CalculatorCubit>(context)
                      .updateExpr('C', 'C'),
                  type: 'hex',
                  isEnabled: BlocProvider.of<CalculatorCubit>(context)
                          .curentNumerSystem ==
                      'hex',
                ),
                createButton(
                  child: const Text('5'),
                  onPressed: () => BlocProvider.of<CalculatorCubit>(context)
                      .updateExpr('5', '5'),
                  type: 'num',
                  isEnabled: BlocProvider.of<CalculatorCubit>(context)
                          .curentNumerSystem !=
                      'bin',
                ),
                createButton(
                  child: const Text('6'),
                  onPressed: () => BlocProvider.of<CalculatorCubit>(context)
                      .updateExpr('6', '6'),
                  type: 'num',
                  isEnabled: BlocProvider.of<CalculatorCubit>(context)
                          .curentNumerSystem !=
                      'bin',
                ),
                createButton(
                  child: const Text('7'),
                  onPressed: () => BlocProvider.of<CalculatorCubit>(context)
                      .updateExpr('7', '7'),
                  type: 'num',
                  isEnabled: BlocProvider.of<CalculatorCubit>(context)
                          .curentNumerSystem !=
                      'bin',
                ),
                //========================= 6th Row ================================//
                createButton(
                  child: const Text('B'),
                  onPressed: () => BlocProvider.of<CalculatorCubit>(context)
                      .updateExpr('B', 'B'),
                  type: 'hex',
                  isEnabled: BlocProvider.of<CalculatorCubit>(context)
                          .curentNumerSystem ==
                      'hex',
                ),
                createButton(
                  child: const Text('2'),
                  onPressed: () => BlocProvider.of<CalculatorCubit>(context)
                      .updateExpr('2', '2'),
                  type: 'num',
                  isEnabled: BlocProvider.of<CalculatorCubit>(context)
                          .curentNumerSystem !=
                      'bin',
                ),
                createButton(
                  child: const Text('3'),
                  onPressed: () => BlocProvider.of<CalculatorCubit>(context)
                      .updateExpr('3', '3'),
                  type: 'num',
                  isEnabled: BlocProvider.of<CalculatorCubit>(context)
                          .curentNumerSystem !=
                      'bin',
                ),
                createButton(
                  child: const Text('4'),
                  onPressed: () => BlocProvider.of<CalculatorCubit>(context)
                      .updateExpr('4', '4'),
                  type: 'num',
                  isEnabled: BlocProvider.of<CalculatorCubit>(context)
                          .curentNumerSystem !=
                      'bin',
                ),
                //========================= 7th Row ================================//
                createButton(
                  child: const Text('A'),
                  onPressed: () => BlocProvider.of<CalculatorCubit>(context)
                      .updateExpr('A', 'A'),
                  type: 'hex',
                  isEnabled: BlocProvider.of<CalculatorCubit>(context)
                          .curentNumerSystem ==
                      'hex',
                ),
                createButton(
                  child: const Text('0'),
                  onPressed: () => BlocProvider.of<CalculatorCubit>(context)
                      .updateExpr('0', '0'),
                  type: 'num',
                  isEnabled: true,
                ),
                createButton(
                  child: const Text('1'),
                  onPressed: () => BlocProvider.of<CalculatorCubit>(context)
                      .updateExpr('1', '1'),
                  type: 'num',
                  isEnabled: true,
                ),
                createButton(
                  child: const Text('='),
                  onPressed: BlocProvider.of<CalculatorCubit>(context).getResult,
                  type: '=',
                  isEnabled: true,
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  TextButton createButton(
      {required Widget child,
      required void Function() onPressed,
      required String type,
      required bool isEnabled}) {
    Color fgColor = (theme == 'light')
        ? ThemeColors.lightBlackText
        : ThemeColors.darkWhiteText;
    if (type == 'opr')
      fgColor = (theme == 'light')
          ? ThemeColors.lightForegroundTeal
          : ThemeColors.darkForegroundTeal;
    else if (type == 'hex' || type == 'ac' || type == 'del')
      fgColor = ThemeColors.blueColor;
    else if (type == '=') fgColor = ThemeColors.redColor;
    return TextButton(
      onPressed: (isEnabled) ? onPressed : null,
      style: TextButton.styleFrom(
        padding: const EdgeInsets.all(0),
        foregroundColor: isEnabled ? fgColor : fgColor.withOpacity(0.5),
        textStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: SizeConfig.heightBlock! * 3,
          fontFamily: SizeConfig.fontName,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: SizeConfig.heightBlock!,
          horizontal: SizeConfig.widthBlock!,
        ),
        child: FittedBox(
          child: child,
        ),
      ),
    );
  }
}
