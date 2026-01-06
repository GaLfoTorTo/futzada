import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lottie/lottie.dart';
import 'package:futzada/theme/app_colors.dart';

class IntroductionPage extends StatefulWidget {
  final Map<String, dynamic> item;
  final PageController pageController;
  final int pageIndex;
  final VoidCallback action;

  const IntroductionPage({
    super.key,
    required this.item,
    required this.pageController,
    required this.pageIndex,
    required this.action,
  });

  @override
  State<IntroductionPage> createState() => _IntroductionPageState();
}

class _IntroductionPageState extends State<IntroductionPage> {
  //CONTROLADORES DE ANIMAÇÕES
  bool _isVisible = false;
  double _titleOffset = 0.5;
  double _descriptionOffset = 0.5;
  double _lottieScale = 0.8;
  bool _isCurrentPage = false;

  @override
  void initState() {
    super.initState();
    widget.pageController.addListener(_handlePageChange);
    
    //VERIFICAR SE ESTA NA PAGINA INICIAL DO ONBORADING
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _isCurrentPage = widget.pageController.page?.round() == widget.pageIndex;
      if (_isCurrentPage) {
        _startAnimations();
      }
    });
  }
  //INICIAR OU RESETAR ANIMAÇÃO NA MUDANÇA DE PAGINA
  void _handlePageChange() {
    //RESGATAR PAGINA ATUAL
    final newCurrentPage = widget.pageController.page?.round() == widget.pageIndex;
    //VERIFICAR SE PAGINA JÁ FOI EXIBIDA
    if (newCurrentPage != _isCurrentPage) {
      //ATUALIZAR INDEX DA PAGINA ATUAL
      setState(() {
        _isCurrentPage = newCurrentPage;
      });
      //INICIAR OU RESETAR ANIMAÇÃO
      if (_isCurrentPage) {
        _startAnimations();
      } else {
        _resetAnimations();
      }
    }
  }

  //FUNÇÃO PARA INICIAR ANIMAÇÃO
  void _startAnimations() {
    setState(() {
      _isVisible = true;
    });

    //DELAY DE ANIMAÇÃO DO TITULO
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) {
        setState(() {
          _titleOffset = 0.0;
        });
      }
    });

    //DELAY DE ANIMAÇÃO DE DESCRIÇÃO
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) {
        setState(() {
          _descriptionOffset = 0.0;
        });
      }
    });

    //DELAY DE ANIMAÇÃO DE LOTTIE
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) {
        setState(() {
          _lottieScale = 1.0;
        });
      }
    });
  }

  //RESETAR ANIMAÇÃO
  void _resetAnimations() {
    setState(() {
      _isVisible = false;
      _titleOffset = 0.5;
      _descriptionOffset = 0.5;
      _lottieScale = 0.8;
    });
  }

  @override
  void dispose() {
    widget.pageController.removeListener(_handlePageChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AnimatedSlide(
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeOutBack,
            offset: Offset(0, _titleOffset),
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 600),
              opacity: _isVisible ? 1.0 : 0.0,
              child: Text(
                widget.item['title'],
                style: Theme.of(context)
                  .textTheme
                  .headlineLarge!
                  .copyWith(color: AppColors.blue_500),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          AnimatedSlide(
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeOutBack,
            offset: Offset(0, _descriptionOffset),
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 800),
              opacity: _isVisible ? 1.0 : 0.0,
              child: Text(
                widget.item['descricao'],
                style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: AppColors.blue_500),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          
          // Animação Lottie com escala e fade
          Padding(
            padding: const EdgeInsets.only(bottom: 50),
            child: AnimatedScale(
              duration: const Duration(milliseconds: 1000),
              scale: _lottieScale,
              curve: Curves.elasticOut,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 1000),
                opacity: _isVisible ? 1.0 : 0.0,
                child: Lottie.asset(
                  widget.item['animation'],
                  fit: BoxFit.fill,
                  
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}