import "dart:async";

import "package:dart_frog/dart_frog.dart";
import "package:dart_frog_utils/dart_frog_utils.dart";

///
abstract class ListCreateView<T> extends BaseView with PostMixin, GetMixin {
  ///
  Serializer<T> get serializer;

  ///
  FutureOr<List<T>> list(RequestContext context);

  ///
  FutureOr<T> create(RequestContext context, T object);

  @override
  Future<Response> post(RequestContext context) async {
    var serialized = await context.loadSerialized(serializer);

    var created = await create(context, serialized);

    var responseSerializer = serializer.withObject(created);

    return Response.json(
      body: responseSerializer.serialize(),
    );
  }

  @override
  Future<Response> get(RequestContext context) async {
    var data = await list(context);

    return Response.json(
      body: {
        "results": [
          for (var item in data) serializer.withObject(item).serialize(),
        ],
      },
    );
  }
}

///
abstract class ReadUpdateDeleteView<T> extends BaseView with GetMixin {}
