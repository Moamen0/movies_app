import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:movies_app/model/Api_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthMangerApi {
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
            message: json["message"] ?? "login success!",
            data: auth,
          );
        }

        return ApiResponse(
          success: false,
          message: "",
        );
      }

      return ApiResponse(
        success: false,
        message: json["message"] ?? "login field please try again",
      );
    } catch (e) {
      return ApiResponse(
        success: false,
        message: "$e",
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
      return ApiResponse(success: false, message: "all fields are required");
    }

    if (password != confirmPassword) {
      return ApiResponse(success: false, message: "passwords isn't match");
    }

    if (password.length < 8) {
      return ApiResponse(
        success: false,
        message: "password must be at least 8 chars",
      );
    }

    // Check for strong password
    final strongPasswordRegex =
        RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{8,}$');
    if (!strongPasswordRegex.hasMatch(password)) {
      return ApiResponse(
        success: false,
        message:
            "The password must contain at least one lowercase letter, one uppercase letter, and one special character such as @",
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
          message: "error",
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
              message: "register complete please login!",
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
              message: json["message"] ?? "login successfully",
              data: auth,
            );
          } else {
            return ApiResponse(
              success: false,
              message: json["message"] ?? "login failed",
            );
          }
        } else {
          return ApiResponse(
            success: false,
            message: "server didn't answer",
          );
        }
      } else if (response.statusCode == 409 || response.statusCode == 400) {
        try {
          final json = jsonDecode(response.body);
          String errorMessage = json["message"] ?? "login field";

          if (errorMessage.toLowerCase().contains("already") ||
              errorMessage.toLowerCase().contains("exist")) {
            errorMessage = "emailAdress already Exist please login!";
          }

          return ApiResponse(
            success: false,
            message: errorMessage,
          );
        } catch (e) {
          return ApiResponse(
            success: false,
            message:
                "The password must contain at least one lowercase letter, one uppercase letter, and one special character such as @",
          );
        }
      } else {
        try {
          final json = jsonDecode(response.body);
          return ApiResponse(
            success: false,
            message: json["message"] ?? "network error",
          );
        } catch (e) {
          return ApiResponse(
            success: false,
            message: "${response.statusCode})",
          );
        }
      }
    } catch (e) {
      print("Register Error: $e");

      String errorMessage = "error while processing";

      if (e.toString().contains("SocketException") ||
          e.toString().contains("Failed host lookup")) {
        errorMessage = "check your network connection";
      } else if (e.toString().contains("TimeoutException")) {
        errorMessage = "please try again";
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
          message: "please enter you emailAddress",
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
          message: "emailAdress Exist",
          data: true,
        );
      } else if (response.statusCode == 404) {
        return ApiResponse(
          success: false,
          message: "emailAdress Not Found",
          data: false,
        );
      } else {
        return ApiResponse(
          success: false,
          message: "error while checking on emailAddress",
          data: false,
        );
      }
    } catch (e) {
      print("Check Email Error: $e");
      return ApiResponse(
        success: false,
        message: "unExpected error happend try again",
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
          message: "emailAdress and password are required",
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
            message: json["message"] ?? "password Changed successfully",
          );
        } else {
          return ApiResponse(
            success: false,
            message: json["message"] ?? "update password failed",
          );
        }
      } else if (response.statusCode == 404) {
        return ApiResponse(
          success: false,
          message: "emailAdress not Found",
        );
      } else {
        return ApiResponse(
          success: false,
          message: "error while connecting to network",
        );
      }
    } catch (e) {
      print("Reset Password Error: $e");
      return ApiResponse(
        success: false,
        message: e.toString(),
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
        return ApiResponse(success: false, message: "please login first");
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
          message: json["message"] ?? "password Changed successfully",
        );
    } else {
      final json = jsonDecode(response.body);
      return ApiResponse(
        success: false,
          message: json["message"] ?? "couldn't update password",
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
        return ApiResponse(success: false, message: "please login first");
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
        return ApiResponse(success: false, message: "session ended");
      } else {
        return ApiResponse(success: false, message: "failed get the data");
      }
    } catch (e) {
      return ApiResponse(success: false, message: "$e");
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
          message: "please Login first!",
        );
    }

    Map<String, dynamic> body = {};
    if (email != null) body["email"] = email;
    if (name != null) body["name"] = name;
    if (phone != null) body["phone"] = phone;

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
          message: "profile updated successfully",
        );
    } else if (response.statusCode == 401) {
      await logout();
      return ApiResponse(
        success: false,
          message: "session ended",
        );
    } else {
      return ApiResponse(
        success: false,
          message: "failed update profile",
        );
    }
  } catch (e) {
    return ApiResponse(
      success: false,
        message: e.toString(),
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
          message: "please login first",
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
            message: json["message"] ?? "account deleted",
          );
        } else {
          return ApiResponse(
            success: false,
            message: json["message"] ?? "failed deleting the account",
          );
        }
      } else {
        return ApiResponse(
          success: false,
          message: "connection error",
        );
      }
    } catch (e) {
      print("Delete Profile Error: $e");
      return ApiResponse(
        success: false,
        message: "${e.toString()}",
      );
    }
  }

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
          message: '',
          data: moviesResponse,
        );
      } else {
        return ApiResponse(
          success: false,
          message: 'error loading movies',
        );
      }
    } catch (e) {
      print('Get Movies Error: $e');
      return ApiResponse(
        success: false,
        message: e.toString(),
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
