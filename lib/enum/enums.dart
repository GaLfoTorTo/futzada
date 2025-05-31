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