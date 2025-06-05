import 'package:flutter/material.dart';
import 'package:futzada/theme/app_colors.dart';

class AnimatedEllipsis extends StatefulWidget {
  final double dotSize;
  final Color dotColor;
  
  const AnimatedEllipsis({
    super.key,
    this.dotSize = 8.0,
    this.dotColor = AppColors.dark_500,
  });

  @override
  State<AnimatedEllipsis> createState() => _AnimatedEllipsisState();
}

class _AnimatedEllipsisState extends State<AnimatedEllipsis> with TickerProviderStateMixin {
  //CONTROLADORES DA ANIMAÇÃO
  late final List<AnimationController> _controllers;
  late final List<Animation<double>> _animations;
  late final List<Animation<double>> _opacityAnimations;

  @override
  void initState() {
    super.initState();
    
    //INICIALIZAÇÃO DOS CONTROLLERS DA ANIMAÇÃO
    _controllers = List.generate(3, (index) {
      return AnimationController(
        duration: const Duration(milliseconds: 1000),
        vsync: this,
      );
    });
    
    //CONFIGURAÇÃO DA ANIMAÇÃO
    _animations = _controllers.map((controller) {
      return Tween<double>(begin: 0, end: 10).animate(
        CurvedAnimation(
          parent: controller,
          curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
        ),
      );
    }).toList();
    //CONFIGURAÇÃO DE OPACIDADE
    _opacityAnimations = _controllers.map((controller) {
      return Tween<double>(begin: 0.2, end: 1).animate(
        CurvedAnimation(
          parent: controller,
          curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
        ),
      );
    }).toList();
    
    //INICIAR ANIMAÇÃO
    _startAnimations();
  }

  //DEFINIR DELAY ENTRE PONTOS
  void _startAnimations() {
    for (int i = 0; i < _controllers.length; i++) {
      Future.delayed(Duration(milliseconds: i * 200), () {
        _controllers[i].repeat(reverse: true);
      });
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (index) {
        return AnimatedBuilder(
          animation: _controllers[index],
          builder: (context, child) {
            return Opacity(
              opacity: _opacityAnimations[index].value,
              child: Transform.translate(
                offset: Offset(0, -_animations[index].value),
                child: Container(
                  width: widget.dotSize,
                  height: widget.dotSize,
                  margin: EdgeInsets.symmetric(horizontal: widget.dotSize / 3),
                  decoration: BoxDecoration(
                    color: widget.dotColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}