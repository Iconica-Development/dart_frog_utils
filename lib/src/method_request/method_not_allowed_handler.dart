import "dart:io";

import "package:dart_frog/dart_frog.dart";

import "package:dart_frog_utils/src/exception_handling/exception_handler.dart";
import "package:dart_frog_utils/src/exceptions/method_not_allowed.dart";

///
ExceptionHandler<MethodNotAllowedException> methodNotAllowedHandler =
    (context, error) => Response.json(
          statusCode: HttpStatus.methodNotAllowed,
          body: {
            "message": "Method: "
                "${context.request.method.name.toUpperCase()} not allowed",
            "Allowed methods":
                error.allowedMethods.map((e) => e.toUpperCase()).toList(),
          },
        );
