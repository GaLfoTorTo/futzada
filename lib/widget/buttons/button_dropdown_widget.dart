import 'package:flutter/material.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/theme/app_size.dart';

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
    this.aligment = 'center' 
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: color ?? Colors.transparent,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: borderColor ?? Colors.transparent,
          width: 1.0,
        ),
      ),
      child: DropdownButton<dynamic>(
        value: items.contains(selectedItem) ? selectedItem : null,
        onChanged: (dynamic newValue) => onChange(newValue),
        style: Theme.of(context).textTheme.displayMedium!.copyWith(
          color: textColor,
          fontSize: textSize,
        ),
        isExpanded: true,
        dropdownColor: color,
        borderRadius: const BorderRadius.all(Radius.circular(5)),
        alignment: aligment != 'center' ? Alignment.centerLeft : Alignment.center,
        underline: Container(height: 0),
        menuWidth: menuWidth ?? width,
        menuMaxHeight: menuHeight ?? null,
        hint: Text(
          hint ?? 'Selecione',
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: AppColors.gray_300, fontSize: textSize),
        ),
        items: items.map<DropdownMenuItem<dynamic>>((item) {
          //RESGATAR O VALUE E O TITULO DEPENDENDO DO TIPO DE DADO NA LISTA
          final option = item is Map<String, dynamic> 
            ? item['id']
            : item;
          return DropdownMenuItem<dynamic>(
            value: option,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  option.toString(),
                  style: Theme.of(context).textTheme.displayMedium!.copyWith(
                    fontSize: textSize
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                if (item is Map<String, dynamic> && item.containsKey('icon'))...[
                  Icon(
                    item['icon'],
                    color: item['color'],
                    size: AppSize.fontLg,
                  )
                ]
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}