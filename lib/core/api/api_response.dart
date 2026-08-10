class ApiResponse<T> {
  final T? data;
  final int status;
  final String? message;

  const ApiResponse({
    this.data,
    required this.status,
    this.message,
  });

  bool get isSuccess => status >= 200 && status < 300;
}