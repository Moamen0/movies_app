import 'package:flutter/material.dart';
import 'package:movies_app/generated/l10n.dart';
import 'package:movies_app/utils/app_assets.dart';
import 'package:movies_app/utils/app_color.dart';
import 'package:movies_app/utils/app_style.dart';
import 'package:movies_app/utils/custom_elevated_button.dart';
import 'package:movies_app/utils/custom_text_form_field.dart';

class ResetPassword extends StatefulWidget {
  ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  TextEditingController currentPasswordController = TextEditingController();

  TextEditingController newPasswordController = TextEditingController();

  TextEditingController confirmNewPasswordController = TextEditingController();

  bool isCurrentPasswordObscured = true;

  bool isPasswordObscured = true;

  bool isConfirmPasswordObscured = true;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppColor.yellow),
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          S.of(context).reset_password,
          style: AppStyle.reglur16yellow,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
            vertical: height * 0.03, horizontal: width * 0.04),
        child: Column(
          children: [
            Image.asset(AppAssets.logo),
            SizedBox(
              height: height * 0.05,
            ),
            CustomTextFormField(
              controller: currentPasswordController,
              prefixIcon: Image.asset(AppAssets.passwordIcon),
              obscureText: isCurrentPasswordObscured,
              hint: S.of(context).Current_Password,
              suffixIcon: GestureDetector(
                onTap: () {
                  setState(() {
                    isCurrentPasswordObscured = !isCurrentPasswordObscured;
                  });
                },
                child: isCurrentPasswordObscured
                    ? Image.asset(AppAssets.eyeoff)
                    : const Icon(Icons.remove_red_eye_outlined,
                        color: Colors.white),
              ),
            ),
            SizedBox(
              height: height * 0.05,
            ),
            CustomTextFormField(
              controller: newPasswordController,
              prefixIcon: Image.asset(AppAssets.passwordIcon),
              obscureText: isPasswordObscured,
              hint: S.of(context).New_Password,
              suffixIcon: GestureDetector(
                onTap: () {
                  setState(() {
                    isPasswordObscured = !isPasswordObscured;
                  });
                },
                child: isPasswordObscured
                    ? Image.asset(AppAssets.eyeoff)
                    : const Icon(Icons.remove_red_eye_outlined,
                        color: Colors.white),
              ),
            ),
            SizedBox(
              height: height * 0.05,
            ),
            CustomTextFormField(
              controller: confirmNewPasswordController,
              prefixIcon: Image.asset(AppAssets.passwordIcon),
              obscureText: isConfirmPasswordObscured,
              hint: S.of(context).Confirm_New_Password,
              suffixIcon: GestureDetector(
                onTap: () {
                  setState(() {
                    isConfirmPasswordObscured = !isConfirmPasswordObscured;
                  });
                },
                child: isConfirmPasswordObscured
                    ? Image.asset(AppAssets.eyeoff)
                    : const Icon(Icons.remove_red_eye_outlined,
                        color: Colors.white),
              ),
            ),
            Spacer(),
            SizedBox(
              width: double.infinity,
              child: CustomElevatedButton(
                  onPressed: () {}, text: S.of(context).reset_password),
            ),
            SizedBox(
              height: height * 0.15,
            ),
          ],
        ),
      ),
    );
  }
}
