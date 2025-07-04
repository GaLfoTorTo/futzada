import 'package:flutter/material.dart';
import 'package:futzada/controllers/event_controller.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:get/get.dart';

class SelectDaysWeekWidget extends StatelessWidget {
  const SelectDaysWeekWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    //RESGATAR DIMENSÕES DO DISPOSITIVO
    var dimensions = MediaQuery.of(context).size;
    //RESGATAR CONTROLLER DE EVENTO
    EventController eventController = EventController.instance;
    //RESGATAR DIAS DA SEMANA
    Map<String, bool> daysOfWeek = eventController.daysOfWeek;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Obx((){
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: daysOfWeek.entries.map((item){
            final key = item.key;
            final value = item.value;
            return InkWell(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () => eventController.daysOfWeek[key] = !value,
              child: Container(
                alignment: Alignment.center,
                width: 55,
                height: 55,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: value ? AppColors.green_300 : AppColors.white,
                  borderRadius: BorderRadius.circular(50),
                  boxShadow: [
                    if (value)...[
                      BoxShadow(
                        color: AppColors.green_300.withAlpha(100),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: Offset(0,2),
                      ),
                    ]
                  ],
                ),
                child: Text(
                  key,
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: value ? AppColors.white : AppColors.dark_500,
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