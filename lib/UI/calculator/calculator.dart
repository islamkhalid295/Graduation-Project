import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/Cubits/calculator_cubit/calculator_cubit.dart';
import 'package:graduation_project/Cubits/theme_cubit/theme_cubit.dart';
import 'package:graduation_project/Models/app_config.dart';
import 'package:graduation_project/UI/drawer.dart';
import 'dart:io';
part 'number_system.dart';
part 'keyboard.dart';
part 'keyboard_options.dart';
part 'keyboard_keys.dart';

class Calculator extends StatelessWidget {
  Calculator({super.key});
  String? theme;
  @override
  Widget build(BuildContext context) {
    if(SizeConfig.width==null) {
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
      builder: (context, state) => Scaffold(
        drawer: MyDrawer(),
        backgroundColor: (theme == 'light')
            ? ThemeColors.lightCanvas
            : ThemeColors.darkCanvas,
        body: SafeArea(
          child: Padding(
            padding:
                EdgeInsets.symmetric(horizontal: SizeConfig.widthBlock! * 5),
            child: Column(
              children: [
                if (Platform.isWindows)
                  SizedBox(
                    height: SizeConfig.heightBlock!,
                  ),
                SizedBox(
                  height: SizeConfig.heightBlock! * 5,
                  child: AppBar(
                    title: const Text(
                      'Calculator',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    centerTitle: true,
                    leading: FittedBox(
                      child: Builder(
                        builder: (context) => IconButton(
                          icon: const Icon(Icons.menu),
                          onPressed: () => Scaffold.of(context).openDrawer(),
                        ),
                      ),
                    ),
                    actions: [
                      FittedBox(
                        child: IconButton(
                            onPressed: () {}, icon: const Icon(Icons.history)),
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
                  child: SingleChildScrollView(
                    reverse: true,
                    scrollDirection: Axis.horizontal,
                    child: BlocBuilder<CalculatorCubit, CalculatorState>(
                      buildWhen: (previous, current) =>
                          current is CalculatorEprUpdate,
                      builder: (context, state) => SelectableText(
                        BlocProvider.of<CalculatorCubit>(context).userExpr,
                        style: TextStyle(
                          color: (theme == 'light')
                              ? ThemeColors.lightBlackText
                              : ThemeColors.darkWhiteText,
                          fontSize: SizeConfig.heightBlock! * 3,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.end,
                        showCursor: true,
                        onSelectionChanged: (selection, cause) =>
                            BlocProvider.of<CalculatorCubit>(context)
                                .changePosition(selection.start, selection.end),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: SizeConfig.heightBlock! * 0.25,
                ),
                Row(
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
                        child: BlocBuilder<CalculatorCubit, CalculatorState>(
                          buildWhen: (previous, current) =>
                              current is CalculatorResult,
                          builder: (context, state) {
                            return SelectableText(
                              BlocProvider.of<CalculatorCubit>(context).result,
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
                SizedBox(
                  height: SizeConfig.heightBlock! * 2,
                ),
                ConvertSystem(),
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
  }
}
