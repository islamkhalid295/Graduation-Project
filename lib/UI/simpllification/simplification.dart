import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/Cubits/simplification_cubit/simplification_cubit.dart';
import 'package:graduation_project/Cubits/theme_cubit/theme_cubit.dart';
import 'package:graduation_project/Models/app_config.dart';
import 'package:graduation_project/UI/drawer.dart';
import 'package:showcaseview/showcaseview.dart';

part 'keyboard.dart';
part 'keyboard_options.dart';
part 'keyboard_keys.dart';

class Simplification extends StatelessWidget {
  Simplification({super.key});
  String? theme;
  @override
  Widget build(BuildContext context) {
    if (SizeConfig.width == null) {
      SizeConfig().init(context);
    }
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
      builder: (context, state) => ShowCaseWidget(
        blurValue: 2.5,
        onFinish: () => UserConfig.setSimplificationGuidance(true),
        builder: Builder(builder: (context) {
          if (UserConfig.getSimplificationGuidance() == null) {
            WidgetsBinding.instance.addPostFrameCallback((timeStamp) =>
                ShowCaseWidget.of(context).startShowCase([
                  BlocProvider.of<SimplificationCubit>(context).pageKey,
                  BlocProvider.of<SimplificationCubit>(context).historyKey,
                  BlocProvider.of<SimplificationCubit>(context).resultKey,
                  BlocProvider.of<SimplificationCubit>(context).keyboardKey,
                  BlocProvider.of<SimplificationCubit>(context).explanationKey,
                  BlocProvider.of<SimplificationCubit>(context).simplifyKey,
                  BlocProvider.of<SimplificationCubit>(context).showTTKey,
                  BlocProvider.of<SimplificationCubit>(context).menuKey,
                ]));
          }
          return Scaffold(
            drawer: MyDrawer(),
            backgroundColor: (theme == 'light')
                ? ThemeColors.lightCanvas
                : ThemeColors.darkCanvas,
            body: SafeArea(
              child: GestureDetector(
                onTap: BlocProvider.of<SimplificationCubit>(context)
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
                            key: BlocProvider.of<SimplificationCubit>(context)
                                .pageKey,
                            title: 'Simplification Page',
                            description:
                                'This page is used to simplify boolean expressions and showing truth table.',
                            child: const Text(
                              'Simplification',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          centerTitle: true,
                          leading: FittedBox(
                            child: Builder(
                              builder: (context) => Showcase(
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
                                key: BlocProvider.of<SimplificationCubit>(
                                        context)
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
                            FittedBox(
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
                                key: BlocProvider.of<SimplificationCubit>(
                                        context)
                                    .historyKey,
                                title: 'History Button',
                                description:
                                    'Is to open history of previous Simplifying Operations.',
                                child: IconButton(
                                    onPressed: () =>
                                        BlocProvider.of<SimplificationCubit>(
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
                          focusNode:
                              BlocProvider.of<SimplificationCubit>(context)
                                  .focusNode,
                          maxLines: 1,
                          autofocus: true,
                          controller:
                              BlocProvider.of<SimplificationCubit>(context)
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
                        height: SizeConfig.heightBlock! * 2,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: BlocBuilder<SimplificationCubit,
                              SimplificationState>(
                            buildWhen: (previous, current) =>
                                current is SimplificationResult,
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
                                key: BlocProvider.of<SimplificationCubit>(
                                        context)
                                    .resultKey,
                                title: 'Result Section',
                                description:
                                    'The section where the results are displayed.',
                                child: SelectableText(
                                  BlocProvider.of<SimplificationCubit>(context)
                                      .result,
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
                                    fontSize: SizeConfig.heightBlock! * 3,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.start,
                                  showCursor: true,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
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
    );
  }
}
