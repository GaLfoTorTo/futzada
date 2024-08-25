import 'package:flutter/material.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/widget/buttons/button_text_widget.dart';

class ApresentacaoPageWiget extends StatelessWidget {
  final String image;
  final String titulo;
  final String subTitulo;
  final String buttonTitulo;
  final IconData buttonIcone;
  final String viewTitulo;
  final VoidCallback createAction;
  final VoidCallback viewAction;

  const ApresentacaoPageWiget({
    super.key,
    required this.image,
    required this.titulo,
    required this.subTitulo,
    required this.buttonTitulo,
    required this.buttonIcone,
    required this.viewTitulo, 
    required this.createAction, 
    required this.viewAction, 
  });

  @override
  Widget build(BuildContext context) {
    
    var dimensions = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Container(
        width: dimensions.width,
        color: AppColors.white,
        child: Column(
          children: [
            Container(
              height: (dimensions.height / 3) - 20,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(image),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.white.withOpacity(0.5),
                      AppColors.white,
                    ],
                    begin: Alignment.center,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),
            Container(
              height: dimensions.height / 2,
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      titulo,
                      style: const TextStyle(
                        color: AppColors.blue_500,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      subTitulo,
                      style: const TextStyle(
                        color: AppColors.blue_500,
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  ButtonTextWidget(
                    text: buttonTitulo,
                    textColor: AppColors.blue_500,
                    color: AppColors.green_300,
                    width: dimensions.width,
                    icon: buttonIcone,
                    action: createAction,
                  ),
                  ButtonTextWidget(
                    text: viewTitulo,
                    textColor: AppColors.blue_500,
                    type: 'outline',
                    width: dimensions.width,
                    action: (){},
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}