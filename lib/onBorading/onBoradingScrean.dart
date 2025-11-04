import 'package:flutter/material.dart';
import 'package:movies_app/utils/app_assets.dart';
import 'package:movies_app/utils/app_route.dart';
import 'package:movies_app/utils/app_style.dart';
import 'package:movies_app/utils/custom_elevated_button.dart';

class OnBoradingScrean extends StatelessWidget {
  OnBoradingScrean({super.key});

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppAssets.onborading1),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.04),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text('Find Your Next \n Favorite Movie Here',
                  textAlign: TextAlign.center, style: AppStyle.medium36white),
              SizedBox(height: height * 0.02),
              Text(
                  'Get access to a huge library of  movies \n to suit all tastes. You will surely like it.',
                  textAlign: TextAlign.center,
                  style: AppStyle.reglur20whiteop60),
              SizedBox(height: height * 0.02),
              CustomElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, AppRoute.OnBoradingItem);
                },
                text: 'Explore Now',
                textStyle: AppStyle.semibold20black,
                padding: EdgeInsets.symmetric(
                  vertical: height * 0.027,
                ),
              ),
              SizedBox(height: height * 0.04),
            ],
          ),
        ),
      ),
    );
  }
}
