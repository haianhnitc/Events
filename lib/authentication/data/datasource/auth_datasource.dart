import 'dart:convert';
import 'dart:typed_data';

import 'package:events_app/api_template/base_response/api_response.dart';
import 'package:events_app/api_template/base_response/api_response_forwarder.dart';
import 'package:events_app/api_template/base_request/api_request.dart';
import 'package:events_app/api_template/api_provider.dart';
import 'package:events_app/api_template/api_path.dart';
import 'package:events_app/api_template/services/rest_clients.dart';
import 'package:events_app/authentication/domain/auth_constants.dart';
import 'package:events_app/authentication/domain/usecase/signup_params.dart';
import 'package:events_app/feature/common/domain/enum/app_enum.dart';
import 'package:events_app/feature/user_management/data/model/user_model.dart';
import 'package:events_app/feature/user_management/data/model/verification_document_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';

class GoogleSignInResult {
  final FirebaseUserModel? user;
  final String? firebaseUid;
  final String? idToken;
  final String? accessToken;
  final bool isNewUser;
  final String? email;
  final String? errorCode;
  final String? errorMessage;

  const GoogleSignInResult._({
    this.user,
    this.firebaseUid,
    this.idToken,
    this.accessToken,
    this.isNewUser = false,
    this.email,
    this.errorCode,
    this.errorMessage,
  });

  factory GoogleSignInResult.success({
    required String firebaseUid,
    required String idToken,
    required String accessToken,
    required bool isNewUser,
    required String email,
  }) {
    return GoogleSignInResult._(
      firebaseUid: firebaseUid,
      idToken: idToken,
      accessToken: accessToken,
      isNewUser: isNewUser,
      email: email,
    );
  }

  factory GoogleSignInResult.canceled() {
    return const GoogleSignInResult._(errorCode: 'CANCELED');
  }

  factory GoogleSignInResult.error(
      {required String code, required String message}) {
    return GoogleSignInResult._(errorCode: code, errorMessage: message);
  }

  bool get isSuccess => errorCode == null && firebaseUid != null;
  bool get isCanceled => errorCode == 'CANCELED';
}

class FirebaseUserModel {
  final String uid;
  final String? email;
  final String? displayName;
  final String? photoURL;

  const FirebaseUserModel({
    required this.uid,
    this.email,
    this.displayName,
    this.photoURL,
  });
}

abstract class AuthDatasource {
  Future<ApiResponse<UserModel?>> signInWithEmailAndPassword(
      String email, String password);
  Future<ApiResponse<UserModel?>> signUpWithEmailAndPassword(
    String password,
    SignupParams signupParams,
  );

  Future<GoogleSignInResult> signInWithGoogleOnly();
  Future<ApiResponse<UserModel?>> signInWithGoogleExistingUser(
      String firebaseUid);
  Future<ApiResponse<UserModel?>> signUpWithGoogle({
    required SignupParams signupParams,
  });

  Future<ApiResponse<void>> signOut();
  Future<ApiResponse<UserModel?>> getCurrentUser();
  Future<ApiResponse<void>> sendPasswordResetEmail(String email);
  Future<ApiResponse<VerificationDocumentModel>> uploadVerificationDocument({
    required int fileId,
    required String documentType,
  });
  Future<ApiResponse<List<VerificationDocumentModel>>>
      getMyVerificationDocuments({
    int page = 0,
    int size = 20,
  });
}

@Injectable(as: AuthDatasource)
class AuthDatasourceImpl extends ApiProvider implements AuthDatasource {
  AuthDatasourceImpl({
    FirebaseAuth? firebaseAuth,
    GoogleSignIn? googleSignIn,
    RestClient? client,
  })  : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn(),
        super(client: client ?? NRDRestClient());

  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  ApiResponse<UserModel?> _missingIdTokenResponse() {
    return const ApiResponse.unexpected(ApiResponseError(
      code: '401',
      message: 'Không lấy được Firebase ID token',
      errors: null,
    ));
  }

  ApiResponse<UserModel?> _parseUserResponse(
    ApiResponse<Map<String, dynamic>> response,
  ) {
    final parsed = forwardEnvelopeResponse<UserModel?>(
      response,
      (object) {
        if (object == null) return null;
        if (object is List) {
          throw FormatException('Unexpected List in user response: $object');
        }
        if (object is! Map<String, dynamic>) {
          throw FormatException(
              'Invalid object payload type: ${object.runtimeType}');
        }
        return UserModel.fromJson(object);
      },
      fallbackError: 'Xác thực thất bại',
    );

    return parsed.when(
      success: (user) {
        if (user == null) return ApiResponse.success(null);
        final role = UserRoleApiValue.fromApiValue(user.role);
        if (role == UserRole.organization) {
          final status = user.organizationProfile?.verificationStatus;
          if (status == VerificationStatus.pending) {
            return const ApiResponse.forbidden(ApiResponseError(
              code: AuthConstants.organizerPendingCode,
              message: 'Tài khoản tổ chức đang chờ duyệt.',
              errors: null,
            ));
          }
          if (status == VerificationStatus.rejected) {
            return const ApiResponse.forbidden(ApiResponseError(
              code: AuthConstants.organizerRejectedCode,
              message: 'Tài khoản tổ chức đã bị từ chối.',
              errors: null,
            ));
          }
        }
        if (UserStatusApiValue.fromApiValue(user.status) ==
            UserStatus.disabled) {
          return const ApiResponse.forbidden(ApiResponseError(
            code: AuthConstants.userDisabledCode,
            message: 'Tài khoản đã bị khóa. Liên hệ Admin để được hỗ trợ.',
            errors: null,
          ));
        }
        return ApiResponse.success(user);
      },
      badRequest: ApiResponse.badRequest,
      unauthorized: ApiResponse.unauthorized,
      forbidden: ApiResponse.forbidden,
      notFound: (error) => const ApiResponse.notFound(const ApiResponseError(
        code: AuthConstants.profileNotFoundCode,
        message: 'Tài khoản chưa hoàn tất đăng ký.',
        errors: null,
      )),
      conflict: (error) => ApiResponse.conflict(error),
      internalServerError: ApiResponse.internalServerError,
      badGateway: ApiResponse.badGateway,
      serviceUnavailable: ApiResponse.serviceUnavailable,
      gatewayTimeout: ApiResponse.gatewayTimeout,
      canceled: ApiResponse.canceled,
      responseParsing: ApiResponse.responseParsing,
      unexpected: ApiResponse.unexpected,
    );
  }

  Future<ApiResponse<UserModel?>> _verifyFirebaseUser(User? firebaseUser,
      {required bool returnNullWhenMissingUser}) async {
    if (firebaseUser == null) {
      return returnNullWhenMissingUser
          ? const ApiResponse.success(null)
          : _missingIdTokenResponse();
    }
    final idToken = await firebaseUser.getIdToken(true);
    if (idToken == null || idToken.isEmpty) {
      return returnNullWhenMissingUser
          ? const ApiResponse.success(null)
          : _missingIdTokenResponse();
    }
    final response = await post<Map<String, dynamic>>(
      ApiPath.authVerify,
      (data) => Map<String, dynamic>.from(data as Map),
      requireAuth: true,
    );
    return _parseUserResponse(response);
  }

  Future<ApiResponse<UserModel?>> _verifyFirebaseUserByUid(
      String firebaseUid) async {
    try {
      final firebaseUser = _firebaseAuth.currentUser;
      if (firebaseUser == null) {
        return _missingIdTokenResponse();
      }
      final idToken = await firebaseUser.getIdToken(true);
      if (idToken == null || idToken.isEmpty) {
        return _missingIdTokenResponse();
      }

      final response = await post<Map<String, dynamic>>(
        ApiPath.authVerify,
        (data) => Map<String, dynamic>.from(data as Map),
        requireAuth: true,
      );
      return _parseUserResponse(response);
    } catch (e) {
      return mapExceptionToApiResponse(e);
    }
  }

  Future<ApiResponse<UserModel?>> _signupWithBackend(
    SignupParams signupParams, {
    bool isRecovery = false,
  }) async {
    final jsonBody = signupParams.toJson();

    final response = await post<Map<String, dynamic>>(
      ApiPath.authSignup,
      (data) => Map<String, dynamic>.from(data as Map),
      body: ApiRequestBody.json(jsonBody),
      requireAuth: false,
    );
    return _parseUserResponse(response);
  }

  @override
  Future<ApiResponse<UserModel?>> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return _verifyFirebaseUser(userCredential.user,
          returnNullWhenMissingUser: false);
    } catch (e) {
      return mapExceptionToApiResponse(e);
    }
  }

  @override
  Future<ApiResponse<UserModel?>> signUpWithEmailAndPassword(
    String password,
    SignupParams signupParams,
  ) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: signupParams.email,
        password: password,
      );

      final firebaseUser = userCredential.user;
      if (firebaseUser == null) {
        return _missingIdTokenResponse();
      }

      final idToken = await firebaseUser.getIdToken(true);
      if (idToken == null || idToken.isEmpty) {
        return _missingIdTokenResponse();
      }

      return _signupWithBackend(
          SignupParams.withIdToken(idToken, signupParams));
    } catch (e, stackTrace) {
      final errorMessage = e.toString();
      if (errorMessage.contains('PigeonUserDetails') ||
          errorMessage.contains('PigeonUserCredential') ||
          errorMessage
              .contains("is not a subtype of type 'PigeonUserDetails")) {
        return _handleFirebasePigeonDecodeError(signupParams);
      }
      return mapExceptionToApiResponse(e);
    }
  }

  Future<ApiResponse<UserModel?>> _handleFirebasePigeonDecodeError(
      SignupParams signupParams) async {
    try {
      final firebaseUser = _firebaseAuth.currentUser;
      if (firebaseUser == null) {
        return const ApiResponse.unexpected(ApiResponseError(
          code: 'FIREBASE_USER_NOT_FOUND',
          message:
              'Không lấy được thông tin người dùng Firebase sau khi tạo tài khoản',
          errors: null,
        ));
      }

      final idToken = await firebaseUser.getIdToken(true);
      if (idToken == null || idToken.isEmpty) {
        return _missingIdTokenResponse();
      }

      return _signupWithBackend(
          SignupParams.withIdToken(idToken, signupParams));
    } catch (e) {
      return mapExceptionToApiResponse(e);
    }
  }

  @override
  Future<GoogleSignInResult> signInWithGoogleOnly() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return GoogleSignInResult.canceled();

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );

      final userCredential =
          await _firebaseAuth.signInWithCredential(credential);
      final firebaseUser = userCredential.user;

      if (firebaseUser == null) {
        return GoogleSignInResult.error(
          code: 'MISSING_USER',
          message: 'Không lấy được thông tin người dùng',
        );
      }

      final idToken = await firebaseUser.getIdToken(true);
      if (idToken == null || idToken.isEmpty) {
        return GoogleSignInResult.error(
          code: 'MISSING_TOKEN',
          message: 'Không lấy được Firebase ID token',
        );
      }

      final isNewUser = userCredential.additionalUserInfo?.isNewUser ?? false;

      return GoogleSignInResult.success(
        firebaseUid: firebaseUser.uid,
        idToken: idToken,
        accessToken: googleAuth.accessToken ?? '',
        isNewUser: isNewUser,
        email: firebaseUser.email ?? '',
      );
    } catch (e) {
      return GoogleSignInResult.error(
        code: 'EXCEPTION',
        message: e.toString(),
      );
    }
  }

  @override
  Future<ApiResponse<UserModel?>> signInWithGoogleExistingUser(
      String firebaseUid) async {
    try {
      return await _verifyFirebaseUserByUid(firebaseUid);
    } catch (e) {
      return mapExceptionToApiResponse(e);
    }
  }

  @override
  Future<ApiResponse<UserModel?>> signUpWithGoogle({
    required SignupParams signupParams,
  }) async {
    try {
      return await _signupWithBackend(signupParams);
    } catch (e) {
      return mapExceptionToApiResponse(e);
    }
  }

  @override
  Future<ApiResponse<void>> signOut() async {
    ApiResponse<void> backendResponse = const ApiResponse.success(null);
    try {
      final response = await post<Map<String, dynamic>>(
        ApiPath.authLogout,
        (data) => Map<String, dynamic>.from(data as Map),
        requireAuth: true,
      );
      backendResponse = forwardEnvelopeResponse<void>(
        response,
        (_) => null,
        fallbackError: 'Logout failed',
      );
      await Future.wait([
        _firebaseAuth.signOut(),
        _googleSignIn.signOut(),
      ]);
      return backendResponse;
    } catch (e) {
      return mapExceptionToApiResponse(e);
    }
  }

  @override
  Future<ApiResponse<UserModel?>> getCurrentUser() async {
    try {
      final response = await get<Map<String, dynamic>>(
        ApiPath.usersMe,
        (data) => Map<String, dynamic>.from(data as Map),
        requireAuth: true,
      );
      return forwardEnvelopeResponse<UserModel?>(
        response,
        (object) {
          if (object == null) return null;
          if (object is! Map<String, dynamic>) {
            throw const FormatException('Invalid object payload');
          }
          return UserModel.fromJson(object);
        },
        fallbackError: 'Lấy thông tin user thất bại',
      ).when(
        success: (user) {
          if (user == null) return ApiResponse.success(null);
          final status = UserStatusApiValue.fromApiValue(user.status);
          if (status == UserStatus.disabled) {
            return const ApiResponse.forbidden(ApiResponseError(
              code: 'USER_DISABLED',
              message: 'Tài khoản đã bị khóa. Liên hệ Admin để được hỗ trợ.',
              errors: null,
            ));
          }
          return ApiResponse.success(user);
        },
        badRequest: ApiResponse.badRequest,
        unauthorized: ApiResponse.unauthorized,
        forbidden: ApiResponse.forbidden,
        notFound: (error) => ApiResponse.notFound(error),
        conflict: ApiResponse.conflict,
        internalServerError: ApiResponse.internalServerError,
        badGateway: ApiResponse.badGateway,
        serviceUnavailable: ApiResponse.serviceUnavailable,
        gatewayTimeout: ApiResponse.gatewayTimeout,
        canceled: ApiResponse.canceled,
        responseParsing: ApiResponse.responseParsing,
        unexpected: ApiResponse.unexpected,
      );
    } catch (e) {
      return mapExceptionToApiResponse(e);
    }
  }

  @override
  Future<ApiResponse<void>> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email.trim());
      return const ApiResponse.success(null);
    } catch (e) {
      return mapExceptionToApiResponse(e);
    }
  }

  @override
  Future<ApiResponse<VerificationDocumentModel>> uploadVerificationDocument({
    required int fileId,
    required String documentType,
  }) async {
    try {
      final bodyMap = <String, dynamic>{
        'fileId': fileId,
        'documentType': documentType,
      };
      final response = await post<Map<String, dynamic>>(
        ApiPath.verificationDocuments,
        (data) => Map<String, dynamic>.from(data as Map),
        body: ApiRequestBody.json(bodyMap),
        requireAuth: true,
      );
      return forwardEnvelopeResponse<VerificationDocumentModel>(
        response,
        (object) {
          if (object is! Map<String, dynamic>) {
            throw const FormatException('Invalid object payload');
          }
          return VerificationDocumentModel.fromJson(object);
        },
        fallbackError: 'Upload failed',
      );
    } catch (e) {
      return mapExceptionToApiResponse(e);
    }
  }

  @override
  Future<ApiResponse<List<VerificationDocumentModel>>>
      getMyVerificationDocuments({
    int page = 0,
    int size = 20,
  }) async {
    try {
      final response = await get<Map<String, dynamic>>(
        ApiPath.myVerificationDocuments,
        (data) => Map<String, dynamic>.from(data as Map),
        queryParameters: {'page': page, 'size': size},
        requireAuth: true,
      );
      return forwardEnvelopeResponse<List<VerificationDocumentModel>>(
        response,
        (object) {
          if (object is! Map<String, dynamic>) {
            throw const FormatException('Invalid object payload');
          }
          final content = object['content'] as List<dynamic>? ?? [];
          return content
              .map((e) =>
                  VerificationDocumentModel.fromJson(e as Map<String, dynamic>))
              .toList();
        },
        fallbackError: 'Get documents failed',
      );
    } catch (e) {
      return mapExceptionToApiResponse(e);
    }
  }

  String _parseJwtSubject(String token) {
    try {
      final parts = token.split('.');
      if (parts.length < 2) return 'invalid token';
      final payload = parts[1];
      final normalized = base64Url.normalize(payload);
      final decoded = utf8.decode(base64.decode(normalized));
      final map = json.decode(decoded) as Map<String, dynamic>;
      return map['sub'] ?? 'no sub';
    } catch (e) {
      return 'parse failed: $e';
    }
  }
}
