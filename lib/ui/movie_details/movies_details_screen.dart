import 'package:flutter/material.dart';
import 'package:movies_app/api/api_manger.dart';
import 'package:movies_app/model/Api_movie_deatils.dart';
import 'package:movies_app/ui/movie_details/widgets/cast_card.dart';
import 'package:movies_app/ui/movie_details/widgets/genres_list.dart';
import 'package:movies_app/ui/movie_details/widgets/screenshots_list.dart';
import 'package:movies_app/ui/movie_details/widgets/similar_item.dart';
import 'package:movies_app/ui/movie_details/widgets/stat_box.dart';
import 'package:movies_app/utils/app_color.dart';
import 'package:movies_app/utils/app_route.dart';
import 'package:movies_app/utils/app_style.dart';
import 'package:cached_network_image/cached_network_image.dart';

class MovieDetailsScreen extends StatelessWidget {
  final int movieId;

  MovieDetailsScreen({super.key, required this.movieId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<MovieModel>(
        future: ApiManager.getMovieDetails(movieId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No data'));
          } else {
            final movie = snapshot.data!;
            return MovieDetailsContent(movie: movie);
          }
        },
      ),
    );
  }
}

class MovieDetailsContent extends StatelessWidget {
  final MovieModel movie;

  const MovieDetailsContent({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              CachedNetworkImage(
                imageUrl: movie.largeCoverImage ?? "",
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.8,
                fit: BoxFit.cover,
                placeholder: (_, __) =>
                    const Center(child: CircularProgressIndicator()),
                errorWidget: (_, __, ___) => const Icon(Icons.error),
              ),
              Positioned(
                top: 40,
                left: 16,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                  child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, AppRoute.homeScreen);
                      },
                      child: Icon(Icons.arrow_back_ios, color: Colors.white)),
                ),
              ),
              Positioned(
                top: 40,
                right: 16,
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: const BoxDecoration(
                    color: Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.bookmark_border, color: Colors.white),
                ),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height * 0.33,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppColor.yellow,
                      shape: BoxShape.circle,
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColor.whiteColor,
                        shape: BoxShape.circle,
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppColor.yellow,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.play_arrow_rounded,
                          color: AppColor.whiteColor,
                          size: 40,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(movie.title ?? '', style: AppStyle.roboto24BoldWhite),
                const SizedBox(height: 8),
                Text('${movie.year ?? ""}', style: AppStyle.roboto20BoldGray),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: Text('Watch', style: AppStyle.roboto20BoldWhite),
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    StatBox(
                      icon: Icons.star,
                      text: movie.rating?.toString() ?? "-",
                      color: AppColor.yellow,
                    ),
                    StatBox(
                      icon: Icons.favorite,
                      text: movie.likeCount?.toString() ?? "0",
                      color: Colors.red,
                    ),
                    StatBox(
                      icon: Icons.remove_red_eye,
                      text: movie.mpaRating?.toString() ?? "0",
                      color: Colors.blue,
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Screenshots
                Align(
                  alignment: Alignment.centerLeft,
                  child:
                      Text('Screen Shots', style: AppStyle.roboto24BoldWhite),
                ),
                const SizedBox(height: 8),
                ScreenshotsColumn(images: movie.mediumScreenshots ?? []),
                const SizedBox(height: 20),

                // Similar movies
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Similar', style: AppStyle.roboto24BoldWhite),
                ),
                const SizedBox(height: 5),
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 5,
                  childAspectRatio: 2 / 3,
                  children: const [
                    SimilarItem(
                        imagePath: 'assets/images/similar1.png', rating: '7.9'),
                    SimilarItem(
                        imagePath: 'assets/images/similar2.png', rating: '8.2'),
                    SimilarItem(
                        imagePath: 'assets/images/similar3.png', rating: '6.8'),
                    SimilarItem(
                        imagePath: 'assets/images/similar4.png', rating: '9.1'),
                  ],
                ),
                const SizedBox(height: 10),

                // Summary
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Summary', style: AppStyle.roboto24BoldWhite),
                ),
                const SizedBox(height: 8),
                Text(movie.descriptionFull ?? "",
                    style: AppStyle.roboto16RegularWhite),
                const SizedBox(height: 20),

                // Cast
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Cast', style: AppStyle.roboto24BoldWhite),
                ),
                const SizedBox(height: 8),
                Column(
                  children: movie.cast?.map((actor) {
                        return CastCard(
                          image: actor.urlSmallImage ?? "",
                          name: actor.name ?? "",
                          character: actor.characterName ?? "",
                        );
                      }).toList() ??
                      [],
                ),
                const SizedBox(height: 20),

                // Genres
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Genres', style: AppStyle.roboto24BoldWhite),
                ),
                const SizedBox(height: 10),
                GenresList(genres: movie.genres ?? []),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
