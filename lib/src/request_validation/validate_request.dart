import "dart:convert";

import "package:dart_frog/dart_frog.dart";
import "package:dart_iconica_utilities/dart_iconica_utilities.dart";

///
Future<void> validateRequest({
  required RequestContext context,
  bool isJson = true,
  Map<String, ValueValidator>? body,
  Map<String, ValueValidator>? headers,
  Map<String, ValueValidator>? parameters,
}) async {
  await validateRequestBody(context, body, isJson: isJson);
  await validateHeaders(context, headers);
  validateParams(context, parameters);
}

///
void validateParams(
  RequestContext context,
  Map<String, ValueValidator>? paramValidator,
) {
  if (paramValidator == null) {
    return;
  }

  paramValidator.validate(context.request.uri.queryParameters);
}

///
Future<void> validateHeaders(
  RequestContext context,
  Map<String, ValueValidator>? headerValidator,
) async {
  if (headerValidator == null) {
    return;
  }
  var headers = context.request.headers;

  headerValidator.validate(headers);
}

///
Future<void> validateRequestBody(
  RequestContext context,
  Map<String, ValueValidator>? bodyValidator, {
  bool isJson = true,
}) async {
  if (bodyValidator == null) {
    return;
  }
  var body = await context.request.body();

  // attempt to validate json body
  if (isJson) {
    _validateJsonBody(body, bodyValidator);
  } else {
    // attempt to validate formdata body
    await _validateFormData(context, bodyValidator);
  }
}

///
Future<void> _validateFormData(
  RequestContext context,
  Map<String, ValueValidator> bodyValidator,
) async {
  try {
    var formData = await context.request.formData();
    bodyValidator.validate(formData.fields);
    // ignore: avoid_catching_errors
  } on StateError {
    // nothing wrong here, it just is not form data
  } on ValidationException {
    rethrow;
  }
}

///
void _validateJsonBody(
  String body,
  Map<String, ValueValidator> bodyValidator,
) {
  try {
    var json = jsonDecode(body);
    if (json is Map<String, dynamic>) {
      bodyValidator.validate(json);
    }
    return;
  } on ValidationException catch (_) {
    rethrow;
  } on FormatException {
    throw ValidationException(
      validationMessages: {"error": "Invalid json provided with content type"},
    );
  }
}
