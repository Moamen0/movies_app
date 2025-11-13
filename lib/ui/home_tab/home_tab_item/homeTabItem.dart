import 'package:flutter/material.dart';

import '../../../api/api_model/MoviesResponse.dart';

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
