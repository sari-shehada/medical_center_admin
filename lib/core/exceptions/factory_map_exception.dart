class FactoryMapException implements Exception {
  final String? message;
  final Map map;
  FactoryMapException({
    required this.map,
    this.message,
  });

  @override
  String toString() {
    return message ?? 'No error message was provided';
  }
}
