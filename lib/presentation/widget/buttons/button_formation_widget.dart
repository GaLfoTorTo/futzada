import 'package:flutter/material.dart';
import 'package:esportly/core/theme/app_colors.dart';

class ButtonFormationWidget extends StatelessWidget {
  final String selectedFormation;
  final List<String> formations;
  final Function onChange;

  const ButtonFormationWidget({
    super.key,
    required this.selectedFormation,
    required this.formations,
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    final validValue = formations.contains(selectedFormation) ? selectedFormation : null;
    return DropdownButton<String>(
      value: validValue,
      onChanged: (String? newValue) => onChange(newValue),
      style: const TextStyle(color: AppColors.dark_500, fontSize: 20),
      underline: Container(height: 0),
      dropdownColor: AppColors.green_300,
      icon: const SizedBox.shrink(),
      iconSize: 0,
      borderRadius: const BorderRadius.all(Radius.circular(5)),
      menuWidth: 150,
      isExpanded: true,
      itemHeight: 60,
      items: formations.map<DropdownMenuItem<String>>((item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: AppColors.green_300,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: Text(item, style: const TextStyle(overflow: TextOverflow.ellipsis)),
          ),
        );
      }).toList(),
    );
  }
}
