import 'api_exception.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:futzada/core/providers/app_session_provider.dart';
import 'package:futzada/core/storage/app_storage.dart';
import 'package:futzada/core/di/service_locator.dart';

class ApiInterceptor extends Interceptor {
  //FUNÇÃO DE CAPTURA DE ERROS DE REQUISIÇÃO
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final exception = _mapException(err);
    final session = sl<ProviderContainer>().read(appSessionProvider.notifier);
    //VERIFICAR SE SESSÃO EXPIROU (STATUS CODE 401)
    if (exception.status == 401) {      
      // REMOVER TOKEN E USUÁRIO DO STORAGE
      if (AppStorage.hasData("user")) AppStorage.remove("user");
      if (AppStorage.hasData("token")) AppStorage.remove("token");
      
      // NAVEGAR PARA LOGIN
      session.setAuthenticated();
      
      // REJEITAR REQUISIÇÃO
      handler.reject(err);
      return;
    }
    
    //REJEITA REQUISIÇÃO
    handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        error: exception,
        type: err.type,
      ),
    );
  }

  //FUNÇÃO DE MAPEAMENTO DE ERROS DE REQUISIÇÃO
  ApiException _mapException(DioException err) {
    return switch (err.type) {
      DioExceptionType.cancel =>
        const ApiException(status: 0, message: 'Operação cancelada!'),

      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout =>
        const ApiException(status: 408, message: 'Conexão expirada!'),

      DioExceptionType.badResponse => _mapStatusCode(err),

      _ => const ApiException(status: 503, message: 'Sem conexão com a internet!'),
    };
  }

  //FUNÇÃO DE MAPEAMENTO DE MENSAGENS DE ERROS DE REQUISIÇÃO
  ApiException _mapStatusCode(DioException err) {
    final status = err.response?.statusCode ?? 500;
    final serverMsg = err.response?.data?['message'] as String?;

    final message = switch (status) {
      400 => serverMsg ?? 'Dados inválidos!',
      401 => 'Sessão expirada. Faça login novamente!',
      403 => 'Acesso negado!',
      404 => 'Recurso não encontrado!',
      422 => serverMsg ?? 'Erro de validação!',
      >= 500 => 'Erro no servidor!',
      _ => serverMsg ?? 'Erro desconhecido!',
    };

    return ApiException(status: status, message: message);
  }
}