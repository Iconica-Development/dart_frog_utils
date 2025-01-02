import "package:dart_frog/dart_frog.dart";
import "package:dart_frog_utils/dart_frog_utils.dart";

///
class Serializer<T> {
  ///
  Serializer({
    required this.fromMap,
    required this.toMap,
    this.validators = const {},
    this.fieldPaths = const [],
    this.data,
  });

  ///
  factory Serializer.readOnly({
    required Map<String, dynamic> Function(T object) toMap,
    required Map<String, ValueValidator> validators,
    List<String> fieldPaths = const [],
    Map<String, dynamic>? data,
  }) =>
      Serializer(
        fromMap: (_) => throw SerializerReadOnlyException(),
        toMap: toMap,
        validators: validators,
        fieldPaths: fieldPaths,
        data: data,
      );

  ///
  factory Serializer.writeOnly({
    required T Function(Map<String, dynamic> map) fromMap,
    required Map<String, ValueValidator> validators,
    List<String> fieldPaths = const [],
    Map<String, dynamic>? data,
  }) =>
      Serializer(
        fromMap: fromMap,
        toMap: (_) => throw SerializerWriteOnlyException(),
        validators: validators,
        fieldPaths: fieldPaths,
        data: data,
      );

  ///
  final Map<String, ValueValidator> validators;

  ///
  final T Function(Map<String, dynamic> map) fromMap;

  ///
  final Map<String, dynamic> Function(T object) toMap;

  ///
  final Map<String, dynamic>? data;

  ///
  final List<String> fieldPaths;

  ///
  bool validate({
    bool raiseException = false,
  }) {
    try {
      validators.validate(this.data ?? {});
      return true;
    } on ValidationException {
      if (raiseException) rethrow;
      return false;
    }
  }

  ///
  Serializer<T> withData(Map<String, dynamic> data) => Serializer(
        toMap: toMap,
        fromMap: fromMap,
        validators: validators,
        data: data,
        fieldPaths: fieldPaths,
      );

  ///
  Serializer<T> withObject(T object) => withData(toMap(object));

  ///
  Map<String, dynamic> serialize() {
    final data = this.data ?? {};
    if (fieldPaths.isEmpty) {
      return data;
    }

    return data.select(fieldPaths);
  }
}

///
class SerializerWriteOnlyException implements Exception {}

///
class SerializerReadOnlyException implements Exception {}

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
