import 'package:flutter/material.dart';
import 'package:movies_app/api/api_manger.dart';
import 'package:movies_app/model/api_Response_model.dart';
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
  bool isLoading = true;
  bool isUpdating = false;
  UserModel? currentUser;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void dispose() {
    userNameController.dispose();
    phoneNumberController.dispose();
    super.dispose();
  }

  // ✅ جلب بيانات اليوزر
 Future<void> _loadUserData() async {
  setState(() => isLoading = true);

  try {
    print("🔹 Fetching profile from API...");
    final response = await ApiManger.getProfile();

    print("🔹 API Response: ${response.toString()}");

    if (response.success && response.data != null) {
      // تأكد أن data من نوع UserModel
      if (response.data is UserModel) {
        currentUser = response.data as UserModel;
        print("✅ Profile loaded from API: $currentUser");

        // حفظ البيانات محليًا
        await ApiManger.saveUserData(currentUser!);
      } else {
        print("❌ API returned data but it's not UserModel: ${response.data.runtimeType}");
      }
    } else {
      print("⚠ API failed, loading local data...");
      currentUser = await ApiManger.getUserData();
      if (currentUser != null) {
        print("✅ Profile loaded from local storage: $currentUser");
      }
    }

    if (currentUser != null) {
      userNameController.text = currentUser!.name ?? "";
      phoneNumberController.text = currentUser!.phone ?? "";

      if (currentUser!.avaterId != null) {
        selectedAvatar = 'assets/images/avatar${currentUser!.avaterId}.png';
      }

      print("🔹 Updated UI controllers with user data");
    } else {
      print("❌ No user data available after all attempts.");
    }
  } catch (e) {
    print("Load User Data Error: $e");
  } finally {
    setState(() => isLoading = false);
  }
}


  // ✅ تحديث البيانات
  Future<void> _updateProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isUpdating = true);

    try {
      // استخراج رقم الـ Avatar
      final avatarMatch = RegExp(r'avatar(\d+)').firstMatch(selectedAvatar);
      final avaterIdString = avatarMatch?.group(1);
      final avaterId =
          avaterIdString != null ? int.parse(avaterIdString) : null;

      final response = await ApiManger.updateProfile(
        name: userNameController.text.trim(),
        phone: phoneNumberController.text.trim(),
        avatar: avaterId?.toString(),
      );

      if (!mounted) return;

      setState(() => isUpdating = false);

      if (response.success && currentUser != null) {
        // حفظ البيانات الجديدة محليًا
        final updatedUser = currentUser!.copyWith(
          name: userNameController.text.trim(),
          phone: phoneNumberController.text.trim(),
          avaterId: avaterId,
        );

        currentUser = updatedUser;
        await ApiManger.saveUserData(updatedUser);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.message ?? "تم تحديث البيانات بنجاح"),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        _showErrorSnackBar(response.message ?? "فشل تحديث البيانات");
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => isUpdating = false);
      _showErrorSnackBar("حدث خطأ: ${e.toString()}");
    }
  }

  // ✅ حذف الحساب
  Future<void> _deleteAccount() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColor.grayColor,
        title: Text("تأكيد الحذف", style: AppStyle.reglur16yellow),
        content: Text(
          "هل أنت متأكد من حذف الحساب؟ هذا الإجراء لا يمكن التراجع عنه.",
          style: AppStyle.reglur14white,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text("إلغاء", style: AppStyle.reglur14white),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text("حذف", style: AppStyle.reglur14yellow),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() => isUpdating = true);

    try {
      final response = await ApiManger.deleteProfile();

      if (!mounted) return;
      setState(() => isUpdating = false);

      if (response.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.message ?? "تم حذف الحساب"),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.of(context).pushNamedAndRemoveUntil(
          AppRoute.loginScreen,
          (route) => false,
        );
      } else {
        _showErrorSnackBar(response.message ?? "فشل حذف الحساب");
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => isUpdating = false);
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

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    if (isLoading) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          centerTitle: true,
          title: Text(
            S.of(context).Pick_Avatar,
            style: AppStyle.reglur16yellow,
          ),
        ),
        body: Center(
          child: CircularProgressIndicator(color: AppColor.yellow),
        ),
      );
    }

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
        child: Form(
          key: _formKey,
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
              SizedBox(height: height * 0.04),
              CustomTextFormField(
                controller: userNameController,
                prefixIcon: Icon(Icons.person),
                iconColor: AppColor.whiteColor,
                validator: (value) =>
                    (value == null || value.trim().isEmpty)
                        ? "يرجى إدخال الاسم"
                        : null,
              ),
              SizedBox(height: height * 0.025),
              CustomTextFormField(
                controller: phoneNumberController,
                prefixIcon: Icon(Icons.phone),
                iconColor: AppColor.whiteColor,
                validator: (value) =>
                    (value == null || value.trim().isEmpty)
                        ? "يرجى إدخال رقم الهاتف"
                        : null,
              ),
              SizedBox(height: height * 0.01),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(AppRoute.resetPassword);
                },
                child: Text(
                  S.of(context).Reset_Password,
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
                      ? "جاري التحديث..."
                      : S.of(context).Update_Data,
                ),
              ),
            ],
          ),
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
              vertical: height * 0.020, horizontal: width * 0.05),
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
                        setState(() => selectedAvatar = avatar);
                        Navigator.pop(context);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColor.yellow.withOpacity(0.5)
                              : Colors.transparent,
                          border: Border.all(color: AppColor.yellow, width: 2),
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
