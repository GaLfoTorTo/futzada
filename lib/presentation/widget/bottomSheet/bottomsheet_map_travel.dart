import 'package:flutter/material.dart';
import 'package:esportly/core/theme/app_colors.dart';
import 'package:esportly/core/helpers/map_helper.dart';
import 'package:esportly/presentation/controllers/event_controller.dart';

class BottomSheetMapTravel extends StatelessWidget {
  const BottomSheetMapTravel({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    //RESGATAR CONTROLLER DO EVENTO
    EventController eventController = EventController.instance;

    return Container(
      padding: const EdgeInsets.all(15),
      child: SingleChildScrollView(
        child: Column(
          spacing: 10,
          children: [
            Text(
              'Tipo de Viagem',
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const Divider(color: AppColors.grey_300),
            ...MapHelper.transports.map((item) {
              return ListTile(
                leading: Container(
                  width: 50,
                  height: 50,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.green_300.withAlpha(50),
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: Icon(
                    item['icon'],
                    color: AppColors.green_300,
                    size: 30,
                  ),
                ),
                title: Text(
                  item['label'],
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                onTap: () => eventController.travelMode = item['type']
              );
            })
          ],
        ),
      ),
    );
  }
}