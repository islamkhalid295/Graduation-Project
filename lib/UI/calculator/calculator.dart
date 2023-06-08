import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/Cubits/calculator_cubit/calculator_cubit.dart';
import 'package:graduation_project/Cubits/theme_cubit/theme_cubit.dart';
import 'package:graduation_project/Models/app_config.dart';
import 'package:graduation_project/UI/drawer.dart';
import 'dart:io';

import 'package:showcaseview/showcaseview.dart';
part 'number_system.dart';
part 'keyboard.dart';
part 'keyboard_options.dart';
part 'keyboard_keys.dart';

class Calculator extends StatelessWidget {
  Calculator({super.key});
  String? theme;
  @override
  Widget build(BuildContext context) {
    if (SizeConfig.width == null) {
      SizeConfig().init(context);
    }
    theme =
        checkTheme(BlocProvider.of<ThemeCubit>(context).currentTheme, context);
    return GestureDetector(
      onTap: BlocProvider.of<CalculatorCubit>(context).focusNode.requestFocus,
      child: BlocConsumer<ThemeCubit, ThemeState>(
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
        builder: (context, state) => ShowCaseWidget(
          blurValue: 2.5,
          onFinish: () => UserConfig.setCalculatorGuidance(true),
          builder: Builder(builder: (context) {
            if (UserConfig.getCalculatorGuidance() == null) {
              WidgetsBinding.instance.addPostFrameCallback((timeStamp) =>
                  ShowCaseWidget.of(context).startShowCase([
                    BlocProvider.of<CalculatorCubit>(context).pageKey,
                    BlocProvider.of<CalculatorCubit>(context).historyKey,
                    BlocProvider.of<CalculatorCubit>(context).resultKey,
                    BlocProvider.of<CalculatorCubit>(context).convertSysKey,
                    BlocProvider.of<CalculatorCubit>(context).keyboardKey,
                    BlocProvider.of<CalculatorCubit>(context).signedKey,
                    BlocProvider.of<CalculatorCubit>(context).explanationKey,
                    BlocProvider.of<CalculatorCubit>(context).menuKey,
                  ]));
            }
            return Scaffold(
              drawer: MyDrawer(),
              backgroundColor: (theme == 'light')
                  ? ThemeColors.lightCanvas
                  : ThemeColors.darkCanvas,
              body: SafeArea(
                child: GestureDetector(
                  onTap: BlocProvider.of<CalculatorCubit>(context)
                      .focusNode
                      .requestFocus,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.widthBlock! * 5),
                    child: Column(
                      children: [
                        if (kIsWeb || Platform.isWindows)
                          SizedBox(
                            height: SizeConfig.heightBlock!,
                          ),
                        SizedBox(
                          height: SizeConfig.heightBlock! * 5,
                          child: AppBar(
                            title: Showcase(
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
                              key: BlocProvider.of<CalculatorCubit>(context)
                                  .pageKey,
                              title: 'Calculator Page',
                              description:
                                  'Is to calculate the Logical expressions',
                              child: const Text(
                                'Calculator',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            centerTitle: true,
                            leading: FittedBox(
                              child: Builder(
                                builder: (context) => Showcase(
                                  tooltipBackgroundColor:
                                      ThemeColors.lightCanvas,
                                  titleTextStyle: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: ThemeColors.lightForegroundTeal,
                                      fontSize: 16),
                                  descTextStyle: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: ThemeColors.lightBlackText,
                                    fontSize: 14,
                                  ),
                                  key: BlocProvider.of<CalculatorCubit>(context)
                                      .menuKey,
                                  title: 'Menu Button',
                                  description:
                                      'This button is to open the side menu to access to other pages.',
                                  child: IconButton(
                                    icon: const Icon(Icons.menu),
                                    onPressed: () =>
                                        Scaffold.of(context).openDrawer(),
                                  ),
                                ),
                              ),
                            ),
                            actions: [
                              Showcase(
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
                                key: BlocProvider.of<CalculatorCubit>(context)
                                    .historyKey,
                                title: 'History Button',
                                description:
                                    'Is to open history of previous calculations.',
                                child: FittedBox(
                                  child: IconButton(
                                      onPressed: () =>
                                          BlocProvider.of<CalculatorCubit>(
                                                  context)
                                              .showHistory(context, theme!),
                                      icon: const Icon(Icons.history)),
                                ),
                              )
                            ],
                            backgroundColor: (theme == 'light')
                                ? ThemeColors.lightElemBG
                                : ThemeColors.darkElemBG,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            foregroundColor: (theme == 'light')
                                ? ThemeColors.lightForegroundTeal
                                : ThemeColors.darkForegroundTeal,
                            elevation: 0,
                          ),
                        ),
                        SizedBox(
                          height: SizeConfig.heightBlock! * 2,
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: TextField(
                            style: TextStyle(
                              color: (theme == 'light')
                                  ? ThemeColors.lightBlackText
                                  : ThemeColors.darkWhiteText,
                              fontSize: SizeConfig.heightBlock! * 3,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.end,
                            focusNode: BlocProvider.of<CalculatorCubit>(context)
                                .focusNode,
                            maxLines: 1,
                            autofocus: true,
                            controller:
                                BlocProvider.of<CalculatorCubit>(context)
                                    .controller,
                            keyboardType: TextInputType.none,
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.zero,
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: SizeConfig.heightBlock! * 0.25,
                        ),
                        Showcase(
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
                          key: BlocProvider.of<CalculatorCubit>(context)
                              .resultKey,
                          title: 'Result Section',
                          description:
                              'The section where the results are displayed.',
                          child: Row(
                            children: [
                              Text(
                                '=',
                                style: TextStyle(
                                  color: (theme == 'light')
                                      ? ThemeColors.lightForegroundTeal
                                      : ThemeColors.darkForegroundTeal,
                                  fontSize: SizeConfig.heightBlock! * 3,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                width: SizeConfig.widthBlock! * 5,
                              ),
                              Expanded(
                                child: SingleChildScrollView(
                                  reverse: true,
                                  scrollDirection: Axis.horizontal,
                                  child: BlocBuilder<CalculatorCubit,
                                      CalculatorState>(
                                    buildWhen: (previous, current) =>
                                        current is CalculatorResult,
                                    builder: (context, state) {
                                      return SelectableText(
                                        BlocProvider.of<CalculatorCubit>(
                                                context)
                                            .result,
                                        style: TextStyle(
                                          color: (theme == 'light')
                                              ? ThemeColors.lightBlackText
                                              : ThemeColors.darkWhiteText,
                                          fontSize: SizeConfig.heightBlock! * 3,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.end,
                                        showCursor: true,
                                      );
                                    },
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: SizeConfig.heightBlock! * 2,
                        ),
                        Showcase(
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
                            key: BlocProvider.of<CalculatorCubit>(context)
                                .convertSysKey,
                            title: 'Convert System Section',
                            description:
                                'You can change the number system in this section by selecting the system you want.',
                            child: ConvertSystem()),
                        SizedBox(
                          height: SizeConfig.heightBlock! * 2,
                        ),
                        Keyboard(),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
