import 'package:flutter/material.dart';
import 'package:futzada/core/theme/app_colors.dart';
import 'package:futzada/core/theme/app_size.dart';
import 'package:futzada/core/helpers/player_helper.dart';

class PositionWidget extends StatelessWidget {
  final String position;
  final bool mainPosition;
  final double width;
  final double height;
  final double textSide;

  const PositionWidget({
    super.key,
    required this.position,
    this.mainPosition = false,
    this.width = 30,
    this.height = 30,
    this.textSide = AppSize.fontSm,
  });

  @override
  Widget build(BuildContext context) {
    
    return Stack(
      children: [ 
        Card(
          child: Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              color: PlayerHelper.setColorPosition(position),
              borderRadius: BorderRadius.circular(5),
            ),
            alignment: Alignment.center,
            child: Text(
              position.toUpperCase(),
              style: Theme.of(context).textTheme.labelMedium!.copyWith(
                color: !position.contains('GOL') || position.contains('PIV') ? AppColors.white : AppColors.dark_700,
                fontWeight: FontWeight.bold,
                fontSize: textSide
              ),
            ),
          ),
        ),
        if(mainPosition)...[
          Positioned(
            top: 4,
            right: 4,
            child: CustomPaint(
              size: const Size(12, 12),
              painter: TrianglePainter(
                color: !position.contains('GOL') || position.contains('PIV') ? AppColors.yellow_500 : AppColors.yellow_700
              ),
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