// lib/screens/update_profile.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/api/auth_api.dart';
import 'package:movies_app/bloc/profile/profile_bloc.dart';
import 'package:movies_app/bloc/profile/profile_event.dart';
import 'package:movies_app/bloc/profile/profile_state.dart';
import 'package:movies_app/generated/l10n.dart';
import 'package:movies_app/utils/app_assets.dart';
import 'package:movies_app/utils/app_color.dart';
import 'package:movies_app/utils/app_route.dart';
import 'package:movies_app/utils/app_style.dart';
import 'package:movies_app/utils/custom_elevated_button.dart';
import 'package:movies_app/utils/custom_text_form_field.dart';

class UpdateProfile extends StatefulWidget {
  const UpdateProfile({super.key});

  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController userNameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();

  String selectedAvatar = AppAssets.avatar1;
  int? selectedAvaterId;

  @override
  void initState() {
    super.initState();
    // Load profile data when screen is initialized
    context.read<ProfileBloc>().add(LoadProfileEvent());
  }

  @override
  void dispose() {
    userNameController.dispose();
    phoneNumberController.dispose();
    super.dispose();
  }

  void _initializeControllers(dynamic user, String avatarPath) {
    if (userNameController.text.isEmpty) {
      userNameController.text = user?.name ?? "";
      phoneNumberController.text = user?.phone ?? "";
      selectedAvatar = avatarPath;
      selectedAvaterId = user?.avaterId;
    }
  }

  Future<void> _updateProfile() async {
    if (!_formKey.currentState!.validate()) return;

    context.read<ProfileBloc>().add(
          UpdateProfileEvent(
            name: userNameController.text.trim(),
            phone: phoneNumberController.text.trim(),
            avatar: selectedAvaterId?.toString(),
          ),
        );
  }

  Future<void> _deleteAccount() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColor.grayColor,
        title:
            Text(S.of(context).Delete_Account, style: AppStyle.reglur16yellow),
        content: Text(
          "Are you sure you want to delete your account? This action cannot be undone.",
          style: AppStyle.reglur14white,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(S.of(context).back, style: AppStyle.reglur14white),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(S.of(context).Delete_Account,
                style: AppStyle.reglur14yellow),
          ),
        ],
      ),
    );

    if (confirm == true) {
      context.read<ProfileBloc>().add(DeleteProfileEvent());
    }
  }

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
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileUpdateSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 1),
              ),
            );
            // Navigate back to profile tab after successful update
            Future.delayed(const Duration(milliseconds: 1500), () {
              if (mounted) {
                Navigator.of(context).pop();
              }
            });
          } else if (state is ProfileError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 3),
              ),
            );
          } else if (state is ProfileDeleted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(S.of(context).Delete_Account),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.of(context).pushNamedAndRemoveUntil(
              AppRoute.loginScreen,
              (route) => false,
            );
          }
        },
        builder: (context, state) {
          if (state is ProfileLoading) {
            return Center(
              child: CircularProgressIndicator(color: AppColor.yellow),
            );
          }

          if (state is ProfileLoaded ||
              state is ProfileUpdating ||
              state is ProfileUpdateSuccess ||
              state is ProfileError) {
            final user = state is ProfileLoaded
                ? state.user
                : state is ProfileUpdating
                    ? state.currentUser
                    : state is ProfileUpdateSuccess
                        ? state.user
                        : (state as ProfileError).user;

            final avatarPath = state is ProfileLoaded
                ? state.avatarPath
                : state is ProfileUpdating
                    ? state.currentAvatarPath
                    : state is ProfileUpdateSuccess
                        ? state.avatarPath
                        : (state as ProfileError).avatarPath ??
                            AppAssets.avatar1;

            final isUpdating = state is ProfileUpdating;

            // Initialize controllers with user data
            _initializeControllers(user, avatarPath);

            return Padding(
              padding: EdgeInsets.symmetric(
                vertical: height * 0.03,
                horizontal: width * 0.04,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: GestureDetector(
                        onTap: isUpdating
                            ? null
                            : () => _showAvatarPicker(avatarPath),
                        child: Image.asset(
                          selectedAvatar,
                          width: width * 0.38,
                          height: height * 0.18,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.04),
                    CustomTextFormField(
                      controller: userNameController,
                      prefixIcon: Icon(Icons.person),
                      iconColor: AppColor.whiteColor,
                      enabled: !isUpdating,
                      validator: (value) =>
                          (value == null || value.trim().isEmpty)
                              ? S.of(context).name
                              : null,
                    ),
                    SizedBox(height: height * 0.025),
                    CustomTextFormField(
                      controller: phoneNumberController,
                      prefixIcon: Icon(Icons.phone),
                      iconColor: AppColor.whiteColor,
                      enabled: !isUpdating,
                      validator: (value) =>
                          (value == null || value.trim().isEmpty)
                              ? S.of(context).phoneNumber
                              : null,
                    ),
                    SizedBox(height: height * 0.01),
                    TextButton(
                      onPressed: isUpdating
                          ? null
                          : () {
                              Navigator.of(context)
                                  .pushNamed(AppRoute.resetPassword);
                            },
                      child: Text(
                        S.of(context).reset_password,
                        style: AppStyle.reglur17white,
                      ),
                    ),
                    Spacer(),
                    SizedBox(
                      width: double.infinity,
                      child: CustomElevatedButton(
                        backgroundColor: AppColor.red,
                        onPressed: _deleteAccount,
                        text: S.of(context).Delete_Account,
                        textStyle: AppStyle.reglur20white,
                      ),
                    ),
                    SizedBox(height: height * 0.02),
                    SizedBox(
                      width: double.infinity,
                      child: CustomElevatedButton(
                        onPressed: _updateProfile,
                        text: isUpdating
                            ? "Updating..."
                            : S.of(context).Update_Data,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return Center(
            child: CircularProgressIndicator(color: AppColor.yellow),
          );
        },
      ),
    );
  }

  void _showAvatarPicker(String currentAvatarPath) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColor.grayColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        final avatars = [
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
            vertical: height * 0.020,
            horizontal: width * 0.05,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
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
                    final isSelected = avatar == selectedAvatar;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedAvatar = avatar;
                          // Extract avatar ID from path
                          final avatarMatch =
                              RegExp(r'avatar(\d+)').firstMatch(avatar);
                          selectedAvaterId = avatarMatch != null
                              ? int.parse(avatarMatch.group(1)!)
                              : null;
                        });

                        // Update avatar in BLoC immediately for live preview
                        if (selectedAvaterId != null) {
                          context.read<ProfileBloc>().add(
                                UpdateAvatarEvent(
                                  avatarPath: avatar,
                                  avaterId: selectedAvaterId!,
                                ),
                              );
                        }

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
          ),
        );
      },
    );
  }
}
