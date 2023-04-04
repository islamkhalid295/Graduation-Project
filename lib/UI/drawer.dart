import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/Cubits/theme_cubit/theme_cubit.dart';
import 'package:graduation_project/Models/app_config.dart';

class MyDrawer extends StatelessWidget {
  MyDrawer({super.key});
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
      builder: (context, state) => Drawer(
        backgroundColor: (theme == 'light')
            ? ThemeColors.lightElemBG
            : ThemeColors.darkElemBG,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.widthBlock! * 2,
            vertical: SizeConfig.heightBlock!,
          ),
          child: Column(children: [
            buildListTile(context, 'Calculator'),
            buildListTile(context, 'Simplification'),
            Padding(
              padding: EdgeInsets.symmetric(vertical: SizeConfig.heightBlock!),
              child: ExpansionTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                collapsedShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                collapsedBackgroundColor: theme == 'light'
                    ? ThemeColors.lightCanvas
                    : ThemeColors.darkCanvas,
                backgroundColor: theme == 'light'
                    ? ThemeColors.lightCanvas
                    : ThemeColors.darkCanvas,
                iconColor: theme == 'light'
                    ? ThemeColors.lightForegroundTeal
                    : ThemeColors.darkForegroundTeal,
                textColor: theme == 'light'
                    ? ThemeColors.lightBlackText
                    : ThemeColors.darkWhiteText,
                title: Text(
                  'Theme',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: SizeConfig.heightBlock! * 2,
                    color: (theme == 'light')
                        ? ThemeColors.lightBlackText
                        : ThemeColors.darkWhiteText,
                  ),
                ),
                collapsedIconColor: theme == 'light'
                    ? ThemeColors.lightForegroundTeal
                    : ThemeColors.darkForegroundTeal,
                children: [
                  Divider(
                    color: (theme == 'light')
                        ? ThemeColors.lightBlackText.withOpacity(0.5)
                        : ThemeColors.darkWhiteText.withOpacity(0.5),
                    thickness: 1,
                    indent: 20,
                    endIndent: 20,
                  ),
                  ListTile(
                    title: Text(
                      'Default',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: SizeConfig.heightBlock! * 2,
                        color: (theme == 'light')
                            ? ThemeColors.lightBlackText
                            : ThemeColors.darkWhiteText,
                      ),
                    ),
                    onTap: () => BlocProvider.of<ThemeCubit>(context)
                        .changeTheme('system'),
                  ),
                  ListTile(
                    title: Text(
                      'Light',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: SizeConfig.heightBlock! * 2,
                        color: (theme == 'light')
                            ? ThemeColors.lightBlackText
                            : ThemeColors.darkWhiteText,
                      ),
                    ),
                    onTap: () => BlocProvider.of<ThemeCubit>(context)
                        .changeTheme('light'),
                  ),
                  ListTile(
                    title: Text(
                      'Dark',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: SizeConfig.heightBlock! * 2,
                        color: (theme == 'light')
                            ? ThemeColors.lightBlackText
                            : ThemeColors.darkWhiteText,
                      ),
                    ),
                    onTap: () => BlocProvider.of<ThemeCubit>(context)
                        .changeTheme('dark'),
                  ),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }

  Padding buildListTile(BuildContext context, String str) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: SizeConfig.heightBlock!),
      child: ListTile(
        title: Text(
          str,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: SizeConfig.heightBlock! * 2,
            color: (theme == 'light')
                ? ThemeColors.lightBlackText
                : ThemeColors.darkWhiteText,
          ),
        ),
        onTap: () =>
            Navigator.of(context).pushReplacementNamed('/${str.toLowerCase()}'),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: SizeConfig.heightBlock! * 2,
        ),
        tileColor: (theme == 'light')
            ? ThemeColors.lightCanvas
            : ThemeColors.darkCanvas,
        iconColor: (theme == 'light')
            ? ThemeColors.lightForegroundTeal
            : ThemeColors.darkForegroundTeal,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
