import 'package:flutter/material.dart';
import 'package:movies_app/utils/app_color.dart';
import 'package:movies_app/utils/app_style.dart';
import 'package:movies_app/utils/custom_text_form_field.dart';

import '../../animated_toggle_switch/animated_toggle_switch.dart';
import '../../generated/l10n.dart';
import '../../utils/app_assets.dart';
import '../../utils/custom_elevated_button.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController? emailController = TextEditingController();
  TextEditingController? passwordController = TextEditingController();
  TextEditingController? nameController = TextEditingController();
  TextEditingController? phoneController = TextEditingController();
  TextEditingController? confirmPasswordController = TextEditingController();

  int selectedAvatar = 1;
  bool isCensored = true;
  late PageController avatarController;

  @override
  void initState() {
    super.initState();
    avatarController =
        PageController(viewportFraction: 0.32, initialPage: selectedAvatar);
  }

  @override
  void dispose() {
    avatarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.blackColor,
        title: Text(
          S.of(context).register,
          style: AppStyle.reglur16yellow,
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: AppColor.yellow),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.04),
          child: Column(
            children: [
              SizedBox(height: height * 0.01),
              SizedBox(
                height: 160,
                child: PageView.builder(
                  controller: avatarController,
                  itemCount: 9,
                  onPageChanged: (index) {
                    setState(() {
                      selectedAvatar = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    final bool isSelected = selectedAvatar == index;
                    return Center(
                      child: GestureDetector(
                        onTap: () {
                          avatarController.animateToPage(
                            index,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                          setState(() {
                            selectedAvatar = index;
                          });
                        },
                        child: AnimatedScale(
                          scale: isSelected ? 1.25 : 1.0,
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.easeInOut,
                          child: Container(
                            width: isSelected ? 110 : 80,
                            height: isSelected ? 110 : 80,
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: ClipOval(
                              child: Image.asset(
                                'assets/images/avatar${index + 1}.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: height * 0.01),
              Text(
                S.of(context).Avatar,
                style: AppStyle.reglur16white,
              ),
              SizedBox(height: height * 0.02),
              CustomTextFormField(
                controller: nameController,
                prefixIcon: Image.asset(AppAssets.nameIcon),
                hint: S.of(context).name,
              ),
              SizedBox(height: height * .024),
              CustomTextFormField(
                controller: emailController,
                prefixIcon: Image.asset(AppAssets.emailIcon),
                hint: S.of(context).email,
              ),
              SizedBox(height: height * .024),
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
                ),
              ),
              SizedBox(height: height * .024),
              CustomTextFormField(
                controller: confirmPasswordController,
                prefixIcon: Image.asset(AppAssets.passwordIcon),
                obscureText: isCensored,
                hint: S.of(context).confirmPassword,
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
                ),
              ),
              SizedBox(height: height * .024),
              CustomTextFormField(
                controller: phoneController,
                prefixIcon: Image.asset(AppAssets.phoneIcon),
                hint: S.of(context).phoneNumber,
              ),
              SizedBox(height: height * .024),
              SizedBox(
                width: double.infinity,
                child: CustomElevatedButton(
                  onPressed: () {},
                  text: S.of(context).Create_Account,
                ),
              ),
              SizedBox(height: height * 0.01),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    S.of(context).alreadyHaveAccount,
                    style: AppStyle.reglur14white,
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      S.of(context).login,
                      style: AppStyle.reglur14yellow,
                    ),
                  ),
                ],
              ),
              const LanguageToggle(),
            ],
          ),
        ),
      ),
    );
  }
}
