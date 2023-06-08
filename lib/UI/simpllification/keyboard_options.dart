part of 'simplification.dart';

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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 3,
            child: BlocBuilder<SimplificationCubit, SimplificationState>(
              buildWhen: (previous, current) => current is SimplificationResult,
              builder: (context, state) {
                return Showcase(
                  tooltipBackgroundColor: ThemeColors.lightCanvas,
                  titleTextStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: ThemeColors.lightForegroundTeal,
                      fontSize: 16),
                  descTextStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: ThemeColors.lightBlackText,
                    fontSize: 14,
                  ),
                  key: BlocProvider.of<SimplificationCubit>(context)
                      .explanationKey,
                  title: 'Explanation Button',
                  description:
                      'Is to show the steps of simplifying an expression.',
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                          horizontal: SizeConfig.widthBlock!),
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
                    onPressed: BlocProvider.of<SimplificationCubit>(context)
                            .isResultExist
                        ? () => BlocProvider.of<SimplificationCubit>(context)
                            .showExplanation(context, theme!)
                        : null,
                    child:
                        BlocBuilder<SimplificationCubit, SimplificationState>(
                      builder: (context, state) {
                        return FittedBox(
                          child: Row(
                            children: [
                              Text(
                                'Explenation',
                                style: TextStyle(
                                  color: (theme == 'light')
                                      ? (BlocProvider.of<SimplificationCubit>(
                                                  context)
                                              .isResultExist)
                                          ? ThemeColors.lightBlackText
                                          : ThemeColors.lightBlackText
                                              .withOpacity(0.5)
                                      : (BlocProvider.of<SimplificationCubit>(
                                                  context)
                                              .isResultExist)
                                          ? ThemeColors.darkWhiteText
                                          : ThemeColors.darkWhiteText
                                              .withOpacity(0.5),
                                  fontSize: SizeConfig.heightBlock! * 2.5,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                width: SizeConfig.widthBlock! * 2,
                              ),
                              Icon(
                                Icons.info_outline,
                                color: (theme == 'light')
                                    ? (BlocProvider.of<SimplificationCubit>(
                                                context)
                                            .isResultExist)
                                        ? ThemeColors.lightForegroundTeal
                                        : ThemeColors.lightBlackText
                                            .withOpacity(0.5)
                                    : (BlocProvider.of<SimplificationCubit>(
                                                context)
                                            .isResultExist)
                                        ? ThemeColors.darkForegroundTeal
                                        : ThemeColors.darkWhiteText
                                            .withOpacity(0.5),
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(
            width: SizeConfig.widthBlock!,
          ),
          Expanded(
            flex: 3,
            child: Showcase(
              tooltipBackgroundColor: ThemeColors.lightCanvas,
              titleTextStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: ThemeColors.lightForegroundTeal,
                  fontSize: 16),
              descTextStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                color: ThemeColors.lightBlackText,
                fontSize: 14,
              ),
              key: BlocProvider.of<SimplificationCubit>(context).simplifyKey,
              title: 'Simplify Button',
              description: 'To Simplify an expression.',
              child: FilledButton(
                style: FilledButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.widthBlock!),
                    backgroundColor: ThemeColors.redColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    )),
                onPressed:
                    BlocProvider.of<SimplificationCubit>(context).getResult,
                child: FittedBox(
                  child: Text(
                    'Simplify',
                    style: TextStyle(
                      color: ThemeColors.darkWhiteText,
                      fontWeight: FontWeight.bold,
                      fontSize: SizeConfig.heightBlock! * 2.5,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
