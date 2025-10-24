import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:futzada/models/user_model.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/theme/app_icones.dart';
import 'package:futzada/widget/inputs/input_text_widget.dart';
import 'package:futzada/helpers/app_helper.dart';

class CardPresentationWidget extends StatelessWidget {
  final UserModel? user;
  const CardPresentationWidget({
    super.key,
    this.user,
  });

  @override
  Widget build(BuildContext context) {
    //RESGATAR DIMENSOES DO DISPOSITIVO
    var dimensions = MediaQuery.of(context).size;
    //CONTROLADOR DE INPUT DE PESQUISA
    final TextEditingController pesquisaController = TextEditingController();

    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(bottom: 10),
      child:
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppHelper.saudacaoPeriodo(),
                      style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                        color: AppColors.blue_500
                      )
                    ),
                    Text(
                      '${user!.firstName?.capitalize} ${user!.lastName?.capitalize}',
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        color: AppColors.blue_500,
                        fontWeight: FontWeight.normal
                      )
                    ),
                  ],
                ),
                Container(
                  width: 100,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(
                      color: AppColors.yellow_200,
                      width: 2,
                    ),
                    color: AppColors.yellow_100.withAlpha(100),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(width: 5),
                      Text(
                        'Gold',
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          color: AppColors.yellow_200,
                          fontWeight: FontWeight.bold
                        )
                      ),
                    ],  
                  ),
                )
              ],
            ),
            SizedBox(
              width: dimensions.width * 0.90,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: InputTextWidget(
                  name: 'search',
                  hint: 'Pesquisa',
                  prefixIcon: AppIcones.search_solid,
                  textController: pesquisaController,
                  type: TextInputType.text,
                ),
              ),
            ),
          ],
        ),
    );
  }
}