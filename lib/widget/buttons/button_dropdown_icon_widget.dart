import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/theme/app_size.dart';
import 'package:futzada/theme/app_images.dart';

class ButtonDropdownIconWidget extends StatelessWidget {
  final dynamic selectedItem;
  final List<dynamic> items;
  final Function onChange;
  final double? width;
  final double? menuWidth;
  final double? menuHeight;
  final double? textSize;
  final Color? textColor;
  final Color? color;
  final Color? borderColor;
  final double? iconSize;
  final bool iconAfter;
  final Alignment? aligment;

  const ButtonDropdownIconWidget({
    super.key,
    required this.selectedItem,
    required this.items,
    required this.onChange,
    this.width = 150,
    this.menuWidth = 170,
    this.menuHeight = 200,
    this.textSize = AppSize.fontXs,
    this.textColor = AppColors.dark_500,
    this.color = AppColors.white,
    this.borderColor,
    this.iconSize = 10,
    this.iconAfter = true,
    this.aligment = Alignment.center
  });

  @override
  Widget build(BuildContext context) {

    return Container(
      width: width,
      alignment: aligment ?? null,
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
        value: selectedItem,
        onChanged: (dynamic newValue) => onChange(newValue),
        style: Theme.of(context).textTheme.displayMedium!.copyWith(
          color: textColor,
          fontSize: textSize,
        ),
        isExpanded: true,
        dropdownColor: color,
        icon: const SizedBox.shrink(),
        underline: Container(height: 0),
        menuWidth: menuWidth ?? width,
        menuMaxHeight: menuHeight ?? null,
        hint: Text(
          'Selecione',
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: AppColors.gray_300, fontSize: textSize),
        ),
        items: items.map<DropdownMenuItem<dynamic>>((item) {
          //RESGATAR O VALUE E O TITULO DEPENDENDO DO TIPO DE DADO NA LISTA
          final optionValue = item is Map<String, dynamic> ? item['id'] : item;
          final optionTitle = item is Map<String, dynamic> ? item['title'] : item;
          return DropdownMenuItem<dynamic>(
            value: optionValue,
            child: Padding(
              padding: !iconAfter 
                  ? const EdgeInsets.only(right: 10) 
                  : const EdgeInsets.only(left: 10),
              child: Row(
                children: [
                  if(item is Map<String, dynamic> && !iconAfter)...[
                    if(item.containsKey('photo'))...[
                      SizedBox(
                        width: iconSize! * 3, 
                        height: iconSize! * 3,
                        child: CircleAvatar(
                          backgroundImage: item['photo'] != null
                            ? CachedNetworkImageProvider(item['photo']!) 
                            : const AssetImage(AppImages.userDefault) as ImageProvider,
                        ),
                      ),
                    ]else...[
                      Icon(
                        item['icon'],
                        size: iconSize,
                        color: item['color'],
                      )
                    ]
                  ],
                  Expanded(
                    child: Padding(
                      padding: iconAfter
                          ? const EdgeInsets.only(right: 5)
                          : const EdgeInsets.only(left: 5),
                      child: Text(
                        optionTitle.toString(),
                        style: Theme.of(context).textTheme.displayMedium!.copyWith(
                          fontSize: textSize
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ),
                  if(item is Map<String, dynamic> && iconAfter)...[
                    if(item.containsKey('photo'))...[
                      SizedBox(
                        width: iconSize! * 3, 
                        height: iconSize! * 3,
                        child: CircleAvatar(
                          backgroundImage: item['photo'] != null
                            ? CachedNetworkImageProvider(item['photo']!) 
                            : const AssetImage(AppImages.userDefault) as ImageProvider,
                        ),
                      ),
                    ]else...[
                      Icon(
                        item['icon'],
                        size: iconSize,
                        color: item['color'],
                      )
                    ]
                  ],
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}