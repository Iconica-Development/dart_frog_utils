import "dart:convert";

import "package:dart_frog/dart_frog.dart";
import "package:dart_frog_utils/src/exceptions/exceptions.dart";

import "package:dart_frog_utils/src/request_validation/validate_request.dart";
import "package:dart_iconica_utilities/dart_iconica_utilities.dart";

///
extension RequestValidator on RequestContext {
  ///
  Future<void> validate({
    bool isJson = true,
    Map<String, ValueValidator>? body,
    Map<String, ValueValidator>? headers,
    Map<String, ValueValidator>? parameters,
  }) {
    try {
      return validateRequest(
        context: this,
        body: body,
        headers: headers,
        parameters: parameters,
        isJson: isJson,
      );
    } on ValidationException catch (e) {
      throw BadRequestException(body: e.validationMessages);
    }
  }

  ///
  Future<Map<String, dynamic>> validateModel({
    required Map<String, ValueValidator> validators,
  }) async {
    try {
      await validateRequestBody(
        this,
        validators,
      );

      var body = jsonDecode(await request.body()) as Map<String, dynamic>;
      return Map<String, dynamic>.from(body);
    } on ValidationException catch (e) {
      throw BadRequestException(body: e.validationMessages);
    }
  }
}

///
extension LoadViewmodelFromRequestBody on RequestContext {
  ///
  Future<T> loadValidatedObject<T>(
    Map<String, ValueValidator> validators,
    T Function(Map<String, dynamic>) deserializer,
  ) async {
    var validatedBody = await validateModel(validators: validators);
    return deserializer(validatedBody);
  }
}
