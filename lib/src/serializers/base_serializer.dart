import "package:dart_frog/dart_frog.dart";
import "package:dart_frog_utils/dart_frog_utils.dart";

///
extension ToResponse<T> on Serializer<T> {
  ///
  Response toResponse({
    int? statusCode,
    Map<String, Object>? headers,
  }) =>
      Response.json(
        statusCode: statusCode ?? 200,
        headers: headers ?? {},
        body: data ?? {},
      );
}

///
extension LoadSerialized on RequestContext {
  ///
  Future<T> loadSerialized<T>(Serializer<T> serializer) async =>
      loadValidatedObject(serializer.validators, serializer.fromMap);
}
