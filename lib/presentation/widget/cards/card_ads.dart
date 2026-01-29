import 'package:flutter/material.dart';
import 'package:futzada/presentation/controllers/home_controller.dart';
import 'package:futzada/core/theme/app_colors.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class CardAds extends StatefulWidget {
  const CardAds({super.key});

  @override
  State<CardAds> createState() => _CardAdsState();
}

class _CardAdsState extends State<CardAds> {
  //RESGATAR CONTROLADOR DE HOME
  HomeController homeController = HomeController.instance;
  //LISTA DE 
  List<Map<String,dynamic>> ads = []; 
  //CONTROLLADOR DE ADS
  late PageController adsController;
  
  @override
  void initState() {
    super.initState();
    //INICIALIZAR CONTROLLER DE HIGHLIGHTS
    adsController = PageController();
    //RESGATAR DESTAQUES DO EVENTO
    ads = homeController.ads;
  }

  @override
  Widget build(BuildContext context) {
    //RESGATAR DIMENSOES DO DISPOSITIVO
    var dimensions = MediaQuery.of(context).size;

    return Column(
      children: [
        SizedBox(
          width: dimensions.width,
          height: 200,
          child: PageView(
            controller: adsController,
            children: [
              ...ads.map((item) {

                return Container(
                  width: dimensions.width,
                  height: 150,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(20)
                  ),
                );
              }),
            ]
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: SmoothPageIndicator(
            controller: adsController,
            count: ads.length,
            effect: const ExpandingDotsEffect(
              dotHeight: 8,
              dotWidth: 8,
              activeDotColor: AppColors.blue_500,
              dotColor: AppColors.grey_300,
              expansionFactor: 2,
            ),
          ),
        ),
      ],
    );
  }
}