
class ApiResponse<T> {
  final bool success;
  final String? message;
  final T? data;
  final String? token;

  ApiResponse({
    required this.success,
    this.message,
    this.data,
    this.token,
  });

  // تحويل من JSON إلى Object
  factory ApiResponse.fromJson(
  Map<String, dynamic> json,
  T Function(dynamic)? fromJsonT,
) {
  // إذا كان success غير موجود، اعتبر العملية ناجحة إذا كان هناك data
  bool isSuccess = json['success'] ?? (json['data'] != null);

  return ApiResponse<T>(
    success: isSuccess,
    message: json['message'],
    token: json['token'],
    data: json['data'] != null && fromJsonT != null
        ? fromJsonT(json['data'])
        : json['data'] as T?,
  );
}


  // تحويل من Object إلى JSON
  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'token': token,
      'data': data,
    };
  }

  @override
  String toString() {
    return 'ApiResponse(success: $success, message: $message, data: $data)';
  }
}

// Response للـ Login/Register
class AuthResponse {
  final String? token;

  AuthResponse({this.token});

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      token: json['data'], // ← لأن الـ API يرجع التوكن هنا
    );
  }
}

// Response للـ Movies
class MoviesResponse {
  final int? movieCount;
  final int? limit;
  final int? pageNumber;
  final List<MovieModel>? movies;

  MoviesResponse({
    this.movieCount,
    this.limit,
    this.pageNumber,
    this.movies,
  });

  factory MoviesResponse.fromJson(Map<String, dynamic> json) {
    return MoviesResponse(
      movieCount: json['movie_count'],
      limit: json['limit'],
      pageNumber: json['page_number'],
      movies: json['movies'] != null
          ? MovieModel.fromJsonList(json['movies'])
          : null,
    );
  }
}

// import للـ UserModel و MovieModel

class UserModel {
  final String? id;
  final String? name;
  final String? email;
  final String? phone;
  final int? avaterId;
  final String? createdAt;
  final String? updatedAt;

  UserModel({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.avaterId,
    this.createdAt,
    this.updatedAt,
  });

  // تحويل من JSON إلى Object
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'] ?? json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      avaterId: json['avaterId'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }

  // تحويل من Object إلى JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'avaterId': avaterId,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  // نسخ الـ Object مع تعديل بعض القيم
  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    int? avaterId,
    String? createdAt,
    String? updatedAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      avaterId: avaterId ?? this.avaterId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'UserModel(id: $id, name: $name, email: $email, phone: $phone, avaterId: $avaterId)';
  }
}

class MovieModel {
  final int? id;
  final String? title;
  final int? year;
  final double? rating;
  final List<String>? genres;
  final String? summary;
  final String? mediumCoverImage;

  MovieModel({
    this.id,
    this.title,
    this.year,
    this.rating,
    this.genres,
    this.summary,
    this.mediumCoverImage,
  });

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    return MovieModel(
      id: json['id'],
      title: json['title'],
      year: json['year'],
      rating: json['rating']?.toDouble(),
      genres: json['genres'] != null ? List<String>.from(json['genres']) : null,
      summary: json['summary'],
      mediumCoverImage: json['medium_cover_image'],
    );
  }

  static List<MovieModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => MovieModel.fromJson(json)).toList();
  }
}