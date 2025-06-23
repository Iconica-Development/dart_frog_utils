import "dart:async";

import "package:dart_frog/dart_frog.dart";
import "package:dart_frog_utils/dart_frog_utils.dart";

///
abstract class BaseView {
  ///
  Future<Response> asView(RequestContext context) => methodRequest(
        requestContext: context,
        get: onGet(context),
        post: onPost(context),
        put: onPut(context),
        patch: onPatch(context),
        delete: onDelete(context),
        options: onOptions(context),
        head: onHead(context),
      );

  ///
  FutureOr<Response> Function(RequestContext context)? onGet(
    RequestContext context,
  ) =>
      null;

  ///
  FutureOr<Response> Function(RequestContext context)? onPost(
    RequestContext context,
  ) =>
      null;

  ///
  FutureOr<Response> Function(RequestContext context)? onPut(
    RequestContext context,
  ) =>
      null;

  ///
  FutureOr<Response> Function(RequestContext context)? onPatch(
    RequestContext context,
  ) =>
      null;

  ///
  FutureOr<Response> Function(RequestContext context)? onDelete(
    RequestContext context,
  ) =>
      null;

  ///
  FutureOr<Response> Function(RequestContext context)? onOptions(
    RequestContext context,
  ) =>
      null;

  ///
  FutureOr<Response> Function(RequestContext context)? onHead(
    RequestContext context,
  ) =>
      null;
}

///
extension WithView on RequestContext {
  ///
  Future<Response> view(BaseView view) => view.asView(this);
}

///
mixin PostMixin on BaseView {
  ///
  FutureOr<Response> post(RequestContext context);

  @override
  FutureOr<Response> Function(RequestContext context)? onPost(
    RequestContext context,
  ) =>
      post;
}

///
mixin GetMixin on BaseView {
  ///
  FutureOr<Response> get(RequestContext context);

  @override
  FutureOr<Response> Function(RequestContext context)? onGet(
    RequestContext context,
  ) =>
      get;
}
