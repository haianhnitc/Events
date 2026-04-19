import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:events_app/api_template/base_response/api_envelope.dart';
import 'package:events_app/api_template/base_response/api_response.dart';
import 'package:events_app/api_template/services/failure.dart';

ApiResponse<T> forwardEnvelopeResponse<T>(
  ApiResponse<Map<String, dynamic>> response,
  T Function(Object?) fromJson, {
  String fallbackError = 'Something went wrong',
}) {
  return response.when(
    success: (payload) {
      try {
        final envelope = ApiEnvelope<T>.fromJson(payload, fromJson);
        if (envelope.isSuccess) {
          return ApiResponse.success(envelope.object as T);
        }
        return ApiResponse.unexpected(ApiResponseError(
          code: (envelope.errorCode ?? 500).toString(),
          message: envelope.message ?? fallbackError,
          errors: null,
        ));
      } on FormatException {
        return const ApiResponse.responseParsing();
      }
    },
    badRequest: ApiResponse.badRequest,
    unauthorized: ApiResponse.unauthorized,
    forbidden: ApiResponse.forbidden,
    notFound: ApiResponse.notFound,
    conflict: ApiResponse.conflict,
    internalServerError: ApiResponse.internalServerError,
    badGateway: ApiResponse.badGateway,
    serviceUnavailable: ApiResponse.serviceUnavailable,
    gatewayTimeout: ApiResponse.gatewayTimeout,
    canceled: ApiResponse.canceled,
    responseParsing: ApiResponse.responseParsing,
    unexpected: ApiResponse.unexpected,
  );
}

ApiResponse<T> forwardTransportResponse<T>(
  ApiResponse<Map<String, dynamic>> response,
  ApiResponse<T> Function(Map<String, dynamic> payload) onSuccess,
) {
  return response.when(
    success: onSuccess,
    badRequest: ApiResponse.badRequest,
    unauthorized: ApiResponse.unauthorized,
    forbidden: ApiResponse.forbidden,
    notFound: ApiResponse.notFound,
    conflict: ApiResponse.conflict,
    internalServerError: ApiResponse.internalServerError,
    badGateway: ApiResponse.badGateway,
    serviceUnavailable: ApiResponse.serviceUnavailable,
    gatewayTimeout: ApiResponse.gatewayTimeout,
    canceled: ApiResponse.canceled,
    responseParsing: ApiResponse.responseParsing,
    unexpected: ApiResponse.unexpected,
  );
}

Future<ApiResponse<TOut>> forwardOnSuccess<TIn, TOut>(
  ApiResponse<TIn> response,
  Future<ApiResponse<TOut>> Function(TIn value) onSuccess,
) {
  return response.when(
    success: onSuccess,
    badRequest: (error) => Future.value(ApiResponse.badRequest(error)),
    unauthorized: (error) => Future.value(ApiResponse.unauthorized(error)),
    forbidden: (error) => Future.value(ApiResponse.forbidden(error)),
    notFound: (error) => Future.value(ApiResponse.notFound(error)),
    conflict: (error) => Future.value(ApiResponse.conflict(error)),
    internalServerError: () => Future.value(ApiResponse.internalServerError()),
    badGateway: () => Future.value(ApiResponse.badGateway()),
    serviceUnavailable: () => Future.value(ApiResponse.serviceUnavailable()),
    gatewayTimeout: () => Future.value(ApiResponse.gatewayTimeout()),
    canceled: () => Future.value(ApiResponse.canceled()),
    responseParsing: () => Future.value(ApiResponse.responseParsing()),
    unexpected: (error) => Future.value(ApiResponse.unexpected(error)),
  );
}

ApiResponse<T> mapExceptionToApiResponse<T>(Object error) {
  if (error is FirebaseAuthException) {
    return ApiResponse.unexpected(ApiResponseError(
      code: error.code,
      message: error.message ?? '',
      errors: null,
    ));
  }

  return ApiResponse.unexpected(ApiResponseError(
    code: 'unknown',
    message: error.toString(),
    errors: null,
  ));
}

extension ApiResponseExtension<T> on ApiResponse<T> {
  Either<FailureEntity, T> toEither() {
    return when(
      success: (model) => Right(model),
      unexpected: (error) => _leftFromError(error),
      badRequest: (error) => _leftFromError(error),
      notFound: (error) => _leftFromError(error),
      unauthorized: (error) => _leftFromError(error),
      forbidden: (error) => _leftFromError(error),
      conflict: (error) => _leftFromError(error),
      internalServerError: () => const Left(
        FailureEntity.serverFailure('500', 'Internal server error'),
      ),
      badGateway: () => const Left(
        FailureEntity.serverFailure('502', 'Bad gateway'),
      ),
      serviceUnavailable: () => const Left(
        FailureEntity.serverFailure('503', 'Service unavailable'),
      ),
      gatewayTimeout: () => const Left(
        FailureEntity.serverFailure('504', 'Gateway timeout'),
      ),
      responseParsing: () => const Left(
        FailureEntity.dataParsingFailure(),
      ),
      canceled: () => const Left(
        FailureEntity.serverFailure('CANCEL', 'Operation canceled'),
      ),
    );
  }

  Either<FailureEntity, Unit> toEitherUnit() {
    return when(
      success: (_) => const Right(unit),
      unexpected: (error) => _leftFromErrorUnit(error),
      badRequest: (error) => _leftFromErrorUnit(error),
      notFound: (error) => _leftFromErrorUnit(error),
      unauthorized: (error) => _leftFromErrorUnit(error),
      forbidden: (error) => _leftFromErrorUnit(error),
      conflict: (error) => _leftFromErrorUnit(error),
      internalServerError: () => const Left(
        FailureEntity.serverFailure('500', 'Internal server error'),
      ),
      badGateway: () => const Left(
        FailureEntity.serverFailure('502', 'Bad gateway'),
      ),
      serviceUnavailable: () => const Left(
        FailureEntity.serverFailure('503', 'Service unavailable'),
      ),
      gatewayTimeout: () => const Left(
        FailureEntity.serverFailure('504', 'Gateway timeout'),
      ),
      responseParsing: () => const Left(
        FailureEntity.dataParsingFailure(),
      ),
      canceled: () => const Left(
        FailureEntity.serverFailure('CANCEL', 'Operation canceled'),
      ),
    );
  }

  Either<FailureEntity, T> toEitherNullable() {
    return toEither().map((model) => model as T);
  }
}

Left<FailureEntity, T> _leftFromError<T>(ApiResponseError error) {
  return Left(FailureEntity.serverFailure(error.code.toString(), error.message));
}

Left<FailureEntity, Unit> _leftFromErrorUnit(ApiResponseError error) {
  return Left(FailureEntity.serverFailure(error.code.toString(), error.message));
}
