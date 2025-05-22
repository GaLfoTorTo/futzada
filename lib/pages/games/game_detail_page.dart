import 'package:flutter/material.dart';
import 'package:futzada/controllers/game_controller.dart';
import 'package:get/get.dart';
import 'package:futzada/widget/bars/header_widget.dart';

class GameDetailPage extends StatefulWidget {
  const GameDetailPage({super.key});

  @override
  State<GameDetailPage> createState() => _MatchPageState();
}

class _MatchPageState extends State<GameDetailPage> {
  int _currentMinute = 32;
    int _homeScore = 1;
    int _awayScore = 0;
    bool _isMatchLive = true;
    String _matchPeriod = "1º Tempo";

    // Dados de exemplo
    final homeTeam = {
      'name': 'Brasil',
      'logo': '🇧🇷',
      'coach': 'Tite',
      'formation': '4-3-3',
      'players': [
        {'number': 1, 'name': 'Alisson', 'position': 'GK', 'events': []},
        {'number': 2, 'name': 'Danilo', 'position': 'DF', 'events': []},
        {'number': 3, 'name': 'Thiago Silva', 'position': 'DF', 'events': []},
        {'number': 4, 'name': 'Marquinhos', 'position': 'DF', 'events': []},
        {'number': 6, 'name': 'Alex Sandro', 'position': 'DF', 'events': []},
        {'number': 5, 'name': 'Casemiro', 'position': 'MF', 'events': []},
        {'number': 8, 'name': 'Fred', 'position': 'MF', 'events': []},
        {'number': 7, 'name': 'Lucas Paquetá', 'position': 'MF', 'events': []},
        {'number': 10, 'name': 'Neymar', 'position': 'FW', 'events': ['⚽ 15\'']},
        {'number': 9, 'name': 'Richarlison', 'position': 'FW', 'events': []},
        {'number': 11, 'name': 'Raphinha', 'position': 'FW', 'events': []},
      ],
    };

    final awayTeam = {
      'name': 'Argentina',
      'logo': '🇦🇷',
      'coach': 'Scaloni',
      'formation': '4-4-2',
      'players': [
        {'number': 23, 'name': 'D. Martínez', 'position': 'GK', 'events': []},
        {'number': 4, 'name': 'Montiel', 'position': 'DF', 'events': []},
        {'number': 13, 'name': 'Romero', 'position': 'DF', 'events': []},
        {'number': 19, 'name': 'Otamendi', 'position': 'DF', 'events': []},
        {'number': 3, 'name': 'Tagliafico', 'position': 'DF', 'events': []},
        {'number': 7, 'name': 'De Paul', 'position': 'MF', 'events': []},
        {'number': 5, 'name': 'Paredes', 'position': 'MF', 'events': []},
        {'number': 20, 'name': 'Lo Celso', 'position': 'MF', 'events': []},
        {'number': 11, 'name': 'Di María', 'position': 'MF', 'events': []},
        {'number': 10, 'name': 'Messi', 'position': 'FW', 'events': []},
        {'number': 22, 'name': 'L. Martínez', 'position': 'FW', 'events': []},
      ],
    };

    final matchStats = {
      'possession': {'home': 58, 'away': 42},
      'shots': {'home': 7, 'away': 3},
      'shots_on_target': {'home': 3, 'away': 1},
      'corners': {'home': 4, 'away': 2},
      'fouls': {'home': 8, 'away': 12},
      'offsides': {'home': 1, 'away': 3},
      'yellow_cards': {'home': 1, 'away': 2},
      'red_cards': {'home': 0, 'away': 0},
    };

    final matchEvents = [
      {'time': '15\'', 'type': 'goal', 'team': 'home', 'player': 'Neymar', 'description': 'Gol de Neymar'},
      {'time': '28\'', 'type': 'yellow', 'team': 'away', 'player': 'Paredes', 'description': 'Cartão amarelo para Paredes'},
    ];

    final matchInfo = {
      'competition': 'Amistoso Internacional',
      'stadium': 'Maracanã, Rio de Janeiro',
      'date': '10 de Novembro de 2023',
      'referee': 'Wilton Sampaio (BRA)',
      'attendance': '65,000',
    };

    Widget _buildSummaryTab() {
      return SingleChildScrollView(
        child: Column(
          children: [
            // Cabeçalho com informações da partida
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    matchInfo['competition']!,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    matchInfo['stadium']!,
                    style: TextStyle(fontSize: 14),
                  ),
                  SizedBox(height: 4),
                  Text(
                    matchInfo['date']!,
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
            
            // Placar
            Container(
              color: Colors.green[50],
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Time da casa
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          "${homeTeam['name']!}",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "${homeTeam['logo']!}",
                          style: TextStyle(fontSize: 40),
                        ),
                      ],
                    ),
                  ),
                  
                  // Placar e tempo
                  Column(
                    children: [
                      if (_isMatchLive)
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            'AO VIVO',
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ),
                      SizedBox(height: 8),
                      Text(
                        '$_matchPeriod $_currentMinute\'',
                        style: TextStyle(fontSize: 14),
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.green[100],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '$_homeScore',
                              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child: Text('x', style: TextStyle(fontSize: 20)),
                          ),
                          Container(
                            width: 50,
                            height: 50,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.green[100],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '$_awayScore',
                              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  
                  // Time visitante
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          "${awayTeam['name']!}",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "${awayTeam['logo']!}",
                          style: TextStyle(fontSize: 40),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            // Eventos do jogo
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Eventos do Jogo',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  ...matchEvents.map((event) => Padding(
                    padding: EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          child: Text(event['time']!, style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        SizedBox(width: 8),
                        Icon(
                          event['type'] == 'goal' ? Icons.sports_soccer : 
                          event['type'] == 'yellow' ? Icons.warning_amber : Icons.warning,
                          color: event['type'] == 'goal' ? Colors.green : 
                                event['type'] == 'yellow' ? Colors.yellow[700] : Colors.red,
                        ),
                        SizedBox(width: 8),
                        Text(
                          event['player']!,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(event['description']!),
                        ),
                      ],
                    ),
                  )).toList(),
                ],
              ),
            ),
          ],
        ),
      );
    }

    Widget _buildPlayerRow(Map<String, dynamic> player, bool isHomeTeam) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            Container(
              width: 30,
              height: 30,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isHomeTeam ? Colors.green[100] : Colors.blue[100],
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(
                player['number'].toString(),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Text(player['name']),
            ),
            SizedBox(width: 12),
            Text(
              player['position'],
              style: TextStyle(color: Colors.grey),
            ),
            if (player['events'].length > 0) ...[
              SizedBox(width: 12),
              ...player['events'].map((event) => Text(event)).toList(),
            ],
          ],
        ),
      );
    }

    Widget _buildLineupsTab() {
      return SingleChildScrollView(
        child: Column(
          children: [
            // Formações
            Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Text(
                        "${homeTeam['name']!}",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 4),
                      Text('${homeTeam['formation']}'),
                      SizedBox(height: 4),
                      Text('Técnico: ${homeTeam['coach']}'),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        "${awayTeam['name']!}",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 4),
                      Text('${awayTeam['formation']}'),
                      SizedBox(height: 4),
                      Text('Técnico: ${awayTeam['coach']}'),
                    ],
                  ),
                ],
              ),
            ),
            
            // Jogadores - Time da casa
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${homeTeam['name']} - Titulares',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  //...homeTeam['players']!.map((player) => _buildPlayerRow(player, true)).toList(),
                ],
              ),
            ),
            
            Divider(height: 32, thickness: 1),
            
            // Jogadores - Time visitante
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${awayTeam['name']} - Titulares',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  //...awayTeam['players']!.map((player) => _buildPlayerRow(player, false)).toList(),
                ],
              ),
            ),
          ],
        ),
      );
    }

    Widget _buildStatRow(String statName, int homeValue, int awayValue) {
      int total = homeValue + awayValue;
      double homePercent = total > 0 ? homeValue / total : 0.5;
      
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    homeValue.toString(),
                    textAlign: TextAlign.right,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(width: 16),
                Container(
                  width: 120,
                  child: Text(
                    statName,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Text(
                    awayValue.toString(),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            SizedBox(height: 4),
            Row(
              children: [
                Expanded(
                  child: LinearProgressIndicator(
                    value: homePercent,
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: LinearProgressIndicator(
                    value: 1 - homePercent,
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }

    Widget _buildStatsTab() {
      return SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              _buildStatRow('Posse de bola', matchStats['possession']!['home']!, matchStats['possession']!['away']!),
              _buildStatRow('Finalizações', matchStats['shots']!['home']!, matchStats['shots']!['away']!),
              _buildStatRow('Finalizações no gol', matchStats['shots_on_target']!['home']!, matchStats['shots_on_target']!['away']!),
              _buildStatRow('Escanteios', matchStats['corners']!['home']!, matchStats['corners']!['away']!),
              _buildStatRow('Faltas', matchStats['fouls']!['home']!, matchStats['fouls']!['away']!),
              _buildStatRow('Impedimentos', matchStats['offsides']!['home']!, matchStats['offsides']!['away']!),
              _buildStatRow('Cartões amarelos', matchStats['yellow_cards']!['home']!, matchStats['yellow_cards']!['away']!),
              _buildStatRow('Cartões vermelhos', matchStats['red_cards']!['home']!, matchStats['red_cards']!['away']!),
            ],
          ),
        ),
      );
    }
    
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Detalhes da Partida'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Resumo'),
              Tab(text: 'Escalações'),
              Tab(text: 'Estatísticas'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildSummaryTab(),
            _buildLineupsTab(),
            _buildStatsTab(),
          ],
        ),
      ),
    );
  }
}