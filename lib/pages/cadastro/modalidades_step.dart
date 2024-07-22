import 'package:flutter/material.dart';
import 'package:futzada/controllers/cadastro_controller.dart';
import 'package:futzada/pages/cadastro/modalidade_jogador_step.dart';
import 'package:futzada/pages/cadastro/modalidade_tecnico_step.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/theme/app_icones.dart';
import 'package:futzada/widget/buttons/button_icon_widget.dart';
import 'package:futzada/widget/buttons/button_text_widget.dart';
import 'package:futzada/widget/indicators/indicator_form_widget.dart';

class ModalidadesStep extends StatefulWidget {
  final VoidCallback proximo;
  final VoidCallback voltar;
  final int etapa;
  final CadastroController controller;


  const ModalidadesStep({
    super.key, 
    required this.proximo, 
    required this.voltar, 
    required this.etapa, 
    required this.controller, 
  });

  @override
  State<ModalidadesStep> createState() => _ModalidadesStepState();
}

class _ModalidadesStepState extends State<ModalidadesStep> {
  int currentPage = 0;
  final PageController _pageModalidade = PageController(initialPage: 0);

  void _alterPage(context, int page) {
    setState(() {
      currentPage = page;
    });
    _pageModalidade.animateToPage(
      page,
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  @override
  Widget build(BuildContext context) {
    var dimensions = MediaQuery.of(context).size;

    return Container(
      width: dimensions.width,
      alignment: Alignment.center,
      child: PageView(
        controller: _pageModalidade,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          SingleChildScrollView(
            child: Container(
              width: double.maxFinite,
              alignment: Alignment.center,
              padding: const EdgeInsets.all(15),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const IndicatorFormWidget(etapa: 2),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      "Modalidades",
                      style: TextStyle(
                        color: AppColors.dark_500,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      "Agora defina suas preferências para cada modalidade disponível. Escolha que tipo de atuação você terá dentro do app. Você também pode optar ambas.",
                      style: TextStyle(
                        color: AppColors.gray_500,
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          const Text(
                            "Jogador",
                            style: TextStyle(
                              color: AppColors.blue_500,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: ButtonIconWidget(
                              icon: AppIcones.chuteiras['campo']!,
                              color: AppColors.green_300,
                              dimensions: 120,
                              action: () => _alterPage(context, currentPage + 1),
                            ),
                          ),
                          Container(
                            width: 150,
                            child: const Text(
                              "Esta modalidade e voltada aos usuários que atuaram em campo ou quadras nas partidas.",
                              style: TextStyle(
                                color: AppColors.gray_500,
                                fontSize: 12,
                                fontWeight: FontWeight.normal,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          const Text(
                            "Técnico",
                            style: TextStyle(
                              color: AppColors.blue_500,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: ButtonIconWidget(
                              icon: AppIcones.prancheta['fas'],
                              iconWidth: 10,
                              iconColor: AppColors.white,
                              color: AppColors.green_300,
                              dimensions: 120,
                              action: () => _alterPage(context, currentPage + 2),
                            ),
                          ),
                          Container(
                            width: 150,
                            child: const Text(
                              "Esta modalidade e voltada aos usuários que atuaram escalando seu times nas peladas.",
                              style: TextStyle(
                                color: AppColors.gray_500,
                                fontSize: 12,
                                fontWeight: FontWeight.normal,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 80),
                    child: Text(
                      "A definição das modalidades podem ser feitas posteriores ao cadastro pórem suas ações no app serão limitadas até a conclusão.",
                      style: TextStyle(
                        color: AppColors.gray_500,
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      ButtonTextWidget(
                        type: "outline",
                        text: "Voltar",
                        textColor: AppColors.blue_500,
                        color: AppColors.blue_500,
                        width: 100,
                        action: widget.voltar,
                      ),
                      ButtonTextWidget(
                        text: "Próximo",
                        textColor: AppColors.blue_500,
                        color: AppColors.green_300,
                        width: 100,
                        action: widget.proximo,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          ModalidadeJogadorStepState(
            proximo: () => _alterPage(context, 0),
            voltar: () => _alterPage(context, 0),
            etapa: currentPage - 1,
            controller: widget.controller,
          ),
          ModalidadeTecnicoStepState(
            proximo: () => _alterPage(context, 0),
            voltar: () => _alterPage(context, 0),
            etapa: currentPage - 1,
            controller: widget.controller,
          ),
        ],
      ),
    );
  }
}