import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/Cubits/theme_cubit/theme_cubit.dart';
import 'package:graduation_project/Models/app_config.dart';
import 'package:graduation_project/UI/drawer.dart';
import 'dart:io';
import '../../Models/documentation_element_model.dart';

class Documentation extends StatelessWidget {
  Documentation({super.key});
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
                      'Documentation',
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
                Expanded(
                  child: ListView(
                    children: documentation
                        .map(
                          (e) => createDocElement(e),
                        )
                        .toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget createDocElement(DocumentationElement element) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: ExpansionTile(
        title: Text(
          element.title,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        collapsedShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        collapsedBackgroundColor:
            theme == 'light' ? ThemeColors.lightElemBG : ThemeColors.darkElemBG,
        backgroundColor:
            theme == 'light' ? ThemeColors.lightElemBG : ThemeColors.darkElemBG,
        iconColor: theme == 'light'
            ? ThemeColors.lightForegroundTeal
            : ThemeColors.darkForegroundTeal,
        textColor: theme == 'light'
            ? ThemeColors.lightBlackText
            : ThemeColors.darkWhiteText,
        // textColor: theme == 'light'
        //     ? ThemeColors.lightForegroundTeal
        //     : ThemeColors.darkForegroundTeal,
        collapsedTextColor: theme == 'light'
            ? ThemeColors.lightForegroundTeal
            : ThemeColors.darkForegroundTeal,
        collapsedIconColor: theme == 'light'
            ? ThemeColors.lightForegroundTeal
            : ThemeColors.darkForegroundTeal,
        childrenPadding: const EdgeInsets.symmetric(horizontal: 10),
        children: [
          Divider(
            color: (theme == 'light')
                ? ThemeColors.lightBlackText.withOpacity(0.5)
                : ThemeColors.darkWhiteText.withOpacity(0.5),
            thickness: 1,
            indent: 20,
            endIndent: 20,
          ),
          Container(
            alignment: AlignmentDirectional.centerStart,
            child: Text(
              'Description:',
              //textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: SizeConfig.heightBlock! * 2.5,
                fontWeight: FontWeight.bold,
                color: ThemeColors.blueColor,
              ),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Container(
            alignment: AlignmentDirectional.centerStart,
            child: Text(
              element.description,
              style: TextStyle(
                fontSize: SizeConfig.heightBlock! * 2,
                color: theme == 'light'
                    ? ThemeColors.lightBlackText
                    : ThemeColors.darkWhiteText,
              ),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Container(
            alignment: AlignmentDirectional.centerStart,
            child: Text('Examples:',
                style: TextStyle(
                  fontSize: SizeConfig.heightBlock! * 2.5,
                  fontWeight: FontWeight.bold,
                  color: ThemeColors.blueColor,
                )),
          ),
          const SizedBox(
            height: 5,
          ),
          ...element.example.map(
            (e) => Container(
              alignment: AlignmentDirectional.centerStart,
              child: Text.rich(
                TextSpan(
                    text: e.num1,
                    children: [
                      TextSpan(
                        text: ' ${e.operation} ',
                        style: const TextStyle(
                          color: ThemeColors.redColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(text: e.num2),
                      const TextSpan(text: " = "),
                      TextSpan(
                        text: e.result,
                        style: const TextStyle(
                          color: ThemeColors.redColor,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                    style: TextStyle(
                      fontSize: SizeConfig.heightBlock! * 2,
                      color: theme == 'light'
                          ? ThemeColors.lightBlackText
                          : ThemeColors.darkWhiteText,
                    )),
              ),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
        ],
      ),
    );
  }
}
