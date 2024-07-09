import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:futzada/theme/app_colors.dart';

class SelectWidget extends StatelessWidget {
  final String label;
  final List<String> options;
  final String? selected;
  final Function onChanged;
  
  const SelectWidget({
    super.key, 
    required this.label,
    this.selected, 
    required this.options, 
    required this.onChanged, 
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: DropdownSearch<String>(
        popupProps: const PopupProps.menu(
          showSearchBox: true,
          searchFieldProps: TextFieldProps(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.all(12),
              hintText: 'Selecione...',
            ),
          ),
        ),
        items: options,
        selectedItem: selected != null ? selected : "Selecione",
        dropdownDecoratorProps: DropDownDecoratorProps(
          dropdownSearchDecoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide.none,
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.green_300),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            labelText: label,
            labelStyle: const TextStyle(
              color: AppColors.gray_500,
              fontSize: 15,
            ),
            floatingLabelStyle: const TextStyle(
              color: AppColors.dark_500,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
          ),
        ),
        onChanged: (value) => onChanged(value),
      ),
    );
  }
}