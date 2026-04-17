import 'package:flutter/material.dart';
import 'package:futzada/core/theme/app_colors.dart';
import 'package:futzada/data/models/task_model.dart';

class CardTaskWidget extends StatelessWidget {
  final TaskModel task;
  const CardTaskWidget({
    super.key, 
    required this.task,
  });

  @override
  Widget build(BuildContext context) {  
    return  Card(
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Row(
          spacing: 10,
          children: [
            const Icon(
              Icons.remove_circle_outline_rounded,
              size: 35,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.title,
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: AppColors.green_300
                    )
                  ),
                  Text(
                    task.description,
                    style: Theme.of(context).textTheme.displayLarge
                  ),
                ],
              ),
            ),
          ],
        )
      ),
    );
  }
}