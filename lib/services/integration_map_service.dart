import 'package:geolocator/geolocator.dart';
import 'package:futzada/helpers/app_helper.dart';
import 'package:futzada/models/address_model.dart';
import 'package:url_launcher/url_launcher.dart';
//import 'package:map_launcher/map_launcher.dart';

enum IntegrationApps {
  googleMaps,
  uber,
  ninetyNine,
  waze,
  appleMaps
}

class RideRequestParams {
  final double startLat;
  final double startLng;
  final String? startName;
  final double endLat;
  final double endLng;
  final String? endName;
  final String? travelMode;

  const RideRequestParams({
    required this.startLat,
    required this.startLng,
    this.startName,
    required this.endLat,
    required this.endLng,
    this.endName,
    this.travelMode,
  });
}

class IntegrationRouteService {

  Future<void> abrirMapa() async {
    
  }

  //FUNÇÃO PARA ABRIR APPS DE MAPA/ROTAS
  static Future<void> openRouteApps(AddressModel address, {String? travelModel}) async {
    /* final availableMaps = await MapLauncher.installedMaps;

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              for (final map in availableMaps)
                ListTile(
                  leading: Image(
                    image: map.icon,
                    width: 30,
                    height: 30,
                  ),
                  title: Text(map.mapName),
                  onTap: () {
                    map.showDirections(
                      destination: Coords(-23.563210, -46.654250),
                      destinationTitle: "Meu destino",
                    );
                  },
                ),
            ],
          ),
        );
      },
    ); */
    //BUSCAR POSIÇÃO ATUAL DO USUARIO
    /* final currentPosition = await Geolocator.getCurrentPosition();
    //GERAR PARAMETROS DE ROTA
    final params = RideRequestParams(
      startLat: currentPosition.latitude,
      startLng: currentPosition.longitude,
      endLat: address.latitude!,
      endLng: address.longitude!,
      endName: address.street,
      travelMode: travelModel
    );
    //GERAR URL
    final url = _buildGoogleMapsUrl(params);
    try {
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(
          Uri.parse(url),
          mode: LaunchMode.externalApplication,
        );
      } 
    } catch (e) {
      //GERAR URL PADRÃO PARA O DISPOSITIVO DO USUARIO
      final defaultUrl = _buildUrl(params);
      await launchUrl(
          Uri.parse(defaultUrl),
          mode: LaunchMode.externalApplication,
        );
    } */
  }

  //FUNÇÃO DE CONSTRUÇÃO DE URL PARA APP DE INTEGRAÇÃO
  static String _buildUrl(RideRequestParams params, {IntegrationApps? app}) {
    switch (app) {
      case IntegrationApps.googleMaps:
        return _buildGoogleMapsUrl(params);
      case IntegrationApps.uber:
        return _buildUberUrl(params);
      case IntegrationApps.ninetyNine:
        return _buildNinetyNineUrl(params);
      case IntegrationApps.waze:
        return _buildWazeUrl(params);
      case IntegrationApps.appleMaps:
        return _buildAppleMapsUrl(params);
      default:
        //VERIFICAR DISPOSITIVO DO USUARIO
        final devicePlatform = AppHelper.getDevicePlatform();
        //GERAR URL PARA APP PADRÃO APARTIR DO DISPOSITIVO DO USUARIO
        return devicePlatform == 'Ios'
          ? _buildAppleMapsUrl(params)
          : _buildGoogleMapsUrl(params);
    }
  }

  //GOOGLE MAPS
  static String _buildGoogleMapsUrl(RideRequestParams params) {
    final baseUrl = 'https://www.google.com/maps/dir/?api=1';
    final origin = '${params.startLat},${params.startLng}';
    final destination = '${params.endLat},${params.endLng}';
    
    final url = '$baseUrl&origin=$origin&destination=$destination';
    
    if (params.travelMode != null) {
      return '$url&travelmode=${params.travelMode}';
    }
    
    return url;
  }

  //UBER
  static String _buildUberUrl(RideRequestParams params) {
    final baseUrl = 'https://m.uber.com/ul/?action=setPickup';
    final pickup = 'pickup[latitude]=${params.startLat}'
        '&pickup[longitude]=${params.startLng}'
        '&pickup[nickname]=${params.startName ?? "Localização Atual"}';
    
    final dropoff = 'dropoff[latitude]=${params.endLat}'
        '&dropoff[longitude]=${params.endLng}'
        '&dropoff[nickname]=${params.endName ?? "Destino"}';
    
    return '$baseUrl&$pickup&$dropoff';
  }

  //99
  static String _buildNinetyNineUrl(RideRequestParams params) {
    return 'https://99app.com/t?'
        'slat=${params.startLat}'
        '&slng=${params.startLng}'
        '&elat=${params.endLat}'
        '&elng=${params.endLng}';
  }

  //WAZE
  static String _buildWazeUrl(RideRequestParams params) {
    return 'https://waze.com/ul?'
        'll=${params.endLat},${params.endLng}'
        '&navigate=yes';
  }

  //APPLE MAPS
  static String _buildAppleMapsUrl(RideRequestParams params) {
    return 'https://maps.apple.com/?'
        'saddr=${params.startLat},${params.startLng}'
        '&daddr=${params.endLat},${params.endLng}'
        '&dirflg=${_getTravelMode(params.travelMode)}';
  }

  //RESGATAR TIPO DE VIAGEM (GOOGLE MAPS/APPLE MAPS)
  static String _getTravelMode(String? travelMode) {
    switch (travelMode) {
      case 'walking':
        return 'w';
      case 'transit':
        return 'r';
      case 'bicycling':
        return 'b';
      default:
        return 'd'; // driving
    }
  }

  //FUNÇÃO DE FALLBACK PARA ABERTURA DE LOJA DE APPS
  static Future<void> _handleFallback(
    IntegrationApps app, 
    String? customFallbackUrl,
  ) async {
    final fallbackUrl = customFallbackUrl ?? _getStoreFallbackUrl(app);
    
    if (await canLaunchUrl(Uri.parse(fallbackUrl))) {
      await launchUrl(Uri.parse(fallbackUrl));
    } else {
      throw 'Não foi possível abrir o aplicativo';
    }
  }

  //FUNÇÃO DE GERAÇÃO DE URL PARA FALLBACK DE LOJA DE APPS
  static String _getStoreFallbackUrl(IntegrationApps app) {
    final devicePlatform = AppHelper.getDevicePlatform();
    switch (app) {
      case IntegrationApps.googleMaps:
        return devicePlatform == 'Ios' 
          ? 'https://apps.apple.com/br/app/google-maps/id585027354'
          : 'https://play.google.com/store/apps/details?id=com.google.android.apps.maps';
      case IntegrationApps.uber:
        return devicePlatform == 'Ios' 
          ? 'https://apps.apple.com/br/app/uber/id368677368' 
          : 'https://play.google.com/store/apps/details?id=com.ubercab';
      case IntegrationApps.ninetyNine:
        return devicePlatform == 'Ios' 
          ? 'https://apps.apple.com/br/app/99-taxi-e-carro/id552855819'
          : 'https://play.google.com/store/apps/details?id=com.taxis99';
      case IntegrationApps.waze:
        return devicePlatform == 'Ios' 
          ? 'https://apps.apple.com/br/app/waze-navigation-&-live-traffic/id323229106'
          : 'https://play.google.com/store/apps/details?id=com.waze';
      case IntegrationApps.appleMaps:
        return devicePlatform == 'Ios' 
          ? 'https://apps.apple.com/br/app/apple-maps/id915056765'
          : '';
    }
  }

  //FUNÇÃO PARA EXIBIR POPUP DE NENHUM APP DISPONIVEL
  static Future<void> _showFallbackDialog() async {
    print('Nenhum app de rotas encontrado no dispositivo');
  }
}