import 'package:flutter/material.dart';
import 'package:movies_app/utils/app_assets.dart';
import 'package:movies_app/utils/app_color.dart';
import 'package:movies_app/utils/app_route.dart';
import 'package:movies_app/utils/app_style.dart';
import 'package:movies_app/utils/custom_elevated_button.dart';
import 'package:movies_app/utils/custom_text_form_field.dart';

import '../../generated/l10n.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController? emailController = TextEditingController();
  TextEditingController? passwordController = TextEditingController();
  bool isCensored = true;

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: width * .05),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: height * .07,
              ),
              Image.asset(
                AppAssets.logo,
              ),
              SizedBox(
                height: height * .07,
              ),
              CustomTextFormField(
                controller: emailController,
                prefixIcon: Image.asset(AppAssets.emailIcon),
                hint: S.of(context).email,
              ),
              SizedBox(
                height: height * .024,
              ),
              CustomTextFormField(
                  controller: passwordController,
                  prefixIcon: Image.asset(AppAssets.passwordIcon),
                  obscureText: isCensored,
                  hint: S.of(context).password,
                  suffixIcon: GestureDetector(
                    onTap: () {
                      setState(() {
                        isCensored = !isCensored;
                      });
                    },
                    child: isCensored
                        ? Image.asset(AppAssets.eyeoff)
                        : const Icon(Icons.remove_red_eye_outlined,
                            color: Colors.white),
                  )),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      S.of(context).forgetPassword,
                      style: AppStyle.reglur14yellow,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: height * .035,
              ),
              SizedBox(
                width: double.infinity,
                child: CustomElevatedButton(
                    onPressed: () {
                      Navigator.of(context)
                          .pushReplacementNamed(AppRoute.home_tab);
                    },
                    text: S.of(context).login),
              ),
              SizedBox(
                height: height * .024,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    S.of(context).DontHaveAcc,
                    style: AppStyle.reglur14white,
                  ),
                  TextButton(
                      onPressed: () {},
                      child: Text(
                        S.of(context).createOne,
                        style: AppStyle.reglur14yellow,
                      )),
                ],
              ),
              Row(
                children: [
                  Expanded(
                      child: Divider(
                    color: AppColor.yellow,
                    indent: 80,
                    endIndent: 15,
                  )),
                  Text(
                    S.of(context).or,
                    style: AppStyle.reglur14yellow,
                  ),
                  Expanded(
                      child: Divider(
                    color: AppColor.yellow,
                    indent: 15,
                    endIndent: 80,
                  )),
                ],
              ),
              SizedBox(
                height: height * .03,
              ),
              SizedBox(
                width: double.infinity,
                child: CustomElevatedButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pushReplacementNamed(AppRoute.home_tab);
                  },
                  hasIcon: true,
                  iconWidget: Image.asset(AppAssets.googleIcon),
                  text: S.of(context).loginWithGoogle,
                  mainAxisAlignment: MainAxisAlignment.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
