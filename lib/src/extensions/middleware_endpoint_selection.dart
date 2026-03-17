import "package:dart_frog/dart_frog.dart";

/// Extensions for selecting endpoints to apply middleware to.
extension SelectEnpointsForMiddleware on Middleware {
  /// Exclude endpoints from middleware.
  ///
  /// [excludedEndpoints] is a map of [Pattern]s to a list of [HttpMethod]s.
  /// The middleware will be applied to all endpoints that do not match any of
  /// the patterns and methods in the map.
  Middleware excludeEndpoints(
    Map<Pattern, List<HttpMethod>> excludedEndpoints,
  ) =>
      (handler) => (context) async {
            final hasMatch = excludedEndpoints.hasMatch(
              context.request.uri.path,
              context.request.method,
            );

            if (hasMatch) {
              return handler(context);
            }

            return this(handler)(context);
          };

  /// Include only specific endpoints for middleware.
  ///
  /// [includedEndpoints] is a map of [Pattern]s to a list of [HttpMethod]s.
  /// The middleware will be applied only to endpoints that match any of the
  /// patterns and methods in the map.
  Middleware includeEndpoints(
    Map<Pattern, List<HttpMethod>> includedEndpoints,
  ) =>
      (handler) => (context) async {
            final hasMatch = includedEndpoints.hasMatch(
              context.request.uri.path,
              context.request.method,
            );

            if (!hasMatch) {
              return handler(context);
            }

            return this(handler)(context);
          };
}

extension on Map<Pattern, List<HttpMethod>> {
  bool hasMatch(
    String path,
    HttpMethod method,
  ) =>
      entries
          .where(
            (entry) =>
                entry.key.matchAsPrefix(path) != null &&
                entry.value.contains(method),
          )
          .firstOrNull !=
      null;
}
