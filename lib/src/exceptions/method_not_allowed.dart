///
class MethodNotAllowedException implements Exception {
  ///
  MethodNotAllowedException({
    required this.allowedMethods,
  });

  ///
  final List<String> allowedMethods;
}
