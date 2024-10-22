import "package:dart_frog/dart_frog.dart";

///
abstract class ApiException implements Exception {
  ///
  int get statusCode;

  ///
  Map<String, dynamic> get body;
}

///
Response apiExceptionHandler(RequestContext context, ApiException exception) =>
    Response.json(
      statusCode: exception.statusCode,
      body: exception.body,
    );
