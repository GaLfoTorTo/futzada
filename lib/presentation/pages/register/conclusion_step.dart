import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:futzada/core/theme/app_colors.dart';
import 'package:futzada/presentation/controllers/register_controller.dart';
import 'package:futzada/presentation/widget/termos_politicas/termos.dart';
import 'package:futzada/presentation/widget/termos_politicas/politicas_privacidade.dart';

class ConclusionStep extends StatefulWidget {
  const ConclusionStep({super.key});

  @override
  State<ConclusionStep> createState() => _ConclusionStepStateState();
}

class _ConclusionStepStateState extends State<ConclusionStep>  with SingleTickerProviderStateMixin {
  //CONTROLADORES
  final RegisterController registerController = RegisterController.instance;
  final GlobalKey<FormState> formKeyStep4 = GlobalKey<FormState>();
  late final TabController _termosController;
  //LISTA DE INPUT CHECKED
  List<String> checked = [
    "Termos de Uso",
    "Politicas de Privacidade"
  ];

  @override
  void initState() {
    super.initState();
    _termosController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _termosController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Form(
      key: formKeyStep4,
      child: SingleChildScrollView(
        child: Column(
          spacing: 20,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              "Conclusão",
              style: Theme.of(context).textTheme.headlineLarge,
              textAlign: TextAlign.center,
            ),
            Text(
              "Estamos quase lá! Para finalizar seu cadastro, você deve aceita os termos de uso e as politicas de privacidade do app para concluir seu cadastro.",
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            Container(
              width: double.maxFinite,
              height: 500,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(10)
              ),
              child: Column(
                children: [
                  TabBar(
                    controller: _termosController,
                    tabs: const [
                      Tab(text: 'Termos de Uso'),
                      Tab(text: 'Políticas Priv.'),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: _termosController,
                      children: const [
                        TermosUso(),
                        PoliticasPrivacidade(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                children: checked.map((item){
                  return Row(
                    children: [
                      Transform.scale(
                        scale: 1.5,
                        child: Checkbox(
                          value: item == "Termos de Uso" 
                            ? registerController.termosUsoChecked 
                            : registerController.politicasChecked,
                          onChanged: (value) {
                            setState(() {
                              if(item == "Termos de Uso"){
                                //CHECKED INPUT
                                registerController.termosUsoChecked = !registerController.termosUsoChecked;
                              }else{
                                //CHECKED INPUT
                                registerController.politicasChecked = !registerController.politicasChecked;
                              }
                            });
                          },
                          activeColor: AppColors.green_300,
                        ),
                      ),
                      Text.rich(
                        TextSpan(
                          text: 'Li e aceito os ',
                          style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            color: AppColors.grey_500
                          ),
                          children: [
                            TextSpan(
                              text: item,
                              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                color: AppColors.green_300,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  );
                }).toList()
              ),
            ),
          ],
        ),
      ),
    );
  }
}