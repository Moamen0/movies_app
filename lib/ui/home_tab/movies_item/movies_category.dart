import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../api/api_manger.dart';
import '../../../utils/app_color.dart';
import '../../../utils/app_style.dart';
import '../home_tab_item/homeTabItem.dart';

class MoviesCategory extends StatelessWidget {
  const MoviesCategory({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: ApiManager.getMoviesByGenre('Action'),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              color: AppColor.yellow,
            ),
          );
        } else if (snapshot.hasError) {
          return Column(
            children: [
              Text(
                snapshot.error.toString(),
                style: AppStyle.bold16White,
              ),
              ElevatedButton(
                  onPressed: () {
                    ApiManager.getMovies();
                  },
                  child: Text('Try again'))
            ],
          );
        }
        if (snapshot.data!.status != 'ok') {
          return Column(
            children: [
              Text(snapshot.data!.statusMessage!),
              ElevatedButton(
                  onPressed: () {
                    ApiManager.getMovies();
                  },
                  child: Text('Try again'))
            ],
          );
        }
        var actionMovies = snapshot.data?.data?.movies ?? [];
        return Hometabitem(movieList: actionMovies);
      },
    );
  }
}
