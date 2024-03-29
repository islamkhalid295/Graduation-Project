import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/Cubits/calculator_cubit/calculator_cubit.dart';
import 'package:graduation_project/Cubits/login_cubit/login_cubit.dart';
import 'package:graduation_project/Cubits/theme_cubit/theme_cubit.dart';
import 'package:graduation_project/Models/app_config.dart';

class MyDrawer extends StatelessWidget {
  MyDrawer({super.key}) {
    for (int i = 4; i < 65; i += 4) {
      noBits.add(i);
    }
    dropDownMenuItems = noBits.map((e) => createItem(e)).toList();
  }
  String? theme;
  List<int> noBits = List.empty(growable: true);
  late List<DropdownMenuItem> dropDownMenuItems;
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
          child: Column(
            children: [
              SizedBox(
                height: SizeConfig.heightBlock! * 5,
              ),
              (BlocProvider.of<LoginCubit>(context).isLogedIn())
                  ? Container(
                      alignment: AlignmentDirectional.centerStart,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            BlocProvider.of<LoginCubit>(context).name,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              color: (theme == 'light')
                                  ? ThemeColors.lightForegroundTeal
                                  : ThemeColors.darkForegroundTeal,
                              fontSize: SizeConfig.heightBlock! * 2,
                              fontFamily: SizeConfig.fontName,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            BlocProvider.of<LoginCubit>(context).email,
                          ),
                          SizedBox(
                            height: SizeConfig.heightBlock! * 2,
                          ),
                          TextButton(
                            onPressed: () =>
                                BlocProvider.of<LoginCubit>(context)
                                    .logout(context),
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.only(
                                left: 0,
                              ),
                              foregroundColor: (theme == 'light')
                                  ? ThemeColors.lightForegroundTeal
                                  : ThemeColors.darkForegroundTeal,
                              textStyle: TextStyle(
                                fontSize: SizeConfig.heightBlock! * 2,
                                fontFamily: SizeConfig.fontName,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text('Logout\t'),
                                Icon(
                                  Icons.logout,
                                  size: SizeConfig.heightBlock! * 2,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: SizeConfig.heightBlock! * 2,
                          ),
                        ],
                      ),
                    )
                  : SizedBox(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: TextButton(
                                  onPressed: () => Navigator.of(context)
                                      .pushReplacementNamed('/login'),
                                  style: TextButton.styleFrom(
                                    foregroundColor: (theme == 'light')
                                        ? ThemeColors.lightForegroundTeal
                                        : ThemeColors.darkForegroundTeal,
                                    textStyle: TextStyle(
                                      fontSize: SizeConfig.heightBlock! * 3,
                                      fontFamily: SizeConfig.fontName,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  child: const Text('Login'),
                                ),
                              ),
                              SizedBox(
                                width: SizeConfig.widthBlock!,
                              ),
                              Expanded(
                                child: TextButton(
                                  onPressed: () => Navigator.of(context)
                                      .pushReplacementNamed('/register'),
                                  style: TextButton.styleFrom(
                                    foregroundColor: (theme == 'light')
                                        ? ThemeColors.lightForegroundTeal
                                        : ThemeColors.darkForegroundTeal,
                                    textStyle: TextStyle(
                                      fontSize: SizeConfig.heightBlock! * 3,
                                      fontFamily: SizeConfig.fontName,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  child: const Text('Register'),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: SizeConfig.heightBlock! * 5,
                          ),
                        ],
                      ),
                    ),
              Divider(
                height: 5,
                thickness: 2,
                color: (theme == 'light')
                    ? ThemeColors.lightBlackText.withOpacity(0.25)
                    : ThemeColors.darkWhiteText.withOpacity(0.25),
              ),
              buildListTile(context, 'Calculator'),
              buildListTile(context, 'Simplification'),
              buildListTile(context, 'Documentation'),
              Padding(
                padding:
                    EdgeInsets.symmetric(vertical: SizeConfig.heightBlock!),
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
              Divider(
                height: 5,
                thickness: 2,
                color: (theme == 'light')
                    ? ThemeColors.lightBlackText.withOpacity(0.25)
                    : ThemeColors.darkWhiteText.withOpacity(0.25),
              ),
              Padding(
                padding:
                    EdgeInsets.symmetric(vertical: SizeConfig.heightBlock!),
                child: ListTile(
                  onTap: null,
                  onFocusChange: null,
                  onLongPress: null,
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 6,
                        child: Text(
                          'Number of Bits ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: SizeConfig.heightBlock! * 2,
                            color: (theme == 'light')
                                ? ThemeColors.lightBlackText
                                : ThemeColors.darkWhiteText,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: BlocBuilder<CalculatorCubit, CalculatorState>(
                          buildWhen: (previous, current) =>
                              current is NoOfBitsChange,
                          builder: (context, state) => DropdownButton(
                            isDense: true,
                            value: BlocProvider.of<CalculatorCubit>(context)
                                .noBits,
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
                            isExpanded: true,
                            items: dropDownMenuItems,
                            onChanged: (value) {
                              BlocProvider.of<CalculatorCubit>(context)
                                  .changeNoBits(value!);
                            },
                          ),
                        ),
                      ),
                    ],
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
              )
            ],
          ),
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
        onTap: () {
          Navigator.of(context).pushReplacementNamed('/${str.toLowerCase()}');
          UserConfig.setLastPage('/${str.toLowerCase()}');
        },
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

  DropdownMenuItem createItem(int bits) => DropdownMenuItem(
        value: bits,
        child: FittedBox(
          child: Text(
            '$bits',
            style: TextStyle(
              color: (theme == 'light')
                  ? ThemeColors.lightBlackText
                  : ThemeColors.darkWhiteText,
              fontWeight: FontWeight.bold,
              fontSize: SizeConfig.heightBlock! * 2,
            ),
          ),
        ),
      );
}
