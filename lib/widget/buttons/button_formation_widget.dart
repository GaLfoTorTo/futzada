import 'package:flutter/material.dart';
import 'package:futzada/theme/app_colors.dart';

class ButtonFormationWidget extends StatelessWidget {
  final String selectedFormation;
  final Function onChange;

  const ButtonFormationWidget({
    super.key,
    required this.selectedFormation,
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    final List<String> itens = [
      '4-3-3',
    	'4-1-2-3',
    	'4-2-1-3',
    	'4-2-3-1',
    	'4-4-2',
      '3-4-3',
      '3-2-4-1',
    	'3-4-2-1',
      '5-3-2',
      '5-4-1'
    ];
    
    return DropdownButton<String>(
      value: selectedFormation,
      onChanged: (String? newValue) => onChange(newValue),
      style: const TextStyle(
        color: AppColors.dark_500,
        fontSize: 20
      ),
      underline: Container(
        height: 0,
      ),
      dropdownColor: AppColors.green_300,
      icon: const SizedBox.shrink(),
      iconSize: 0,
      borderRadius: BorderRadius.all(Radius.circular(5)),
      menuWidth: 150,
      isExpanded: true,
      itemHeight: 60,
      items: itens.map<DropdownMenuItem<String>>((item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              color: AppColors.green_300,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: Text(
              item,
              style: const TextStyle(
                overflow: TextOverflow.ellipsis
              ),
            ),
          )
        );
      }).toList(),
    );
  }
}