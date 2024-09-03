import 'package:flutter/material.dart';
import 'package:futzada/pages/apresentacao_page.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/theme/app_icones.dart';
import 'package:futzada/theme/app_images.dart';
import 'package:futzada/widget/bars/header_widget.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class ExplorePageState extends StatefulWidget {
  final VoidCallback actionButton;
  
  const ExplorePageState({
    super.key,
    required this.actionButton,
  });

  @override
  State<ExplorePageState> createState() => ExplorePageStateState();
}

class ExplorePageStateState extends State<ExplorePageState> {
  //CONTROLADOR DE PAGINAS
  final PageController _pageController = PageController(initialPage: 0);
  //TITULO
  String title = "";
  //INDEX DE PAGINA
  int currentPage = 0;
  //FUNÇÃO PARA ALTERAÇÃO DE PÁGINAS
  void _alterPage(context, String action) {
    setState(() {
      //ADICIONAR TITULO
      currentPage = action == "Proximo" ? currentPage + 1 : currentPage - 1;
    });
    //ALTERAR PAGINA
    _pageController.animateToPage(
      currentPage,
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.light,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: HeaderWidget(
          title: 'Explore',
          leftAction: () => widget.actionButton(),
        )
      ),
      body: SafeArea(
        child: Container()
      ), 
    );
  }
}