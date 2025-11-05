import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flag/flag.dart';
import 'package:flutter/material.dart';
import 'package:movies_app/utils/app_color.dart';

class LanguageToggle extends StatefulWidget {
  final Function(String)? onChangedLanguage;

  const LanguageToggle({super.key, this.onChangedLanguage});

  @override
  State<LanguageToggle> createState() => _LanguageToggleState();
}

class _LanguageToggleState extends State<LanguageToggle> {
  int? selectedValue = 0; // 0 = English, 1 = Arabic

  @override
  Widget build(BuildContext context) {
    return AnimatedToggleSwitch<int?>.rolling(
      iconOpacity: 1.0,
      allowUnlistedValues: true,
      current: selectedValue,
      spacing: 15,
      values: const [0, 1],
      onChanged: (value) {
        setState(() => selectedValue = value);
        print("Language changed to: ${value == 0 ? "English" : "Arabic"}");
      },
      iconBuilder: (value, foreground) => Center(child: flagByValue(value)),
      style: ToggleStyle(
        backgroundColor: Colors.transparent,
        borderColor: AppColor.yellow,
        borderRadius: BorderRadius.circular(25),
        indicatorColor: AppColor.yellow,
      ),
      borderWidth: 1.5,
    );
  }

  Widget flagByValue(int? value) {
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
