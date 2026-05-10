import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show PlatformException;
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
    internalServerError: () => const ApiResponse.internalServerError(),
    badGateway: () => const ApiResponse.badGateway(),
    serviceUnavailable: () => const ApiResponse.serviceUnavailable(),
    gatewayTimeout: () => const ApiResponse.gatewayTimeout(),
    canceled: () => const ApiResponse.canceled(),
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
    internalServerError: () => const ApiResponse.internalServerError(),
    badGateway: () => const ApiResponse.badGateway(),
    serviceUnavailable: () => const ApiResponse.serviceUnavailable(),
    gatewayTimeout: () => const ApiResponse.gatewayTimeout(),
    canceled: () => const ApiResponse.canceled(),
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
    internalServerError: () =>
        Future.value(const ApiResponse.internalServerError()),
    badGateway: () => Future.value(const ApiResponse.badGateway()),
    serviceUnavailable: () =>
        Future.value(const ApiResponse.serviceUnavailable()),
    gatewayTimeout: () => Future.value(const ApiResponse.gatewayTimeout()),
    canceled: () => Future.value(const ApiResponse.canceled()),
    responseParsing: () => Future.value(const ApiResponse.responseParsing()),
    unexpected: (error) => Future.value(ApiResponse.unexpected(error)),
  );
}

ApiResponse<T> mapExceptionToApiResponse<T>(Object error) {
  if (error is FirebaseAuthException) {
    final code = error.code;
    if (code == 'wrong-password' || code == 'user-not-found') {
      return ApiResponse.unauthorized(ApiResponseError(
        code: code,
        message: 'Email không tồn tại hoặc mật khẩu không chính xác.',
        errors: null,
      ));
    }
    if (code == 'invalid-credential') {
      return ApiResponse.unauthorized(ApiResponseError(
        code: code,
        message: 'Email hoặc mật khẩu không chính xác.',
        errors: null,
      ));
    }
    if (code == 'user-disabled') {
      return ApiResponse.unauthorized(ApiResponseError(
        code: code,
        message: 'Tài khoản đã bị vô hiệu hóa.',
        errors: null,
      ));
    }
    if (code == 'too-many-requests') {
      return ApiResponse.unauthorized(ApiResponseError(
        code: code,
        message: 'Đã thử quá nhiều lần. Vui lòng thử lại sau.',
        errors: null,
      ));
    }
    return ApiResponse.unauthorized(ApiResponseError(
      code: code,
      message: 'Có lỗi xảy ra khi đăng nhập. Vui lòng thử lại.',
      errors: null,
    ));
  }

  if (error is TypeError) {
    final msg = error.toString();
    if (msg.contains('PigeonUserDetails') ||
        msg.contains('PigeonUserCredential')) {
      return ApiResponse.unexpected(const ApiResponseError(
        code: 'PLUGIN_MISMATCH',
        message: 'Lỗi đồng bộ Firebase. Vui lòng khởi động lại ứng dụng.',
        errors: null,
      ));
    }
    return ApiResponse.unexpected(const ApiResponseError(
      code: 'TYPE_ERROR',
      message: 'Đã xảy ra lỗi không xác định. Vui lòng thử lại.',
      errors: null,
    ));
  }

  if (error is PlatformException) {
    final code = error.code;
    final msg = error.message ?? '';
    if (msg.contains('PigeonUserDetails') ||
        msg.contains('PigeonUserCredential')) {
      return ApiResponse.unexpected(const ApiResponseError(
        code: 'PLUGIN_MISMATCH',
        message: 'Lỗi đồng bộ Firebase. Vui lòng khởi động lại ứng dụng.',
        errors: null,
      ));
    }
    return ApiResponse.unexpected(ApiResponseError(
      code: code,
      message: msg.isNotEmpty ? msg : 'Đã xảy ra lỗi. Vui lòng thử lại.',
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
        FailureEntity.serverFailure(
            '500', 'Máy chủ đang bận. Vui lòng thử lại sau.'),
      ),
      badGateway: () => const Left(
        FailureEntity.serverFailure(
            '502', 'Kết nối đến máy chủ thất bại. Vui lòng thử lại.'),
      ),
      serviceUnavailable: () => const Left(
        FailureEntity.serverFailure('503',
            'Mất kết nối mạng hoặc máy chủ không phản hồi. Vui lòng kiểm tra mạng và thử lại.'),
      ),
      gatewayTimeout: () => const Left(
        FailureEntity.serverFailure(
            '504', 'Yêu cầu hết thời gian chờ. Vui lòng thử lại.'),
      ),
      responseParsing: () => const Left(
        FailureEntity.dataParsingFailure(),
      ),
      canceled: () => const Left(
        FailureEntity.serverFailure('CANCEL', 'Thao tác đã bị hủy.'),
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
        FailureEntity.serverFailure(
            '500', 'Máy chủ đang bận. Vui lòng thử lại sau.'),
      ),
      badGateway: () => const Left(
        FailureEntity.serverFailure(
            '502', 'Kết nối đến máy chủ thất bại. Vui lòng thử lại.'),
      ),
      serviceUnavailable: () => const Left(
        FailureEntity.serverFailure('503',
            'Mất kết nối mạng hoặc máy chủ không phản hồi. Vui lòng kiểm tra mạng và thử lại.'),
      ),
      gatewayTimeout: () => const Left(
        FailureEntity.serverFailure(
            '504', 'Yêu cầu hết thời gian chờ. Vui lòng thử lại.'),
      ),
      responseParsing: () => const Left(
        FailureEntity.dataParsingFailure(),
      ),
      canceled: () => const Left(
        FailureEntity.serverFailure('CANCEL', 'Thao tác đã bị hủy.'),
      ),
    );
  }

  Either<FailureEntity, T> toEitherNullable() {
    return toEither().map((model) => model);
  }
}

Left<FailureEntity, T> _leftFromError<T>(ApiResponseError error) {
  return Left(
      FailureEntity.serverFailure(error.code.toString(), error.message));
}

Left<FailureEntity, Unit> _leftFromErrorUnit(ApiResponseError error) {
  return Left(
      FailureEntity.serverFailure(error.code.toString(), error.message));
}
