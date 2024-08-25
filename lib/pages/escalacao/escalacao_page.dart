import 'package:flutter/material.dart';
import 'package:futzada/pages/apresentacao_page.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/theme/app_icones.dart';
import 'package:futzada/theme/app_images.dart';
import 'package:futzada/widget/bars/header_widget.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class EscalacaoPageState extends StatefulWidget {
  final VoidCallback actionButton;
  
  const EscalacaoPageState({
    super.key,
    required this.actionButton,
  });

  @override
  State<EscalacaoPageState> createState() => EscalacaoPageStateState();
}

class EscalacaoPageStateState extends State<EscalacaoPageState> {
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
      title = currentPage == 0 ? "" : "Cadastro";
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
          title: 'Escalações',
          action: () => widget.actionButton(),
        )
      ),
      body: SafeArea(
        child: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          onPageChanged: (int page) {
          },
          children: [
            ApresentacaoPageWiget(
              image: AppImages.capaEscalacao,
              titulo: 'Monte o seu time ideal da pelada',
              subTitulo: 'Escale os melhores jogadores da pelada para sua equipe e fique no topo dos rankings da pelada.',
              buttonTitulo: 'Começar Escalar',
              buttonIcone: LineAwesomeIcons.clipboard,
              viewTitulo: 'Ver minhas escalações',
              createAction: () => {},
              viewAction: () => {},
            )
          ],
        ),
      ), 
    );
  }
}