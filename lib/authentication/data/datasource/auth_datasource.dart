import 'package:events_app/api_template/base_response/api_response.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';

abstract class AuthDatasource {
  Future<ApiResponse<User?>> signInWithEmailAndPassword(
      String email, String password);
  Future<ApiResponse<User?>> signUpWithEmailAndPassword(
      String email, String password);
  Future<ApiResponse<User?>> signInWithGoogle();
  Future<ApiResponse<void>> signOut();
  Future<ApiResponse<User?>> getCurrentUser();
}

@Injectable(as: AuthDatasource)
class AuthDatasourceImpl implements AuthDatasource {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  AuthDatasourceImpl(
    this._firebaseAuth,
    this._googleSignIn,
  );

  @override
  Future<ApiResponse<User?>> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return ApiResponse.success(userCredential.user);
    } on FirebaseAuthException catch (e) {
      return ApiResponse.unexpected(ApiResponseError(
          code: e.code, message: e.message ?? '', errors: null));
    } catch (e) {
      return ApiResponse.unexpected(ApiResponseError(
          code: 'unknown', message: e.toString(), errors: null));
    }
  }

  @override
  Future<ApiResponse<User?>> signUpWithEmailAndPassword(
      String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      return ApiResponse.success(userCredential.user);
    } on FirebaseAuthException catch (e) {
      return ApiResponse.unexpected(ApiResponseError(
          code: e.code, message: e.message ?? '', errors: null));
    } catch (e) {
      return ApiResponse.unexpected(ApiResponseError(
          code: 'unknown', message: e.toString(), errors: null));
    }
  }

  @override
  Future<ApiResponse<User?>> signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return const ApiResponse.canceled();
      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
          idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);
      final userCredential =
          await _firebaseAuth.signInWithCredential(credential);
      return ApiResponse.success(userCredential.user);
    } on FirebaseAuthException catch (e) {
      return ApiResponse.unexpected(ApiResponseError(
          code: e.code, message: e.message ?? '', errors: null));
    } catch (e) {
      return ApiResponse.unexpected(ApiResponseError(
          code: 'unknown', message: e.toString(), errors: null));
    }
  }

  @override
  Future<ApiResponse<void>> signOut() async {
    try {
      await Future.wait([
        _firebaseAuth.signOut(),
        _googleSignIn.signOut(),
      ]);
      return const ApiResponse.success(null);
    } on FirebaseAuthException catch (e) {
      return ApiResponse.unexpected(ApiResponseError(
          code: e.code, message: e.message ?? '', errors: null));
    } catch (e) {
      return ApiResponse.unexpected(ApiResponseError(
          code: 'unknown', message: e.toString(), errors: null));
    }
  }

  @override
  Future<ApiResponse<User?>> getCurrentUser() async {
    try {
      return ApiResponse.success(_firebaseAuth.currentUser);
    } catch (e) {
      return ApiResponse.unexpected(
          ApiResponseError(code: 'unknown', message: e.toString(), errors: []));
    }
  }
}
