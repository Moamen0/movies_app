import 'package:flutter/material.dart';
import 'package:movies_app/generated/l10n.dart';
import 'package:movies_app/utils/app_assets.dart';
import 'package:movies_app/utils/app_color.dart';
import 'package:movies_app/utils/app_style.dart';
import 'package:movies_app/utils/custom_elevated_button.dart';
import 'package:movies_app/utils/custom_text_form_field.dart';

class ResetPassword extends StatelessWidget {
  ResetPassword({super.key});

  TextEditingController currentPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmNewPasswordController = TextEditingController();

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
              labelStyle: AppStyle.reglur17white,
              controller: currentPasswordController,
              label: S.of(context).Current_Password,
            ),
            SizedBox(
              height: height * 0.05,
            ),
            CustomTextFormField(
              controller: newPasswordController,
              label: S.of(context).New_Password,
              labelStyle: AppStyle.reglur17white,
            ),
            SizedBox(
              height: height * 0.05,
            ),
            CustomTextFormField(
              controller: confirmNewPasswordController,
              label: S.of(context).Current_Password,
              labelStyle: AppStyle.reglur17white,
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
