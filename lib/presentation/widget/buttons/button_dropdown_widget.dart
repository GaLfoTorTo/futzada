import 'package:flutter/material.dart';
import 'package:esportly/core/theme/app_colors.dart';
import 'package:esportly/core/theme/app_size.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class ButtonDropdownWidget extends StatelessWidget {
  final dynamic selectedItem;
  final List<dynamic> items;
  final Function onChange;
  final double? width;
  final double? menuHeight;
  final double? menuWidth;
  final double? textSize;
  final Color? textColor;
  final Color? color;
  final Color? borderColor;
  final String? hint;
  final String aligment;

  const ButtonDropdownWidget({
    super.key,
    required this.selectedItem,
    required this.items,
    required this.onChange,
    this.width = 150,
    this.menuWidth = 170,
    this.menuHeight = 200,
    this.textSize = AppSize.fontXs,
    this.textColor = AppColors.dark_500,
    this.color,
    this.borderColor,
    this.hint = 'Selecione',
    this.aligment = 'center',
  });

  String _idOf(dynamic item) => item is Map<String, dynamic> ? item['id'] as String : item.toString();
  String _titleOf(dynamic item) => item is Map<String, dynamic> ? item['title'] as String : item.toString();

  dynamic get _currentItem {
    if (selectedItem == null) return null;
    try {
      return items.firstWhere((item) => _idOf(item) == selectedItem.toString());
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final current = _currentItem;

    return Container(
      width: width,
      height: 50,
      decoration: BoxDecoration(
        color: color ?? Colors.transparent,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: borderColor ?? Colors.transparent,
          width: 1.0,
        ),
      ),
      child: DropdownButton2<String>(
        isExpanded: true,
        value: current != null ? _idOf(current) : null,
        onChanged: (value) => onChange(value),
        customButton: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisAlignment: aligment == 'center' ? MainAxisAlignment.center : MainAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  current != null ? _titleOf(current) : (hint ?? 'Selecione'),
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontSize: textSize,
                    color: current != null ? null : AppColors.grey_300,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              if (current is Map<String, dynamic> && current['icon'] != null)
                Icon(current['icon'] as IconData, color: current['color'] as Color?, size: AppSize.fontLg),
            ],
          ),
        ),
        dropdownStyleData: DropdownStyleData(
          width: menuWidth ?? width,
          maxHeight: menuHeight,
          decoration: BoxDecoration(
            color: Theme.of(context).cardTheme.color,
            borderRadius: const BorderRadius.all(Radius.circular(5)),
          ),
        ),
        iconStyleData: const IconStyleData(icon: SizedBox.shrink(), iconSize: 0),
        alignment: aligment != 'center' ? Alignment.centerLeft : Alignment.center,
        underline: const SizedBox.shrink(),
        items: items.map<DropdownMenuItem<String>>((item) {
          final id = _idOf(item);
          final title = _titleOf(item);

          return DropdownMenuItem<String>(
            value: id,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: textSize),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                if (item is Map<String, dynamic> && item['icon'] != null)
                  Icon(item['icon'] as IconData, color: item['color'] as Color?, size: AppSize.fontLg),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
