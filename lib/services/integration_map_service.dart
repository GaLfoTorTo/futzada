import 'package:get/get.dart';
import 'package:futzada/theme/app_icones.dart';
import 'package:futzada/widget/dialogs/map_apps_dialog.dart';
import 'package:futzada/helpers/app_helper.dart';
import 'package:futzada/models/address_model.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:map_launcher/map_launcher.dart';

enum IntegrationApps {
  google,
  uber,
  ninetyNine,
  waze,
  apple,
  moovit
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

class AppMap {
  final String name;
  final String icon;
  final IntegrationApps type;
  final MapType? mapType;
  final bool method;

  const AppMap({
    required this.name,
    required this.icon,
    required this.type,
    this.mapType,
    required this.method,
  });
}

class IntegrationRouteService {

  //FUNÇÃO PARA ABRIR APPS DE MAPA/ROTAS
  static Future<void> openDialogApps(AddressModel address, {String? travelModel}) async {
    //BUSCAR POSIÇÃO ATUAL DO USUARIO
    final currentPosition = await Geolocator.getCurrentPosition();
    //GERAR PARAMETROS DE ROTA
    final params = RideRequestParams(
      startLat: currentPosition.latitude,
      startLng: currentPosition.longitude,
      endLat: address.latitude!,
      endLng: address.longitude!,
      endName: address.street,
      travelMode: travelModel
    );
    //RESGATAR APPS DE MAPA/VIAGEM
    final apps = await _getMapApps(params);
    if(apps.isNotEmpty){
      //EXIBIR DIALOG DE APPS
      Get.bottomSheet(MapAppsDialog(
        params: params,
        apps: apps
      ));
    }else{
      //REDIRECIONAR PARA LOJA
      _handleFallback();
    }
  }

  //FUNÇÃO PARA BUSCAR OS APPS DE MAPA DISPONIVEIS
  static Future<List<AppMap>> _getMapApps(RideRequestParams params)async{
    final devicePlatform = AppHelper.getDevicePlatform();
    // 1. Primeiro pegar apps de mapa com MapLauncher
    final installedMaps = await MapLauncher.installedMaps;
    //LISTA DE APPS
    final List<AppMap> listApps = [];
    //ICONES DOS APPS
    final appsMapIcons = {
      'google': AppIcones.google_map,
      'uber': AppIcones.uber,
      'ninetyNine': AppIcones.ninetyNine,
      'moovit': AppIcones.moovit,
      'waze': AppIcones.waze,
      'apple': AppIcones.apple_map,
    };
    
    //LOOP APPS DE MAP
    for (final app in appsMapIcons.entries) {
      //RESGATAR CHAVE, ICONE, TIPO E NOME DO APP NO ARRAY
      final appKey = app.key;
      final appMapType = MapType.values.firstWhereOrNull((a) => a.toString() == 'MapType.$appKey');
      //VERIFICAÇÃO DE PLATAFORMA (IOS/ANDROID)
      if(appKey == 'apple' && devicePlatform != 'Ios'){
        continue;
      }
      final appName = _getAppDisplayName(appKey);
      final appIcon = app.value;
      final appType = IntegrationApps.values.firstWhere((a) => a.toString() == 'IntegrationApps.$appKey');
      final appMapLauncer = installedMaps.firstWhereOrNull((e) => e.mapType.toString() == "MapType.$appKey");
      //VERIFICAR SE APP DE MAP ESTA NA LISTA DE APPS DO USUARIO
      if(appMapType != null && appMapLauncer == null){
        continue;
      }
      //ADICIONAR APP A LISTA
      listApps.add(AppMap(
          name: appName,
          icon: appIcon,
          type: appType,
          mapType: appMapType,
          method: appMapLauncer != null
        )
      );
    }
    return listApps;
  }

  // Função auxiliar para converter chaves em nomes exibíveis
  static String _getAppDisplayName(String appKey) {
    switch (appKey) {
      case 'google': return 'Google Maps';
      case 'uber': return 'Uber';
      case 'ninetyNine': return '99';
      case 'waze': return 'Waze';
      case 'apple': return 'Apple Maps';
      case 'moovit': return 'Moovit';
      default: return appKey;
    }
  }

  //FUNÇÃO PARA ABRIR APP DE INTEGRAÇÃO
  static Future<void> openRouteApps(RideRequestParams params, IntegrationApps app) async{
    //GERAR URL
    final url = _buildUrl(params, app: app);
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
    }
  }

  //FUNÇÃO DE CONSTRUÇÃO DE URL PARA APP DE INTEGRAÇÃO
  static String _buildUrl(RideRequestParams params, {IntegrationApps? app}) {
    switch (app) {
      case IntegrationApps.uber:
        return _buildUberUrl(params);
      case IntegrationApps.ninetyNine:
        return _buildNinetyNineUrl(params);
      case IntegrationApps.waze:
        return _buildWazeUrl(params);
      case IntegrationApps.moovit:
        return _buildMoovitUrl(params);
      default:
        //VERIFICAR DISPOSITIVO DO USUARIO
        final devicePlatform = AppHelper.getDevicePlatform();
        //GERAR URL PARA APP PADRÃO APARTIR DO DISPOSITIVO DO USUARIO
        return devicePlatform == 'Ios'
          ? _buildAppleUrl(params)
          : _buildGoogleUrl(params);
    }
  }

  //GOOGLE MAPS
  static String _buildGoogleUrl(RideRequestParams params) {
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
    return 'taxis99onetravel://one?'
        'pickup_latitude=${params.startLat}'
        '&pickup_longitude=${params.startLng}'
        '&dropoff_latitude=${params.endLat}'
        '&dropoff_longitude=${params.endLng}'
        '&source=futzada';
  }

  //WAZE
  static String _buildWazeUrl(RideRequestParams params) {
    return 'https://waze.com/ul?'
        'll=${params.endLat},${params.endLng}'
        '&navigate=yes';
  }
  
  //MOOVIT
  static String _buildMoovitUrl(RideRequestParams params) {
    return 'https://moovit.com/directions/?'
        'dest_lat=${params.endLat}'
        '&dest_lon=${params.endLng}'
        '&dest_name=${Uri.encodeComponent(params.endName ?? "Destino")}'
        '&orig_lat=${params.startLat}'
        '&orig_lon=${params.startLng}'
        '&orig_name=${Uri.encodeComponent(params.startName ?? "Minha Localização")}'
        '&trav_mode=public_transit';
  }

  //APPLE MAPS
  static String _buildAppleUrl(RideRequestParams params) {
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
  static Future<void> _handleFallback() async {
    //VERIFICAR DISPOSITIVO DO USUARIO
    final devicePlatform = AppHelper.getDevicePlatform();
    //GERAR URL PARA APP PADRÃO APARTIR DO DISPOSITIVO DO USUARIO
    final fallbackUrl = devicePlatform == 'Ios'
      ? _getStoreFallbackUrl(IntegrationApps.apple)
      : _getStoreFallbackUrl(IntegrationApps.google);
    
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
      case IntegrationApps.google:
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
      case IntegrationApps.moovit:
        return devicePlatform == 'Ios' 
          ? 'https://apps.apple.com/br/app/moovit-transit-app/id498477945'
          : 'https://play.google.com/store/apps/details?id=com.tranzmate';
      case IntegrationApps.apple:
        return devicePlatform == 'Ios' 
          ? 'https://apps.apple.com/br/app/apple-maps/id915056765'
          : '';
    }
  }
}