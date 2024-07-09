import 'package:flutter/material.dart';
import 'package:futzada/controllers/cadastro_controller.dart';
import 'package:futzada/pages/cadastro/apresentacao_step.dart';
import 'package:futzada/pages/cadastro/conclusao_step.dart';
import 'package:futzada/pages/cadastro/dados_basicos_step.dart';
import 'package:futzada/pages/cadastro/dados_login_step.dart';
import 'package:futzada/pages/cadastro/modalidades_step.dart';
import 'package:futzada/theme/app_colors.dart';

class CadastroPage extends StatefulWidget {
  const CadastroPage({super.key});

  @override
  CadastroPageState createState() => CadastroPageState();
}

class CadastroPageState extends State<CadastroPage> {
  //CONTROLADOR DE PAGINAS
  final PageController _pageController = PageController(initialPage: 0);
  //CONTROLADOR DOS INPUTS DO FORMULÁRIO
  final controller = CadastroController();
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
      appBar: AppBar(
        backgroundColor: AppColors.green_300,
        title: Text(
          title,
          style: const TextStyle(
            color: AppColors.blue_500,
            fontWeight: FontWeight.normal
          ),
        ),
        leading: BackButton(
          color: AppColors.blue_500,
          onPressed: () => {
            if(currentPage != 0){
              _alterPage(context, "Voltar")
            }else{
              Navigator.of(context).pop()
            }
          }
        ),
        elevation: currentPage != 0 ? 8 : 0,
      ),
      body: SafeArea(
        child: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          onPageChanged: (int page) {
          },
          children: [
            ApresentacaoStep(
              action: () => _alterPage(context, "Proximo"),
            ),
            DadosBasicosStep(
              proximo: () => _alterPage(context, "Proximo"),
              etapa: currentPage - 1,
              controller: controller,
            ),
            DadosLoginStepState(
              proximo: () => _alterPage(context, "Proximo"),
              voltar: () => _alterPage(context, "Voltar"),
              etapa: currentPage - 1,
              controller: controller,
            ),
            ModalidadesStep(
              proximo: () => _alterPage(context, "Proximo"),
              voltar: () => _alterPage(context, "Voltar"),
              etapa: currentPage - 1,
              controller: controller,
            ),
            ConclusaoStepState(
              proximo: () => _alterPage(context, "Proximo"),
              voltar: () => _alterPage(context, "Voltar"),
              etapa: currentPage - 1,
              controller: controller,
            ),
          ],
        ),
      ), 
    );
  }
}