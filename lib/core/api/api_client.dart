import 'api_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:esportly/core/api/api_response.dart';
import 'package:esportly/core/api/api_routes.dart';
import 'package:esportly/core/storage/app_storage.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;

  late final Dio _dio;

  //CLIENT DE REQUISIÇÕES
  ApiClient._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiRoutes.url(),
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );

    _dio.interceptors.addAll([
      AuthInterceptor(),
      ApiInterceptor(),
    ]);
  }

  // GET —
  Future<ApiResponse> get(String route) async {
    final resp = await _dio.get(route);
    storeToken(resp);
    final respData = resp.data is Map ? Map<String, dynamic>.from(resp.data as Map) : <String, dynamic>{};
    return ApiResponse(
      data: respData,
      status: resp.statusCode ?? 200,
      message: respData['message'] as String?,
    );
  }

  // POST —
  Future<ApiResponse> post(String route, Map<String, dynamic> data) async {
    final body = await _buildBody(data);
    final resp = await _dio.post(route, data: body);
    storeToken(resp);
    final respData = resp.data is Map ? Map<String, dynamic>.from(resp.data as Map) : <String, dynamic>{};
    return ApiResponse(
      data: respData,
      status: resp.statusCode ?? 200,
      message: respData['message'] as String?,
    );
  }

  // PATCH
  Future<ApiResponse> patch(String route, Map<String, dynamic> data) async {
    final resp = await _dio.patch(route, data: data);
    storeToken(resp);
    final respData = resp.data is Map ? Map<String, dynamic>.from(resp.data as Map) : <String, dynamic>{};
    return ApiResponse(
      data: respData,
      status: resp.statusCode ?? 200,
      message: respData['message'] as String?,
    );
  }

  // DELETE -
  Future<ApiResponse> delete(String route) async {
    final resp = await _dio.delete(route);
    storeToken(resp);
    final respData = resp.data is Map ? Map<String, dynamic>.from(resp.data as Map) : <String, dynamic>{};
    return ApiResponse(
      data: respData,
      status: resp.statusCode ?? 200,
      message: respData['message'] as String?,
    );
  }

  // FUNÇÃO DE MONTAGEM DE BODY DE REQUISIÇÃO (COM E SEM UPLOAD DE ARQUIVOS)
  Future<dynamic> _buildBody(Map<String, dynamic> data) async {
    final hasPhoto = data.containsKey('photo') || data.containsKey('photos');
    if (!hasPhoto) return data;

    final formData = FormData.fromMap(data);
    final photoPath = data['photo'] as String;
    formData.files.add(
      MapEntry(
        'photo',
        await MultipartFile.fromFile(
          photoPath,
          filename: photoPath.split('/').last,
        ),
      ),
    );
    return formData;
  }

  //FUNÇÃO DE ARMAZENAMENTO DE TOKEN (REFRESH)
  Future<void> storeToken(resp) async {
    // EXTRAIR HEADER DE FORMA CASE-INSENSITIVE
    final headers = resp.headers.map as Map<String, List<String>>;
    String? refreshedValue;
    String? authorizationValue;

    // PROCURAR POR HEADERS
    headers.forEach((key, value) {
      if (key.toLowerCase() == 'x-token-refreshed') {
        refreshedValue = value.isNotEmpty ? value.first : null;
      }
      if (key.toLowerCase() == 'authorization') {
        authorizationValue = value.isNotEmpty ? value.first : null;
      }
    });

    // SE FOI RENOVADO, ARMAZENAR O NOVO TOKEN
    if (refreshedValue?.toLowerCase() == 'true' && authorizationValue != null) {
      final newToken = authorizationValue!.replaceFirst(RegExp(r'^Bearer\s+'), '');        
      AppStorage.write('token', newToken);
    }
  }
}

// CLASSE DE INJEÇÃO DE TOKEN
class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final String? token = AppStorage.read<String>('token');
    if (token != null) options.headers['Authorization'] = 'Bearer $token';
    handler.next(options);
  }
}