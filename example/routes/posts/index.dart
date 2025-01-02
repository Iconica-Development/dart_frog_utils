import 'dart:async';
import 'dart:math';

import 'package:dart_frog/dart_frog.dart';

import 'package:dart_frog_utils/dart_frog_utils.dart';

import '../../src/models/post.dart';

final postSerializer = Serializer<PostModel>(
  fromMap: (map) {
    return PostModel(
      id: map['id'] as String?,
      title: map['title'] as String,
      created: DateTime.tryParse(map['created'] as String? ?? ''),
      message: map['message'] as String,
    );
  },
  toMap: (post) => {
    'id': post.id,
    'title': post.title,
    'message': post.message,
    'created': post.created?.toIso8601String(),
  },
  validators: {
    'title': ValueValidator.string(),
    'message': ValueValidator.string(),
  },
  fieldPaths: ['id', 'title', 'message'],
);

class PostView extends ListCreateView<PostModel> {
  @override
  FutureOr<PostModel> create(RequestContext context, PostModel object) {
    final random = Random();
    return object.copyWith(
      id: random.nextInt(100000).toRadixString(16),
    );
  }

  @override
  FutureOr<List<PostModel>> list(RequestContext context) {
    final random = Random();

    return List.generate(
      100,
      (_) => PostModel(
        id: random.nextInt(100000000).toRadixString(16),
        title: 'Title',
        created: DateTime.now(),
        message: 'Some message',
      ),
    );
  }

  @override
  Serializer<PostModel> get serializer => postSerializer;
}

Future<Response> onRequest(RequestContext context) {
  return context.view(PostView());
}
