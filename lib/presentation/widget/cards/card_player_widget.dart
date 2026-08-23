import 'package:flutter/material.dart';
import 'package:esportly/core/helpers/modality_helper.dart';
import 'package:esportly/data/models/user_model.dart';
import 'package:esportly/core/theme/app_colors.dart';
import 'package:esportly/core/helpers/img_helper.dart';
import 'package:esportly/core/helpers/user_helper.dart';
import 'package:esportly/presentation/widget/badges/position_widget.dart';

class CardPlayerWidget extends StatelessWidget {
  final UserModel user;
  final String? modality;
  const CardPlayerWidget({
    super.key,
    required this.user,
    this.modality
  });

  @override
  Widget build(BuildContext context) {
    //RESGATAR TEMA PERSONALIZADO PARA MODALIDADE PRINCIPAL DO USUARIO
    final modalityInfo = ModalityHelper.getEventModalityColor(user.config!.mainModality!.name);
    final modalityColor = modalityInfo['color'];
    final modalityTextColor = modalityInfo['textColor'];
    final mainModality = user.config!.mainModality!;

    return Card(
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: modalityColor,
          borderRadius: BorderRadius.circular(10)
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              '',
              style: Theme.of(context).textTheme.headlineSmall,
            )
          ],
        ),
      ),
    );
  }
}