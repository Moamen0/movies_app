import 'package:flutter/material.dart';
import 'package:movies_app/api/api_model/movieResponse.dart';

class Hometabitem extends StatelessWidget {
  List<Movies> movieList;

  Hometabitem({required this.movieList, super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (context, index) {
        return Text(movieList[index].titleEnglish!);
      },
      separatorBuilder: (BuildContext context, int index) {
        return Container();
      },
      itemCount: 10,
    );
  }
}
