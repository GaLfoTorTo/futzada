import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/widget/images/ImgCircularWidget.dart';

class UserStackWidget extends StatelessWidget {
  final List<dynamic>? usuarios;
  final IconData? icone;
  final String? side;
  
  const UserStackWidget({
    super.key,
    required this.usuarios,
    this.icone,
    this.side = 'right',
  });

  @override
  Widget build(BuildContext context) {
    double widthUsuario = usuarios != null ? (usuarios!.length * 35) : 0;
    double widthUsuarioStack = usuarios!.length > 1 ? widthUsuario - 10 : widthUsuario;

    return LimitedBox(
      maxWidth: 110,
      maxHeight: 50,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: side == 'right' ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if(usuarios!.isNotEmpty && side == 'left' && icone != null)
            Icon(
              icone!,
              color: AppColors.white,
            ),
          Padding(
            padding: const EdgeInsets.all(5),
            child: Container(
              width: widthUsuarioStack,
              child: Stack(
                children: usuarios != null
                ? usuarios!.asMap().entries.map((entry) {
                  //RESGATAR A CHAVE DO ICONE
                    int key = entry.key;
                    //CALCULAR MEDIDA 
                    double medida = key > 0 ? (key * 25) : 0;
                    //RESGATAR O MARCADOR
                    Map<String, dynamic> usuario = entry.value;
                    return Positioned(
                      left: medida,
                      child: ImgCircularWidget(
                        width: 35,
                        height: 35,
                        image: usuario['image'],
                        borderColor: AppColors.white,
                      ),
                    );
                  }).toList()
                : [],
              ),
            ),
          ),
          if(usuarios!.isNotEmpty && side == 'right' && icone != null)
            Icon(
              icone!,
              color: AppColors.white,
            ),
        ],
      ), 
    );
  }
}