import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/Cubits/register_cubit/register_cubit.dart';
import 'package:graduation_project/Cubits/theme_cubit/theme_cubit.dart';
import 'package:graduation_project/Models/app_config.dart';

class Register extends StatelessWidget {
  Register({super.key});
  String? theme;
  @override
  Widget build(BuildContext context) {
    //SizeConfig().init(context);
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
        backgroundColor: (theme == 'light')
            ? ThemeColors.lightCanvas
            : ThemeColors.darkCanvas,
        body: SafeArea(
            child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: SizeConfig.widthBlock! * 10),
          child: BlocConsumer<RegisterCubit, RegisterState>(
            listener: (context, state) {
              // TODO: implement listener
            },
            builder: (context, state) {
              return Form(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Register',
                      style: TextStyle(
                        fontSize: SizeConfig.widthBlock! * 12,
                        fontWeight: FontWeight.bold,
                        color: (theme == 'light')
                            ? ThemeColors.lightForegroundTeal
                            : ThemeColors.darkForegroundTeal,
                      ),
                    ),
                    Text(
                      'Create a new account',
                      style: TextStyle(
                        fontSize: SizeConfig.widthBlock! * 5,
                        color: (theme == 'light')
                            ? ThemeColors.lightBlackText.withOpacity(0.75)
                            : ThemeColors.darkWhiteText.withOpacity(0.75),
                      ),
                    ),
                    SizedBox(
                      height: SizeConfig.heightBlock! * 6,
                    ),
                    LayoutBuilder(
                      builder: (context, constraints) => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: constraints.maxWidth * 0.48,
                            child: TextFormField(
                              cursorColor: (theme == 'light')
                                  ? ThemeColors.lightBlackText
                                  : ThemeColors.darkWhiteText,
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                                color: (theme == 'light')
                                    ? ThemeColors.lightBlackText
                                    : ThemeColors.darkWhiteText,
                              ),
                              maxLines: 1,
                              keyboardType: TextInputType.emailAddress,
                              validator: (str) {},
                              decoration: InputDecoration(
                                labelText: 'First Name',
                                hintStyle: const TextStyle(
                                    fontStyle: FontStyle.italic),
                                labelStyle: const TextStyle(
                                  fontStyle: FontStyle.italic,
                                ),
                                floatingLabelStyle: const TextStyle(
                                  fontStyle: FontStyle.normal,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4),
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: (theme == 'light')
                                        ? ThemeColors.lightUnfocused
                                        : ThemeColors.darkUnfocused,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4),
                                  borderSide: BorderSide(
                                      width: 2,
                                      color: (theme == 'light')
                                          ? ThemeColors.lightForegroundTeal
                                          : ThemeColors.darkForegroundTeal,
                                      style: BorderStyle.solid),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: constraints.maxWidth * 0.48,
                            child: TextFormField(
                              cursorColor: (theme == 'light')
                                  ? ThemeColors.lightBlackText
                                  : ThemeColors.darkWhiteText,
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                                color: (theme == 'light')
                                    ? ThemeColors.lightBlackText
                                    : ThemeColors.darkWhiteText,
                              ),
                              maxLines: 1,
                              keyboardType: TextInputType.emailAddress,
                              validator: (str) {},
                              decoration: InputDecoration(
                                labelText: 'Last Name',
                                hintStyle: const TextStyle(
                                    fontStyle: FontStyle.italic),
                                labelStyle: const TextStyle(
                                  fontStyle: FontStyle.italic,
                                ),
                                floatingLabelStyle: const TextStyle(
                                  fontStyle: FontStyle.normal,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4),
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: (theme == 'light')
                                        ? ThemeColors.lightUnfocused
                                        : ThemeColors.darkUnfocused,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4),
                                  borderSide: BorderSide(
                                      width: 2,
                                      color: (theme == 'light')
                                          ? ThemeColors.lightForegroundTeal
                                          : ThemeColors.darkForegroundTeal,
                                      style: BorderStyle.solid),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: SizeConfig.heightBlock! * 2.5,
                    ),
                    TextFormField(
                      cursorColor: (theme == 'light')
                          ? ThemeColors.lightBlackText
                          : ThemeColors.darkWhiteText,
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        color: (theme == 'light')
                            ? ThemeColors.lightBlackText
                            : ThemeColors.darkWhiteText,
                      ),
                      maxLines: 1,
                      keyboardType: TextInputType.emailAddress,
                      validator: (str) {},
                      decoration: InputDecoration(
                        hintText: 'example123@example.com',
                        labelText: 'Email',
                        hintStyle: const TextStyle(fontStyle: FontStyle.italic),
                        labelStyle: const TextStyle(
                          fontStyle: FontStyle.italic,
                        ),
                        floatingLabelStyle: const TextStyle(
                          fontStyle: FontStyle.normal,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                          borderSide: BorderSide(
                            width: 1,
                            color: (theme == 'light')
                                ? ThemeColors.lightUnfocused
                                : ThemeColors.darkUnfocused,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                          borderSide: BorderSide(
                              width: 2,
                              color: (theme == 'light')
                                  ? ThemeColors.lightForegroundTeal
                                  : ThemeColors.darkForegroundTeal,
                              style: BorderStyle.solid),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: SizeConfig.heightBlock! * 2.5,
                    ),
                    TextFormField(
                      cursorColor: (theme == 'light')
                          ? ThemeColors.lightBlackText
                          : ThemeColors.darkWhiteText,
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        color: (theme == 'light')
                            ? ThemeColors.lightBlackText
                            : ThemeColors.darkWhiteText,
                      ),
                      maxLines: 1,
                      obscureText:
                          BlocProvider.of<RegisterCubit>(context).isSecured,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        suffixIcon: IconButton(
                          icon:
                              BlocProvider.of<RegisterCubit>(context).isSecured
                                  ? const Icon(Icons.visibility)
                                  : const Icon(Icons.visibility_off),
                          onPressed: () =>
                              BlocProvider.of<RegisterCubit>(context)
                                  .changePassVisibility(),
                        ),
                        hintStyle: const TextStyle(fontStyle: FontStyle.italic),
                        labelStyle: const TextStyle(
                          fontStyle: FontStyle.italic,
                        ),
                        floatingLabelStyle: const TextStyle(
                          fontStyle: FontStyle.normal,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                          borderSide: BorderSide(
                            width: 1,
                            color: (theme == 'light')
                                ? ThemeColors.lightUnfocused
                                : ThemeColors.darkUnfocused,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                          borderSide: BorderSide(
                            width: 2,
                            color: (theme == 'light')
                                ? ThemeColors.lightForegroundTeal
                                : ThemeColors.darkForegroundTeal,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: SizeConfig.heightBlock! * 2.5,
                    ),
                    TextFormField(
                      cursorColor: (theme == 'light')
                          ? ThemeColors.lightBlackText
                          : ThemeColors.darkWhiteText,
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        color: (theme == 'light')
                            ? ThemeColors.lightBlackText
                            : ThemeColors.darkWhiteText,
                      ),
                      maxLines: 1,
                      obscureText: BlocProvider.of<RegisterCubit>(context)
                          .isSecuredConfirm,
                      decoration: InputDecoration(
                        labelText: 'Confirm password',
                        suffixIcon: IconButton(
                          icon: BlocProvider.of<RegisterCubit>(context)
                                  .isSecuredConfirm
                              ? const Icon(Icons.visibility)
                              : const Icon(Icons.visibility_off),
                          onPressed: () =>
                              BlocProvider.of<RegisterCubit>(context)
                                  .changeConfirmPassVisibility(),
                        ),
                        hintStyle: const TextStyle(fontStyle: FontStyle.italic),
                        labelStyle: const TextStyle(
                          fontStyle: FontStyle.italic,
                        ),
                        floatingLabelStyle: const TextStyle(
                          fontStyle: FontStyle.normal,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                          borderSide: BorderSide(
                            width: 1,
                            color: (theme == 'light')
                                ? ThemeColors.lightUnfocused
                                : ThemeColors.darkUnfocused,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                          borderSide: BorderSide(
                            width: 2,
                            color: (theme == 'light')
                                ? ThemeColors.lightForegroundTeal
                                : ThemeColors.darkForegroundTeal,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: SizeConfig.heightBlock! * 6,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context)
                            .pushReplacementNamed('/calculator'),
                        style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                                vertical: SizeConfig.heightBlock! * 2,
                                horizontal: SizeConfig.widthBlock! * 2),
                            textStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: SizeConfig.heightBlock! * 4,
                                fontFamily: SizeConfig.fontName,
                                color: (theme == 'light')
                                    ? ThemeColors.lightForegroundTeal
                                    : ThemeColors.darkForegroundTeal),
                            side: BorderSide(
                              width: 3,
                              color: (theme == 'light')
                                  ? ThemeColors.lightForegroundTeal
                                  : ThemeColors.darkForegroundTeal,
                              style: BorderStyle.solid,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            )),
                        child: const Text('Register'),
                      ),
                    ),
                    SizedBox(
                      height: SizeConfig.heightBlock,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'You have an account?',
                          style: TextStyle(
                            fontSize: SizeConfig.heightBlock! * 2,
                            color: (theme == 'light')
                                ? ThemeColors.lightBlackText.withOpacity(0.75)
                                : ThemeColors.darkWhiteText.withOpacity(0.75),
                          ),
                        ),
                        const SizedBox(
                          width: 2,
                        ),
                        InkWell(
                          onTap: () => Navigator.of(context)
                              .pushReplacementNamed('/login'),
                          child: Text(
                            'Login',
                            style: TextStyle(
                              color: (theme == 'light')
                                  ? ThemeColors.lightForegroundTeal
                                  : ThemeColors.darkForegroundTeal,
                              fontSize: SizeConfig.heightBlock! * 2,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    //themeTestBtn(context)
                  ],
                ),
              );
            },
          ),
        )),
      ),
    );
  }
}