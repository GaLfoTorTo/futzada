import 'package:futzada/theme/app_icones.dart';
import 'package:futzada/widget/cards/card_ads.dart';
import 'package:futzada/widget/inputs/input_text_widget.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:futzada/helpers/app_helper.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/models/user_model.dart';
import 'package:futzada/widget/cards/card_day_event_widget.dart';
import 'package:futzada/widget/images/img_circle_widget.dart';
import 'package:futzada/controllers/home_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //CONTROLLER DO HOME PAGE
  HomeController homeController = HomeController.instance;
  //DEFINIR USUARIO LOGADO
  late UserModel? user;

  @override
  void initState() {
    super.initState();
    //RESGATAR USUARIO
    user = Get.find<UserModel>(tag: 'user');
  }
  
  @override
  Widget build(BuildContext context) {
    //RESGATAR DIMENSOES DO DISPOSITIVO
    var dimensions = MediaQuery.of(context).size;

    return Column(
      children: [
        //CARD USUARIO
        Container(
          padding: const EdgeInsets.all(10.0),
          margin: const EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
            color: AppColors.green_300,
            borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: AppColors.dark_500.withAlpha(50),
                spreadRadius: 0.5,
                blurRadius: 5,
                offset: const Offset(2, 5),
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.only(bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 10.0),
                          child: ImgCircularWidget(
                            width: 60, 
                            height: 60,
                            image: user?.photo,
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppHelper.saudacaoPeriodo(),
                              style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                                color: AppColors.blue_500
                              )
                            ),
                            Text(
                              '${user!.firstName?.capitalize} ${user!.lastName?.capitalize}',
                              style: Theme.of(context).textTheme.labelLarge!.copyWith(
                                color: AppColors.blue_500
                              )
                            )
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              //ADS - PROPAGANDAS
              if(homeController.ads.isNotEmpty)...[
                CardAds()
              ]
            ]
          )
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              CardDayEventWidget(
                event: homeController.userEvents[0],
              ),
            ],
          ),
        )
      ]
    );
  }
}