import 'package:flutter/material.dart';
import 'package:futzada/theme/app_colors.dart';

class TermosUso extends StatelessWidget {
  const TermosUso({super.key});

  @override
  Widget build(BuildContext context) {

    final List<String> uso_licenca = [
      "Usar os materiais para qualquer finalidade comercial ou para exibição pública (comercial ou não comercial); ",
      "Tentar descompilar ou fazer engenharia reversa de qualquer software contido no site Futzada; ",
      "Remover quaisquer direitos autorais ou outras notações de propriedade dos materiais;",
      "Transferir os materiais para outra pessoa ou 'espelhe' os materiais em qualquer outro servidor.",
    ];

    return SingleChildScrollView(
      child: SizedBox(
        width: double.maxFinite,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "1. Termos",
                style: TextStyle(
                  color: AppColors.green_300,
                  fontSize: 15,
                  fontWeight: FontWeight.normal
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  "Ao acessar ao site Futzada, concorda em cumprir estes termos de serviço, todas as leis e regulamentos aplicáveis ​​e concorda que é responsável pelo cumprimento de todas as leis locais aplicáveis. Se você não concordar com algum desses termos, está proibido de usar ou acessar este site. Os materiais contidos neste site são protegidos pelas leis de direitos autorais e marcas comerciais aplicáveis.",
                  style: TextStyle(
                    color: AppColors.gray_500,
                    fontSize: 12,
                    fontWeight: FontWeight.normal
                  ),
                ),
              ),
              const Text(
                "2. Uso de Licença",
                style: TextStyle(
                  color: AppColors.green_300,
                  fontSize: 15,
                  fontWeight: FontWeight.normal
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  "É concedida permissão para baixar temporariamente uma cópia dos materiais (informações ou software) no site Futzada , apenas para visualização transitória pessoal e não comercial. Esta é a concessão de uma licença, não uma transferência de título e, sob esta licença, você não pode:",
                  style: TextStyle(
                    color: AppColors.gray_500,
                    fontSize: 12,
                    fontWeight: FontWeight.normal
                  ),
                ),
              ),
              Container(
                width: double.maxFinite,
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                child: Column(
                  children: [
                    for(var item in uso_licenca)
                      Row(
                        children: [
                          Container(
                            width: 5,
                            height: 5,
                            decoration: BoxDecoration(
                              color: AppColors.gray_500,
                              borderRadius: BorderRadius.circular(10)
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Text(
                                item,
                                style: TextStyle(
                                  color: AppColors.gray_500,
                                  fontSize: 12,
                                  fontWeight: FontWeight.normal
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                  ],
                )
              ),
              const Text(
                "Esta licença será automaticamente rescindida se você violar alguma dessas restrições e poderá ser rescindida por Futzada a qualquer momento. Ao encerrar a visualização desses materiais ou após o término desta licença, você deve apagar todos os materiais baixados em sua posse, seja em formato eletrônico ou impresso.",
                style: TextStyle(
                  color: AppColors.gray_500,
                  fontSize: 12,
                  fontWeight: FontWeight.normal
                ),
              ),
              const Text(
                "3. Isenção de responsabilidade",
                style: TextStyle(
                  color: AppColors.green_300,
                  fontSize: 15,
                  fontWeight: FontWeight.normal
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  "Os materiais no site da Futzada são fornecidos 'como estão'. Futzada não oferece garantias, expressas ou implícitas, e, por este meio, isenta e nega todas as outras garantias, incluindo, sem limitação, garantias implícitas ou condições de comercialização, adequação a um fim específico ou não violação de propriedade intelectual ou outra violação de direitos. Além disso, o Futzada não garante ou faz qualquer representação relativa à precisão, aos resultados prováveis ​​ou à confiabilidade do uso dos materiais em seu site ou de outra forma relacionado a esses materiais ou em sites vinculados a este site.",
                  style: TextStyle(
                    color: AppColors.gray_500,
                    fontSize: 12,
                    fontWeight: FontWeight.normal
                  ),
                ),
              ),
              const Text(
                "4. Limitações",
                style: TextStyle(
                  color: AppColors.green_300,
                  fontSize: 15,
                  fontWeight: FontWeight.normal
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  "Em nenhum caso o Futzada ou seus fornecedores serão responsáveis ​​por quaisquer danos (incluindo, sem limitação, danos por perda de dados ou lucro ou devido a interrupção dos negócios) decorrentes do uso ou da incapacidade de usar os materiais em Futzada, mesmo que Futzada ou um representante autorizado da Futzada tenha sido notificado oralmente ou por escrito da possibilidade de tais danos. Como algumas jurisdições não permitem limitações em garantias implícitas, ou limitações de responsabilidade por danos consequentes ou incidentais, essas limitações podem não se aplicar a você.",
                  style: TextStyle(
                    color: AppColors.gray_500,
                    fontSize: 12,
                    fontWeight: FontWeight.normal
                  ),
                ),
              ),
              const Text(
                "5. Precisão dos materiais",
                style: TextStyle(
                  color: AppColors.green_300,
                  fontSize: 15,
                  fontWeight: FontWeight.normal
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  "Os materiais exibidos no site da Futzada podem incluir erros técnicos, tipográficos ou fotográficos. Futzada não garante que qualquer material em seu site seja preciso, completo ou atual. Futzada pode fazer alterações nos materiais contidos em seu site a qualquer momento, sem aviso prévio. No entanto, Futzada não se compromete a atualizar os materiais.",
                  style: TextStyle(
                    color: AppColors.gray_500,
                    fontSize: 12,
                    fontWeight: FontWeight.normal
                  ),
                ),
              ),
              const Text(
                "6. Links",
                style: TextStyle(
                  color: AppColors.green_300,
                  fontSize: 15,
                  fontWeight: FontWeight.normal
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  "O Futzada não analisou todos os sites vinculados ao seu site e não é responsável pelo conteúdo de nenhum site vinculado. A inclusão de qualquer link não implica endosso por Futzada do site. O uso de qualquer site vinculado é por conta e risco do usuário.",
                  style: TextStyle(
                    color: AppColors.gray_500,
                    fontSize: 12,
                    fontWeight: FontWeight.normal
                  ),
                ),
              ),
              const Text(
                "Modificações",
                style: TextStyle(
                  color: AppColors.green_300,
                  fontSize: 15,
                  fontWeight: FontWeight.normal
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  "O Futzada pode revisar estes termos de serviço do site a qualquer momento, sem aviso prévio. Ao usar este site, você concorda em ficar vinculado à versão atual desses termos de serviço.\nLei aplicável\nEstes termos e condições são regidos e interpretados de acordo com as leis do Futzada e você se submete irrevogavelmente à jurisdição exclusiva dos tribunais naquele estado ou localidade.",
                  style: TextStyle(
                    color: AppColors.gray_500,
                    fontSize: 12,
                    fontWeight: FontWeight.normal
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}