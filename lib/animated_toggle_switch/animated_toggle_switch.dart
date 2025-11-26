// lib/animated_toggle_switch/animated_toggle_switch.dart

import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flag/flag.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/bloc/locale/localization.dart';
import 'package:movies_app/utils/app_color.dart';

class LanguageToggle extends StatelessWidget {
  final Function(String)? onChangedLanguage;

  const LanguageToggle({super.key, this.onChangedLanguage});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocaleCubit, Locale>(
      builder: (context, locale) {
        // Convert locale to toggle value: 0 = English, 1 = Arabic
        final int selectedValue = locale.languageCode == 'en' ? 0 : 1;

        return AnimatedToggleSwitch<int>.rolling(
          iconOpacity: 1.0,
          allowUnlistedValues: true,
          current: selectedValue,
          spacing: 15,
          values: const [0, 1],
          onChanged: (value) async {
            // Determine language code based on toggle value
            final String languageCode = value == 0 ? 'en' : 'ar';
            
            // Update locale using Cubit
            await context.read<LocaleCubit>().changeLocale(languageCode);
            
            // Call callback if provided
            onChangedLanguage?.call(languageCode);
            
            print("Language changed to: ${value == 0 ? "English" : "Arabic"}");
          },
          iconBuilder: (value, foreground) => Center(
            child: _flagByValue(value),
          ),
          style: ToggleStyle(
            backgroundColor: Colors.transparent,
            borderColor: AppColor.yellow,
            borderRadius: BorderRadius.circular(25),
            indicatorColor: AppColor.yellow,
          ),
          borderWidth: 1.5,
        );
      },
    );
  }

  Widget _flagByValue(int? value) {
    switch (value) {
      case 0:
        return Flag.fromCode(FlagsCode.US, height: 20, width: 30);
      case 1:
        return Flag.fromCode(FlagsCode.EG, height: 20, width: 30);
      default:
        return const Icon(Icons.language, size: 20, color: Colors.white);
    }
  }
}