// lib/services/match_timer_service.dart
import 'dart:async';

class TimerService {
  //DEFINIR HORARIO DE INICIO E FIM DA PARTIDA (DATETIME)
  late DateTime startTime;
  late DateTime endTime;
  //DEFINIR 
  Timer? _minuteTimer;
  Timer? _secondTimer;
  //DEFINIR CONTROLADOR DE CONTAGEM
  final StreamController<int> _minutesController = StreamController<int>.broadcast();
  //GETTER DE STREAMER
  Stream<int> get minutesStream => _minutesController.stream;

  //FUNÇÃO DE INICIALIZAÇÃO DE CONTAGEM
  void initialize(DateTime startTimeStr, DateTime endTimeStr) {
    //RESGATAR HORARIO DE INICIO E FIM
    startTime = startTimeStr;
    endTime = endTimeStr;
    //INICIAR CONTAGEM
    startTimers();
  }

  int getRemainingMinutes() {
    //RESGATAR DATA E HORA ATUAL
    final now = DateTime.now();
    //VERIFICAR SE DATA E HORA ATUAL SÃO ANTERIORES AO INICIO DA PARTIDA
    if (now.isBefore(startTime)) {
      //RETORNAR DIFERENÇA DE HORARIO DE INICIO E FIM EM MINUTOS
      return endTime.difference(startTime).inMinutes;
    //VERIFICAR SE DATA E HORA ATUAL SÃO POSTERIORES AO FIM DA PARTIDA
    } else if (now.isAfter(endTime)) {
      //RETORNAR 0
      return 0;
    } else {
      //RETORNAR DIFERENÇA DE HORARIO DE INICIO E DATA ATUAL
      return startTime.difference(now).inMinutes;
    }
  }

  //FUNÇÃO PARA PARAR CONTADORES
  void stopTimers(){
    //INTERROMPER TIMERS INICIALIZADOS
    _minuteTimer?.cancel();
    _secondTimer?.cancel();
  }

  //FUNÇÃO PARA INICIALIZAR CONTADORES
  void startTimers() {
    //INTERROMPER TIMERS ATIVOS
    stopTimers();

    //TIMER DE CONTABILIZAÇÃO DE MINUTOS
    _minuteTimer = Timer.periodic(const Duration(minutes: 1), (_) {
      _minutesController.add(getRemainingMinutes());
    });

    //TIMER DE CONTABILIZAÇÃO DE MINUTOS E SEGUNDOS
    _secondTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      //CALCULAR DIFERENÇA EM MINUTOS
      final remaining = getRemainingMinutes();
      //VERIFICAR SE NÃO É MENOR DO QUE 0
      if (remaining <= 0) {
        timer.cancel();
        return;
      }
      //CALCULAR DIFERENÇA EM SEGUNDOS 
      final secondsRemaining = endTime.difference(DateTime.now()).inSeconds;
      //VERIFICAR SE DIFEREÇA É IGUAL A 0
      if (secondsRemaining % 60 == 0) {
        //EMITIR SEGUNDOS AO STREAM
        _minutesController.add(remaining);
      }
    });
    //EMITIR MINUTOS AO STREAM
    _minutesController.add(getRemainingMinutes());
  }

  //DISPOSE PARA ENCERRAR SERVIÇO
  void dispose() {
    //INTERROMPER TIMERS ATIVOS
    stopTimers();
    _minutesController.close();
  }
}