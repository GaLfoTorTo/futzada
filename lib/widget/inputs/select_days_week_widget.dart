import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:futzada/theme/app_colors.dart';

class SelectDaysWeekWidget extends StatelessWidget {
  final List<String> values;
  final Function onChanged;

  const SelectDaysWeekWidget({
    super.key,
    required this.values,
    required this.onChanged
  });

  @override
  Widget build(BuildContext context) {
    //RESGATAR DIAS DA SEMANA
    List<String> daysOfWeek = ['Dom','Seg','Ter','Qua','Qui','Sex','Sab'];
    final color = Get.isDarkMode ? AppColors.dark_300 : AppColors.white;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Obx((){
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: daysOfWeek.map((value){
            return InkWell(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () => onChanged(value),
              child: Container(
                alignment: Alignment.center,
                width: 55,
                height: 55,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: values.contains(value) ? Theme.of(context).primaryColor : color,
                  borderRadius: BorderRadius.circular(50),
                  boxShadow: [
                    if (values.contains(value))...[
                      BoxShadow(
                        color: Theme.of(context).primaryColor.withAlpha(100),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: Offset(0,2),
                      ),
                    ]
                  ],
                ),
                child: Text(
                  value,
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: values.contains(value) ? AppColors.blue_500 : null,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),
            );
          }).toList()
        );
      })
    );
  }
}