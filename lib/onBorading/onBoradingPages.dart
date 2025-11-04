import 'package:flutter/material.dart';
import 'package:movies_app/utils/app_color.dart';
import 'package:movies_app/utils/app_style.dart';
import 'package:movies_app/utils/custom_elevated_button.dart';

class OnboradingPages extends StatelessWidget {
  const OnboradingPages({
    super.key,
    required this.image,
    required this.title,
    required this.desc,
    required this.buttonText,
    required this.isLast,
    required this.isFirst,
    this.buttonText2 = 'Back',
    required this.onNext,
    required this.onBack,
  });

  final String image;
  final String title;
  final String desc;
  final String buttonText;
  final String buttonText2;
  final bool isLast;
  final bool isFirst;
  final VoidCallback onNext;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          image,
          fit: BoxFit.cover,
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            decoration: const BoxDecoration(
              color: AppColor.blackColor,
              borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
            ),
            padding: EdgeInsets.symmetric(
              horizontal: width * 0.04,
              vertical: height * 0.03,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: AppStyle.bold24White,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: height * 0.015),
                isLast
                    ? SizedBox.shrink()
                    : Text(
                        desc,
                        style: AppStyle.reglur20white,
                        textAlign: TextAlign.center,
                      ),
                SizedBox(height: height * 0.04),
                CustomElevatedButton(
                  padding: EdgeInsets.symmetric(vertical: height * 0.027),
                  text: buttonText,
                  onPressed: onNext,
                  textStyle: AppStyle.semibold20black,
                ),
                SizedBox(height: height * 0.02),
                if (!isFirst)
                  CustomElevatedButton(
                    padding: EdgeInsets.symmetric(vertical: height * 0.027),
                    text: buttonText2,
                    backgroundColor: Colors.transparent,
                    borderColor: AppColor.yellow,
                    textStyle: AppStyle.semibold20yellow,
                    onPressed: onBack,
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
