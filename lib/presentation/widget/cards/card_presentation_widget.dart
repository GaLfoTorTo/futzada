import 'package:futzada/core/utils/map_utils.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:futzada/data/models/user_model.dart';
import 'package:futzada/core/theme/app_colors.dart';
import 'package:futzada/core/theme/app_icones.dart';
import 'package:futzada/presentation/widget/inputs/input_text_widget.dart';
import 'package:futzada/core/helpers/app_helper.dart';

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
              crossAxisAlignment: CrossAxisAlignment.end,
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
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: AppColors.blue_500,
                        fontWeight: FontWeight.normal
                      )
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(5),
                  constraints: BoxConstraints(
                    maxWidth: dimensions.width * 0.3
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.blue_500.withAlpha(30),
                    borderRadius: BorderRadius.circular(5)
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 20,
                        color: AppColors.blue_500,
                      ),
                      Text(
                        MapUtils.getLocation(),
                        style: Theme.of(context).textTheme.displayMedium!.copyWith(
                          color: AppColors.blue_500
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
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