class ApiException implements Exception {
  String cause;
  ApiException(this.cause);
}
