import 'package:flutter/material.dart';
import 'package:movies_app/utils/app_assets.dart';

import '../../generated/l10n.dart';
import '../../utils/custom_elevated_button.dart';
import '../../utils/custom_text_form_field.dart';

class ForgetPassword extends StatelessWidget {
  final TextEditingController? emailController = TextEditingController();

  ForgetPassword({super.key});

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).forgetPassword),
      ),
      body: Column(
        children: [
          Image.asset(AppAssets.forgetPasswordPhoto),
          SizedBox(
            height: height * .025,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: width * .05),
            child: CustomTextFormField(
              controller: emailController,
              prefixIcon: Image.asset(AppAssets.emailIcon),
              hint: S.of(context).email,
            ),
          ),
          SizedBox(
            height: height * .025,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: width * .05),
            child: SizedBox(
              width: double.infinity,
              child: CustomElevatedButton(
                  onPressed: () {
                    Future.delayed(Duration(milliseconds: 500), () {
                      Navigator.pop(context);
                    });
                  },
                  text: S.of(context).VerifyEmail),
            ),
          ),
        ],
      ),
    );
  }
}
