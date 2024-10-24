import "package:dart_frog/dart_frog.dart";

import "package:dart_frog_utils/src/exceptions/exceptions.dart";

///
Future<Response> methodRequest({
  required RequestContext requestContext,
  Handler? get,
  Handler? post,
  Handler? patch,
  Handler? put,
  Handler? options,
  Handler? head,
  Handler? delete,
}) async {
  final allowedMethods = <HttpMethod, Handler>{
    if (get != null) HttpMethod.get: get,
    if (post != null) HttpMethod.post: post,
    if (patch != null) HttpMethod.patch: patch,
    if (put != null) HttpMethod.put: put,
    if (delete != null) HttpMethod.delete: delete,
    if (head != null) HttpMethod.head: head,
    if (options != null) HttpMethod.options: options,
  };

  final handler = allowedMethods[requestContext.request.method];

  if (handler == null) {
    throw MethodNotAllowedException(
      allowedMethods: allowedMethods.keys.asNameMap().keys.toList(),
      disallowedMethod: requestContext.request.method.name,
    );
  }

  return await handler(requestContext);
}
