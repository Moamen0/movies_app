import 'package:flutter/material.dart';
import 'package:movies_app/api/api_manger.dart';
import 'package:movies_app/ui/home_tab/home_tab_item/homeTabItem.dart';
import 'package:movies_app/utils/app_color.dart';
import 'package:movies_app/utils/app_style.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: ApiManager.getMovies(),
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
        var moviesList = snapshot.data?.data?.movies ?? [];
        return Hometabitem(movieList: moviesList);
      },
    );
  }
}
