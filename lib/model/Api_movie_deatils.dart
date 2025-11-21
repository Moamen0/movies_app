class MovieModel {
  final int? id;
  final String? title;
  final int? year;
  final double? rating;
  final List<String>? genres;
  final String? summary;
  final String? mediumCoverImage;

  final List<ActorModel>? cast;
  final List<String>? screenshots;
  final List<TorrentModel>? torrents;

  MovieModel({
    this.id,
    this.title,
    this.year,
    this.rating,
    this.genres,
    this.summary,
    this.mediumCoverImage,
    this.cast,
    this.screenshots,
    this.torrents,
  });

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    return MovieModel(
      id: json['id'],
      title: json['title'],
      year: json['year'],
      rating: json['rating']?.toDouble(),
      genres: json['genres'] != null ? List<String>.from(json['genres']) : null,
      summary: json['description_full'], // أو description_intro لو تحب
      mediumCoverImage: json['medium_cover_image'],

      // Cast
      cast: json['cast'] != null
          ? (json['cast'] as List).map((e) => ActorModel.fromJson(e)).toList()
          : null,

      // Screenshots
      screenshots: [
        if (json['large_screenshot_image1'] != null)
          json['large_screenshot_image1'],
        if (json['large_screenshot_image2'] != null)
          json['large_screenshot_image2'],
        if (json['large_screenshot_image3'] != null)
          json['large_screenshot_image3'],
      ],

      // Torrents
      torrents: json['torrents'] != null
          ? (json['torrents'] as List)
              .map((e) => TorrentModel.fromJson(e))
              .toList()
          : null,
    );
  }
}

// موديل للممثلين
class ActorModel {
  final String? name;
  final String? characterName;
  final String? urlSmallImage;

  ActorModel({this.name, this.characterName, this.urlSmallImage});

  factory ActorModel.fromJson(Map<String, dynamic> json) {
    return ActorModel(
      name: json['name'],
      characterName: json['character_name'],
      urlSmallImage: json['url_small_image'],
    );
  }
}

// موديل للتورنت
class TorrentModel {
  final String? url;
  final String? hash;
  final String? quality;
  final String? type;
  final String? size;

  TorrentModel({this.url, this.hash, this.quality, this.type, this.size});

  factory TorrentModel.fromJson(Map<String, dynamic> json) {
    return TorrentModel(
      url: json['url'],
      hash: json['hash'],
      quality: json['quality'],
      type: json['type'],
      size: json['size'],
    );
  }
}
