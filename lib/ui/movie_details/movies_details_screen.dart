import 'package:flutter/material.dart';
import 'package:movies_app/ui/movie_details/widgets/cast_card.dart';
import 'package:movies_app/ui/movie_details/widgets/genres_list.dart';
import 'package:movies_app/ui/movie_details/widgets/screenshots_list.dart';
import 'package:movies_app/ui/movie_details/widgets/similar_item.dart';
import 'package:movies_app/ui/movie_details/widgets/stat_box.dart';
import 'package:movies_app/utils/app_color.dart';
import 'package:movies_app/utils/app_style.dart';


class MovieDetailsScreen extends StatelessWidget {
  const MovieDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Image.asset(
                        'assets/images/poster.png',
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height * 0.8,
                        fit: BoxFit.cover,
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
                          child: const Icon(Icons.arrow_back_ios, color: Colors.white),
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
                            padding: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: AppColor.yellow,
                              shape: BoxShape.circle,
                            ),
                            child: Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: AppColor.whiteColor,
                                shape: BoxShape.circle,
                              ),
                              child: Container(
                                padding: EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: AppColor.yellow,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.play_arrow_rounded,
                                  color: AppColor.whiteColor,
                                  size: 40,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),


                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 600),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(height: 4),

                            RichText(
                              textAlign: TextAlign.center,
                              text:  TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Doctor Strange in the Multiverse\n of Madness',
                                    style:AppStyle.roboto24BoldWhite
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 8),
                             Text(
                              '2022',
                              style: AppStyle.roboto20BoldGray ,

                            ),

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
                                child:  Text(
                                  'Watch',
                                  style:AppStyle.roboto20BoldWhite
                                ),
                              ),
                            ),

                            const SizedBox(height: 14),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                StatBox(icon: Icons.favorite, text: '15', color: AppColor.yellow),
                                StatBox(icon: Icons.watch_later, text: '90', color: AppColor.yellow),
                                StatBox(icon: Icons.star, text: '7.6', color: AppColor.yellow),
                              ],
                            ),

                            const SizedBox(height: 20),

                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Screen Shots',
                                style: AppStyle.roboto24BoldWhite
                              ),
                            ),
                            const SizedBox(height: 8),

                            ScreenshotsColumn(
                              images: [
                                'assets/images/shot1.png',
                                'assets/images/shot2.png',
                                'assets/images/shot3.png',
                              ],
                            ),

                            const SizedBox(height: 20),

                             Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Similar',
                                style: AppStyle.roboto24BoldWhite
                              ),
                            ),
                            const SizedBox(height: 5),

                            GridView.count(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              crossAxisCount: 2,
                              crossAxisSpacing: 12,
                              mainAxisSpacing:5 ,
                              childAspectRatio: 2 / 3,
                              children: const [
                                SimilarItem(imagePath: 'assets/images/similar1.png', rating: '7.9'),
                                SimilarItem(imagePath: 'assets/images/similar2.png', rating: '8.2'),
                                SimilarItem(imagePath: 'assets/images/similar3.png', rating: '6.8'),
                                SimilarItem(imagePath: 'assets/images/similar4.png', rating: '9.1'),
                              ],
                            ),

                            const SizedBox(height: 10),

                             Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Summary',
                                style: AppStyle.roboto24BoldWhite
                              ),
                            ),
                            const SizedBox(height: 8),

                             Text(
                              'Following the events of "Avengers: Endgame," Doctor Strange embarks on a new adventure in the Multiverse with unpredictable consequences. Strange teams up with old and new allies to confront a mysterious threat, changing the fabric of reality forever.',
                              style: AppStyle.roboto16RegularWhite
                            ),

                            const SizedBox(height: 20),

                             Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Cast',
                                style:AppStyle.roboto24BoldWhite
                              ),
                            ),
                            const SizedBox(height: 8),

                            Column(
                              children: const [
                                CastCard(
                                  image: "assets/images/cast1.png",
                                  name: "Hayley Atwell",
                                  character: "Captain Carter",
                                ),
                                CastCard(
                                  image: "assets/images/cast2.png",
                                  name: "Elizabeth Olsen",
                                  character: "Scarlet Witch",
                                ),
                                CastCard(
                                  image: "assets/images/cast3.png",
                                  name: "Rachel McAdams",
                                  character: "Christine Palmer",
                                ),
                                CastCard(
                                  image: "assets/images/cast4.png",
                                  name: "Charlize Theron",
                                  character: "Clea",
                                ),
                              ],
                            ),

                            const SizedBox(height: 20),

                             Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Genres',
                                style: AppStyle.roboto24BoldWhite
                              ),
                            ),
                            const SizedBox(height: 10),

                            GenresList(
                              genres: [
                                'Action',
                                'Sci-Fi',
                                'Adventure',
                                'Fantasy',
                                'Horror',
                              ],
                            ),


                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
