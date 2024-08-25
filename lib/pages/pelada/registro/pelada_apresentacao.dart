import 'package:flutter/material.dart';
import 'package:futzada/controllers/pelada_controller.dart';
import 'package:futzada/pages/apresentacao_page.dart';
import 'package:futzada/pages/pelada/registro/dados_basicos_step.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/theme/app_icones.dart';
import 'package:futzada/theme/app_images.dart';
import 'package:futzada/widget/bars/header_widget.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class PeladaApresentacaoState extends StatefulWidget {
  final VoidCallback actionButton;
  
  const PeladaApresentacaoState({
    super.key,
    required this.actionButton,
  });

  @override
  State<PeladaApresentacaoState> createState() => PeladaPageStateState();
}

class PeladaPageStateState extends State<PeladaApresentacaoState> {
  //CONTROLADOR DE PAGINAS
  final PageController _pageController = PageController(initialPage: 0);
  //CONTROLADOR DOS INPUTS DO FORMULÁRIO
  final controller = PeladaController();
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
          title: 'Peladas',
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
              image: AppImages.capaPelada,
              titulo: 'Nunca foi tão facil organizar suas peladas',
              subTitulo: 'Sua pelada agora está na palma da suas mãos! Organize e gerencie suas peladas entre os amigos de forma simples e colaborativa.',
              buttonTitulo: 'Criar nova pelada',
              buttonIcone: LineAwesomeIcons.plus_circle_solid,
              viewTitulo: 'Ver minhas peladas',
              createAction: () => _alterPage(context, "Proximo"),
              viewAction: () => _alterPage(context, "Proximo"),
            ),
            DadosBasicosStep(
              proximo: () => _alterPage(context, "Proximo"),
              etapa: currentPage - 1,
              controller: controller,
            ),
          ],
        ),
      ), 
    );
  }
}