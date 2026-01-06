import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/utils/icon_utils.dart';
import 'package:futzada/utils/form_utils.dart';
import 'package:futzada/controllers/explorer_controller.dart';
import 'package:futzada/widget/bars/header_widget.dart';
import 'package:futzada/widget/inputs/input_date_widget.dart';
import 'package:futzada/widget/inputs/input_text_widget.dart';
import 'package:futzada/widget/buttons/button_text_widget.dart';
import 'package:futzada/widget/inputs/select_avaliation_widget.dart';
import 'package:futzada/widget/inputs/select_days_week_widget.dart';
import 'package:futzada/widget/inputs/select_rounded_widget.dart';

class ExploreFilterPage extends StatefulWidget {
  const ExploreFilterPage({super.key});

  @override
  State<ExploreFilterPage> createState() => _ExploreFilterPageState();
}

class _ExploreFilterPageState extends State<ExploreFilterPage> {
  //RESGATAR CONTROLLER DE EXPLORE
  ExplorerController exploreController = ExplorerController.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //INICIALIZAR CONTROLLERS DE FILTRO
    exploreController.initTextControllers();
  }


  @override
  Widget build(BuildContext context) {
    //RESGATAR DIMENSÕES DO DISPOSITIVO
    var dimensions = MediaQuery.of(context).size;
    //CATEGORIAS DE PARTIDAS
    List<String> categories = ['Futebol','Fut7','Futsal'];

    return Scaffold(
      appBar: HeaderWidget(
        title: 'Filtros',
        leftAction: () => Get.back(),
        shadow: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Obx((){
              return Column(
                spacing: 10,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Text(
                      "Radio de Distância",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  Text(
                    "Defina o raio de distância para o a busca de peladas no mapa. Distância máximo para contas padrão é de 10 km.",
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: AppColors.gray_500
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                      color: Get.isDarkMode ? AppColors.dark_300 : AppColors.white,
                      borderRadius: BorderRadius.circular(5)
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Distancia (km): ${exploreController.ratio}",
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                            Text(
                              "10 Km",
                              style: Theme.of(context).textTheme.labelMedium,
                            )
                          ],
                        ),
                        Slider(
                          value: exploreController.ratio.toDouble(),
                          min: 0,
                          max: 10,
                          divisions: 10,
                          label: exploreController.ratio.toInt().toString(),
                          activeColor: AppColors.green_300,
                          inactiveColor: AppColors.white,
                          onChanged: (double newValue) => exploreController.ratio.value = newValue.toInt(),
                        ),
                      ],
                    )
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child:Text(
                      "Categoria",
                      style: Theme.of(context).textTheme.titleMedium,
                      textAlign: TextAlign.start,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: categories.map((category){
                      //RESGATAR ICONE DA CATEGORIA
                      IconData icone = IconUtils.getIconCategory(category);
                      return SelectRoundedWidget(
                        value: category,
                        icon: icone,
                        size: 110,
                        iconSize: 40,
                        checked: exploreController.categories.contains(category),
                        onChanged: (_) {
                          if (exploreController.categories.contains(category)) {
                            exploreController.categories.remove(category);
                          } else {
                            exploreController.categories.add(category);
                          }
                        },
                      );
                    }).toList()
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child:Text(
                      "Dias da Semana",
                      style: Theme.of(context).textTheme.titleMedium,
                      textAlign: TextAlign.start,
                    ),
                  ),
                  SelectDaysWeekWidget(
                    values: exploreController.daysWeek,
                    onChanged: (value){
                      if (exploreController.daysWeek.contains(value)) {
                        exploreController.daysWeek.remove(value);
                      } else {
                        exploreController.daysWeek.add(value);
                      }
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child:Text(
                      "Horários",
                      style: Theme.of(context).textTheme.titleMedium,
                      textAlign: TextAlign.start,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: dimensions.width / 2 - 20,
                        child: InputDateWidget(
                          name: 'horaInicio',
                          label: 'Hora de Início',
                          textController: exploreController.startTimeController,
                          showModal: () => FormUtils.selectTime(context, 'horaInicio'),
                        ),
                      ),
                      SizedBox(
                        width: dimensions.width / 2 - 20,
                        child: InputDateWidget(
                          name: 'horaFim',
                          label: 'Hora de Fim',
                          textController: exploreController.endTimeController,
                          showModal: () => FormUtils.selectTime(context, 'horaFim'),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child:Text(
                      "Nº de Participantes",
                      style: Theme.of(context).textTheme.titleMedium,
                      textAlign: TextAlign.start,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: dimensions.width / 2 - 20,
                        child: InputTextWidget(
                          name: 'min',
                          label: 'Min',
                          type: TextInputType.number,
                          textController: exploreController.minController,
                        ),
                      ),
                      SizedBox(
                        width: dimensions.width / 2 - 20,
                        child: InputTextWidget(
                          name: 'max',
                          label: 'Max',
                          type: TextInputType.number,
                          textController: exploreController.maxController,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child:Text(
                      "Avaliação",
                      style: Theme.of(context).textTheme.titleMedium,
                      textAlign: TextAlign.start,
                    ),
                  ),
                  SelectAvaliationWidget(
                    value: exploreController.avaliation.value,
                    onChanged: (value) => exploreController.avaliation.value = value,
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        ButtonTextWidget(
                          text: "Cancelar",
                          textColor: AppColors.white,
                          backgroundColor: AppColors.red_300,
                          width: 100,
                          action: () => Get.back(),
                        ),
                        ButtonTextWidget(
                          text: "Aplicar",
                          icon: Icons.filter_alt,
                          iconSize: 25,
                          width: 100,
                          action: (){},
                        ),
                      ],
                    ),
                  ),
                ]
              );
            }),
          ),
        ),
      ),
    );
  }
}
