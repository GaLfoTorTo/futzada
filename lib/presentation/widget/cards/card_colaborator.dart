import 'package:flutter/material.dart';
import 'package:futzada/core/helpers/img_helper.dart';
import 'package:futzada/core/theme/app_colors.dart';
import 'package:futzada/data/models/user_model.dart';

class CardColaborator extends StatelessWidget {
  final UserModel user;
  final String role;
  const CardColaborator({
    super.key,
    required this.user,
    required this.role
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        child: Row(
          spacing: 10,
          children: [
            SizedBox(
              width: 50,
              height: 50,
              child: CircleAvatar(
                backgroundImage: ImgHelper.getUserImg(user.photo)
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${user.firstName} ${user.lastName}",
                  style: Theme.of(context).textTheme.labelMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                Text(
                  role,
                  style: Theme.of(context).textTheme.labelMedium!.copyWith(
                    color: AppColors.grey_500,
                  ),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ],
            ),
            if(role != 'Organizador')...[
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(
                      Icons.drag_indicator_rounded,
                    ),
                  ],
                )
              )
            ]
          ],
        ),
      ),
    );
  }
}