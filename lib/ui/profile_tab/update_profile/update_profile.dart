import 'package:flutter/material.dart';
import 'package:movies_app/generated/l10n.dart';
import 'package:movies_app/utils/app_assets.dart';
import 'package:movies_app/utils/app_color.dart';
import 'package:movies_app/utils/app_route.dart';
import 'package:movies_app/utils/app_style.dart';
import 'package:movies_app/utils/custom_elevated_button.dart';
import 'package:movies_app/utils/custom_text_form_field.dart';

class UpdateProfile extends StatefulWidget {
  UpdateProfile({super.key});

  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  TextEditingController userNameController =
      TextEditingController(text: "Moamen Abdallah");

  TextEditingController phoneNumberController =
      TextEditingController(text: "01200000000");

  String selectedAvatar = AppAssets.avatar1;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          S.of(context).Pick_Avatar,
          style: AppStyle.reglur16yellow,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
            vertical: height * 0.03, horizontal: width * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: GestureDetector(
                onTap: _showAvatarPicker,
                child: Image.asset(
                  selectedAvatar,
                  width: width * 0.38,
                  height: height * 0.18,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            SizedBox(
              height: height * 0.04,
            ),
            CustomTextFormField(
              controller: userNameController,
              prefixIcon: Icon(Icons.person),
              iconColor: AppColor.whiteColor,
            ),
            SizedBox(
              height: height * 0.025,
            ),
            CustomTextFormField(
              controller: phoneNumberController,
              prefixIcon: Icon(Icons.phone),
              iconColor: AppColor.whiteColor,
            ),
            SizedBox(
              height: height * 0.01,
            ),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(AppRoute.resetPassword);
                },
                child: Text(
                  S.of(context).Reset_Password,
                  style: AppStyle.reglur17white,
                )),
            Spacer(),
            SizedBox(
              width: double.infinity,
              child: CustomElevatedButton(
                backgroundColor: AppColor.red,
                onPressed: () {},
                text: S.of(context).Delete_Account,
                textStyle: AppStyle.reglur20white,
              ),
            ),
            SizedBox(
              height: height * 0.02,
            ),
            SizedBox(
              width: double.infinity,
              child: CustomElevatedButton(
                  onPressed: () {}, text: S.of(context).Update_Data),
            ),
          ],
        ),
      ),
    );
  }

  void _showAvatarPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColor.grayColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        final List<String> avatars = [
          AppAssets.avatar1,
          AppAssets.avatar2,
          AppAssets.avatar3,
          AppAssets.avatar4,
          AppAssets.avatar5,
          AppAssets.avatar6,
          AppAssets.avatar7,
          AppAssets.avatar8,
          AppAssets.avatar9,
        ];
        var height = MediaQuery.of(context).size.height;
        var width = MediaQuery.of(context).size.width;
        return Padding(
          padding: EdgeInsets.symmetric(
              vertical: height * 0.020, horizontal: width * 0.05),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: height * 0.01),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: height * 0.025,
                  crossAxisSpacing: width * 0.04,
                ),
                itemCount: avatars.length,
                itemBuilder: (context, index) {
                  final avatar = avatars[index];
                  final bool isSelected = avatar == selectedAvatar;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedAvatar = avatar;
                      });
                      Navigator.pop(context);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColor.yellow.withOpacity(0.5)
                            : Colors.transparent,
                        border: Border.all(
                          color: AppColor.yellow,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(avatar, fit: BoxFit.cover),
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }
}
