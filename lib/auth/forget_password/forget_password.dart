import 'package:flutter/material.dart';
import 'package:movies_app/api/api_manger.dart';
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
  final TextEditingController confirmPasswordController = TextEditingController();

  bool isPasswordObscured = true;
  bool isConfirmPasswordObscured = true;
  bool isLoading = false;
  bool emailVerified = false; // للتحقق من البريد أولاً (في حال كان الـ API يدعم ذلك)

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
      final res = await ApiManger.ForgetPassword(
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
                
                Text(
                  "أدخل بريدك الإلكتروني وكلمة المرور الجديدة",
                  style: AppStyle.reglur14white,
                  textAlign: TextAlign.center,
                ),
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
                SizedBox(height: height * .025),
                
                // New Password Field
                CustomTextFormField(
                  controller: newPasswordController,
                  prefixIcon: Image.asset(AppAssets.passwordIcon),
                  obscureText: isPasswordObscured,
                  hint: "كلمة المرور الجديدة",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "يرجى إدخال كلمة المرور الجديدة";
                    }
                    if (value.length < 8) {
                      return "كلمة المرور يجب أن تكون 8 أحرف على الأقل";
                    }
                    // Strong password validation
                    final strongPasswordRegex = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{8,}$');
                    if (!strongPasswordRegex.hasMatch(value)) {
                      return "يجب أن تحتوي على حرف كبير وصغير ورقم";
                    }
                    return null;
                  },
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
                SizedBox(height: height * .025),
                
                // Confirm Password Field
                CustomTextFormField(
                  controller: confirmPasswordController,
                  prefixIcon: Image.asset(AppAssets.passwordIcon),
                  obscureText: isConfirmPasswordObscured,
                  hint: "تأكيد كلمة المرور الجديدة",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "يرجى تأكيد كلمة المرور";
                    }
                    if (value != newPasswordController.text) {
                      return "كلمة المرور غير مطابقة";
                    }
                    return null;
                  },
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
                SizedBox(height: height * .035),
                
                // Reset Password Button
                SizedBox(
                  width: double.infinity,
                  child: CustomElevatedButton(
                    onPressed:  _resetPassword,
                    text: isLoading ? "جاري التغيير..." : "تغيير كلمة المرور",
                  ),
                ),
                
                SizedBox(height: height * .025),
                
                // Back to Login
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "العودة لتسجيل الدخول",
                    style: AppStyle.reglur14yellow,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}