///
class BadRequestException implements Exception {
  ///
  BadRequestException({
    required this.body,
  });

  ///
  final Map<String, dynamic> body;
}
