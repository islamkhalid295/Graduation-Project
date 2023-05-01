part of 'calculator.dart';

class KeyboardOptions extends StatelessWidget {
  KeyboardOptions({super.key});
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
      builder: (context, state) => Row(
        children: [
          Expanded(
            flex: 3,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.widthBlock!,
                vertical: SizeConfig.heightBlock! * 0.8,
              ),
              decoration: BoxDecoration(
                  color: (theme == 'light')
                      ? ThemeColors.lightCanvas
                      : ThemeColors.darkCanvas,
                  borderRadius: BorderRadius.circular(8)),
              child: BlocBuilder<CalculatorCubit, CalculatorState>(
                buildWhen: (previous, current) =>
                    current is CalculatorIsSignedChange,
                builder: (context, state) {
                  return DropdownButton(
                    isDense: true,
                    isExpanded: true,
                    icon: Icon(
                      Icons.arrow_drop_down,
                      color: (theme == 'light')
                          ? ThemeColors.lightForegroundTeal
                          : ThemeColors.darkForegroundTeal,
                    ),
                    dropdownColor: (theme == 'light')
                        ? ThemeColors.lightCanvas
                        : ThemeColors.darkCanvas,
                    underline: const SizedBox(),
                    value: BlocProvider.of<CalculatorCubit>(context).isSigned,
                    items: [
                      DropdownMenuItem(
                        value: true,
                        child: FittedBox(
                          child: Text(
                            'Signed',
                            style: TextStyle(
                              color: (theme == 'light')
                                  ? ThemeColors.lightBlackText
                                  : ThemeColors.darkWhiteText,
                              fontWeight: FontWeight.bold,
                              fontSize: SizeConfig.heightBlock! * 2.5,
                            ),
                          ),
                        ),
                      ),
                      DropdownMenuItem(
                        value: false,
                        child: FittedBox(
                          child: Text(
                            'Unsigned',
                            style: TextStyle(
                              color: (theme == 'light')
                                  ? ThemeColors.lightBlackText
                                  : ThemeColors.darkWhiteText,
                              fontWeight: FontWeight.bold,
                              fontSize: SizeConfig.heightBlock! * 2.5,
                            ),
                          ),
                        ),
                      ),
                    ],
                    onChanged: (value) =>
                        BlocProvider.of<CalculatorCubit>(context)
                            .isSignedChanger(),
                  );
                },
              ),
            ),
          ),
          SizedBox(
            width: SizeConfig.heightBlock! * 0.5,
          ),
          Expanded(
            flex: 4,
            child: FilledButton(
              style: FilledButton.styleFrom(
                padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.widthBlock!,
                  vertical: 0,
                ),
                disabledBackgroundColor: (theme == 'light')
                    ? ThemeColors.lightCanvas
                    : ThemeColors.darkCanvas,
                backgroundColor: (theme == 'light')
                    ? ThemeColors.lightCanvas
                    : ThemeColors.darkCanvas,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: BlocProvider.of<CalculatorCubit>(context).isResultExist
                  ? () {}
                  : null,
              child: BlocBuilder<CalculatorCubit, CalculatorState>(
                builder: (context, state) {
                  return FittedBox(
                    child: Row(
                      children: [
                        Text(
                          'Explenation',
                          style: TextStyle(
                            color: (theme == 'light')
                                ? (BlocProvider.of<CalculatorCubit>(context)
                                        .isResultExist)
                                    ? ThemeColors.lightBlackText
                                    : ThemeColors.lightBlackText
                                        .withOpacity(0.5)
                                : (BlocProvider.of<CalculatorCubit>(context)
                                        .isResultExist)
                                    ? ThemeColors.darkWhiteText
                                    : ThemeColors.darkWhiteText
                                        .withOpacity(0.5),
                            fontWeight: FontWeight.bold,
                            fontSize: SizeConfig.heightBlock! * 2.5,
                          ),
                        ),
                        SizedBox(
                          width: SizeConfig.widthBlock! * 2,
                        ),
                        Icon(
                          Icons.info_outline,
                          color: (theme == 'light')
                              ? (BlocProvider.of<CalculatorCubit>(context)
                                      .isResultExist)
                                  ? ThemeColors.lightForegroundTeal
                                  : ThemeColors.lightBlackText.withOpacity(0.5)
                              : (BlocProvider.of<CalculatorCubit>(context)
                                      .isResultExist)
                                  ? ThemeColors.darkForegroundTeal
                                  : ThemeColors.darkWhiteText.withOpacity(0.5),
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          SizedBox(
            width: SizeConfig.heightBlock!,
          ),
          Expanded(
            child: FilledButton(
              style: FilledButton.styleFrom(
                  padding:
                      EdgeInsets.symmetric(horizontal: SizeConfig.widthBlock!),
                  backgroundColor: (theme == 'light')
                      ? ThemeColors.lightCanvas
                      : ThemeColors.darkCanvas,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  )),
              child: FittedBox(
                child: Text(
                  '(',
                  style: TextStyle(
                    color: (theme == 'light')
                        ? ThemeColors.lightForegroundTeal
                        : ThemeColors.darkForegroundTeal,
                    fontWeight: FontWeight.bold,
                    fontSize: SizeConfig.heightBlock! * 2.5,
                  ),
                ),
              ),
              onPressed: () => BlocProvider.of<CalculatorCubit>(context)
                  .updateExpr('(', ' ( '),
            ),
          ),
          SizedBox(
            width: SizeConfig.heightBlock! * 0.5,
          ),
          Expanded(
            child: FilledButton(
              style: FilledButton.styleFrom(
                  padding:
                      EdgeInsets.symmetric(horizontal: SizeConfig.widthBlock!),
                  backgroundColor: (theme == 'light')
                      ? ThemeColors.lightCanvas
                      : ThemeColors.darkCanvas,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  )),
              child: FittedBox(
                child: Text(
                  ')',
                  style: TextStyle(
                    color: (theme == 'light')
                        ? ThemeColors.lightForegroundTeal
                        : ThemeColors.darkForegroundTeal,
                    fontWeight: FontWeight.bold,
                    fontSize: SizeConfig.heightBlock! * 2.5,
                  ),
                ),
              ),
              onPressed: () => BlocProvider.of<CalculatorCubit>(context)
                  .updateExpr(')', ' ) '),
            ),
          ),
          SizedBox(
            width: SizeConfig.heightBlock!,
          ),
          Expanded(
            child: FilledButton(
              style: FilledButton.styleFrom(
                  padding:
                      EdgeInsets.symmetric(horizontal: SizeConfig.widthBlock!),
                  backgroundColor: (theme == 'light')
                      ? ThemeColors.lightCanvas
                      : ThemeColors.darkCanvas,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  )),
              child: FittedBox(
                child: Icon(
                  Icons.more_horiz,
                  color: (theme == 'light')
                      ? ThemeColors.lightForegroundTeal
                      : ThemeColors.darkForegroundTeal,
                ),
              ),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}
