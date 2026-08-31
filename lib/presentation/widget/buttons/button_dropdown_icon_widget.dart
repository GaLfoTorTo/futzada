import 'package:flutter/material.dart';
import 'package:esportly/core/theme/app_colors.dart';
import 'package:esportly/core/theme/app_size.dart';

class ButtonDropdownIconWidget<T> extends StatelessWidget {
  final T? selectedItem;
  final List<T> items;
  final ValueChanged<T?> onChange;
  final String Function(T) labelBuilder;
  final Widget? Function(T)? iconBuilder;
  final double? width;
  final double? menuWidth;
  final double? menuHeight;
  final double? textSize;
  final Color? textColor;
  final Color? backgroundColor;
  final Color? borderColor;
  final double? iconSize;
  final bool iconAfter;
  final Alignment? aligment;

  const ButtonDropdownIconWidget({
    super.key,
    required this.selectedItem,
    required this.items,
    required this.onChange,
    required this.labelBuilder,
    this.iconBuilder,
    this.width = 150,
    this.menuWidth = 170,
    this.menuHeight = 200,
    this.textSize = AppSize.fontXs,
    this.textColor = AppColors.dark_500,
    this.backgroundColor = AppColors.white,
    this.borderColor,
    this.iconSize = 10,
    this.iconAfter = true,
    this.aligment = Alignment.center,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      alignment: aligment,
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.transparent,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: borderColor ?? Colors.transparent,
          width: 1.0,
        ),
      ),
      child: DropdownButton<T>(
        value: selectedItem,
        onChanged: onChange,
        style: Theme.of(context).textTheme.displayMedium!.copyWith(
          color: textColor,
          fontSize: textSize,
        ),
        isExpanded: true,
        dropdownColor: backgroundColor,
        icon: const SizedBox.shrink(),
        underline: Container(height: 0),
        menuWidth: menuWidth ?? width,
        menuMaxHeight: menuHeight,
        hint: Text(
          'Selecione',
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
            color: AppColors.grey_300,
            fontSize: textSize,
          ),
        ),
        items: items.map<DropdownMenuItem<T>>((item) {
          final icon = iconBuilder?.call(item);
          return DropdownMenuItem<T>(
            value: item,
            child: Padding(
              padding: !iconAfter
                  ? const EdgeInsets.only(right: 10)
                  : const EdgeInsets.only(left: 10),
              child: Row(
                children: [
                  if (icon != null && !iconAfter)
                    SizedBox(
                      width: iconSize! * 3,
                      height: iconSize! * 3,
                      child: icon,
                    ),
                  Expanded(
                    child: Padding(
                      padding: iconAfter
                          ? const EdgeInsets.only(right: 5)
                          : const EdgeInsets.only(left: 5),
                      child: Text(
                        labelBuilder(item),
                        style: Theme.of(context).textTheme.displayMedium!.copyWith(
                          fontSize: textSize,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ),
                  if (icon != null && iconAfter)
                    SizedBox(
                      width: iconSize! * 3,
                      height: iconSize! * 3,
                      child: icon,
                    ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
