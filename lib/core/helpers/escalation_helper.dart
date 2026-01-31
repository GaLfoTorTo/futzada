class EscalationHelper {
  //FUNÇÃO PARA RESGATAR NOME COMPLETO DO USUARIO
  static List<int> getFormation(String category, int playersLen){
    switch (category) {
      case "Volei":
      case "Volei de Praia":
      case "Fut Volei":
        switch(playersLen){
          case 2:
            return [0, 2, 0];
          case 3:
            return [1, 2, 0];
          case 4:
            return [2, 0, 2];
          case 5:
            return [2, 1, 2];
          default:
            return [2, 1, 2, 1];
        }
      case "Basquete":
      case "Streetball":
        switch(playersLen){
          case 1:
            return [0, 1, 0];
          case 2:
            return [0, 2, 0];
          case 3:
            return [1, 2, 0];
          case 4:
            return [2, 0, 2];
          default:
            return [2, 1, 2];
        }
      default:
        switch(playersLen){
          case 4:
            return [1, 1, 2, 0];
          case 5:
            return [1, 1, 2, 1];
          case 6:
            return [1, 1, 3, 1];
          case 7:
            return [1, 3, 2, 1];
          case 8:
            return [1, 3, 3, 1];
          case 9:
            return [1, 3, 3, 2];
          case 10:
            return [1, 3, 3, 3];
          case 11:
            return [1, 4, 3, 3];
          default:
            return [1, 4, 3, 3];
        }
        
    }
  }
}