import 'package:flutter/material.dart';
import 'package:movies_app/generated/l10n.dart';
import 'package:movies_app/onBorading/onBoradingPages.dart';
import 'package:movies_app/utils/app_assets.dart';

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
        "image": AppAssets.onborading1,
        "title": 'Welcome to MovieApp',
        "desc":
            "Explore a vast collection of movies in all qualities and genres. Find your next favorite film with ease.",
        "button": "Next"
      },
      {
        "image": AppAssets.onborading1,
        "title": "Explore All Genres",
        "desc":
            "Discover movies from every genre, in all available qualities. Find something new and exciting to watch every day.",
        "button": "Next"
      },
      {
        "image": AppAssets.onborading1,
        "title": "Rate, Review, and Learn",
        "desc":
            "Share your thoughts on the movies you’ve watched. Deep dive into their details and discover movies with reviews.",
        "button": "Next"
      },
      {
        "image": AppAssets.onborading1,
        "title": "Start Watching Now",
        "desc": "",
        "button": "Finish"
      },
    ];

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: PageView.builder(
          controller: _controller,
          itemCount: onboardingData.length,
          onPageChanged: (index) {
            setState(() => currentPage = index);
          },
          itemBuilder: (context, index) => OnboradingPages(
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
              } else {}
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
      ),
    );
  }
}
