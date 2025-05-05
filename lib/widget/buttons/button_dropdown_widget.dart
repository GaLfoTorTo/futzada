import 'package:flutter/material.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/theme/app_size.dart';
import 'package:futzada/widget/images/ImgCircularWidget.dart';

class ButtonDropdownWidget extends StatelessWidget {
  final dynamic selectedEvent;
  final List<dynamic> itens;
  final Function onChange;
  final double? width;
  final double? menuWidth;
  final double? textSize;
  final Color? textColor;
  final Color? color;
  final Color? borderColor;
  final bool icon;
  final double? iconSize;
  final bool iconAfter;
  final String aligment;

  const ButtonDropdownWidget({
    super.key,
    required this.selectedEvent,
    required this.itens,
    required this.onChange,
    this.width = 150,
    this.menuWidth = 170,
    this.textSize = AppSize.fontXs,
    this.textColor = AppColors.dark_500,
    this.color = AppColors.white,
    this.borderColor,
    this.icon = true,
    this.iconSize = 10,
    this.iconAfter = true,
    this.aligment = 'center' 
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      alignment: aligment == 'center' ? Alignment.center : null,
      decoration: BoxDecoration(
        border: Border.all(
          color: borderColor ?? Colors.transparent,
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(5),
      ),
      child: DropdownButton<dynamic>(
        value: selectedEvent,
        onChanged: (dynamic newValue) => onChange(newValue),
        style: TextStyle(
          color: textColor,
          fontSize: textSize
        ),
        underline: Container(
          height: 0,
        ),
        dropdownColor: color,
        icon: icon ? const SizedBox.shrink() : null,
        iconSize: iconSize != null ? iconSize! : 0,
        borderRadius: const BorderRadius.all(Radius.circular(5)),
        alignment: aligment != 'center' ? Alignment.centerLeft : Alignment.center,
        menuWidth: menuWidth ?? width,
        hint: Text(
          'Selecione',
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: AppColors.gray_300, fontSize: textSize),
        ),
        items: itens.map<DropdownMenuItem<dynamic>>((item) {
          //RESGATAR O VALUE E O TITULO DEPENDENDO DO TIPO DE DADO NA LISTA
          final optionValue = item is Map<String, dynamic> ? item['id'] : item;
          final optionTitle = item is Map<String, dynamic> ? item['title'] : item;
          return DropdownMenuItem<dynamic>(
            value: optionValue,
            child: Padding(
              padding: !iconAfter ? const EdgeInsets.only(right: 10) : const EdgeInsets.only(left: 10),
              child: Row(
                children: [
                  if(item is Map<String, dynamic> && !iconAfter)...[
                    if(item.containsKey('photo'))...[
                      ImgCircularWidget(
                        width: 20, 
                        height: 20,
                        image: item['photo'],
                      ),
                    ]else...[
                      Icon(
                        item['icon'],
                        color: item['color'],
                      )
                    ]
                  ],
                  Padding(
                    padding: iconAfter ? const EdgeInsets.only(right: 5) : const EdgeInsets.only(left: 5),
                    child: Text(
                      optionTitle,
                      style: const TextStyle(
                        overflow: TextOverflow.ellipsis
                      ),
                    ),
                  ),
                  if(item is Map<String, dynamic> && iconAfter)...[
                    if(item.containsKey('photo'))...[
                      ImgCircularWidget(
                        width: 20, 
                        height: 20,
                        image: item['photo'],
                      ),
                    ]else...[
                      Icon(
                        item['icon'],
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