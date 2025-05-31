import 'package:flutter/material.dart';
import 'package:futzada/controllers/escalation_controller.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/theme/app_size.dart';
import 'package:futzada/widget/images/img_circle_widget.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:get/get.dart';

class ButtonDropdownMultiWidget extends StatefulWidget {
  final List<dynamic> selectedItems;
  final List<dynamic> items;
  final Function(String) onChanged;
  final double? width;
  final double? height;
  final double? menuWidth;
  final double? textSize;
  final Color? textColor;
  final Color? color;
  final Color? borderColor;
  final bool showIcon;
  final double? iconSize;
  final String alignment;

  const ButtonDropdownMultiWidget({
    super.key,
    required this.selectedItems,
    required this.items,
    required this.onChanged,
    this.width = 150,
    this.height = 50,
    this.menuWidth = 170,
    this.textSize = AppSize.fontXs,
    this.textColor = AppColors.dark_500,
    this.color = AppColors.white,
    this.borderColor,
    this.showIcon = true,
    this.iconSize = 20,
    this.alignment = 'center',

  });

  @override
  State<ButtonDropdownMultiWidget> createState() => ButtonDropdownMultiWidgetState();
}

class ButtonDropdownMultiWidgetState extends State<ButtonDropdownMultiWidget> {
  //RESGATAR CONTROLLER DE ESCALAÇÃO
  var controller = EscalationController.instace;
  //CONTROLDOR DE MENU
  bool isMenuOpen = false;

  @override
  Widget build(BuildContext context) {
    //RESGATAR PRIMEIRO OPÇÃO SELECIONADA
    var hint = widget.selectedItems.isNotEmpty ? widget.items.firstWhere((item) => item['id'] == widget.selectedItems[0]) : null;

    //FUNÇÃO PARA SELECIONAR ITEMS
    void setItems(String value){
      widget.onChanged(value);
    }

    return Container(
      width: widget.width,
      height: widget.height,
      alignment: widget.alignment == 'center' ? Alignment.center : null,
      decoration: BoxDecoration(
        border: Border.all(
          color: widget.borderColor ?? Colors.transparent,
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(5),
      ),
      child: DropdownButton2<dynamic>(
        isExpanded: true,
        value: null,
        onChanged: (optionTitle) => setItems(optionTitle),
        customButton: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              hint != null? hint['title']! : 'Status',
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: widget.textSize),
            ),
            if (hint != null)
              Icon(
                hint['icon'],
                color: hint['color'],
                size: widget.iconSize,
              )
          ],
        ),
        onMenuStateChange: (isOpen) {
          setState(() {
            isMenuOpen = isOpen;
          });
        },
        dropdownStyleData: DropdownStyleData(
          width: widget.menuWidth ?? widget.width,
          decoration: BoxDecoration(
            color: widget.color,
            borderRadius: const BorderRadius.all(Radius.circular(5)),
          ),
        ),
        iconStyleData: const IconStyleData(
          icon: SizedBox.shrink(),
          iconSize: 0,
        ),
        alignment: widget.alignment != 'center' ? Alignment.centerLeft : Alignment.center,
        underline: Container(height: 0),
        items: widget.items.map<DropdownMenuItem<dynamic>>((item) {
          final optionValue = item is Map<String, dynamic> ? item['id'] : item;
          final optionTitle = item is Map<String, dynamic> ? item['title'] : item;

          return DropdownMenuItem<dynamic>(
            value: optionValue,
            child: StatefulBuilder(
              builder: (context, menuSetState) {
                return Obx((){
                  //RESGATAR STATUS SELECIONADA
                  final isSelected = controller.filtrosMarket['status'].contains(optionValue);

                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if(isMenuOpen)...[
                        Checkbox(
                          value: isSelected,
                          onChanged: (bool? selected) => setItems(optionTitle),
                        ),
                      ],
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 5),
                          child: Text(
                            optionTitle.toString(),
                            style: TextStyle(
                              color: widget.textColor,
                              fontSize: widget.textSize,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ),
                      if (item.containsKey('photo')) ...[
                        ImgCircularWidget(
                          width: widget.iconSize!,
                          height: widget.iconSize!,
                          image: item['photo'],
                        ),
                      ] else if (item.containsKey('icon')) ...[
                        Icon(
                          item['icon'],
                          color: item['color'],
                          size: widget.iconSize,
                        )
                      ]
                    ],
                  );
                });
              },
            ),
          );
        }).toList(),
      ),
    );
  }
}