class ApiException implements Exception {
  final int status;
  final String message;

  const ApiException({required this.status, required this.message});

  @override
  String toString() => 'ApiException($status): $message';

  // Helpers para verificar a categoria do erro
  bool get isUnauthorized  => status == 401;
  bool get isNotFound      => status == 404;
  bool get isServerError   => status >= 500;
  bool get isTimeout       => status == 408;
}

// Como capturar no seu ViewModel/Controller:
//
// try {
//   final user = await UserRepository().userFetch(id);
// } on ApiException catch (e) {
//   if (e.isUnauthorized) logout();
//   showError(e.message);
// }