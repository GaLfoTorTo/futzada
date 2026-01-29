import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:futzada/core/theme/app_colors.dart';
import 'package:futzada/core/theme/app_style.dart';

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
        popupProps: PopupProps.menu(
          showSearchBox: true,
          searchFieldProps: TextFieldProps(
            decoration: Theme.of(context).brightness == Brightness.light
            ? AppStyle.lightDropdownMenuTheme.copyWith(
              hintText: 'Selecione...',
            )
            : AppStyle.darkDropdownMenuTheme.copyWith(
              hintText: 'Selecione...',
            )
          ),
          containerBuilder: (context, child) {
            return Material(
              color: Theme.of(context).brightness == Brightness.light
                ? AppColors.white
                : AppColors.dark_500,
              child: child,
            );
          },
        ),
        dropdownDecoratorProps: DropDownDecoratorProps(
          dropdownSearchDecoration: Theme.of(context).brightness == Brightness.light
            ? AppStyle.lightDropdownMenuTheme.copyWith(
              labelText: label,
            )
            : AppStyle.darkDropdownMenuTheme.copyWith(
              labelText: label,
            )
        ),
        items: options,
        selectedItem: selected ?? "Selecione",
        onChanged: (value) => onChanged(value),
      ),
    );
  }
}