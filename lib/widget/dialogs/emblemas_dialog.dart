import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:futzada/theme/app_icones.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/controllers/game_controller.dart';

class EmblemasDialog extends StatelessWidget {
  final bool team;
  final String emblema;
  const EmblemasDialog({
    super.key,
    required this.team,
    required this.emblema
  });

  @override
  Widget build(BuildContext context) {
    //RESGATAR DIMENSÕES DO DISPOSITIVO
    var dimensions = MediaQuery.of(context).size;
    //RESHATAR CONTROLLER DE PARTIDA
    GameController gameController = GameController.instance;
    //RESGATAR EMBLEMAS
    List<String> emblemas = AppIcones.emblemas.values.toList();

    return Container(
      height: dimensions.height * 0.60,
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15))
      ),
      child: Column(
        children: [
          Row(
            children: [
              const BackButton(),
              Padding(
                padding: const EdgeInsets.only(left: 100),
                child: Text(
                  'Emblemas',
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Text(
              'Escolha um emblema para a equipe e personalize ainda mais a partida.',
              style: Theme.of(Get.context!).textTheme.bodyMedium!.copyWith(
                color: AppColors.gray_500,
              ),
              textAlign: TextAlign.center
            ),
          ),
          Divider(color: AppColors.gray_300),
          Expanded(
            child: Wrap(
              alignment: WrapAlignment.center,
              children: List.generate(emblemas.length, (key){
                return InkWell(
                  onTap: (){
                    if(team){
                      gameController.teamAEmblemaController.text = "emblema_${key + 1}";
                    }else{
                      gameController.teamBEmblemaController.text = "emblema_${key + 1}";
                    }
                    print(gameController.teamBEmblemaController.text);
                    Get.back();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: AppColors.white,
                      boxShadow: [
                        if(emblema == emblemas[key])...[
                            BoxShadow(
                              color: AppColors.green_300.withAlpha(150),
                              spreadRadius: 8,
                              blurRadius: 1,
                              offset: Offset(0,0),
                            ),
                        ]else ...[
                          BoxShadow(
                            color: AppColors.dark_500.withAlpha(30),
                            spreadRadius: 0.5,
                            blurRadius: 5,
                            offset: const Offset(2, 5),
                          ),
                        ]
                      ],
                    ),
                    child: SvgPicture.asset(
                      emblemas[key],
                      width: 80,
                      colorFilter: const ColorFilter.mode(
                        AppColors.gray_300, 
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                );  
              }),
            ),
          ),
        ],
      ),
    );
  }
}