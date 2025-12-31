//VISIBILIDADE GERAL
enum VisibilityPerfil { Public, Private }
//PERMISSÕES DE COLABORADORES DO EVENTO
enum Permissions { Add, Remove, Edit }
//REGRAS DE PARTICIPAÇÃO DO EVENTO
enum Roles { Organizator, Colaborator, Refereer, Player, Manager }
//STATUS DE PARTIDAS
enum GameStatus { Scheduled, In_progress, Completed, Cancelled }
//STATUS DE PARTICIPANTES DO EVENTO
enum PlayerStatus { Avaliable, Out, Doubt, None }
//TIPO DE EVENTO NA PARTIDA
enum GameEvent { 
  //TIME
  StartGame,
  EndGame,
  HalfTimeEnd,
  ExtraTime,
  ExtraTimeStart,
  ExtraTimeEnd,
  Penalties,

  //FINALIZAÇÕES
  Goal,
  Defense,
  Penalty,

  //BOLA PARADA
  Corner,
  FreeKick,
  GoalKick,

  //IMPEDIMENTO
  Offside,

  //FALTA E DISCIPLINA
  Foul,
  FoulTaken,
  YellowCard,
  RedCard,

  //SUBSTITUIÇÃO
  Substitution,

  //PASSE
  Assist,

  //INTERCEPTAÇÕES
  Interception,

  //GOLEIRO
  GoalkeeperSave,

  //OUTROS
  Injury,
  VARCheck,
}
//TIPO DE NOTICIAS DO EVENTO
enum NewsType { 
  EventRegister,
  EventUpdate,
  EventLocation,
  EventConfig,
  EventGameDay,
  EventGame,
  EventNewRule,
  EventAlterRule,
  EventRemoveRule,
  ParticipantAdd,
  ParticipantRemove,
  ParticipantLeft,
  ParticipantChange,
}