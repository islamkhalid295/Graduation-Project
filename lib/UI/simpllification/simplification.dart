import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/Cubits/simplification_cubit/simplification_cubit.dart';
import 'package:graduation_project/Cubits/theme_cubit/theme_cubit.dart';
import 'package:graduation_project/Models/app_config.dart';
import 'package:graduation_project/UI/drawer.dart';

part 'keyboard.dart';
part 'keyboard_options.dart';
part 'keyboard_keys.dart';

class Simplification extends StatelessWidget {
  bool showCursor = true;
  Simplification({super.key});
  String? theme;
  @override
  Widget build(BuildContext context) {
    // SizeConfig().init(context);
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
                if (kIsWeb || Platform.isWindows)
                  SizedBox(
                    height: SizeConfig.heightBlock!,
                  ),
                SizedBox(
                  height: SizeConfig.heightBlock! * 5,
                  child: AppBar(
                    title: const Text(
                      'Simplification',
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
                    scrollDirection: Axis.horizontal,
                    child:
                        BlocBuilder<SimplificationCubit, SimplificationState>(
                      buildWhen: (previous, current) =>
                          current is SimplificationEprUpdate,
                      builder: (context, state) => SelectableText(
                        BlocProvider.of<SimplificationCubit>(context).userExpr,
                        style: TextStyle(
                          color: (theme == 'light')
                              ? ThemeColors.lightBlackText
                              : ThemeColors.darkWhiteText,
                          fontSize: SizeConfig.heightBlock! * 3,
                          fontWeight: FontWeight.bold,
                        ),
                        showCursor: true,
                        onSelectionChanged: (selection, cause) {
                          BlocProvider.of<SimplificationCubit>(context)
                              .changePosition(selection.start, selection.end);
                        },
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
                    child:
                        BlocBuilder<SimplificationCubit, SimplificationState>(
                      buildWhen: (previous, current) =>
                          current is SimplificationResult,
                      builder: (context, state) {
                        return SelectableText(
                          BlocProvider.of<SimplificationCubit>(context).result,
                          style: TextStyle(
                            color: (theme == 'light')
                                ? (BlocProvider.of<SimplificationCubit>(context)
                                        .isResultExist)
                                    ? ThemeColors.lightBlackText
                                    : ThemeColors.lightBlackText
                                        .withOpacity(0.5)
                                : (BlocProvider.of<SimplificationCubit>(context)
                                        .isResultExist)
                                    ? ThemeColors.darkWhiteText
                                    : ThemeColors.darkWhiteText
                                        .withOpacity(0.5),
                            fontSize: SizeConfig.heightBlock! * 3,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.start,
                          showCursor: true,
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
  }
}
