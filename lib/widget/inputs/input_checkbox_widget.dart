import 'package:flutter/material.dart';
import 'package:futzada/theme/app_colors.dart';

class InputCheckBoxWidget extends StatelessWidget {
  final String name;
  final bool? value;
  final Function onChanged;

  const InputCheckBoxWidget({
    super.key,
    required this.name, 
    this.value = false,
    required this.onChanged 
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Transform.scale(
            scale: 2,
            child: Checkbox(
              value: value,
              onChanged: (value) {
                onChanged(name);
              },
              activeColor: AppColors.green_300,
              side: const BorderSide(color: AppColors.gray_500, width: 2),
            ),
          ),
          Text(
            name,
            style: Theme.of(context).textTheme.titleSmall,
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}