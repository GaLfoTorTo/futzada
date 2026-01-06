import 'dart:math';
import 'package:intl/intl.dart';
import 'package:faker/faker.dart';
import 'package:futzada/models/avaliation_model.dart';
import 'package:futzada/models/participant_model.dart';
import 'package:futzada/enum/enums.dart';
import 'package:futzada/helpers/app_helper.dart';
import 'package:futzada/models/address_model.dart';
import 'package:futzada/models/event_model.dart';
import 'package:futzada/models/user_model.dart';
import 'package:futzada/services/news_service.dart';
import 'package:futzada/services/rules_service.dart';
import 'package:futzada/services/avaliation_service.dart';
import 'package:futzada/services/game_service.dart';
import 'package:futzada/services/participant_service.dart';

class EventService {
  //INSTANCIAR FAKER E RANDOM (TEMPORARIAMENTE)
  static var faker = Faker();
  static var random = Random();

  //INSTANCIAR SERVIÇO DE PARTIDAS
  GameService gameService = GameService();
  //INSTANCIAR SERVIÇO DE PARTICIPANTES
  ParticipantService participantService = ParticipantService();
  //INSTANCIAR SERVIÇO DE AVALIAÇÃO
  AvaliationService avaliationService = AvaliationService();
  //INSTANCIAR SERVIÇO DE RULES
  RuleService ruleService = RuleService();
  //INSTANCIAR SERVIÇO DE RULES
  NewsService newsService = NewsService();

  //FUNÇÃO PARA GERAR EVENTO
  EventModel generateEvent(i){
    //CONTADORES DE ITENS FAKE
    int qtdParticipants = random.nextInt(50);
    int qtdAvaliations = random.nextInt(25);
    int qtdRules = random.nextInt(10);
    int qtdNews = random.nextInt(25);
    //DEFINIR STATUS DE PERMISSÃO
    bool permissionState = random.nextBool();
    //DEFINIR PERMISSÕES DO EVENTO
    String? permissions = permissionState == true ? [Permissions.Add.name, Permissions.Edit.name, Permissions.Remove.name].toString() : null;
    //GERAR LISTA DE PARTICIPANTS
    final participants = List.generate(qtdParticipants, (u) => participantService.generateParticipant(u + 1).toMap());
    //GERAR EVENTO (PELADA)
    return EventModel.fromMap({
      "id" : i,
      "uuid" : "$i",
      "title" : faker.company.name(),
      "bio" : faker.lorem.sentence().toString(),
      "daysWeek" : "[Seg, Qua, Sex]",
      "startTime" : faker.date.justTime(),
      "endTime" : faker.date.justTime(),
      "category" : gameService.getCategory(),
      "allowCollaborators" : permissionState,
      "permissions" : permissions,
      "photo" : random.nextBool() == true ? faker.image.loremPicsum() : null,
      //GERAR ENDEREÇO DO EVENTO (PELADA)
      "address" : generateAddress(i).toMap(),
      //GERAR CONFIGURAÇÕES DE PARTIDA DO EVENTO (PELADA)
      "gameConfig" : gameService.generateGameConfig(i).toMap(),
      //GERAR AVALIAÇÕES DO EVENTO (PELADA)
      "avaliations" : List.generate(qtdAvaliations, (u) => avaliationService.generateAvaliation(u + 1).toMap()),
      //GERAR PARTICIPANTES DO EVENTO (PELADA)
      "participants" : participants,
      //GERAR REGRAS DO EVENTO (PELADA)
      "rules" : List.generate(qtdRules, (u) => ruleService.generateRule(ParticipantModel.fromMap(participants[0]), u).toMap()),
      //GERAR NOTICIAS DO EVENTO (PELADA)
      "news" : List.generate(qtdNews, (u) => newsService.generateNews().toMap()),
      "visibility" : random.nextBool() == true ? VisibilityPerfil.Public.name : VisibilityPerfil.Private.name,
      "createdAt" : faker.date.dateTime(minYear: 2024, maxYear: 2025),
      "updatedAt" : faker.date.dateTime(minYear: 2024, maxYear: 2025),
    });
  }

  //FUNÇÃO PARA GERAÇÃO DE ENDEREÇO
  AddressModel generateAddress(int i){
    return AddressModel.fromMap({
      "id" : i,
      "street" : faker.address.streetAddress(),
      "number" : random.nextInt(10).toString(),
      "suburb" : faker.address.streetSuffix(),
      "borough" : faker.address.neighborhood(),
      "city" : faker.address.city(),
      "state" : faker.address.stateAbbreviation(),
      "country" : faker.address.country().toString(),
      "zipCode" : faker.address.zipCode(),
      "latitude" : coordinates[random.nextInt(coordinates.length)]['latitude'],
      "longitude" : coordinates[random.nextInt(coordinates.length)]['longitude'],
      "photos" : List.generate(random.nextInt(5), (i) => faker.image.loremPicsum()),
      "createdAt" : faker.date.dateTime(minYear: 2024, maxYear: 2025),
"updatedAt" : faker.date.dateTime(minYear: 2024, maxYear: 2025),
    });
  }
  
  //FUNÇÃO PARA BUSCAR EVENTOS DO USUARIO
  List<EventModel> getUserEvents(){
    //DEFINIR ARRAY DE EVENTOS
    List<EventModel> events = [];
    //LOOP PARA EVENTOS DO USUARIO
    for (var i = 1; i <= 2; i++) {
      //ADICIONAR JOGADOR A LISTA
      events.add(
        generateEvent(i)
      );
    }
    //RETORNAR LISTA DE NOTIFICAÇÕES
    return events;
  }

  //FUNÇÃO PARA BUSCAR EVENTOS DO USUARIO
  List<EventModel> getEventsSuggestion(){
    //DEFINIR ARRAY DE EVENTOS
    List<EventModel> events = [];
    //LOOP PARA EVENTOS DO USUARIO
    for (var i = 1; i <= 2; i++) {
      //ADICIONAR JOGADOR A LISTA
      events.add(
        generateEvent(i)
      );
    }
    //RETORNAR LISTA DE NOTIFICAÇÕES
    return events;
  }
  
  //FUNÇÃO PARA BUSCAR AVALIAÇÕES DO EVNTO
  double getEventAvaliation(List<AvaliationModel>? avaliations) {
    if(avaliations == null || avaliations.isEmpty) return 0.0;
    return avaliations.map((a) => a.avaliation!).reduce((a, b) => a + b) / avaliations.length;
  }
  //FUNÇÃO PARA BUSCAR EVENTOS
  List<EventModel> getEvents(){
    //DEFINIR ARRAY DE EVENTOS
    List<EventModel> events = [];
    int count = random.nextInt(50);
    //LOOP PARA EVENTOS DO USUARIO
    for (var i = 1; i <= count; i++) {
      //ADICIONAR JOGADOR A LISTA
      events.add(
        generateEvent(i)
      );
    }
    //RETORNAR LISTA DE NOTIFICAÇÕES
    return events;
  }
  
  //FUNÇÃO PARA BUSCAR EVENTOS POR ID
  EventModel getEventById(int id){
    //BUSCAR EVENTO PELO ID
    return getEvents().firstWhere((event) => event.id == id, orElse: () => EventModel());
  }

  //FUNÇÃO PARA BUSCAR DESTAQUES DO EVENTOS
  List<Map<String, dynamic>> getHighlightsEvent(){
    List<Map<String, dynamic>> arr = [];
    //LOOP PARA TITULARES
    List.generate(random.nextInt(5), (item){
      //DEFINIR QUANTIDADE DE PARTICIPANTES
      int qtdParticipants = random.nextInt(3);
      qtdParticipants = qtdParticipants > 0 ? qtdParticipants : 1;
      //ADICIONAR JOGADOR A LISTA
      arr.add({
        'title' : faker.company.name(),
        'description' : faker.lorem.sentence().toString(),
        "participants" : List.generate(qtdParticipants, (p){
          return UserModel.fromMap({
            'uuid' : "$p",
            'firstName': faker.person.firstName(),
            'lastName': faker.person.lastName(),
            'userName': "${faker.person.firstName()}_${faker.person.lastName()}",
            'photo': faker.image.loremPicsum()
          });
        }),
        "params" : {
          'label' :  faker.company.name(),
          "value" : random.nextBool() 
            ? double.parse(setValues(0.0, 10.0).toStringAsFixed(2))
            : null
        }
      });
    });
    //RETORNAR LISTA DE NOTIFICAÇÕES
    return arr;
  }

  //FUNÇÃO PARA VERIFICAR SE EVENTO ESTA AO VIVO
  bool isEventLive(EventModel event){
    //RESGATAR DATAS DE ACONTECIMENTO DO EVENTO
    var eventDateTime = getNextEventDate(event);
    var eventDate = DateFormat("dd/MM/yyyy").format(eventDateTime);
    //VERIFICAR SE O EVENTO ESTA ACONTECENDO AGORA
    return AppHelper.verifyInLive("$eventDate ${event.startTime}", "$eventDate ${event.endTime}");
  }

  //FUNÇÃO PARA RESGATAR A DATA DO PROXIMO DIA DO EVENTO
  DateTime getNextEventDate(EventModel event) {
    //LISTA DE DIAS DA SEMANA ABREVIADOS
    List<String> weekDays = ['Dom','Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb'];
    //RESGATAR DIAS DA SEMANA DO EVENTO
    final eventDaysWeek = event.daysWeek!
      .replaceAll(RegExp(r'[\[\]]'), '')
      .split(',')
      .map((d) => weekDays.indexOf(d.trim()))
      .toList();
    //RESGATAR DATA DE HOJE E INDEX DO DIA DA SEMANA
    DateTime today = DateTime.now();
    final todayIndex = today.weekday % 7;
    //VERIFICAR SE INDEX DO DIA DE HOJE (NA SEMANA) É MAIOR DO QUE INDEX DO ULTIMA DATA DO EVENTO (NA SEMANA)
    final nextDay = eventDaysWeek.firstWhere(
      (day) => day > todayIndex,
      orElse: () => eventDaysWeek.first + 7,
    );
    //ADICIONAR NOVA DATA DO EVENTO BASEADO NA DATA DE HOJE E NO INDEX DE PROXMO EVENTO ADIQUIRIDO;
    return DateTime(
      today.year,
      today.month,
      today.day + (nextDay - todayIndex),
    );
  }

  //FUNÇÃO PARA GERAÇÃO DE VALORES (TEMPORARIAMENTE)
  static double setValues(double min, double max){
    return min + random.nextDouble() * (max - min);
  }

  //ARRAY DE COORDENADAS (TEMPORARIAMENTE)
  List<Map<String, dynamic>> coordinates = [
    {'latitude' : -15.630159, 'longitude' :-47.718006},
    {'latitude' : -15.766881, 'longitude' :-47.870571},
    {'latitude' : -15.789487, 'longitude' :-47.842076},
    {'latitude' : -15.789502, 'longitude' :-47.842641},
    {'latitude' : -15.779601, 'longitude' :-47.933252},
    {'latitude' : -15.780835, 'longitude' :-47.938284},
    {'latitude' : -15.805872, 'longitude' :-47.939342},
    {'latitude' : -15.802196, 'longitude' :-47.94395},
    {'latitude' : -15.808837, 'longitude' :-47.941552},
    {'latitude' : -15.806219, 'longitude' :-47.945205},
    {'latitude' : -15.808307, 'longitude' :-47.943707},
    {'latitude' : -15.798907, 'longitude' :-47.941208},
    {'latitude' : -15.785221, 'longitude' :-47.935123},
    {'latitude' : -15.785341, 'longitude' :-47.935566},
    {'latitude' : -15.90771, 'longitude' :-47.810933},
    {'latitude' : -15.915451, 'longitude' :-47.786852},
    {'latitude' : -15.907053, 'longitude' :-47.810963},
    {'latitude' : -15.907919, 'longitude' :-47.811419},
    {'latitude' : -15.907223, 'longitude' :-47.811109},
    {'latitude' : -15.905923, 'longitude' :-47.809804},
    {'latitude' : -15.804536, 'longitude' :-47.943887},
    {'latitude' : -15.804517, 'longitude' :-47.943721},
    {'latitude' : -15.786117, 'longitude' :-47.940331},
    {'latitude' : -15.798606, 'longitude' :-47.931282},
    {'latitude' : -15.813641, 'longitude' :-47.920626},
    {'latitude' : -15.785947, 'longitude' :-47.938609},
    {'latitude' : -15.813823, 'longitude' :-47.91984},
    {'latitude' : -15.784331, 'longitude' :-47.939672},
    {'latitude' : -15.785878, 'longitude' :-47.938094},
    {'latitude' : -15.804469, 'longitude' :-47.935656},
    {'latitude' : -15.783848, 'longitude' :-47.939504},
    {'latitude' : -15.785906, 'longitude' :-47.937787},
    {'latitude' : -15.812987, 'longitude' :-47.924365},
    {'latitude' : -15.812966, 'longitude' :-47.920145},
    {'latitude' : -15.811847, 'longitude' :-47.923413},
    {'latitude' : -15.813316, 'longitude' :-47.919891},
    {'latitude' : -15.812725, 'longitude' :-47.923893},
    {'latitude' : -15.81212, 'longitude' :-47.924349},
    {'latitude' : -15.812992, 'longitude' :-47.924805},
    {'latitude' : -15.81211, 'longitude' :-47.924821},
    {'latitude' : -15.812725, 'longitude' :-47.923427},
    {'latitude' : -15.811843, 'longitude' :-47.923893},
    {'latitude' : -15.804714, 'longitude' :-47.946062},
    {'latitude' : -15.798315, 'longitude' :-48.117564},
    {'latitude' : -15.907311, 'longitude' :-47.755854},
    {'latitude' : -15.907403, 'longitude' :-47.756736},
    {'latitude' : -15.82895, 'longitude' :-48.020698},
    {'latitude' : -15.829441, 'longitude' :-48.02125},
    {'latitude' : -15.828838, 'longitude' :-48.020547},
    {'latitude' : -15.828726, 'longitude' :-48.020394},
    {'latitude' : -15.816489, 'longitude' :-47.868992},
    {'latitude' : -15.817328, 'longitude' :-47.872788},
    {'latitude' : -15.817478, 'longitude' :-47.866539},
    {'latitude' : -15.818429, 'longitude' :-47.867572},
    {'latitude' : -15.801832, 'longitude' :-48.11285},
    {'latitude' : -15.828357, 'longitude' :-48.097839},
    {'latitude' : -15.767799, 'longitude' :-47.85905},
    {'latitude' : -15.768218, 'longitude' :-47.859116},
    {'latitude' : -15.770288, 'longitude' :-47.858563},
    {'latitude' : -15.769271, 'longitude' :-47.857772},
    {'latitude' : -15.75208, 'longitude' :-47.868097},
    {'latitude' : -15.751672, 'longitude' :-47.870923},
    {'latitude' : -15.751027, 'longitude' :-47.870011},
    {'latitude' : -15.752518, 'longitude' :-47.868346},
    {'latitude' : -15.751908, 'longitude' :-47.868604},
    {'latitude' : -15.752209, 'longitude' :-47.86847},
    {'latitude' : -15.753242, 'longitude' :-47.867955},
    {'latitude' : -15.83255, 'longitude' :-47.890279},
    {'latitude' : -15.831021, 'longitude' :-47.934194},
    {'latitude' : -15.830843, 'longitude' :-47.932566},
    {'latitude' : -15.833617, 'longitude' :-47.932751},
    {'latitude' : -15.830714, 'longitude' :-47.932381},
    {'latitude' : -15.83219, 'longitude' :-47.930801},
    {'latitude' : -15.787066, 'longitude' :-47.856909},
    {'latitude' : -15.782397, 'longitude' :-47.859671},
    {'latitude' : -15.782983, 'longitude' :-47.8595},
    {'latitude' : -15.82273, 'longitude' :-47.94286},
    {'latitude' : -15.835034, 'longitude' :-47.938235},
    {'latitude' : -15.834887, 'longitude' :-47.937993},
    {'latitude' : -15.796229, 'longitude' :-48.053584},
    {'latitude' : -15.857898, 'longitude' :-47.954531},
    {'latitude' : -15.817631, 'longitude' :-47.983156},
    {'latitude' : -15.822654, 'longitude' :-47.986437},
    {'latitude' : -15.817083, 'longitude' :-47.981877},
    {'latitude' : -15.818269, 'longitude' :-47.981574},
    {'latitude' : -15.82782, 'longitude' :-47.972518},
    {'latitude' : -15.827872, 'longitude' :-47.971811},
    {'latitude' : -15.827838, 'longitude' :-47.972282},
    {'latitude' : -15.827859, 'longitude' :-47.972044},
    {'latitude' : -15.820149, 'longitude' :-47.989573},
    {'latitude' : -15.828487, 'longitude' :-47.972592},
    {'latitude' : -15.801858, 'longitude' :-48.160781},
    {'latitude' : -16.015541, 'longitude' :-48.064397},
    {'latitude' : -16.01421, 'longitude' :-48.060948},
    {'latitude' : -16.014215, 'longitude' :-48.060756},
    {'latitude' : -16.00528, 'longitude' :-48.071557},
    {'latitude' : -16.017346, 'longitude' :-48.076099},
    {'latitude' : -16.015353, 'longitude' :-48.079532},
    {'latitude' : -16.020913, 'longitude' :-48.052344},
    {'latitude' : -16.01849, 'longitude' :-48.061533},
    {'latitude' : -16.019297, 'longitude' :-48.061667},
    {'latitude' : -16.022665, 'longitude' :-48.060882},
    {'latitude' : -16.011992, 'longitude' :-48.046556},
    {'latitude' : -16.018323, 'longitude' :-48.061526},
    {'latitude' : -16.022234, 'longitude' :-48.077617},
    {'latitude' : -15.67713, 'longitude' :-48.191635},
    {'latitude' : -15.688663, 'longitude' :-48.196875},
    {'latitude' : -16.013276, 'longitude' :-48.011683},
    {'latitude' : -16.021542, 'longitude' :-48.019374},
    {'latitude' : -16.043788, 'longitude' :-48.033647},
    {'latitude' : -16.043354, 'longitude' :-48.034694},
    {'latitude' : -15.815847, 'longitude' :-47.869582},
    {'latitude' : -15.816102, 'longitude' :-47.870069},
    {'latitude' : -15.881191, 'longitude' :-47.975764},
    {'latitude' : -15.801172, 'longitude' :-48.133807},
    {'latitude' : -15.989957, 'longitude' :-48.044044},
    {'latitude' : -15.828044, 'longitude' :-48.110328},
    {'latitude' : -15.79688, 'longitude' :-47.851681},
    {'latitude' : -15.777701, 'longitude' :-47.908478},
    {'latitude' : -15.810816, 'longitude' :-47.985663},
    {'latitude' : -15.807855, 'longitude' :-47.985959},
    {'latitude' : -15.800126, 'longitude' :-47.918926},
    {'latitude' : -15.802366, 'longitude' :-47.924373},
    {'latitude' : -15.794753, 'longitude' :-47.93098},
    {'latitude' : -15.801175, 'longitude' :-47.929289},
    {'latitude' : -15.808371, 'longitude' :-48.04081},
    {'latitude' : -15.807566, 'longitude' :-48.040614},
    {'latitude' : -15.817365, 'longitude' :-48.007566},
    {'latitude' : -15.687241, 'longitude' :-48.197369},
    {'latitude' : -15.845707, 'longitude' :-47.966377},
    {'latitude' : -15.822966, 'longitude' :-47.989306},
    {'latitude' : -15.825805, 'longitude' :-48.053097},
    {'latitude' : -15.811807, 'longitude' :-48.055191},
    {'latitude' : -15.602963, 'longitude' :-47.651994},
    {'latitude' : -15.75915, 'longitude' :-47.776749},
    {'latitude' : -15.652663, 'longitude' :-47.785196},
    {'latitude' : -15.737469, 'longitude' :-47.888979},
    {'latitude' : -15.669968, 'longitude' :-48.192134},
    {'latitude' : -15.599159, 'longitude' :-47.881698},
    {'latitude' : -15.867978, 'longitude' :-48.028664},
    {'latitude' : -15.866146, 'longitude' :-48.02933},
    {'latitude' : -15.867957, 'longitude' :-48.028892},
    {'latitude' : -15.866394, 'longitude' :-48.029193},
    {'latitude' : -15.866228, 'longitude' :-48.029492},
    {'latitude' : -15.868355, 'longitude' :-48.028926},
    {'latitude' : -15.868374, 'longitude' :-48.028704},
    {'latitude' : -15.866472, 'longitude' :-48.029358},
    {'latitude' : -15.817605, 'longitude' :-47.862974},
    {'latitude' : -15.814554, 'longitude' :-47.845112},
    {'latitude' : -15.817768, 'longitude' :-47.864608},
    {'latitude' : -15.817653, 'longitude' :-47.863815},
    {'latitude' : -15.814804, 'longitude' :-47.847263},
    {'latitude' : -15.999491, 'longitude' :-47.993059},
    {'latitude' : -15.952632, 'longitude' :-48.043714},
    {'latitude' : -15.858778, 'longitude' :-48.052597},
    {'latitude' : -15.762956, 'longitude' :-47.858444},
    {'latitude' : -15.762601, 'longitude' :-47.859269},
    {'latitude' : -15.739372, 'longitude' :-47.895991},
    {'latitude' : -16.001606, 'longitude' :-47.997012},
    {'latitude' : -16.026017, 'longitude' :-47.7891},
    {'latitude' : -16.026447, 'longitude' :-47.790033},
    {'latitude' : -15.76236, 'longitude' :-47.881497},
    {'latitude' : -15.798045, 'longitude' :-47.917137},
    {'latitude' : -15.812592, 'longitude' :-47.972515},
    {'latitude' : -15.788759, 'longitude' :-48.01327},
    {'latitude' : -15.788664, 'longitude' :-48.012804},
    {'latitude' : -15.812836, 'longitude' :-47.993949},
    {'latitude' : -15.832064, 'longitude' :-47.919176},
    {'latitude' : -15.832427, 'longitude' :-47.919098},
    {'latitude' : -15.742207, 'longitude' :-48.166943},
    {'latitude' : -15.742565, 'longitude' :-48.166692},
    {'latitude' : -15.716274, 'longitude' :-47.872452},
    {'latitude' : -15.821288, 'longitude' :-48.122521},
    {'latitude' : -15.821032, 'longitude' :-48.121828},
    {'latitude' : -15.811369, 'longitude' :-48.107238},
    {'latitude' : -15.821533, 'longitude' :-48.069853},
    {'latitude' : -15.847677, 'longitude' :-48.047403},
    {'latitude' : -15.795414, 'longitude' :-47.925062},
    {'latitude' : -15.886568, 'longitude' :-47.816992},
    {'latitude' : -15.678103, 'longitude' :-47.82566},
    {'latitude' : -15.775575, 'longitude' :-47.90818},
    {'latitude' : -15.775146, 'longitude' :-47.914639},
    {'latitude' : -15.779677, 'longitude' :-47.916763},
    {'latitude' : -15.779266, 'longitude' :-47.917506},
    {'latitude' : -15.775425, 'longitude' :-47.913989},
    {'latitude' : -15.879556, 'longitude' :-48.088756},
    {'latitude' : -15.887765, 'longitude' :-48.086615},
    {'latitude' : -15.810578, 'longitude' :-48.089601},
    {'latitude' : -15.851728, 'longitude' :-47.961768},
    {'latitude' : -15.898794, 'longitude' :-48.119361},
    {'latitude' : -15.813725, 'longitude' :-47.99192},
    {'latitude' : -15.833679, 'longitude' :-47.937589},
    {'latitude' : -15.906541, 'longitude' :-48.07467},
    {'latitude' : -15.913525, 'longitude' :-48.066548},
    {'latitude' : -15.859449, 'longitude' :-47.812284},
    {'latitude' : -15.859706, 'longitude' :-47.812351},
    {'latitude' : -15.859761, 'longitude' :-47.811881},
    {'latitude' : -15.842463, 'longitude' :-48.12227},
    {'latitude' : -15.751248, 'longitude' :-47.894027},
    {'latitude' : -15.857229, 'longitude' :-48.032911},
    {'latitude' : -15.857209, 'longitude' :-48.032241},
    {'latitude' : -15.853991, 'longitude' :-48.034263},
    {'latitude' : -15.865227, 'longitude' :-48.023309},
    {'latitude' : -15.88291, 'longitude' :-48.101879},
    {'latitude' : -15.888292, 'longitude' :-48.102031},
    {'latitude' : -15.868491, 'longitude' :-48.090507},
    {'latitude' : -15.883365, 'longitude' :-48.143371},
    {'latitude' : -15.886353, 'longitude' :-48.144461},
    {'latitude' : -15.891105, 'longitude' :-48.14908},
    {'latitude' : -15.890378, 'longitude' :-48.144728},
    {'latitude' : -15.89224, 'longitude' :-48.14685},
    {'latitude' : -15.893071, 'longitude' :-48.146357},
    {'latitude' : -15.893912, 'longitude' :-48.144648},
    {'latitude' : -15.892691, 'longitude' :-48.140473},
    {'latitude' : -15.894045, 'longitude' :-48.137816},
    {'latitude' : -15.816854, 'longitude' :-48.007492},
    {'latitude' : -15.816943, 'longitude' :-48.007724},
    {'latitude' : -15.816416, 'longitude' :-48.007652},
    {'latitude' : -15.817278, 'longitude' :-48.007326},
    {'latitude' : -15.816505, 'longitude' :-48.007912},
    {'latitude' : -16.046561, 'longitude' :-48.031545},
    {'latitude' : -16.046787, 'longitude' :-48.03146},
    {'latitude' : -15.878343, 'longitude' :-48.06805},
    {'latitude' : -15.87822, 'longitude' :-48.072851},
    {'latitude' : -15.980626, 'longitude' :-47.974761},
    {'latitude' : -15.981725, 'longitude' :-47.970317},
    {'latitude' : -15.882193, 'longitude' :-48.072147},
    {'latitude' : -15.756114, 'longitude' :-47.887601},
    {'latitude' : -15.758345, 'longitude' :-47.883005},
    {'latitude' : -15.749005, 'longitude' :-47.884751},
    {'latitude' : -15.768299, 'longitude' :-47.885042},
    {'latitude' : -15.815674, 'longitude' :-47.843594},
    {'latitude' : -15.743556, 'longitude' :-47.89277},
    {'latitude' : -15.799717, 'longitude' :-47.894777},
    {'latitude' : -16.011357, 'longitude' :-48.061742},
    {'latitude' : -15.837598, 'longitude' :-48.080194},
    {'latitude' : -15.83611, 'longitude' :-48.080626},
    {'latitude' : -15.760471, 'longitude' :-47.893644},
    {'latitude' : -15.807238, 'longitude' :-47.887941},
    {'latitude' : -15.769856, 'longitude' :-47.887786},
    {'latitude' : -15.780024, 'longitude' :-47.885125},
    {'latitude' : -15.754241, 'longitude' :-47.884474},
    {'latitude' : -15.782167, 'longitude' :-47.890315},
    {'latitude' : -15.782749, 'longitude' :-47.890151},
    {'latitude' : -15.630444, 'longitude' :-47.651206},
    {'latitude' : -15.748654, 'longitude' :-47.891705},
    {'latitude' : -15.82087, 'longitude' :-47.902604},
    {'latitude' : -15.828366, 'longitude' :-47.91295},
    {'latitude' : -15.810876, 'longitude' :-47.913175},
    {'latitude' : -15.817583, 'longitude' :-47.982971},
    {'latitude' : -16.005586, 'longitude' :-48.063498},
    {'latitude' : -16.011537, 'longitude' :-48.084263},
    {'latitude' : -15.775393, 'longitude' :-47.873335},
    {'latitude' : -15.867152, 'longitude' :-48.027152},
    {'latitude' : -15.793923, 'longitude' :-48.037651},
    {'latitude' : -15.804391, 'longitude' :-47.891383},
    {'latitude' : -15.80417, 'longitude' :-47.891634},
    {'latitude' : -15.817142, 'longitude' :-47.859111},
    {'latitude' : -15.816437, 'longitude' :-47.859028},
    {'latitude' : -15.816102, 'longitude' :-47.858101},
    {'latitude' : -15.816712, 'longitude' :-47.850723},
    {'latitude' : -15.819075, 'longitude' :-47.841179},
    {'latitude' : -15.819654, 'longitude' :-47.840288},
    {'latitude' : -15.803878, 'longitude' :-47.934569},
    {'latitude' : -15.8001, 'longitude' :-48.033742},
    {'latitude' : -15.806886, 'longitude' :-47.888098},
    {'latitude' : -15.838765, 'longitude' :-47.950002},
    {'latitude' : -15.839166, 'longitude' :-47.949464},
    {'latitude' : -15.839013, 'longitude' :-47.949668},
    {'latitude' : -15.776966, 'longitude' :-47.78068},
    {'latitude' : -15.769627, 'longitude' :-47.781998},
    {'latitude' : -15.767482, 'longitude' :-47.783286},
    {'latitude' : -15.77019, 'longitude' :-47.779992},
    {'latitude' : -15.837164, 'longitude' :-47.911145},
    {'latitude' : -15.820127, 'longitude' :-47.921954},
    {'latitude' : -15.813385, 'longitude' :-47.900436},
    {'latitude' : -15.813159, 'longitude' :-47.900645},
    {'latitude' : -15.881362, 'longitude' :-48.01578},
    {'latitude' : -15.809805, 'longitude' :-47.895013},
    {'latitude' : -15.765936, 'longitude' :-47.88868},
    {'latitude' : -15.818243, 'longitude' :-47.904662},
    {'latitude' : -15.812839, 'longitude' :-47.90314},
    {'latitude' : -15.816397, 'longitude' :-47.897616},
    {'latitude' : -15.780599, 'longitude' :-47.883594},
    {'latitude' : -15.837347, 'longitude' :-48.041516},
    {'latitude' : -15.878246, 'longitude' :-47.772194},
    {'latitude' : -15.878122, 'longitude' :-47.772454},
    {'latitude' : -15.880324, 'longitude' :-47.802885},
    {'latitude' : -15.748583, 'longitude' :-47.781267},
    {'latitude' : -15.87114, 'longitude' :-47.794392},
    {'latitude' : -15.869178, 'longitude' :-47.814854},
    {'latitude' : -15.868945, 'longitude' :-47.814541},
    {'latitude' : -15.771746, 'longitude' :-47.93131},
    {'latitude' : -16.015821, 'longitude' :-48.004751},
    {'latitude' : -16.016522, 'longitude' :-48.005474},
    {'latitude' : -15.765215, 'longitude' :-47.894204},
    {'latitude' : -15.886044, 'longitude' :-48.017772},
    {'latitude' : -15.879547, 'longitude' :-48.005168},
    {'latitude' : -15.879403, 'longitude' :-48.01022},
    {'latitude' : -15.886216, 'longitude' :-48.017692},
    {'latitude' : -15.840955, 'longitude' :-48.036925},
    {'latitude' : -15.867057, 'longitude' :-48.057598},
    {'latitude' : -15.748108, 'longitude' :-47.872699},
    {'latitude' : -15.748835, 'longitude' :-47.872053},
    {'latitude' : -15.748864, 'longitude' :-47.872472},
    {'latitude' : -15.749632, 'longitude' :-47.87309},
    {'latitude' : -15.749021, 'longitude' :-47.873517},
    {'latitude' : -15.891744, 'longitude' :-47.781407},
    {'latitude' : -15.891688, 'longitude' :-47.781723},
    {'latitude' : -15.864843, 'longitude' :-47.823652},
    {'latitude' : -15.864388, 'longitude' :-47.822798},
    {'latitude' : -15.864449, 'longitude' :-47.822573},
    {'latitude' : -15.864508, 'longitude' :-47.822345},
    {'latitude' : -15.842003, 'longitude' :-47.97771},
    {'latitude' : -15.790264, 'longitude' :-47.850033},
    {'latitude' : -15.790769, 'longitude' :-47.847661},
    {'latitude' : -15.677019, 'longitude' :-48.19418},
    {'latitude' : -15.835581, 'longitude' :-48.043571},
    {'latitude' : -16.046504, 'longitude' :-48.043003},
    {'latitude' : -15.893184, 'longitude' :-47.808862},
    {'latitude' : -15.860576, 'longitude' :-48.028681},
    {'latitude' : -15.779611, 'longitude' :-47.88884},
    {'latitude' : -15.810042, 'longitude' :-47.894531},
    {'latitude' : -15.877706, 'longitude' :-48.021999},
    {'latitude' : -15.887421, 'longitude' :-48.012766},
    {'latitude' : -15.887589, 'longitude' :-48.023524},
    {'latitude' : -15.882885, 'longitude' :-48.020194},
    {'latitude' : -15.884192, 'longitude' :-48.024265},
    {'latitude' : -15.884988, 'longitude' :-48.014348},
    {'latitude' : -15.88793, 'longitude' :-48.02176},
    {'latitude' : -15.886489, 'longitude' :-48.017995},
    {'latitude' : -15.830477, 'longitude' :-47.958385},
    {'latitude' : -15.830893, 'longitude' :-47.957491},
    {'latitude' : -15.894868, 'longitude' :-47.980495},
    {'latitude' : -15.709883, 'longitude' :-47.912388},
    {'latitude' : -15.698363, 'longitude' :-47.913489},
    {'latitude' : -15.649661, 'longitude' :-47.648474},
    {'latitude' : -15.649673, 'longitude' :-47.64879},
    {'latitude' : -15.816677, 'longitude' :-47.869546},
    {'latitude' : -15.833461, 'longitude' :-48.042569},
    {'latitude' : -15.8902, 'longitude' :-48.115403},
    {'latitude' : -15.825712, 'longitude' :-47.915843},
    {'latitude' : -15.816598, 'longitude' :-47.908689},
    {'latitude' : -15.832193, 'longitude' :-47.97181},
    {'latitude' : -15.903631, 'longitude' :-47.777187},
    {'latitude' : -15.903056, 'longitude' :-47.777853},
    {'latitude' : -15.84176, 'longitude' :-47.964759},
    {'latitude' : -15.842307, 'longitude' :-47.965517},
    {'latitude' : -15.742147, 'longitude' :-47.895516},
    {'latitude' : -15.800275, 'longitude' :-47.852587},
    {'latitude' : -15.934565, 'longitude' :-47.601949},
    {'latitude' : -15.798878, 'longitude' :-47.944842},
    {'latitude' : -15.799855, 'longitude' :-47.944959},
    {'latitude' : -15.778516, 'longitude' :-47.916849},
    {'latitude' : -15.621678, 'longitude' :-47.652689},
    {'latitude' : -15.614726, 'longitude' :-47.651832},
    {'latitude' : -15.790795, 'longitude' :-47.915092},
    {'latitude' : -15.774461, 'longitude' :-47.931943},
    {'latitude' : -15.774041, 'longitude' :-47.931938},
    {'latitude' : -15.774121, 'longitude' :-47.93167},
    {'latitude' : -15.773327, 'longitude' :-47.927639},
    {'latitude' : -15.773673, 'longitude' :-47.92343},
    {'latitude' : -15.774003, 'longitude' :-47.923537},
    {'latitude' : -15.772421, 'longitude' :-47.927368},
    {'latitude' : -15.772785, 'longitude' :-47.927493},
    {'latitude' : -15.778376, 'longitude' :-47.908673},
    {'latitude' : -15.846856, 'longitude' :-47.981809},
    {'latitude' : -15.878315, 'longitude' :-48.018483},
    {'latitude' : -16.000911, 'longitude' :-48.056581},
    {'latitude' : -16.0011, 'longitude' :-48.055354},
    {'latitude' : -16.006621, 'longitude' :-48.068838},
    {'latitude' : -16.00619, 'longitude' :-48.067792},
    {'latitude' : -16.008071, 'longitude' :-48.066438},
    {'latitude' : -16.00985, 'longitude' :-48.057974},
    {'latitude' : -16.009922, 'longitude' :-48.057621},
    {'latitude' : -15.82234, 'longitude' :-47.966186},
    {'latitude' : -15.792486, 'longitude' :-47.915513},
    {'latitude' : -15.79178, 'longitude' :-47.915505},
    {'latitude' : -15.995436, 'longitude' :-48.052571},
    {'latitude' : -15.790237, 'longitude' :-47.918292},
    {'latitude' : -15.790194, 'longitude' :-47.91842},
    {'latitude' : -15.789986, 'longitude' :-47.918316},
    {'latitude' : -15.796131, 'longitude' :-47.921223},
    {'latitude' : -15.677253, 'longitude' :-48.201271},
    {'latitude' : -15.830951, 'longitude' :-47.987803},
    {'latitude' : -15.682778, 'longitude' :-48.198169},
    {'latitude' : -15.671613, 'longitude' :-48.200474},
    {'latitude' : -15.687224, 'longitude' :-48.191883},
    {'latitude' : -15.667139, 'longitude' :-48.197099},
    {'latitude' : -15.681492, 'longitude' :-48.198673},
    {'latitude' : -15.674422, 'longitude' :-48.200556},
    {'latitude' : -15.664865, 'longitude' :-48.201413},
    {'latitude' : -15.665662, 'longitude' :-48.194291},
    {'latitude' : -15.66594, 'longitude' :-48.19335},
    {'latitude' : -15.878298, 'longitude' :-48.079031},
    {'latitude' : -15.871212, 'longitude' :-48.070044},
    {'latitude' : -15.797234, 'longitude' :-47.831949},
    {'latitude' : -15.796993, 'longitude' :-47.83167},
    {'latitude' : -15.660017, 'longitude' :-48.19967},
    {'latitude' : -15.658573, 'longitude' :-48.196072},
    {'latitude' : -15.659367, 'longitude' :-48.19308},
    {'latitude' : -15.669878, 'longitude' :-48.201838},
    {'latitude' : -15.883139, 'longitude' :-47.965011},
    {'latitude' : -15.883213, 'longitude' :-47.96565},
    {'latitude' : -15.883244, 'longitude' :-47.966307},
    {'latitude' : -15.66427, 'longitude' :-48.197639},
    {'latitude' : -15.901563, 'longitude' :-48.06195},
    {'latitude' : -15.90155, 'longitude' :-48.065871},
    {'latitude' : -15.664166, 'longitude' :-48.190983},
    {'latitude' : -15.803543, 'longitude' :-47.931256},
    {'latitude' : -15.79373, 'longitude' :-47.940415},
    {'latitude' : -15.817667, 'longitude' :-47.848829},
    {'latitude' : -15.818214, 'longitude' :-47.848754},
    {'latitude' : -15.818489, 'longitude' :-47.849011},
    {'latitude' : -15.818434, 'longitude' :-47.848715},
    {'latitude' : -15.635762, 'longitude' :-47.823364},
    {'latitude' : -15.636507, 'longitude' :-47.822866},
    {'latitude' : -15.893833, 'longitude' :-48.120595},
    {'latitude' : -15.885208, 'longitude' :-48.096263},
    {'latitude' : -15.830202, 'longitude' :-48.108505},
    {'latitude' : -15.79365, 'longitude' :-47.846529},
    {'latitude' : -15.910066, 'longitude' :-48.048433},
    {'latitude' : -15.8381, 'longitude' :-47.903772},
    {'latitude' : -15.862651, 'longitude' :-47.859609},
    {'latitude' : -15.85813, 'longitude' :-48.035045},
    {'latitude' : -15.688254, 'longitude' :-47.827208},
    {'latitude' : -15.820107, 'longitude' :-48.022312},
    {'latitude' : -15.795146, 'longitude' :-47.920361},
    {'latitude' : -15.800975, 'longitude' :-48.124511},
    {'latitude' : -15.801775, 'longitude' :-48.126368},
    {'latitude' : -15.788381, 'longitude' :-48.131667},
    {'latitude' : -15.805954, 'longitude' :-47.910413},
    {'latitude' : -15.788134, 'longitude' :-47.855291},
    {'latitude' : -15.70498, 'longitude' :-47.820487},
    {'latitude' : -15.740369, 'longitude' :-47.899664},
    {'latitude' : -15.961038, 'longitude' :-47.81953},
    {'latitude' : -15.845141, 'longitude' :-48.12542},
    {'latitude' : -15.862247, 'longitude' :-48.021749},
    {'latitude' : -15.860249, 'longitude' :-48.021675},
    {'latitude' : -15.786121, 'longitude' :-48.139366},
    {'latitude' : -15.800535, 'longitude' :-48.097513},
    {'latitude' : -15.639711, 'longitude' :-47.802023},
    {'latitude' : -15.89309, 'longitude' :-48.136862},
    {'latitude' : -15.755058, 'longitude' :-47.883847},
    {'latitude' : -16.012308, 'longitude' :-48.005392},
    {'latitude' : -16.013851, 'longitude' :-48.051867},
    {'latitude' : -15.842687, 'longitude' :-47.912894},
    {'latitude' : -15.803824, 'longitude' :-48.061703},
    {'latitude' : -15.763332, 'longitude' :-47.885793},
    {'latitude' : -15.817321, 'longitude' :-47.974016},
    {'latitude' : -15.879591, 'longitude' :-47.97842},
    {'latitude' : -15.81659, 'longitude' :-47.972343},
    {'latitude' : -15.673619, 'longitude' :-47.856875},
    {'latitude' : -16.036513, 'longitude' :-48.027567},
    {'latitude' : -15.796517, 'longitude' :-48.053704},
    {'latitude' : -15.796746, 'longitude' :-48.053777},
    {'latitude' : -15.875327, 'longitude' :-48.076025},
    {'latitude' : -15.866496, 'longitude' :-48.065283},
    {'latitude' : -15.866372, 'longitude' :-48.066102},
    {'latitude' : -15.814417, 'longitude' :-47.953369},
    {'latitude' : -15.81145, 'longitude' :-47.953651},
    {'latitude' : -16.040117, 'longitude' :-48.029866},
    {'latitude' : -15.838901, 'longitude' :-48.207302},
    {'latitude' : -15.837724, 'longitude' :-48.207048},
    {'latitude' : -15.816354, 'longitude' :-48.045084},
    {'latitude' : -15.889888, 'longitude' :-47.807568},
    {'latitude' : -15.847373, 'longitude' :-48.054406},
    {'latitude' : -15.847535, 'longitude' :-48.053218},
    {'latitude' : -15.846792, 'longitude' :-48.054558},
    {'latitude' : -15.874585, 'longitude' :-47.979194},
    {'latitude' : -15.88449, 'longitude' :-47.977079},
    {'latitude' : -16.028795, 'longitude' :-48.07615},
    {'latitude' : -15.801479, 'longitude' :-47.937872},
    {'latitude' : -15.848211, 'longitude' :-47.921928},
    {'latitude' : -15.845393, 'longitude' :-47.920216},
    {'latitude' : -15.668801, 'longitude' :-47.854789},
    {'latitude' : -15.656643, 'longitude' :-47.872996},
    {'latitude' : -15.593812, 'longitude' :-47.859706},
    {'latitude' : -15.993418, 'longitude' :-47.995394},
    {'latitude' : -15.689193, 'longitude' :-47.833614},
    {'latitude' : -15.758072, 'longitude' :-47.8878},
    {'latitude' : -15.757919, 'longitude' :-47.887149},
    {'latitude' : -15.829986, 'longitude' :-48.032201},
    {'latitude' : -16.014609, 'longitude' :-47.987341},
    {'latitude' : -16.014697, 'longitude' :-47.987984},
    {'latitude' : -16.015432, 'longitude' :-48.06065},
    {'latitude' : -15.854255, 'longitude' :-47.85104},
    {'latitude' : -15.64052, 'longitude' :-47.787366},
    {'latitude' : -15.640763, 'longitude' :-47.785966},
    {'latitude' : -15.640676, 'longitude' :-47.78578},
    {'latitude' : -15.64059, 'longitude' :-47.785596},
    {'latitude' : -15.640474, 'longitude' :-47.785398},
    {'latitude' : -15.653663, 'longitude' :-47.794053},
    {'latitude' : -15.806411, 'longitude' :-47.944902},
    {'latitude' : -15.735198, 'longitude' :-47.785978},
    {'latitude' : -15.731568, 'longitude' :-47.86434},
    {'latitude' : -15.600464, 'longitude' :-47.659961},
    {'latitude' : -15.784123, 'longitude' :-47.855007},
    {'latitude' : -15.784237, 'longitude' :-47.85463},
    {'latitude' : -15.750866, 'longitude' :-47.869509},
    {'latitude' : -15.750519, 'longitude' :-47.86986},
    {'latitude' : -15.825579, 'longitude' :-47.907618},
    {'latitude' : -15.743583, 'longitude' :-47.893198},
    {'latitude' : -15.743092, 'longitude' :-47.892891},
    {'latitude' : -15.659795, 'longitude' :-47.740385},
    {'latitude' : -15.838965, 'longitude' :-48.018806},
    {'latitude' : -15.838916, 'longitude' :-48.018689},
    {'latitude' : -15.598284, 'longitude' :-47.682001},
    {'latitude' : -15.883229, 'longitude' :-47.969522},
    {'latitude' : -15.874306, 'longitude' :-47.979088},
    {'latitude' : -15.874501, 'longitude' :-47.978894},
    {'latitude' : -15.790995, 'longitude' :-47.852558},
    {'latitude' : -15.78351, 'longitude' :-47.899206},
    {'latitude' : -15.641056, 'longitude' :-47.633861},
    {'latitude' : -15.640438, 'longitude' :-47.628023},
    {'latitude' : -15.779819, 'longitude' :-47.786345},
    {'latitude' : -15.823685, 'longitude' :-48.099209},
    {'latitude' : -15.810962, 'longitude' :-47.964822},
    {'latitude' : -15.811375, 'longitude' :-47.965037},
    {'latitude' : -15.811106, 'longitude' :-47.965753},
    {'latitude' : -15.812595, 'longitude' :-47.964449},
    {'latitude' : -15.812125, 'longitude' :-47.963869},
    {'latitude' : -15.812145, 'longitude' :-47.964374},
    {'latitude' : -15.812434, 'longitude' :-47.963133},
    {'latitude' : -15.753346, 'longitude' :-47.90722},
    {'latitude' : -15.752291, 'longitude' :-47.903363},
    {'latitude' : -15.78835, 'longitude' :-47.780609},
    {'latitude' : -15.860996, 'longitude' :-48.173096},
    {'latitude' : -15.922985, 'longitude' :-48.042865},
    {'latitude' : -15.831079, 'longitude' :-47.988566},
    {'latitude' : -15.895457, 'longitude' :-47.915448},
    {'latitude' : -15.601458, 'longitude' :-47.870448},
    {'latitude' : -15.909837, 'longitude' :-47.945763},
    {'latitude' : -16.034725, 'longitude' :-48.036064},
    {'latitude' : -15.993793, 'longitude' :-47.99618},
    {'latitude' : -15.827634, 'longitude' :-47.989627},
    {'latitude' : -15.827124, 'longitude' :-47.989853},
    {'latitude' : -15.89143, 'longitude' :-47.948456},
    {'latitude' : -15.892129, 'longitude' :-47.949533},
    {'latitude' : -15.603506, 'longitude' :-47.65842},
    {'latitude' : -15.80353, 'longitude' :-48.020041},
    {'latitude' : -15.791443, 'longitude' :-48.017353},
    {'latitude' : -15.792371, 'longitude' :-48.017354},
    {'latitude' : -15.914703, 'longitude' :-48.046773},
    {'latitude' : -16.030989, 'longitude' :-48.027665},
    {'latitude' : -16.039684, 'longitude' :-48.033698},
    {'latitude' : -16.043604, 'longitude' :-48.038114},
    {'latitude' : -15.591573, 'longitude' :-47.868195},
    {'latitude' : -15.805861, 'longitude' :-47.887026},
    {'latitude' : -15.833034, 'longitude' :-48.007124},
    {'latitude' : -15.739551, 'longitude' :-47.885259},
    {'latitude' : -15.745666, 'longitude' :-47.877528},
    {'latitude' : -15.997025, 'longitude' :-47.990637},
    {'latitude' : -15.630185, 'longitude' :-47.717968},
    {'latitude' : -15.75502, 'longitude' :-47.884224},
    {'latitude' : -15.640776, 'longitude' :-47.789375},
    {'latitude' : -15.641953, 'longitude' :-47.79746},
    {'latitude' : -15.637534, 'longitude' :-47.805126},
    {'latitude' : -15.649111, 'longitude' :-47.799073},
    {'latitude' : -15.649164, 'longitude' :-47.798889},
    {'latitude' : -15.649212, 'longitude' :-47.798684},
    {'latitude' : -15.895882, 'longitude' :-47.935276},
    {'latitude' : -15.894866, 'longitude' :-47.935653},
    {'latitude' : -15.603513, 'longitude' :-47.654687},
    {'latitude' : -15.836262, 'longitude' :-48.134288},
    {'latitude' : -15.835622, 'longitude' :-48.134659},
    {'latitude' : -15.828036, 'longitude' :-48.132791},
    {'latitude' : -15.859144, 'longitude' :-48.052323},
    {'latitude' : -15.811207, 'longitude' :-48.106734},
    {'latitude' : -15.78513, 'longitude' :-48.124513},
    {'latitude' : -15.808663, 'longitude' :-48.14097},
    {'latitude' : -15.800547, 'longitude' :-47.892375},
    {'latitude' : -15.800539, 'longitude' :-47.892382},
    {'latitude' : -15.834832, 'longitude' :-48.054985},
    {'latitude' : -15.834993, 'longitude' :-48.05529},
    {'latitude' : -15.897907, 'longitude' :-47.914172},
    {'latitude' : -15.797996, 'longitude' :-47.857117},
    {'latitude' : -15.797836, 'longitude' :-47.858312},
    {'latitude' : -15.914765, 'longitude' :-48.09981},
    {'latitude' : -15.853589, 'longitude' :-48.111448},
    {'latitude' : -15.756376, 'longitude' :-47.878364},
    {'latitude' : -15.795064, 'longitude' :-48.03141},
    {'latitude' : -15.835542, 'longitude' :-48.054585},
    {'latitude' : -15.80901, 'longitude' :-47.881987},
    {'latitude' : -15.846436, 'longitude' :-48.113765},
    {'latitude' : -15.736267, 'longitude' :-47.903903},
    {'latitude' : -15.642027, 'longitude' :-47.821474},
    {'latitude' : -15.800004, 'longitude' :-48.055058},
    {'latitude' : -15.803116, 'longitude' :-48.056939},
    {'latitude' : -15.817534, 'longitude' :-48.056075},
    {'latitude' : -15.790818, 'longitude' :-48.134019},
    {'latitude' : -15.788294, 'longitude' :-48.130632},
    {'latitude' : -15.798185, 'longitude' :-48.131012},
    {'latitude' : -15.8731, 'longitude' :-48.082697},
    {'latitude' : -15.821404, 'longitude' :-47.910581},
    {'latitude' : -15.65327, 'longitude' :-47.786826}
  ];
}