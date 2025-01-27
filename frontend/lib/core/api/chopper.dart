// ignore: depend_on_referenced_packages
import 'dart:async';

import 'package:chopper/chopper.dart';
import 'package:flutter_application_1/core/api/services/admin.dart';
import 'package:flutter_application_1/core/api/services/application.dart';
import 'package:flutter_application_1/core/api/services/applications.dart';
import 'package:flutter_application_1/core/api/services/forecast.dart';
import 'package:flutter_application_1/core/api/services/user.dart';
import 'package:flutter_application_1/core/token.dart';

class TokenInterceptor implements Interceptor {
  TokenInterceptor();

  @override
  FutureOr<Response<BodyType>> intercept<BodyType>(
    Chain<BodyType> chain,
  ) async {
    Request request = chain.request;

    String? token = tokenService.getToken();

    if (token != null) {
      request = request.copyWith(
        headers: {
          'auth': token,
          ...request.headers,
        },
      );
    }

    final response = await chain.proceed(request);

    return response;
  }
}

final class Api extends ChopperClient {
  Api({
    required String baseUrl,
  }) : super(
          baseUrl: Uri.parse(baseUrl),
          services: [
            UserService.create(),
            ApplicationsService.create(),
            ApplicationService.create(),
            ForecastService.create(),
            AdminService.create(),
          ],
          converter: const JsonConverter(),
          interceptors: [TokenInterceptor()],
        );
}

final api = Api(baseUrl: 'http://127.0.0.1:8000');
