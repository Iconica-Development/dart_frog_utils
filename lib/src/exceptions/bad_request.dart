import "dart:io";

import "package:dart_frog_utils/src/exceptions/api_exception.dart";

///
class BadRequestException implements ApiException {
  ///
  BadRequestException({
    required this.body,
  });

  ///
  @override
  int get statusCode => HttpStatus.badRequest;

  ///
  @override
  final Map<String, dynamic> body;
}
