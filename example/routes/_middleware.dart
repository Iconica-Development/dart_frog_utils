import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_utils/dart_frog_utils.dart';

Handler middleware(Handler handler) {
  final exceptionMiddleware = ExceptionHandlerMiddleware()
    ..addExceptionHandler(apiExceptionHandler);
  return handler.use(exceptionMiddleware.asMiddleware());
}
