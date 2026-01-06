import 'package:flutter/material.dart';
import 'package:futzada/pages/onboarding/welcome_page.dart';
import 'package:futzada/pages/onboarding/introduction_page.dart';
import 'package:futzada/theme/app_animations.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/widget/buttons/button_outline_widget.dart';
import 'package:futzada/widget/buttons/button_text_widget.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => OnboardingPageState();
}

class OnboardingPageState extends State<OnboardingPage> {
  //CONTROLADOR DE PAGINAS
  final PageController pageController = PageController(initialPage: 0);
  //INDEX DE PAGINA
  late int currentPage;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //INICIALIZAR CURRENT PAGE
    currentPage = 0;
  }

  //FUNÇÃO PARA ALTERAÇÃO DE PÁGINAS
  void alterPage(context, String action) {
    setState(() {
      if(currentPage == 4){
        //NAVEGAR PARA HOME PAGE
        Navigator.pushReplacementNamed(context, "/home");
      }else{
        //ADICIONAR TITULO
        currentPage = action == "Proximo" ? currentPage + 1 : currentPage - 1;
      }
    });
    //ALTERAR PAGINA
    pageController.animateToPage(
      currentPage,
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  @override
  Widget build(BuildContext context) {
    //LISTA DE OPTIONS PARA O CARD PERTO DE VOCE
    List<Map<String, dynamic>> pages = [
      {
        'title':"Gerenciar suas peladas nunca foi tão fácil!",
        'descricao':"Com uma gama de funcionalidades e uma interface amigável e intuitiva, suas peladas nunca mais serão as mesmas.",
        'animation':AppAnimations.introductionPhone
      },
      {
        'title':"Ta afim de um Fut ?",
        'descricao':"Encontre peladas rolando na sua redondeza em tempo real ou marcadas para acontecer em alguma data ou local especifico.",
        'animation':AppAnimations.introductionEscalation
      },
      {
        'title':"Quem manda é o professor!",
        'descricao':"No Futzada, você pode mostrar que é o craque também com a prancheta. Monte o time ideal da pelada com os melhores na sua escalação.",
        'animation':AppAnimations.introductionManager
      },
      {
        'title': "Você é o craque da pelada ?",
        'descricao':"Prove que é o melhor com a bola no pé demonstrando toda sua habilidade pontuando com suas ações em campo.",
        'animation':AppAnimations.introductionPlayer
      }
    ];

    Widget? buildIndicator() {
      if(currentPage > 0){
        //VERIFICAR PAGINA ATUAL
        return Container(
          padding: const EdgeInsets.all(15),
          color: AppColors.green_300,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ButtonOutlineWidget(
                text: "Pular",
                textColor: AppColors.blue_500,
                backgroundColor: AppColors.white,
                width: 100,
                action: () => Get.toNamed('/home'),
              ),
              SmoothPageIndicator(
                controller: pageController,
                count: 5,
                effect: const ExpandingDotsEffect(
                  dotHeight: 8,
                  dotWidth: 8,
                  activeDotColor: AppColors.blue_500,
                  dotColor: AppColors.white,
                  expansionFactor: 2,
                ),
              ),
              ButtonTextWidget(
                text: currentPage == 4 ? "Começar" : null,
                textColor: AppColors.white,
                icon: currentPage != 4 ? Icons.chevron_right : null,
                iconSize: 30,
                iconAfter: true,
                backgroundColor: AppColors.blue_500,
                width: currentPage == 4 ? 100 : null,
                action: () {
                  if(currentPage != 4){
                    alterPage(context, "Proximo");
                  }else{
                    Get.toNamed('/home');
                  }
                }
              ),
            ],
          ),
        ); 
      }
      return null;
    }

    return Scaffold(
      backgroundColor: AppColors.green_300,
      body: SafeArea(
        child: PageView(
          controller: pageController,
          onPageChanged: (int page){
            setState(() {
              currentPage = page;
            });
          },
          children: [
            WelcomePage(
              action: () => alterPage(context, "Proximo")
            ),
            ...pages.map((item){
              return
                IntroductionPage(
                  item: item,
                  pageController: pageController,
                  pageIndex: currentPage,
                  action: () => alterPage(context, "Proximo")
                );
            }).toList()
          ],
        ),
      ),
      bottomSheet: buildIndicator()
    );
  }
}