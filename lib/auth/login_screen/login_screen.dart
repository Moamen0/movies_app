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
    print("🔐 Starting login...");
    final res = await AuthMangerApi.login(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );

    if (!mounted) return;

    setState(() {
      isLoading = false;
    });

    print("🔐 Login response success: ${res.success}");
    print("🔐 Login response message: ${res.message}");

    if (res.success && res.data != null) {
      final token = res.data!.token;

      if (token != null && token.isNotEmpty) {
        print("✅ Token received: ${token.substring(0, 20)}...");
        
        // Save token
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
        print("✅ Token saved to SharedPreferences");

        // Important: Fetch and save user profile data
        try {
          print("📡 Fetching user profile...");
          final profileResponse = await AuthMangerApi.getProfile();
          
          if (profileResponse.success && profileResponse.data != null) {
            // Save user data to local storage
            await AuthMangerApi.saveUserData(profileResponse.data!);
            print("✅ User profile saved:");
            print("   - Name: ${profileResponse.data!.name}");
            print("   - Email: ${profileResponse.data!.email}");
            print("   - Phone: ${profileResponse.data!.phone}");
            print("   - Avatar ID: ${profileResponse.data!.avaterId}");
          } else {
            print("⚠️ Could not fetch profile, but login successful");
          }
        } catch (e) {
          print("⚠️ Error fetching profile: $e");
          // Continue anyway since login was successful
        }

        // Clear old user data cache
        await prefs.remove('user_data');

        // Show success message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(res.message ?? "Login successful!"),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );

          // Navigate to home
          Navigator.of(context).pushReplacementNamed(AppRoute.homeScreen);
        }
        return;
      }
    }

    _showErrorSnackBar(res.message ?? "Incorrect email or password");

  } catch (e) {
    if (!mounted) return;

    setState(() {
      isLoading = false;
    });

    print("❌ Login error: $e");
    _showErrorSnackBar(e.toString());
  }
}

void _showErrorSnackBar(String message) {
  print("❌ Error: $message");
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
