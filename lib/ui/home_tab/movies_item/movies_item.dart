import 'package:flutter/material.dart';
import 'package:movies_app/utils/app_color.dart';
import 'package:movies_app/utils/app_style.dart';

import '../../../api/api_model/MoviesResponse.dart';

class MoviesItem extends StatelessWidget {

  Movies movie;
  MoviesItem({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: DecorationImage(image: NetworkImage(movie.largeCoverImage!),fit: BoxFit.cover),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: width*0.02,
              vertical: height*0.01
            ),
            padding: EdgeInsets.symmetric(
              horizontal: width*0.005,
              vertical: height*0.003
            ),
            width: width*0.13,
            height: height*0.03 ,
            decoration: BoxDecoration(
              color: AppColor.blackTransparentColor,
              borderRadius: BorderRadius.circular(10)
            ),
            child: Row(
              children: [
                Text('${movie.rating}',style: AppStyle.bold16White,),
                Icon(Icons.star,color: AppColor.yellow,)
              ],
            ),
          )
        ],
      ),
    );
  }
}
