import 'package:futzada/helpers/app_helper.dart';
import 'package:futzada/models/participant_model.dart';
import 'package:futzada/theme/app_icones.dart';
import 'package:futzada/widget/images/img_circle_widget.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/controllers/game_controller.dart';
import 'package:futzada/widget/cards/card_player_team_widget.dart';

class BottomSheetGamePlayers extends StatefulWidget {
  final int team;
  final int qtdPlayers;
  const BottomSheetGamePlayers({
    super.key,
    required this.team,
    required this.qtdPlayers
  });

  @override
  State<BottomSheetGamePlayers> createState() => _BottomSheetGamePlayersState();
}

class _BottomSheetGamePlayersState extends State<BottomSheetGamePlayers> {
  //CONTROLLER DE REGISTRO DA PELADA
  final gameController = GameController.instance;
  //OBSERVAR PARTICIPANTES SELECIONADOS
  late List<ParticipantModel>? participants;
  //DEFINIR ARRAY DE SELECIONADOS
  late RxList<ParticipantModel?> selectedPlayers = <ParticipantModel?>[].obs;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // RESGATAR PARTICIPANTES DO EVENTO
    final allParticipants = gameController.event.participants!;
    // FILTRAR SOMENTE OS PARTICIPANTES QUE NÃO ESTÃO EM NENHUM TIME
    participants = allParticipants
      .where((p) =>
        !gameController.teamA.players.contains(p) &&
        !gameController.teamB.players.contains(p))
      .toList()
      .obs;
    //RESGATAR JOGADOR DO TIME RECEBIDO
    selectedPlayers.value = widget.team == 0 
      ? gameController.teamA.players
      : gameController.teamB.players; 
  }

  //FUNÇÃO PARA DEFINIR PARTICIPANTE NA EQUIPE
  void setPlayerTeam(ParticipantModel participant, String action){
    //VERIFICAR AÇÃO 
    if(action == 'add'){
      //VERIFICAR SE TIME JA ATINGIO O LIMITE DE JOGADORES POR EQUIPE
      if(selectedPlayers.length < widget.qtdPlayers){
        //VERIFICAR SE PARTICIPANT JA FOI ADICIONADO AO TIME
        if (!selectedPlayers.contains(participant)) {
          //ADICIONAR JOGADOR AO ARRAY DO TIME
          selectedPlayers.add(participant);
          //REMOVER PARTICIPANTE DA LISA
          participants!.remove(participant);
        }
      }else{
        //FECHAR DIALOG
        Get.back();
        //MENSAGEM DE ERRO DE LIMITE DE JOGADORES
        AppHelper.feedbackMessage(context, "A equipe ja atingiu o número de jogadores!", type: "danger");
      }
    }else{
      //VERIFICAR SE PARTICIPANT JA FOI ADICIONADO AO TIME
      if (selectedPlayers.contains(participant)) {
        //REMOVER JOGADOR DO ARRAY DO TIME
        selectedPlayers.remove(participant);
        //ADICIONAR PARTICIPANTE DA LISA
        participants!.insert(0, participant);
      }
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).dialogTheme.backgroundColor,
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15))
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                const BackButton(),
                Padding(
                  padding: const EdgeInsets.only(left: 90),
                  child: Text(
                    'Participantes',
                    style: Theme.of(context).textTheme.headlineMedium,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            child: Text(
              'Escolha os jogadores que iram compor as equipes da partida',
              style: Theme.of(Get.context!).textTheme.bodyMedium!.copyWith(
                color: AppColors.gray_500,
              ),
              textAlign: TextAlign.center
            ),
          ),
          Obx((){
            if(selectedPlayers.isNotEmpty){
              return Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                        ...selectedPlayers.map((participant){
                          return InkWell(
                            onTap: () => setPlayerTeam(participant, 'remove'),
                            child: Stack(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                  child: ImgCircularWidget(
                                    width: 50, 
                                    height: 50,
                                    image: participant!.user.photo,
                                  ),
                                ),
                                const Positioned(
                                  right: 5,
                                  bottom: 0,
                                  child: Icon(
                                    AppIcones.times_circle_solid,
                                    color: AppColors.gray_300,
                                    size: 15,
                                  ),
                                )
                              ],
                            ),
                          );
                        }),
                    ]
                  ),
                )
              );
            }else{
              return SizedBox.shrink();
            }
          }),
          Expanded(
            child: Obx(() => Padding(
              padding: const EdgeInsets.all(10.0),
              child: ListView(
                children: participants!.map((participant) {
                  //VERIFICAR SE PARTICIPANTE ESTA HABILITADO COMO JOGADOR
                  if(participant.user.player != null){
                    return CardPlayerTeamWidget(
                      participant: participant,
                      onPressed: () => setPlayerTeam(participant, 'add'),
                    );
                  }
                  return SizedBox.shrink();
                }).toList(),
              ),
            )),
          ),
        ],
      ),
    );
  }
}