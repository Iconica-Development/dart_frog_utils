import "dart:io";

import "package:dart_frog_utils/src/exceptions/api_exception.dart";

///
class MethodNotAllowedException implements ApiException {
  ///
  MethodNotAllowedException({
    required this.allowedMethods,
    required this.disallowedMethod,
  });

  ///
  final List<String> allowedMethods;

  ///
  final String disallowedMethod;

  @override
  int get statusCode => HttpStatus.methodNotAllowed;

  @override
  Map<String, dynamic> get body => {
        "message": "Method: "
            "${disallowedMethod.toUpperCase()} not allowed",
        "Allowed methods": allowedMethods.map((e) => e.toUpperCase()).toList(),
      };
}
