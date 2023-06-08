part of 'simplification.dart';

class Keyboard extends StatelessWidget {
  Keyboard({super.key});
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
      builder: (context, state) => Expanded(
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
          key: BlocProvider.of<SimplificationCubit>(context).keyboardKey,
          title: 'Keyboard Section',
          description: 'You can write your expression via this section.',
          child: Container(
            padding: const EdgeInsets.all(10),
            width: double.infinity,
            decoration: BoxDecoration(
              color: (theme == 'light')
                  ? ThemeColors.lightElemBG
                  : ThemeColors.darkElemBG,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(8)),
            ),
            child: Column(
              children: [
                Expanded(
                  child: KeyboardOptions(),
                ),
                Divider(
                  height: 5,
                  thickness: 2,
                  indent: SizeConfig.widthBlock! * 2,
                  endIndent: SizeConfig.widthBlock! * 2,
                  color: (theme == 'light')
                      ? ThemeColors.lightBlackText.withOpacity(0.25)
                      : ThemeColors.darkWhiteText.withOpacity(0.25),
                ),
                Expanded(
                  flex: 9,
                  child: KeyboardKeys(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
