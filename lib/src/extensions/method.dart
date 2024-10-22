import "dart:async";

import "package:dart_frog/dart_frog.dart";

import "package:dart_frog_utils/src/method_request/method_request.dart";

///
extension MethodRequest on RequestContext {
  ///
  FutureOr<Response> method({
    Handler? get,
    Handler? post,
    Handler? patch,
    Handler? put,
    Handler? options,
    Handler? head,
    Handler? delete,
  }) =>
      methodRequest(
        requestContext: this,
        get: get,
        post: post,
        patch: patch,
        put: put,
        options: options,
        head: head,
        delete: delete,
      );
}
