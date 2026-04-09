import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:futzada/core/theme/app_colors.dart';
import 'package:futzada/core/theme/app_icones.dart';
import 'package:futzada/data/models/user_model.dart';
import 'package:futzada/presentation/controllers/user_controller.dart';

class CardTasksWidget extends StatelessWidget {
  final UserModel user;
  
  const CardTasksWidget({
    super.key, 
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    UserController userController = UserController.instance;
            
    return Card(
      child: Container(
        padding: const EdgeInsets.all(30),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          /* color: AppColors.green_300,
          image: DecorationImage(
            image: const AssetImage(AppImages.cardFootball) as ImageProvider,
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              AppColors.green_300.withAlpha(200), 
              BlendMode.srcATop,
            )
          ), */
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 10,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Finalize as tarefas para completar seu perfil de usuário',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
                Container(
                  width: 60,
                  height: 60,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.green_300,
                    borderRadius: BorderRadius.circular(50)
                  ),
                  child: const Icon(
                    AppIcones.clipboard_solid,
                    size: 35,
                    color: AppColors.blue_500,
                  ),
                )
              ],
            ),
            Text(
              "Checklist: ${userController.tasks.length} Tarefas",
              style: Theme.of(context).textTheme.displayMedium,
            ),
            const Divider(color: AppColors.grey_500),
            Obx((){
              return Column(
                children: userController.tasks.take(3).map((task){
                  return RadioGroup(
                    onChanged: (value) => task['value'] = value,
                    child: RadioListTile(
                      title: Text(
                        task['task'],
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      subtitle: Text(
                        task['description'],
                        style: Theme.of(context).textTheme.displayMedium!.copyWith(
                          color: AppColors.grey_500
                        ),
                      ),
                      value: task['value']
                    )
                  );
                }).toList(),
              );
            })
          ],
        ),
      ),
    );
  }
}