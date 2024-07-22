import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:futzada/helpers/app_helper.dart';
import 'package:futzada/providers/usuario_provider.dart';
import 'package:futzada/pages/home/secao/secao_home_widget.dart';
import 'package:futzada/widget/cards/card_para_voce_widget.dart';
import 'package:futzada/widget/skeletons/skeleton_home_widget.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:provider/provider.dart';
import '/theme/app_colors.dart';
import '/theme/app_icones.dart';
import '/widget/images/ImgCircularWidget.dart';

class HomePage extends StatefulWidget {
  final Function menuFunction;
  final Function chatFunction;

  const HomePage({
    super.key,
    required this.menuFunction,
    required this.chatFunction,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  //BUSCAR USUARIO PROVIDER
  late UsuarioProvider usuarioProvider;
  late var usuario;
   late Future<List<Color>> dominantColorsFuture;
  //LISTA DE CORES GRADIENTE PARA IMAGEM E TITULO 
  LinearGradient gradientDefault = LinearGradient(
                      colors: [
                        AppColors.dark_500.withOpacity(0),
                        AppColors.dark_500,
                      ],
                      begin: Alignment.center,
                      end: Alignment.bottomCenter,
                );
  Color textColorsDefault = AppColors.white;
  //LISTA DE OPTIONS PARA O CARD PERTO DE VOCE
  List<Map<String, dynamic>> peladas = [];
  //LISTA DE OPTIONS PARA O CARD TOP RANKING
  List<Map<String, dynamic>> ranking = [];

  @override
  void initState() {
    super.initState();
  }

  //SIMNULAR BUSCA DE RECOMENDAÇÕES NO SERVIDOR
  Future<void> fetchPertoVoce() async {
    //DELAY DE 2 SEGUNDOS
    await Future.delayed(Duration(seconds: 2));
    //INICIALIZAR PELADAS
    peladas = [
      {
        'titulo':'Pelada 1',
        'distancia':'1 Km',
        'gradient': gradientDefault,
        'textColor' : textColorsDefault,
        'image': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR_TKnLeWu0hXkL_Hn5V8Cbht0EoJcp1qpkUg&s'
      },
      {
        'titulo':'Pelada 2',
        'distancia':'5 Km',
        'gradient': gradientDefault,
        'textColor' : textColorsDefault,
        'image': 'https://conteudo.imguol.com.br/c/esporte/f6/2018/12/14/especial---futebol-raiz-vista-de-regiao-da-mooca-com-o-estadio-conde-rodolfo-crespi-do-juventus-na-rua-javari-1544836797933_v2_956x500.jpg'
      },
      {
        'titulo':'Pelada 3',
        'distancia':'7 Km',
        'gradient': gradientDefault,
        'textColor' : textColorsDefault,
        'image': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQpvAPs7hide0pK8nHFQWOGIevZYGjBz7tmg74I6Yne2lTyFV3E8PfqPUyoxRTh4-rjGAc&usqp=CAU'
      },
      {
        'titulo':'Pelada 4',
        'distancia':'8 Km',
        'gradient': gradientDefault,
        'textColor' : textColorsDefault,
        'image': 'https://conteudo.imguol.com.br/c/esporte/10/2018/12/17/especial---futebol-raiz-varzea-1545078822417_v2_1920x1080.jpg'
      },
      {
        'titulo':'Pelada 5',
        'distancia':'10 Km',
        'gradient': gradientDefault,
        'textColor' : textColorsDefault,
        'image': 'https://pbs.twimg.com/media/DV2GFCuXUAABORU?format=jpg&name=small'
      },
    ];
    //RESGATAR COR PREDOMINANTE DAS IMAGENS DOS CARDS
    for (var item in peladas) {
      var colorSelected = await getDominantColor(item['image']!);
      //ATUALIZAR O GRADIENTE DOS CARDS APARTIR DAS CORES OBTIDAS
      item['gradient'] = LinearGradient(
        colors: [
          colorSelected.withOpacity(0.0),
          colorSelected,
        ],
        begin: Alignment.center,
        end: Alignment.bottomCenter,
      );
      //VERIFCAR SE LUMINOSIDADE DA COR OBTIDA E RETORNAR COR PARA TEXTO NO CARD
      item['textColor'] = colorSelected.computeLuminance() > 0.5 ? AppColors.dark_500 : AppColors.white;
    }
  }

  Future<void>fecthTopRanking() async {
    //DELAY DE 2 SEGUNDOS
    await Future.delayed(Duration(seconds: 2));
    //INICIALIZAR TOP RANKING
    ranking = [
      {
        'ranking':'Média',
        'pelada':{
          'image':null,
          'titulo': 'Pelada 1'
        },
        'jogadores': [
          {
            'nome':'jogador 2',
            'user_name':'user_name',
            'posicao':'mei',
            'colocacao':'2',
            'media': '5.91',
            'image': 'https://conteudo.imguol.com.br/c/esporte/f6/2018/12/14/especial---futebol-raiz-vista-de-regiao-da-mooca-com-o-estadio-conde-rodolfo-crespi-do-juventus-na-rua-javari-1544836797933_v2_956x500.jpg'
          },
          {
            'nome':'jogador 1',
            'user_name':'user_name',
            'posicao':'ata',
            'colocacao':'1',
            'media': '5.91',
            'image': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR_TKnLeWu0hXkL_Hn5V8Cbht0EoJcp1qpkUg&s'
          },
          {
            'nome':'jogador 3',
            'user_name':'user_name',
            'posicao':'zag',
            'colocacao':'3',
            'media': '5.91',
            'image': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQpvAPs7hide0pK8nHFQWOGIevZYGjBz7tmg74I6Yne2lTyFV3E8PfqPUyoxRTh4-rjGAc&usqp=CAU'
          },
        ]
      },
      {
        'ranking':'Gols',
        'pelada':{
          'image':null,
          'titulo': 'Pelada 2'
        },
        'jogadores': [
          {
            'nome':'jogador 2',
            'user_name':'user_name',
            'posicao':'ata',
            'colocacao':'2',
            'media': '12',
            'image': 'https://conteudo.imguol.com.br/c/esporte/f6/2018/12/14/especial---futebol-raiz-vista-de-regiao-da-mooca-com-o-estadio-conde-rodolfo-crespi-do-juventus-na-rua-javari-1544836797933_v2_956x500.jpg'
          },
          {
            'nome':'jogador 1',
            'user_name':'user_name',
            'posicao':'ata',
            'colocacao':'1',
            'media': '15',
            'image': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR_TKnLeWu0hXkL_Hn5V8Cbht0EoJcp1qpkUg&s'
          },
          {
            'nome':'jogador 3',
            'user_name':'user_name',
            'posicao':'mei',
            'colocacao':'3',
            'media': '9',
            'image': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQpvAPs7hide0pK8nHFQWOGIevZYGjBz7tmg74I6Yne2lTyFV3E8PfqPUyoxRTh4-rjGAc&usqp=CAU'
          },
        ]
      },
      {
        'ranking':'Assistências',
        'pelada':{
          'image':null,
          'titulo': 'Pelada 3'
        },
        'jogadores': [
          {
            'nome':'jogador 2',
            'user_name':'user_name',
            'posicao':'ata',
            'colocacao':'2',
            'media': '5',
            'image': 'https://conteudo.imguol.com.br/c/esporte/f6/2018/12/14/especial---futebol-raiz-vista-de-regiao-da-mooca-com-o-estadio-conde-rodolfo-crespi-do-juventus-na-rua-javari-1544836797933_v2_956x500.jpg'
          },
          {
            'nome':'jogador 1',
            'user_name':'user_name',
            'posicao':'mei',
            'colocacao':'1',
            'media': '11',
            'image': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR_TKnLeWu0hXkL_Hn5V8Cbht0EoJcp1qpkUg&s'
          },
          {
            'nome':'jogador 3',
            'user_name':'user_name',
            'posicao':'zag',
            'colocacao':'3',
            'media': '4',
            'image': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQpvAPs7hide0pK8nHFQWOGIevZYGjBz7tmg74I6Yne2lTyFV3E8PfqPUyoxRTh4-rjGAc&usqp=CAU'
          },
        ]
      }
    ];
  }

  Future<UsuarioProvider>fetchUsuario(BuildContext context) async {
    //ADICIONAR DELAY DE 2 SEGUNDOS
    await Future.delayed(Duration(seconds: 2));
    //BUSCAR OS DADOS DO PROVIDER 
    usuarioProvider = Provider.of<UsuarioProvider>(context, listen: false);
    //RESGATAR USUARIO
    usuario = usuarioProvider.usuario;
    return usuarioProvider;
  }

  //FUNÇÃO PARA RESGATAR COR PREDOMINANTE DA IMAGEM
  Future<Color> getDominantColor(String imageUrl) async {
    try {
      //RESGATAR IMAGEM 
      final imageProvider = NetworkImage(imageUrl);
      //GERAR PALETA DE CORES APARTIR DA IMAGEM
      final paletteGenerator = await PaletteGenerator.fromImageProvider(
        imageProvider,
        size: const Size(200, 200), //TAMANHO DA IMAGEM PARA ANALISE
        maximumColorCount: 10, //NUMERO MAXIMO DE CORES A SEREM COLETADAS
      );
      //VERIFICAR SE FOI POSSIVEL GERAR A PALETA DE CORES
      if (paletteGenerator.colors.isNotEmpty) {
        //RESGATAR A PRIMERA COR DA PALETA DE CORES
        return paletteGenerator.colors.first;
      } else {
        //COR PADÃO CASO NENHUMA COR TENHA SIDO SELECIONADA
        return AppColors.dark_500;
      }
    } catch (e) {
      //COR PADÃO CASO DE ERRO
      return AppColors.dark_500;
    }
  }
  
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: AppColors.light,
      appBar: AppBar(
        backgroundColor: AppColors.green_300,
        leading: InkWell(
          onTap: () => widget.menuFunction(true),
          child: Container(
            width: 60,
            height: 60,
            decoration: const BoxDecoration(
              color: Colors.transparent,
            ),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: SvgPicture.asset(
                AppIcones.menu["fas"]!,
                width: double.maxFinite,
                height: double.maxFinite,
                color: AppColors.blue_500,
              ),
            ),
          ),
        ),
        actions: [
          InkWell(
            onTap: () => widget.menuFunction(true),
            child: Container(
              width: 60,
              height: 60,
              decoration: const BoxDecoration(
                color: Colors.transparent,
              ),
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: SvgPicture.asset(
                  AppIcones.direct["fas"]!,
                  width: double.maxFinite,
                  height: double.maxFinite,
                  color: AppColors.blue_500,
                ),
              ),
            ),
          ),
        ],
        elevation: 8,
        shadowColor: const Color.fromARGB(255, 0, 0, 0),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: FutureBuilder<List<dynamic>>(
            future: Future.wait([fetchUsuario(context), fetchPertoVoce(), fecthTopRanking()]),
            builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SkeletonHomeWidget();
              } else if (snapshot.hasError) {
                return Center(child: Text('Ocorreu um erro: ${snapshot.error}'));
              } else if (snapshot.hasData) {
                return Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        children: [
                          Stack(
                            children: [
                              ImgCircularWidget(
                                width: 80, 
                                height: 80, 
                                image: usuario.foto
                              ),
                              Positioned(
                                top: 60,
                                left: 60,
                                child: Container(
                                  width: 15,
                                  height: 15,
                                  decoration: BoxDecoration(
                                    color: AppColors.green_300,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.all(15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppHelper.saudacaoPeriodo(),
                                  style: const TextStyle(
                                    color: AppColors.blue_500,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '${usuario.nome} ${usuario.sobrenome}',
                                  style: const TextStyle(
                                    color: AppColors.blue_500,
                                    fontSize: 15,
                                    fontWeight: FontWeight.normal,
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    SecaoHomeWidget(
                      titulo: "Perto de Você",
                      options: peladas,
                    ),
                    SecaoHomeWidget(
                      titulo: "Top Ranking",
                      options: ranking,
                    ),
                  ]
                );
              } else {
                return const SkeletonHomeWidget();
              }
            },
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}