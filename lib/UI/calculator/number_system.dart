part of 'calculator.dart';

class ConvertSystem extends StatelessWidget {
  ConvertSystem({super.key});
  String? theme;
  String? currentSystem;
  @override
  Widget build(BuildContext context) {
    //SizeConfig().init(context);
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
      builder: (context, state) => Container(
        height: SizeConfig.heightBlock! * 12,
        decoration: BoxDecoration(
          color: (theme == 'light')
              ? ThemeColors.lightElemBG
              : ThemeColors.darkElemBG,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            numberSystem(
              system: 'bin',
              onTap: () => BlocProvider.of<CalculatorCubit>(context)
                  .changeNumberSystem('bin'),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(8),
              ),
            ),
            numberSystem(
              system: 'oct',
              onTap: () => BlocProvider.of<CalculatorCubit>(context)
                  .changeNumberSystem('oct'),
              borderRadius: BorderRadius.circular(0),
            ),
            numberSystem(
              system: 'dec',
              onTap: () => BlocProvider.of<CalculatorCubit>(context)
                  .changeNumberSystem('dec'),
              borderRadius: BorderRadius.circular(0),
            ),
            numberSystem(
              system: 'hex',
              onTap: () => BlocProvider.of<CalculatorCubit>(context)
                  .changeNumberSystem('hex'),
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(8),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Expanded numberSystem(
      {required String system,
      required void Function() onTap,
      required BorderRadius borderRadius}) {
    return Expanded(
      child: BlocBuilder<CalculatorCubit, CalculatorState>(
        buildWhen: (previous, current) =>
            current is CalculatorExprUpdate ||
            current is CalculatorNumberSystemChange,
        builder: (context, state) {
          String str = '';
          switch (system) {
            case 'bin':
              str = BlocProvider.of<CalculatorCubit>(context).binResult;
              break;
            case 'oct':
              str = BlocProvider.of<CalculatorCubit>(context).octResult;
              break;
            case 'dec':
              str = BlocProvider.of<CalculatorCubit>(context).decResult;
              break;
            case 'hex':
              str = BlocProvider.of<CalculatorCubit>(context).hexResult;
              break;
          }
          print("System : ${system} is rebuilded");
          return Material(
            borderRadius: borderRadius,
            color:
                (BlocProvider.of<CalculatorCubit>(context).curentNumerSystem ==
                        system)
                    ? ((theme == 'light')
                        ? ThemeColors.lightSelectedSystemBG
                        : ThemeColors.darkSelectedSystemBG)
                    : Colors.transparent,
            child: InkWell(
              onTap: onTap,
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: FittedBox(
                      child: Text(
                        '${system.toUpperCase()}\t',
                        style: TextStyle(
                          color: (theme == 'light')
                              ? ThemeColors.lightForegroundTeal
                              : ThemeColors.darkForegroundTeal,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: FittedBox(
                      alignment: AlignmentDirectional.centerStart,
                      child: Text(
                        str,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          color: (theme == 'light')
                              ? ThemeColors.lightBlackText
                              : ThemeColors.darkWhiteText,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
