import 'package:flutter/material.dart';
import 'package:movies_app/api/api_manger.dart';
import 'package:movies_app/generated/l10n.dart';
import 'package:movies_app/utils/app_assets.dart';
import 'package:movies_app/utils/app_color.dart';
import 'package:movies_app/utils/app_style.dart';
import 'package:movies_app/utils/custom_elevated_button.dart';
import 'package:movies_app/utils/custom_text_form_field.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController currentPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmNewPasswordController = TextEditingController();

  bool isCurrentPasswordObscured = true;
  bool isPasswordObscured = true;
  bool isConfirmPasswordObscured = true;
  bool isLoading = false;

  @override
  void dispose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmNewPasswordController.dispose();
    super.dispose();
  }

  // ✅ تغيير كلمة المرور
  Future<void> _resetPassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
    });

    try {
      // استدعاء API لتغيير كلمة المرور مع oldPassword و newPassword
      final res = await ApiManger.resetPassword(
        oldPassword: currentPasswordController.text.trim(),
        newPassword: newPasswordController.text.trim(),
      );

      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      if (res.success) {
        _showSuccessSnackBar(res.message ?? "تم تغيير كلمة المرور بنجاح");

        // مسح الحقول
        currentPasswordController.clear();
        newPasswordController.clear();
        confirmNewPasswordController.clear();

        // الرجوع للصفحة السابقة بعد ثانيتين
        Future.delayed(const Duration(seconds: 2), () {
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
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.yellow),
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          S.of(context).reset_password,
          style: AppStyle.reglur16yellow,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          vertical: height * 0.03,
          horizontal: width * 0.04,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Image.asset(AppAssets.logo),
              SizedBox(height: height * 0.05),

              // Current Password
              CustomTextFormField(
                controller: currentPasswordController,
                prefixIcon: Image.asset(AppAssets.passwordIcon),
                obscureText: isCurrentPasswordObscured,
                hint: S.of(context).Current_Password,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "يرجى إدخال كلمة المرور الحالية";
                  }
                  return null;
                },
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
              SizedBox(height: height * 0.05),

              // New Password
              CustomTextFormField(
                controller: newPasswordController,
                prefixIcon: Image.asset(AppAssets.passwordIcon),
                obscureText: isPasswordObscured,
                hint: S.of(context).New_Password,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "يرجى إدخال كلمة المرور الجديدة";
                  }
                  if (value.length < 8) {
                    return "كلمة المرور يجب أن تكون 8 أحرف على الأقل";
                  }
                  final strongPasswordRegex =
                      RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{8,}$');
                  if (!strongPasswordRegex.hasMatch(value)) {
                    return "يجب أن تحتوي على حرف كبير وصغير ورقم";
                  }
                  if (value == currentPasswordController.text) {
                    return "كلمة المرور الجديدة يجب أن تختلف عن القديمة";
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
              SizedBox(height: height * 0.05),

              CustomTextFormField(
                controller: confirmNewPasswordController,
                prefixIcon: Image.asset(AppAssets.passwordIcon),
                obscureText: isConfirmPasswordObscured,
                hint: S.of(context).Confirm_New_Password,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "يرجى تأكيد كلمة المرور الجديدة";
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

              const Spacer(),

              // Reset Password Button
              SizedBox(
                width: double.infinity,
                child: CustomElevatedButton(
                  onPressed: _resetPassword,
                  text: isLoading
                      ? "جاري التغيير..."
                      : S.of(context).reset_password,
                ),
              ),
              SizedBox(height: height * 0.15),
            ],
          ),
        ),
      ),
    );
  }
}
