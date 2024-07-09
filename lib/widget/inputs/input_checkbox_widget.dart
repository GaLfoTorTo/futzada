import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:futzada/theme/app_colors.dart';

class InputCheckboxWidget extends StatelessWidget {
  final String title;
  final String sigla;
  final String? icon;
  final bool? isChecked;
  final Function onChanged;

  const InputCheckboxWidget({
    super.key,
    required this.title, 
    required this.sigla, 
    this.icon,
    this.isChecked = false,
    required this.onChanged 
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(5),
            child: icon != null 
            ? SvgPicture.asset(
                icon!,
                width: 30,
                height: 30,
              )
            :null,
          ),
          Transform.scale(
            scale: 2,
            child: Checkbox(
              value: isChecked,
              onChanged: (value) {
                onChanged(value, sigla);
              },
              activeColor: AppColors.green_300,
            ),
          ),
          Text(
            title,
            style: const TextStyle(
              color: AppColors.dark_500,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}