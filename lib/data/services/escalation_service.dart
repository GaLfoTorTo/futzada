import 'package:esportly/core/api/api_client.dart';
import 'package:esportly/core/api/api_routes.dart';
import 'package:esportly/core/helpers/app_helper.dart';
import 'package:esportly/data/models/user_model.dart';
import 'package:esportly/core/di/service_locator.dart';
import 'package:go_router/go_router.dart';

class EscalationService {
  //CLIENTE HTTP
  ApiClient apiClient = sl<ApiClient>();

  //POSIÇÕES
  final positions = {
    'Atacante'    : 'ATA',
    'Meio-Campo'  : 'MEI',
    'Zagueiro'    : 'ZAG',
    'Zagueiros'   : 'ZAG',
    'Goleiro'     : 'GOL',
    'Lateral'     : 'LAT',
    'Pivô'        : 'PIV',
    'Ala'         : 'ALA',
    'Fixo'        : 'FIX',
    'Ala-Armador' : 'ALM',
    'Armador'     : 'ARM',
    'Ala-Pivô'    : 'ALP',
    'Ponteiro'    : 'PON',
    'Central'     : 'CEN',
    'Levantador'  : 'LEV',
    'Oposto'      : 'OPO',
    'Libero'      : 'LIB',
    'Jogador'     : 'JOG',
    'Reserva'     : 'RES',
  };
  
  //FORMAÇÕES
  final formations = {
    'Futebol': [
      '4-3-3',
      '4-1-2-3',
      '4-2-1-3',
      '4-2-3-1',
      '4-4-2',
      '3-4-3',
      '3-2-4-1',
      '3-4-2-1',
      '5-3-2',
      '5-4-1',
    ],
    'Fut7': [
      '3-1-2',
      '3-2-1',
      '3-0-3',
      '2-1-3',
      '2-1-2-1',
      '2-2-2',
      '2-3-1',
      '1-4-1',
      '1-3-2',
      '1-2-3',
    ],
    'Futsal': [
      '2-0-2',
      '2-1-1',
      '1-2-1',
      '1-3',
      '1-1-2',
    ],
    'Basquete': [
      '2-3',
      '3-2',
      '1-3-1',
      '2-1-2',
      '1-2-2',
      '2-2-1',
    ],
    'Streetball': [
      '1-1',
      '2-1',
      '1-2',
    ],
    'Volei': [
      '3-3',
      '2-2-2',
      '1-4-1',
      '2-3-1',
      '3-2-1',
    ],
    'Volei de Praia': [
      '1-1',
      '2-1',
      '1-2',
    ],
    'Fut Volei': [
      '1-1',
      '2-1',
      '1-2',
    ],
  };
  
  //FORMAÇÕES
  final numPlayers = {
    'Futebol': {
      'starters': 11,
      'reserves': 5,
    },
    'Fut7': {
      'starters': 9,
      'reserves': 5,
    },
    'Futsal': {
      'starters': 6,
      'reserves': 5,
    },
    'Basquete': {
      'starters': 5,
      'reserves': 3,
    },
    'Streetball': {
      'starters': 3,
      'reserves': 2,
    },
    'Volei': {
      'starters': 6,
      'reserves': 3,
    },
    'Volei de Praia': {
      'starters': 2,
      'reserves': 2,
    },
    'Fut Volei': {
      'starters': 2,
      'reserves': 2,
    },
  };
  
  /*
  ____________________________________________________
  
  REQUISIÇÕES
  ____________________________________________________
  */

  //REQUISIÇÃO - BUSCA DE PARTICIPANTS DO EVENTO
  Future<List<UserModel?>> participantsFetch(int id) async{
    final resp = await apiClient.get(ApiRoutes.getUrl("${ApiRoutes.eventParticipants}/$id"));
    return resp.data.map<UserModel?>((json) => UserModel.fromJson(json)).toList();
  }

  //REQUISIÇÃO - SALVAR ESCALAÇÃO
  Future<void> saveEscalation(Map<String, dynamic> data) async {
    final ctx = sl<GoRouter>().routerDelegate.navigatorKey.currentContext;
    final resp = await apiClient.post(ApiRoutes.getUrl(ApiRoutes.escalationSave), data);
    AppHelper.feedbackMessage(ctx, AppHelper.extractErrorMessage(resp));
  }

  /*___________________________________________________ 

  UTILITARIOS
  ____________________________________________________
  */


  //FUNÇÃO QUE DEFINE A FORMAÇÃO NA AMOSTRAGEM DO CAMPO APARTIR DA QUANTIDADE DE JOGADORES DEFINA
  List<int> setFormation(qtd){
    switch (qtd) {
      case 4:
        //SETORES PARA 4 JOGADORES
        return [0, 2, 1];
      case 5:
        //SETORES PARA 5 JOGADORES
        return [1, 2, 1];
      case 6:
        //SETORES PARA 6 JOGADORES
        return [1, 2, 2];
      case 7:
        //SETORES PARA 7 JOGADORES
        return [1, 3, 2];
      case 8:
        //SETORES PARA 8 JOGADORES
        return [2, 3, 2];
      case 9:
        //SETORES PARA 9 JOGADORES
        return [2, 3, 3];
      case 10:
        //SETORES PARA 10 JOGADORES
        return [3, 3, 3];
      case 11:
        //SETORES PARA 11 JOGADORES
        return [3, 4, 4];
      default:
        return [3, 4, 4];
    }
  }

  //FUNÇÃO DE DEFINIÇÃO DE FORMAÇÃO POR CATEGORIA (FUTEBOL — mantida por compatibilidade)
  List<int> getFormation(String formation) {
    List<int> splitedFormation = formation.split('-').map((i) => int.parse(i)).toList();
    splitedFormation.insert(0, 1);
    return splitedFormation.reversed.toList();
  }

  //FUNÇÃO DE LAYOUT DE FORMAÇÃO CIENTE DA MODALIDADE
  List<int> getFormationLayout(String category, String formationString) {
    final parts = formationString.split('-').map(int.parse).toList();
    switch (category) {
      case 'Futebol':
      case 'Fut7':
      case 'Futsal':
        parts.insert(0, 1);
        return parts.reversed.toList();
      default:
        return parts.reversed.toList();
    }
  }

  //FUNÇÃO PARE DEFINIR NOME DE POSIÇÃO
  String getPositionName(int sectorIndex, String category, String formationString) {
    final formation = getFormationLayout(category, formationString);
    final totalGroups = formation.length;

    switch (category) {
      case 'Futebol':
        return getFootballPosition(sectorIndex, totalGroups);
      case 'Fut7':
        return getFut7Position(sectorIndex, totalGroups);
      case 'Futsal':
        return getFutsalPosition(sectorIndex);
      case 'Basquete':
      case 'Streetball':
        return getBasketballPosition(sectorIndex, totalGroups);
      case 'Volei':
      case 'Volei de Praia':
      case 'Fut Volei':
        return getVolleyballPosition(sectorIndex, totalGroups);
      default:
        return 'Jogador';
    }
  }

  //FUNÇÃO PARA RESGATAR POSIÇÃO DO JOGADOR NA ESCALAÇÃO
  String getPositionEscalation(int index, String category, String formationString) {
    final formation = getFormationLayout(category, formationString);
    int sectorIndex = 0;
    //LOOP NO ARRAY DE FORMAÇÃOS
    for(int i = 0; i < formation.length; i++){
      //RESGTAR LINHAS DE CADA SETOR
      int lines = formation[i];
      //VERIFICAR SE O ÍNDICE É MENOR QUE A QUANTIDADE DE LINHAS DO SETOR
      if(index < lines){
        //RESGATAR NOME DA POSIÇÃO
        return getPositionName(i, category, formationString);
      }else{
        index -= lines;
      }
    }
    return getPositionName(sectorIndex, category, formationString);
  }

    //FUNÇÃO PARA RESGATAR ABREVIAÇÃO DA POSIÇÃO DO RESERVA
  String getReservePosition(int index, String category) {
    switch (category) {
      case 'Futebol': // 5 reservas (teto máximo)
        switch (index) {
          case 0: return 'gol';
          case 1: return 'zag';
          case 2: return 'lat';
          case 3: return 'mei';
          case 4: return 'ata';
          default: return 'ata';
        }
      case 'Fut7': // 5 reservas
        switch (index) {
          case 0: return 'gol';
          case 1: return 'zag';
          case 2: return 'lat';
          case 3: return 'mei';
          case 4: return 'ata';
          default: return 'ata';
        }
      case 'Futsal': // 4 reservas
        switch (index) {
          case 0: return 'gol';
          case 1: return 'fix';
          case 2: return 'ala';
          case 3: return 'ala';
          default: return 'ala';
        }
      case 'Basquete': // 3 reservas
        switch (index) {
          case 0: return 'arm';
          case 1: return 'ala';
          case 2: return 'piv';
          default: return 'ala';
        }
      case 'Streetball': // 2 reservas
        switch (index) {
          case 0: return 'arm';
          case 1: return 'ala';
          default: return 'ala';
        }
      case 'Volei': // 4 reservas
        switch (index) {
          case 0: return 'lev';
          case 1: return 'pon';
          case 2: return 'cen';
          case 3: return 'lib';
          default: return 'pon';
        }
      case 'Volei de Praia':
      case 'Fut Volei': // 1 reserva
        return 'res';
      default:
        switch (index) {
          case 0: return 'gol';
          case 1: return 'zag';
          case 2: return 'lat';
          case 3: return 'mei';
          case 4: return 'ata';
          default: return 'ata';
        }
    }
  }

  //FUNÇÃO PARA SELECIONAR NOME DA POSIÇÃO PARA FUTEBOL
  String getFootballPosition(int index, int linhas) {
    //VERIFICAR LINHAS DE LINHAS NA FORMAÇÃO
    if(linhas == 4){
      //VERIFICAR QUANTIDADE DE ZAGUEIROS OU MEIAS
      switch (index) {
        case 0:
          return 'Atacante';
        case 1:
          return 'Meio-Campo';
        case 2:
          return 'Zagueiro';
        case 3:
          return 'Goleiro';
        default:
          return 'Jogador';
      }
    //VERIFICAR LINHAS DE LINHAS NA FORMAÇÃO
    }else if(linhas == 5){
      //VERIFICAR QUANTIDADE DE ZAGUEIROS OU MEIAS
      switch (index) {
        case 0:
          return 'Atacante';
        case 1:
        case 2:
          return 'Meio-Campo';
        case 3:
          return 'Zagueiro';
        case 4:
          return 'Goleiro';
        default:
          return 'Jogador';
      }
    }
    return 'Jogador';
  }

  //FUNÇÃO PARA SELECIONAR NOME DA POSIÇÃO PARA FUT7
  String getFut7Position(int index, int linhas){
    //VERIFICAR LINHAS DE LINHAS NA FORMAÇÃO
    if(linhas == 5){
      switch (index) {
        case 0:
          return 'Atacante';
        case 1:
        case 2:
          return 'Meio-Campo';
        case 3:
          return 'Zagueiros';
        case 4:
          return 'Goleiro';
        default:
          return 'Jogador';
      }
    }else{
      switch (index) {
        case 0:
          return 'Atacante';
        case 1:
          return 'Meio-Campo';
        case 2:
          return 'Zagueiros';
        case 3:
          return 'Goleiro';
        default:
          return 'Jogador';
      }
    }
  }
  
  //FUNÇÃO PARA SELECIONAR NOME DA POSIÇÃO PARA FUTSAL
  String getFutsalPosition(int index){
    switch (index) {
      case 0:
        return 'Pivô';
      case 1:
        return 'Ala';
      case 2:
        return 'Fixo';
      case 3:
        return 'Goleiro';
      default:
        return 'Jogador';
    }
  }

  //FUNÇÃO PARA SELECIONAR NOME DA POSIÇÃO PARA BASQUETE / STREETBALL
  String getBasketballPosition(int index, int totalGroups) {
    if (totalGroups <= 3) {
      switch (index) {
        case 0:
          return 'Ala';
        case 1:
          return 'Ala-Armador';
        case 2:
          return 'Armador';
        default:
          return 'Jogador';
      }
    } else {
      switch (index) {
        case 0:
          return 'Pivô';
        case 1:
          return 'Ala-Pivô';
        case 2:
          return 'Ala';
        case 3:
          return 'Ala-Armador';
        case 4:
          return 'Armador';
        default:
          return 'Jogador';
      }
    }
  }

  //FUNÇÃO PARA SELECIONAR NOME DA POSIÇÃO PARA VÔLEI / VÔLEI DE PRAIA / FUTVÔLEI
  String getVolleyballPosition(int index, int totalGroups) {
    switch (index) {
      case 0:
        return 'Ponteiro';
      case 1:
        return 'Central';
      case 2:
        return 'Levantador';
      case 3:
        return 'Oposto';
      default:
        return 'Jogador';
    }
  }

  // Converte qualquer nome completo ou alias (maiúsculo/minúsculo) para alias maiúsculo padronizado.
  String getPositionAlias(String position) {
    const _map = {
      // Nomes completos (retornados por getPositionName)
      'Atacante'    : 'ATA',
      'Meio-Campo'  : 'MEI',
      'Zagueiro'    : 'ZAG',
      'Zagueiros'   : 'ZAG',
      'Goleiro'     : 'GOL',
      'Lateral'     : 'LAT',
      'Pivô'        : 'PIV',
      'Ala'         : 'ALA',
      'Fixo'        : 'FIX',
      'Ala-Armador' : 'ALM',
      'Armador'     : 'ARM',
      'Ala-Pivô'    : 'ALP',
      'Ponteiro'    : 'PON',
      'Central'     : 'CEN',
      'Levantador'  : 'LEV',
      'Oposto'      : 'OPO',
      'Libero'      : 'LIB',
      'Jogador'     : 'JOG',
      'Reserva'     : 'RES',
    };
    return _map[position] ?? position.toUpperCase();
  }
}