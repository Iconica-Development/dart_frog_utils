import 'dart:async';

import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_utils/dart_frog_utils.dart';

class MyPostView extends BaseView with PostMixin, GetMixin {
  @override
  Future<Response> post(RequestContext context) async => Response.json();

  @override
  Response get(RequestContext context) {
    return Response(body: "We gettin'");
  }
}

Future<Response> onRequest(RequestContext context) =>
    context.view(MyPostView());
