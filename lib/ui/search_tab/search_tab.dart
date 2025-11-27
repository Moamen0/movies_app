
import 'package:flutter/material.dart';
import 'package:movies_app/api/api_manger.dart';
import 'package:movies_app/api/api_model/MoviesResponse.dart';
import 'package:movies_app/ui/home_tab/movies_item/movies_item.dart';
import 'package:movies_app/utils/app_assets.dart';
import 'package:movies_app/utils/custom_text_form_field.dart';

import '../../utils/app_color.dart';
import '../../utils/app_style.dart';

class SearchTab extends StatefulWidget {
  SearchTab({super.key});

  @override
  State<SearchTab> createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  TextEditingController controller =TextEditingController();
  List<Movies> moviesList = [];

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title:CustomTextFormField(
          prefixIcon: Image.asset(AppAssets.unSelectedIconSearch),
          hint: 'Marvel',
          controller: controller,
          keyboardType: TextInputType.text,
          maxLines: 1,
          onChanged: (text) {
            controller.text = text;
            setState(() {

            });
          },
        ),
      ),
      body: FutureBuilder(
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
          return Padding(
            padding: EdgeInsets.symmetric(
                vertical: height*0.02
            ),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: width*0.02,   // مسافة بين الأعمدة
                mainAxisSpacing:height*0.02,    // مسافة بين الصفوف
              ),
              itemBuilder: (context, index) {
                return MoviesItem(movie: moviesList[index]);
              },
              itemCount: moviesList.length,
            ),
          );
        },
      )
    );
  }

}
