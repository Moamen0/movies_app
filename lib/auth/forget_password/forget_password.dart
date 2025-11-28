import 'package:flutter/material.dart';
import 'package:movies_app/api/auth_api.dart';
import 'package:movies_app/utils/app_assets.dart';
import 'package:movies_app/utils/app_color.dart';
import 'package:movies_app/utils/app_style.dart';

import '../../generated/l10n.dart';
import '../../utils/custom_elevated_button.dart';
import '../../utils/custom_text_form_field.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool isPasswordObscured = true;
  bool isConfirmPasswordObscured = true;
  bool isLoading = false;
  bool emailVerified =
      false; // للتحقق من البريد أولاً (في حال كان الـ API يدعم ذلك)

  @override
  void dispose() {
    emailController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  // ✅ إعادة تعيين كلمة المرور
  Future<void> _resetPassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
    });

    try {
      final res = await AuthMangerApi.ForgetPassword(
        email: emailController.text.trim(),
        newPassword: newPasswordController.text.trim(),
      );

      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      if (res.success) {
        _showSuccessSnackBar(res.message ?? "تم تغيير كلمة المرور بنجاح");

        // الانتظار ثانيتين ثم الرجوع لصفحة تسجيل الدخول
        Future.delayed(Duration(seconds: 2), () {
          if (mounted) {
            Navigator.pop(context);
          }
        });
      } else {
        _showErrorSnackBar(res.message ?? "فشل تغيير كلمة المرور");
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
      _showErrorSnackBar("حدث خطأ: ${e.toString()}");
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        iconTheme: IconThemeData(color: AppColor.yellow),
        title: Text(
          S.of(context).forgetPassword,
          style: AppStyle.reglur16yellow,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: width * .05),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: height * .02),
                Image.asset(AppAssets.forgetPasswordPhoto),
                SizedBox(height: height * .025),

                SizedBox(height: height * .025),

                // Email Field
                CustomTextFormField(
                  controller: emailController,
                  prefixIcon: Image.asset(AppAssets.emailIcon),
                  hint: S.of(context).email,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "يرجى إدخال البريد الإلكتروني";
                    }
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                        .hasMatch(value)) {
                      return "البريد الإلكتروني غير صحيح";
                    }
                    return null;
                  },
                ),
                SizedBox(height: height * .035),

                SizedBox(
                  width: double.infinity,
                  child: CustomElevatedButton(
                    onPressed: _resetPassword,
                    text: isLoading
                        ? S.of(context).Updating
                        : S.of(context).VerifyEmail,
                  ),
                ),

                SizedBox(height: height * .025),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
