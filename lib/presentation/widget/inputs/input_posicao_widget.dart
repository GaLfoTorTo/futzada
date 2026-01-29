import 'package:flutter/material.dart';
import 'package:futzada/core/theme/app_colors.dart';
import 'package:futzada/presentation/widget/badges/position_widget.dart';

class InputPosicaoWidget extends StatelessWidget {
  final String title;
  final String modality;
  final String icon;
  final String alias;
  final bool? isChecked;
  final Function onChanged;

  const InputPosicaoWidget({
    super.key,
    required this.title, 
    required this.modality, 
    required this.alias, 
    required this.icon,
    this.isChecked = false,
    required this.onChanged 
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      child: Column(
        spacing: 2,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          PositionWidget(
            width: 50,
            position: alias
          ),
          Transform.scale(
            scale: 2,
            child: Checkbox(
              value: isChecked,
              onChanged: (value) {
                onChanged(value, modality, alias);
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