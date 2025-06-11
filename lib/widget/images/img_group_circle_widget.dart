import 'package:flutter/material.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/theme/app_images.dart';
import 'package:futzada/widget/images/img_circle_widget.dart';

class ImgGroupCircularWidget extends StatelessWidget {
  final double width;
  final double height;
  final List<dynamic>? images;
  final Color? borderColor;
  final String side;

  const ImgGroupCircularWidget({
    super.key, 
    required this.width, 
    required this.height,
    this.images,
    this.borderColor,
    this.side = "right"
  });

  @override
  Widget build(BuildContext context) {
    final imgs = images ?? const [AppImages.userDefault, AppImages.userDefault];
    
    return Container(
      width: width + (imgs.length - 1) * (width - 10),
      height: height,
      alignment: side == "left" ? Alignment.centerRight : Alignment.centerLeft,
      child: Stack(
        children: _buildStackChildren(imgs),
      ), 
    );
  }

  List<Widget> _buildStackChildren(List<dynamic> imgs) {
    final children = <Widget>[];
    
    for (int i = 0; i < imgs.length; i++) {
      final index = side == "left" ? imgs.length - 1 - i : i;
      final position = i * 20.0;
      
      children.add(
        Positioned(
          left: side == "right" ? position : null,
          right: side == "left" ? position : null,
          child: ImgCircularWidget(
            width: width ,
            height: height ,
            image: images != null ? imgs[index] : null,
            borderColor: borderColor,
          ),
        ),
      );
    }
    
    return children;
  }
}