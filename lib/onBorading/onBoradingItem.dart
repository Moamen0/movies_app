import 'package:flutter/material.dart';
import 'package:movies_app/generated/l10n.dart';
import 'package:movies_app/onBorading/onBoradingPages.dart';
import 'package:movies_app/utils/app_assets.dart';
import 'package:movies_app/utils/app_route.dart';

class OnBoradingItem extends StatefulWidget {
  const OnBoradingItem({super.key});

  @override
  State<OnBoradingItem> createState() => _OnBoradingScreenState();
}

class _OnBoradingScreenState extends State<OnBoradingItem> {
  final PageController _controller = PageController();
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> onboardingData = [
      {
        "image": AppAssets.onborading2,
        "title": S.of(context).Discover_Movies,
        "desc": S.of(context).Explore_avast_collection,
        "button": S.of(context).next
      },
      {
        "image": AppAssets.onborading3,
        "title": S.of(context).Explore_All_Genres,
        "desc": S.of(context).Discover_movies_from_every_genre,
        "button": S.of(context).next
      },
      {
        "image": AppAssets.onborading4,
        "title": S.of(context).Create_Watchlists,
        "desc": S.of(context).Save_movies_to_your_watchlist,
        "button": S.of(context).next
      },
      {
        "image": AppAssets.onborading5,
        "title": S.of(context).RateReviewandLearn,
        "desc": S.of(context).Shareyourthoughts,
        "button": S.of(context).next
      },
      {
        "image": AppAssets.onborading6,
        "title": S.of(context).StartWatchingNow,
        "desc": "",
        "button": S.of(context).finish
      },
    ];

    return Scaffold(
      backgroundColor: Colors.black,
      body: PageView.builder(
        controller: _controller,
        itemCount: onboardingData.length,
        onPageChanged: (index) {
          setState(() => currentPage = index);
        },
        itemBuilder: (context, index) => OnboradingPages(
          buttonText2: S.of(context).back,
          image: onboardingData[index]["image"]!,
          title: onboardingData[index]["title"]!,
          desc: onboardingData[index]["desc"]!,
          buttonText: onboardingData[index]["button"]!,
          isLast: index == onboardingData.length - 1,
          isFirst: index == 0,
          onNext: () {
            if (index < onboardingData.length - 1) {
              _controller.nextPage(
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeInOut,
              );
            } else {
              Navigator.of(context).pushReplacementNamed(AppRoute.loginScreen);
            }
          },
          onBack: () {
            if (index > 0) {
              _controller.previousPage(
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeInOut,
              );
            }
          },
        ),
      ),
    );
  }
}
