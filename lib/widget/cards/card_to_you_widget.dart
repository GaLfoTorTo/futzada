import 'package:flutter/material.dart';
import 'package:futzada/models/event_model.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/theme/app_images.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CardToYouWidget extends StatelessWidget {
  final List<Map<String, dynamic>> events;
  final PageController pageController;
  
  const CardToYouWidget({
    super.key, 
    required this.events,
    required this.pageController
  });

  @override
  Widget build(BuildContext context) {
    
    return Center(
      child: SizedBox(
        height: 450,
        child: PageView(
          controller: pageController,
          children: events.map((item) {
            //RESGATAR EVENTO
            EventModel event = item['event'];
            //RESGATAR GRADIENTE
            LinearGradient gradient = item['gradient'];
            //RESGATAR DISTANCIA
            String distancia = item['distancia'];
            //RESGATAR COR DE TEXTO
            Color textColor = item['textColor'];
            return Container(
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.dark_500.withAlpha(50),
                    spreadRadius: 0.5,
                    blurRadius: 5,
                    offset: const Offset(2, 5),
                  ),
                ],
                image: DecorationImage(
                  image: event.photo != null 
                    ? CachedNetworkImageProvider(event.photo!) 
                    : const AssetImage(AppImages.gramado) as ImageProvider,
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: gradient
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
                        event.title!,
                        style: TextStyle(
                          color: textColor,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          color: textColor,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text(
                            distancia,
                            style: TextStyle(
                              color: textColor,
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
    );
  }
}