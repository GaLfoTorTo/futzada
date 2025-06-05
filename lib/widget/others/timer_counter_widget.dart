import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:futzada/services/timer_service.dart';
import 'package:futzada/theme/app_colors.dart';

class TimerCounterWidget extends StatefulWidget {
  final String startTime;
  final String endTime;

  const TimerCounterWidget({
    super.key,
    required this.startTime,
    required this.endTime,
  });

  @override
  State<TimerCounterWidget> createState() => _CounterMatchWidgetState();
}

class _CounterMatchWidgetState extends State<TimerCounterWidget> {
  //DEFINIR HORARIO DE INICIO E FIM DA PARTIDA (DATETIME)
  late DateTime startTime;
  late DateTime endTime;
  //DEFINIR SERVIÇO DE TIMER
  TimerService timerService = TimerService();
  //DEFINIR CONTROLADORES DE CONTAGEM
  late int minutesErased;

  @override
  void initState() {
    super.initState();
    //RESGATAR HORARIO DE INICIO E FIM
    startTime = DateTime(2025,06,04,12,30,00,000)/* DateFormat("HH:mm").parse(widget.startTime) */;
    endTime = DateTime(2025,06,04,12,40,00,000)/* DateFormat("HH:mm").parse(widget.endTime) */;
    //INICIALIZAR SERVIÇO DE CRONOMETRO
    timerService.initialize(startTime, endTime);
    minutesErased = timerService.getRemainingMinutes();
    //INICIALIZAR STREAM DE CONTAGEM
    timerService.minutesStream.listen((minutes) {
      //VERIFICAR MONTAGEM DO COMPONETNE
      if (mounted) {
        //ATUALIZAR MINUTOS COM REPSOSTA DO STREAM
        setState(() {
          minutesErased = minutes;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    //DEFINIR TEXTO DE EXIBIÇÃO
    String displayText = "";
    //VERIFICAR MINUTOS RESTANTES
    if (minutesErased >= 0) {
      //EXIBIÇÃO QUANDO 
      displayText = "Tempo Extra";
    } else if (DateTime.now().isBefore(startTime)) {
      //EXIBIÇÃO ANTERIOR AO INICIO DA PARTIDA
      displayText = "Aguardando Inicio";
    } else {
      //EXIBIÇÃO DURANTE O DECORRER DA PARTIDA
      displayText = "$minutesErased'";
    }

    return Text(
      displayText,
      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
        color: AppColors.gray_500,
      ),
    );
  }

  @override
  void dispose() {
    //REMOVER SERVIÇOS
    super.dispose();
  }
}