import 'package:flutter/material.dart';
import 'package:esportly/presentation/controllers/home_controller.dart';
import 'package:esportly/presentation/widget/buttons/button_text_widget.dart';

class HomeErrorPage extends StatelessWidget {
  const HomeErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController homeController = HomeController.instance;
    //RESGATAR DIMENSÕES DO DISPOSITIVO
    var dimensions = MediaQuery.of(context).size;
    
    return Container(
      width: dimensions.width,
      height: dimensions.height - 150,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).cardTheme.color!.withAlpha(50),
            Theme.of(context).cardTheme.color!,
          ],
          begin: Alignment.topCenter,
          end: Alignment.center,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text(
              'Ops! Houve um erro ao carregar o app.',
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
          ),
          Icon(
            Icons.no_cell_rounded,
            size: 200,
            color: Theme.of(context).iconTheme.color,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Text(
              'Parece que houve um erro ao carregar o app. Verifique sua conexão de internet e tente novamente.',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ),
          Column(
            children: [
              ButtonTextWidget(
                text: "Recarregar",
                width: dimensions.width,
                icon: Icons.restart_alt_rounded,
                iconSize: 30,
                action: () => homeController.fetchHome(),
              ),
            ],
          )
        ],
      ),
    );
  }
}