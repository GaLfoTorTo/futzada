import 'package:flutter/material.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/theme/app_icones.dart';
import 'package:futzada/widget/buttons/button_text_widget.dart';
import 'package:get/get.dart';

class SectionCategoriesWidget extends StatelessWidget {
  const SectionCategoriesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    //DEFINIR CATEGORIAS (MODALIDADES)
    RxList<Map<String, dynamic>> categories = [
      {
        'category': 'Futebol',
        'icon': AppIcones.futebol_ball_solid,
        'active' : true,
        'color' : AppColors.green_500,
      },
      {
        'category': 'Fut7',
        'icon': AppIcones.futebol_ball_solid,
        'active' : false,
        'color' : AppColors.green_300,
      },
      {
        'category': 'Futsal',
        'icon': Icons.sports_soccer,
        'active' : false,
        'color' : AppColors.blue_300,
      },
      {
        'category': 'Volei',
        'icon': AppIcones.volei_ball_solid,
        'active' : false,
        'color' : AppColors.yellow_300,
      },
      {
        'category': 'Volei de Praia',
        'icon': Icons.sports_volleyball,
        'active' : false,
        'color' : AppColors.bege_500,
      },
      {
        'category': 'Basquete',
        'icon': AppIcones.basquete_ball_solid,
        'active' : false,
        'color' : AppColors.orange_500,
      },
      {
        'category': 'Streetball',
        'icon': Icons.sports_basketball,
        'active' : false,
        'color' : AppColors.dark_300,
      },
    ].obs;

    void alterActive(String category){
      for (var item in categories) {
        if(item['category'] == category){
          item['active'] = true;
        }else{
          item['active'] = false;
        }
      }
      categories.refresh();
    }

    return Center(
      child: Container(
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.only(top: 10.0),
        height: 120,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Obx(() {
            return Row(
              spacing: 10,
              children: categories.map((item) {
                //RESGATAR CATEGORIA
                String category = item['category'];
                bool active = item['active'];

                return Column(
                  children: [
                    ButtonTextWidget(
                      action: () => alterActive(category),
                      width: 60,
                      height: 50,
                      icon: item['icon'],
                      iconSize: 30,
                      backgroundColor: active ? AppColors.green_300 : AppColors.white,
                      textColor: AppColors.blue_500,
                      borderRadius: 15,
                      shadow: true,
                    ),
                    Container(
                      width: 60,
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        category,
                        style: Theme.of( context).textTheme.displayMedium!.copyWith(
                          color: AppColors.blue_500,
                          fontWeight: FontWeight.bold
                        ),
                        textAlign: TextAlign.center,
                      ),
                    )
                  ],
                );
              }).toList(),
            );
          }),
        ),
      ),
    );
  }
}