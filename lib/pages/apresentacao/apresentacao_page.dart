import 'package:flutter/material.dart';
import 'package:futzada/pages/apresentacao/boas_vindas_view_page.dart';
import 'package:futzada/pages/apresentacao/introducao_page.dart';
import 'package:futzada/theme/app_animations.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/widget/buttons/button_outline_widget.dart';
import 'package:futzada/widget/buttons/button_text_widget.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ApresentacaoPage extends StatefulWidget {
  const ApresentacaoPage({super.key});

  @override
  State<ApresentacaoPage> createState() => ApresentacaoPageStateState();
}

class ApresentacaoPageStateState extends State<ApresentacaoPage> {
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
      if(currentPage == 3){
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
        'descricao':"Gerenciar suas peladas nunca foi tão fácil! Com uma gama de funcionalidades e uma interface amigável e intuitiva, suas peladas nunca mais serão as mesmas.",
        'animation':AppAnimations.introducaoCelular
      },
      {
        'descricao':"Ta afim de um Fut ? Encontre peladas rolando na sua redondeza em tempo real ou marcadas para acontecer em alguma data ou local especifico.",
        'animation':AppAnimations.introducaoEstadio
      },
      {
        'descricao':"No Futzada, você pode mostrar que não é o craque apenas em campo mas também com a prancheta. Monte o time ideal da pelada com os melhores na sua escalação.",
        'animation':AppAnimations.introducaoTecnico
      },
      {
        'descricao':"Você por acaso é o craque da pelada ? Prove que é o melhor com a bola no pé demonstrando toda sua habilidade pontuando com suas ações em campo.",
        'animation':AppAnimations.introducaoJogador
      }
    ];

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
            BoasVindasViewPage(
              action: () => alterPage(context, "Proximo")
            ),
            for(var i = 0; i < pages.length; i++)
              IntroducaoPage(
                descricao: pages[i]['descricao'],
                animation: pages[i]['animation'],
                pageController: pageController,
                action: () => alterPage(context, "Proximo")
              ),
          ],
        ),
      ),
      bottomSheet: currentPage > 0 
        ? Container(
            padding: const EdgeInsets.all(15),
            color: AppColors.green_300,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ButtonOutlineWidget(
                  text: "Pular",
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
                  text: currentPage != 4 ? "Começar" : null,
                  textColor: AppColors.white,
                  icon: currentPage == 4 ? Icons.chevron_right : null,
                  backgroundColor: AppColors.blue_500,
                  width: 100,
                  action: () {
                    if(currentPage == 4){
                      alterPage(context, "Proximo");
                    }else{
                      Get.toNamed('/home');
                    }
                  }
                ),
              ],
            ),
          )
        : null
    );
  }
}