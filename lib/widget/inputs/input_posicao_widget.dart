import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:futzada/theme/app_colors.dart';

class InputPosicaoWidget extends StatelessWidget {
  final String title;
  final String? sigla;
  final String? icon;
  final bool? isChecked;
  final Function onChanged;

  const InputPosicaoWidget({
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
            style: Theme.of(context).textTheme.titleSmall,
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}