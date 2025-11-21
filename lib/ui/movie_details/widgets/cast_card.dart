import 'package:flutter/material.dart';
import 'package:movies_app/utils/app_style.dart';

class CastCard extends StatelessWidget {
  final String image;
  final String name;
  final String character;

  const CastCard({
    super.key,
    required this.image,
    required this.name,
    required this.character,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFF2E2E2E),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              image,
              width: 55,
              height: 55,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Name : $name",
                style:AppStyle.roboto20RegularWhite
              ),
              const SizedBox(height: 4),
              Text(
                "Character : $character",
                style: AppStyle.roboto20RegularWhite
              ),
            ],
          )
        ],
      ),
    );
  }
}
