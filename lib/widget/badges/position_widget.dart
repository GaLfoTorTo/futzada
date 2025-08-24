import 'package:flutter/material.dart';
import 'package:futzada/helpers/app_helper.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/theme/app_size.dart';

class PositionWidget extends StatelessWidget {
  final String position;
  final bool mainPosition;
  final double size;

  const PositionWidget({
    super.key,
    required this.position,
    this.mainPosition = false,
    this.size = 30
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [ 
        Container(
          width: mainPosition ? 50 : 30,
          height: mainPosition ? 30 : 20,
          decoration: BoxDecoration(
            color: AppHelper.setColorPosition(position),
            borderRadius: BorderRadius.circular(5),
            boxShadow: [
              BoxShadow(
                color: AppColors.dark_500.withAlpha(50),
                spreadRadius: 0.2,
                blurRadius: 2,
                offset: Offset(2, 3),
              ),
            ]
          ),
          alignment: Alignment.center,
          child: Text(
            position.toUpperCase(),
            style: Theme.of(context).textTheme.labelMedium!.copyWith(
              color: position != 'gol' ? AppColors.white : AppColors.dark_700,
              fontWeight: FontWeight.bold,
              fontSize: mainPosition ? AppSize.fontSm : AppSize.fontXxs
            ),
          ),
        ),
        if(mainPosition)...[
          Positioned(
            top: 0,
            right: 0,
            child: CustomPaint(
              size: const Size(12, 12),
              painter: TrianglePainter(color: AppColors.yellow_500),
            ),
          ),
        ]
      ]
    );
  }
}

// Classe para pintar o triângulo
class TrianglePainter extends CustomPainter {
  final Color color;

  TrianglePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, 0);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}