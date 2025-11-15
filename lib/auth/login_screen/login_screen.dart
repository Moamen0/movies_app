import 'package:flutter/material.dart';
import 'package:movies_app/api/auth_api.dart';
import 'package:movies_app/utils/app_assets.dart';
import 'package:movies_app/utils/app_color.dart';
import 'package:movies_app/utils/app_route.dart';
import 'package:movies_app/utils/app_style.dart';
import 'package:movies_app/utils/custom_elevated_button.dart';
import 'package:movies_app/utils/custom_text_form_field.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../animated_toggle_switch/animated_toggle_switch.dart';
import '../../generated/l10n.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController =
      TextEditingController(text: 'sakata@gmail.com');
  TextEditingController passwordController =
      TextEditingController(text: 'Sakata@525');
  bool isCensored = true;
  bool isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final res = await AuthMangerApi.login(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      if (res.success && res.data != null) {
        final token = res.data!.token;

        if (token != null && token.isNotEmpty) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.remove('user_data');
          await AuthMangerApi.saveToken(token);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(res.message ?? "login succes!"),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );

          Navigator.of(context).pushReplacementNamed(AppRoute.homeScreen);
          return;
        }
      }

      _showErrorSnackBar(res.message ?? "incorrect emailAdress of password");

      if (res.message != null &&
          (res.message!.contains("no account found with this data") ||
              res.message!.contains("create account"))) {
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {}
        });
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      _showErrorSnackBar(e.toString());
    }
  }

  void _showErrorSnackBar(String message) {
    print(message);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: width * .05),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: height * .07),
                Image.asset(AppAssets.logo),
                SizedBox(height: height * .07),
                CustomTextFormField(
                  controller: emailController,
                  prefixIcon: Image.asset(AppAssets.emailIcon),
                  hint: S.of(context).email,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "please enter your email adress";
                    }
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                        .hasMatch(value)) {
                      return "incorrect email adress";
                    }
                    return null;
                  },
                ),
                SizedBox(height: height * .024),
                CustomTextFormField(
                  controller: passwordController,
                  prefixIcon: Image.asset(AppAssets.passwordIcon),
                  obscureText: isCensored,
                  hint: S.of(context).password,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "please enter your password";
                    }
                    if (value.length < 6) {
                      return "password should be at least 6 chars or more";
                    }
                    return null;
                  },
                  suffixIcon: GestureDetector(
                    onTap: () {
                      setState(() {
                        isCensored = !isCensored;
                      });
                    },
                    child: isCensored
                        ? Image.asset(AppAssets.eyeoff)
                        : const Icon(
                            Icons.remove_red_eye_outlined,
                            color: Colors.white,
                          ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, AppRoute.forgetPassword);
                      },
                      child: Text(
                        '${S.of(context).forgetPassword}?',
                        style: AppStyle.reglur14yellow,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: height * .035),
                SizedBox(
                  width: double.infinity,
                  child: CustomElevatedButton(
                    onPressed: _handleLogin,
                    text: isLoading ? "loading" : S.of(context).login,
                  ),
                ),
                SizedBox(height: height * .024),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      S.of(context).DontHaveAcc,
                      style: AppStyle.reglur14white,
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, AppRoute.registerScreen);
                      },
                      child: Text(
                        S.of(context).createOne,
                        style: AppStyle.reglur14yellow,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: AppColor.yellow,
                        indent: 80,
                        endIndent: 15,
                      ),
                    ),
                    Text(
                      S.of(context).or,
                      style: AppStyle.reglur14yellow,
                    ),
                    Expanded(
                      child: Divider(
                        color: AppColor.yellow,
                        indent: 15,
                        endIndent: 80,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: height * .03),
                SizedBox(
                  width: double.infinity,
                  child: CustomElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("success login with google"),
                          backgroundColor: Colors.green,
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                    hasIcon: true,
                    iconWidget: Image.asset(AppAssets.googleIcon),
                    text: S.of(context).loginWithGoogle,
                    mainAxisAlignment: MainAxisAlignment.center,
                  ),
                ),
                SizedBox(height: height * .03),
                const LanguageToggle(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
