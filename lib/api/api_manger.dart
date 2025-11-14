import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:movies_app/auth/forget_password/forget_password.dart';
import 'package:movies_app/model/api_Response_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiManger {
  static const String baseUrl = 'https://route-movie-apis.vercel.app';

  // ===================== LOGIN =====================
  static Future<ApiResponse<AuthResponse>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email,
          "password": password,
        }),
      );

      print("Login Status Code: ${response.statusCode}");
      print("Login Response: ${response.body}");

      final json = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final auth = AuthResponse.fromJson(json);

        // تأكد أن التوكن فعلاً موجود
        if (auth.token != null && auth.token!.isNotEmpty) {
          return ApiResponse(
            success: true,
            message: json["message"] ?? "تم تسجيل الدخول بنجاح",
            data: auth,
          );
        }

        return ApiResponse(
          success: false,
          message: "لم يتم استلام التوكن",
        );
      }

      return ApiResponse(
        success: false,
        message: json["message"] ?? "فشل تسجيل الدخول",
      );
    } catch (e) {
      return ApiResponse(
        success: false,
        message: "حدث خطأ أثناء تسجيل الدخول: $e",
      );
    }
  }
  static Future<UserModel?> getUserData() async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userData = prefs.getString('user_data');
    
    if (userData != null) {
      return UserModel.fromJson(jsonDecode(userData));
    }
    return null;
  } catch (e) {
    print("Get User Data Error: $e");
    return null;
  }
}
static Future<void> saveUserData(UserModel user) async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_data', jsonEncode(user.toJson()));
  } catch (e) {
    print("Save User Data Error: $e");
  }
}
static Future<void> _fetchAndSaveUserProfile(String token) async {
  try {
    final response = await http.get(
      Uri.parse("$baseUrl/profile"),
      headers: {"Authorization": "Bearer $token"},
    );

    print("Fetch User Profile Status: ${response.statusCode}");
    print("Fetch User Profile Response: ${response.body}");

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);

      if (json["status"] == true && json["user"] != null) {
        final user = UserModel.fromJson(json["user"]);
        await saveUserData(user);
        print("User data saved successfully");
      }
    }
  } catch (e) {
    print("Error fetching user profile: $e");
  }
}

  // ===================== REGISTER =====================
  static Future<ApiResponse<AuthResponse>> register({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
    required String phone,
    required String avatar,
  }) async {
    // Validate inputs
    if (name.trim().isEmpty ||
        email.trim().isEmpty ||
        password.isEmpty ||
        phone.trim().isEmpty ||
        avatar.isEmpty) {
      return ApiResponse(success: false, message: "جميع الحقول مطلوبة");
    }

    if (password != confirmPassword) {
      return ApiResponse(success: false, message: "كلمة المرور غير مطابقة");
    }

    if (password.length < 8) {
      return ApiResponse(
        success: false,
        message: "كلمة المرور يجب أن تكون 8 أحرف على الأقل",
      );
    }

    // Check for strong password
    final strongPasswordRegex =
        RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{8,}$');
    if (!strongPasswordRegex.hasMatch(password)) {
      return ApiResponse(
        success: false,
        message: "كلمة المرور يجب أن تحتوي على حرف كبير وحرف صغير ورقم",
      );
    }

    // Format phone number
    String formattedPhone = phone.trim();
    if (formattedPhone.startsWith('0')) {
      formattedPhone = '+2' + formattedPhone;
    } else if (!formattedPhone.startsWith('+')) {
      formattedPhone = '+20' + formattedPhone;
    }

    try {
      final avaterId = int.tryParse(avatar);
      if (avaterId == null) {
        return ApiResponse(
          success: false,
          message: "خطأ في اختيار الصورة الرمزية",
        );
      }

      final requestBody = {
        "name": name.trim(),
        "email": email.trim(),
        "password": password,
        "confirmPassword": confirmPassword,
        "phone": formattedPhone,
        "avaterId": avaterId,
      };

      print("=== REGISTER REQUEST ===");
      print("URL: $baseUrl/auth/register");
      print("Body: ${jsonEncode(requestBody)}");
      print("========================");

      final response = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      print("Register Status Code: ${response.statusCode}");
      print("Register Response: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.body.trim().startsWith('{')) {
          final json = jsonDecode(response.body);

          if (json["message"] != null &&
              json["message"].toString().contains("successfully")) {
            return ApiResponse(
              success: true,
              message: "تم التسجيل بنجاح. يرجى تسجيل الدخول",
              data: null,
            );
          } else if (json["status"] == true) {
            final auth = AuthResponse.fromJson(json);

            if (auth.token != null && auth.token!.isNotEmpty) {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.setString("token", auth.token!);
            }

            return ApiResponse(
              success: true,
              message: json["message"] ?? "تم التسجيل بنجاح",
              data: auth,
            );
          } else {
            return ApiResponse(
              success: false,
              message: json["message"] ?? "فشل التسجيل",
            );
          }
        } else {
          return ApiResponse(
            success: false,
            message: "الخادم لم يرجع استجابة صحيحة",
          );
        }
      } else if (response.statusCode == 409 || response.statusCode == 400) {
        try {
          final json = jsonDecode(response.body);
          String errorMessage = json["message"] ?? "فشل التسجيل";

          if (errorMessage.toLowerCase().contains("already") ||
              errorMessage.toLowerCase().contains("exist")) {
            errorMessage = "البريد الإلكتروني مسجل مسبقاً. يرجى تسجيل الدخول";
          }

          return ApiResponse(
            success: false,
            message: errorMessage,
          );
        } catch (e) {
          return ApiResponse(
            success: false,
            message: "البريد الإلكتروني مسجل مسبقاً",
          );
        }
      } else {
        try {
          final json = jsonDecode(response.body);
          return ApiResponse(
            success: false,
            message: json["message"] ?? "خطأ في الخادم",
          );
        } catch (e) {
          return ApiResponse(
            success: false,
            message: "خطأ في الاتصال بالخادم (${response.statusCode})",
          );
        }
      }
    } catch (e) {
      print("Register Error: $e");

      String errorMessage = "حدث خطأ أثناء التسجيل";

      if (e.toString().contains("SocketException") ||
          e.toString().contains("Failed host lookup")) {
        errorMessage = "تحقق من اتصال الإنترنت";
      } else if (e.toString().contains("TimeoutException")) {
        errorMessage = "انتهت مهلة الاتصال. حاول مرة أخرى";
      }

      return ApiResponse(
        success: false,
        message: errorMessage,
      );
    }
  }

  // ===================== CHECK EMAIL EXISTS =====================
  // ✅ NEW: Function to check if email exists before login
  static Future<ApiResponse<bool>> checkEmailExists(String email) async {
    try {
      if (email.trim().isEmpty) {
        return ApiResponse(
          success: false,
          message: "يرجى إدخال البريد الإلكتروني",
          data: false,
        );
      }

      // Try to get user info - if email doesn't exist, API will return error
      final response = await http.get(
        Uri.parse('$baseUrl/user/check-email?email=${email.trim()}'),
        headers: {'Content-Type': 'application/json'},
      );

      print("Check Email Status: ${response.statusCode}");
      print("Check Email Response: ${response.body}");

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return ApiResponse(
          success: true,
          message: "البريد الإلكتروني موجود",
          data: true,
        );
      } else if (response.statusCode == 404) {
        return ApiResponse(
          success: false,
          message: "البريد الإلكتروني غير مسجل",
          data: false,
        );
      } else {
        return ApiResponse(
          success: false,
          message: "خطأ في التحقق من البريد الإلكتروني",
          data: false,
        );
      }
    } catch (e) {
      print("Check Email Error: $e");
      return ApiResponse(
        success: false,
        message: "حدث خطأ في التحقق",
        data: false,
      );
    }
  }

  // ===================== RESET PASSWORD =====================
  static Future<ApiResponse<void>> ForgetPassword({
    required String email,
    required String newPassword,
  }) async {
    try {
      if (email.trim().isEmpty || newPassword.isEmpty) {
        return ApiResponse(
          success: false,
          message: "البريد الإلكتروني وكلمة المرور الجديدة مطلوبان",
        );
      }

      final response = await http.post(
        Uri.parse('$baseUrl/auth/reset-password'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "email": email.trim(),
          "newPassword": newPassword,
        }),
      );

      print("Reset Password Status: ${response.statusCode}");
      print("Reset Password Response: ${response.body}");

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);

        if (json["status"] == true) {
          return ApiResponse(
            success: true,
            message: json["message"] ?? "تم تغيير كلمة المرور بنجاح",
          );
        } else {
          return ApiResponse(
            success: false,
            message: json["message"] ?? "فشل تغيير كلمة المرور",
          );
        }
      } else if (response.statusCode == 404) {
        return ApiResponse(
          success: false,
          message: "البريد الإلكتروني غير موجود",
        );
      } else {
        return ApiResponse(
          success: false,
          message: "خطأ في الاتصال بالخادم",
        );
      }
    } catch (e) {
      print("Reset Password Error: $e");
      return ApiResponse(
        success: false,
        message: "حدث خطأ: ${e.toString()}",
      );
    }
  }

  static Future<ApiResponse<void>> resetPassword({
  required String oldPassword,
  required String newPassword,
}) async {
  try {
    final token = await getToken();
    if (token == null || token.isEmpty) {
      return ApiResponse(success: false, message: "يرجى تسجيل الدخول أولاً");
    }

    final response = await http.patch(
      Uri.parse('$baseUrl/auth/reset-password'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        "oldPassword": oldPassword,
        "newPassword": newPassword,
      }),
    );

    print("Reset Password Status: ${response.statusCode}");
    print("Reset Password Response: ${response.body}");

    if (response.statusCode == 201) {
      final json = jsonDecode(response.body);
      return ApiResponse(
        success: true,
        message: json["message"] ?? "تم تغيير كلمة المرور بنجاح",
      );
    } else {
      final json = jsonDecode(response.body);
      return ApiResponse(
        success: false,
        message: json["message"] ?? "فشل تغيير كلمة المرور",
      );
    }
  } catch (e) {
    print("Reset Password Error: $e");
    return ApiResponse(
      success: false,
      message: "حدث خطأ: ${e.toString()}",
    );
  }
}

  // ===================== GET PROFILE =====================
  static Future<ApiResponse<UserModel>> getProfile() async {
    try {
      final token = await getToken();
      if (token == null || token.isEmpty) {
        return ApiResponse(success: false, message: "يرجى تسجيل الدخول أولاً");
      }

      final response = await http.get(
        Uri.parse("$baseUrl/profile"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      print("Profile Status Code: ${response.statusCode}");
      print("Profile Response: ${response.body}");

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        return ApiResponse<UserModel>.fromJson(
          jsonResponse,
          (data) => UserModel.fromJson(data),
        );
      } else if (response.statusCode == 401) {
        // إذا انتهت صلاحية الجلسة
        await logout();
        return ApiResponse(success: false, message: "انتهت صلاحية الجلسة");
      } else {
        return ApiResponse(success: false, message: "فشل جلب البيانات");
      }
    } catch (e) {
      return ApiResponse(success: false, message: "حدث خطأ: $e");
    }
  }

  // ===================== UPDATE PROFILE =====================
  static Future<ApiResponse<void>> updateProfile({
  String? name,
  String? email,
  String? phone,
  String? avatar,
}) async {
  try {
    String? token = await getToken();

    if (token == null || token.isEmpty) {
      return ApiResponse(
        success: false,
        message: "يرجى تسجيل الدخول أولاً",
      );
    }

    // تجهيز body حسب المتاح
    Map<String, dynamic> body = {};
    if (email != null) body["email"] = email;
    if (name != null) body["name"] = name;
    if (phone != null) body["phone"] = phone;

    // avatar = رقم فقط لذلك نضيف avaterId
    if (avatar != null) {
      int? id = int.tryParse(avatar);
      if (id != null) body["avaterId"] = id;
    }

    final response = await http.patch(
      Uri.parse("$baseUrl/profile"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode(body),
    );

    print("Update Profile Status: ${response.statusCode}");
    print("Update Profile Response: ${response.body}");

    // ✔ API doesn’t return body, فقط status
    if (response.statusCode == 200) {
      return ApiResponse(
        success: true,
        message: "تم تحديث الملف الشخصي بنجاح",
      );
    } else if (response.statusCode == 401) {
      await logout();
      return ApiResponse(
        success: false,
        message: "انتهت صلاحية الجلسة",
      );
    } else {
      return ApiResponse(
        success: false,
        message: "فشل تحديث الملف الشخصي",
      );
    }
  } catch (e) {
    return ApiResponse(
      success: false,
      message: "حدث خطأ: ${e.toString()}",
    );
  }
}

  // ===================== DELETE PROFILE =====================
  static Future<ApiResponse<void>> deleteProfile() async {
    try {
      String? token = await getToken();

      if (token == null || token.isEmpty) {
        return ApiResponse(
          success: false,
          message: "يرجى تسجيل الدخول أولاً",
        );
      }

      final response = await http.delete(
        Uri.parse("$baseUrl/user"),
        headers: {"Authorization": "Bearer $token"},
      );

      print("Delete Profile Status: ${response.statusCode}");
      print("Delete Profile Response: ${response.body}");

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);

        if (json["status"] == true) {
          await logout();
          return ApiResponse(
            success: true,
            message: json["message"] ?? "تم حذف الحساب",
          );
        } else {
          return ApiResponse(
            success: false,
            message: json["message"] ?? "فشل حذف الحساب",
          );
        }
      } else {
        return ApiResponse(
          success: false,
          message: "خطأ في الاتصال بالخادم",
        );
      }
    } catch (e) {
      print("Delete Profile Error: $e");
      return ApiResponse(
        success: false,
        message: "حدث خطأ: ${e.toString()}",
      );
    }
  }

  // ===================== GET MOVIES =====================
  static Future<ApiResponse<MoviesResponse>> getMovies() async {
    try {
      final response = await http.get(
        Uri.parse('https://yts.mx/api/v2/list_movies.json'),
        headers: {'Accept': 'application/json'},
      );

      print('Movies Status Code: ${response.statusCode}');

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final moviesResponse = MoviesResponse.fromJson(json['data']);

        return ApiResponse(
          success: true,
          message: 'تم تحميل الأفلام بنجاح',
          data: moviesResponse,
        );
      } else {
        return ApiResponse(
          success: false,
          message: 'فشل تحميل الأفلام',
        );
      }
    } catch (e) {
      print('Get Movies Error: $e');
      return ApiResponse(
        success: false,
        message: 'حدث خطأ في الاتصال: ${e.toString()}',
      );
    }
  }

  // ===================== UTILITIES =====================
  static Future<String?> getToken() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getString('token');
    } catch (e) {
      print("Get Token Error: $e");
      return null;
    }
  }

  static Future<void> logout() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.clear();
    } catch (e) {
      print("Logout Error: $e");
    }
  }

  static Future<bool> isLoggedIn() async {
    String? token = await getToken();
    return token != null && token.isNotEmpty;
  }

  static Future<void> saveToken(String token) async {
    try {
      if (token.isNotEmpty) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
      }
    } catch (e) {
      print("Save Token Error: $e");
    }
  }
}
