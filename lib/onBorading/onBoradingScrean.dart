import 'package:flutter/material.dart';
import 'package:movies_app/utils/app_assets.dart';

class OnBoradingScrean extends StatelessWidget {
  OnBoradingScrean({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppAssets.onborading1),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text('Find Your Next \n Favorite Movie Here',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.w500,
                )),
            SizedBox(height: 20),
            Text(
                'Get access to a huge library of  movies \n to suit all tastes. You will surely like it.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white70,
                  fontWeight: FontWeight.w400,
                  fontSize: 15,
                )),
            ElevatedButton(
              onPressed: () {
                // Navigate to the next screen or perform any action
              },
              child: Text('Get Started'),
            ),
            SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
