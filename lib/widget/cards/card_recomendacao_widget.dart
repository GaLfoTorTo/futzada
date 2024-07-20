import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/theme/app_icones.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class CardRecomendacaoWidget extends StatefulWidget {
  final List<Map<String, dynamic>> options;
  const CardRecomendacaoWidget({
    super.key,
    required this.options
  });

  @override
  State<CardRecomendacaoWidget> createState() => _CardRecomendacaoWidgetState();
}

class _CardRecomendacaoWidgetState extends State<CardRecomendacaoWidget> {
  //CONTROLLADOR DE PAGINAS
  final PageController pageController = PageController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Perto de Você',
                style: TextStyle(
                  color: AppColors.blue_500,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),  
              Text(
                'Ver Mais',
                style: TextStyle(
                  color: AppColors.red_500,
                  fontSize: 15,
                  fontWeight: FontWeight.normal,
                ),
              ) 
            ]
          ),
        ),
        Center(
          child: Container(
            height: 450,
            child: PageView(
              controller: pageController,
              children: widget.options.map((item) {
                return Container(
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.gray_300.withOpacity(0.5),
                        spreadRadius: 0.8,
                        blurRadius: 7,
                        offset: Offset(5, 5),
                      ),
                    ],
                    image: DecorationImage(
                      image: NetworkImage(item['image']),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: item['gradient']
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 40),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Text(
                            item['titulo'],
                            style: TextStyle(
                              color: item['textColor'],
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            SvgPicture.asset(
                              AppIcones.location['fas']!,
                              width: 20,
                              height: 20,
                              color: item['textColor'],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Text(
                                item['distancia'],
                                style: TextStyle(
                                  color: item['textColor'],
                                  fontSize: 15,
                                  fontWeight: FontWeight.normal,
                                ),
                                
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: SmoothPageIndicator(
            controller: pageController,
            count: 5,
            effect: const ExpandingDotsEffect(
                dotHeight: 8,
                dotWidth: 8,
                activeDotColor: AppColors.blue_500,
                dotColor: AppColors.gray_300,
                expansionFactor: 2,
              ),
          ),
        ),
      ],
    );
  }
}