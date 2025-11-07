import 'package:events_app/api_template/base_response/api_response.dart';
import 'package:events_app/authentication/data/model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class AuthDatasource {
  Future<ApiResponse<UserModel?>> signInWithEmailAndPassword(
      String email, String password);
  Future<ApiResponse<UserModel?>> signUpWithEmailAndPassword(
      String email, String password);
  Future<ApiResponse<UserModel?>> signInWithGoogle();
  Future<ApiResponse<void>> signOut();
  Future<ApiResponse<UserModel?>> getCurrentUser();
}

class AuthDatasourceImpl implements AuthDatasource {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  AuthDatasourceImpl({
    FirebaseAuth? firebaseAuth,
    GoogleSignIn? googleSignIn,
  })  : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn();

  @override
  Future<ApiResponse<UserModel?>> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      final user = userCredential.user;
      return ApiResponse.success(
          user != null ? UserModel.fromFirebaseUser(user) : null);
    } on FirebaseAuthException catch (e) {
      return ApiResponse.unexpected(ApiResponseError(
          code: e.code, message: e.message ?? '', errors: null));
    } catch (e) {
      return ApiResponse.unexpected(ApiResponseError(
          code: 'unknown', message: e.toString(), errors: null));
    }
  }

  @override
  Future<ApiResponse<UserModel?>> signUpWithEmailAndPassword(
      String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      final user = userCredential.user;
      return ApiResponse.success(
          user != null ? UserModel.fromFirebaseUser(user) : null);
    } on FirebaseAuthException catch (e) {
      return ApiResponse.unexpected(ApiResponseError(
          code: e.code, message: e.message ?? '', errors: null));
    } catch (e) {
      return ApiResponse.unexpected(ApiResponseError(
          code: 'unknown', message: e.toString(), errors: null));
    }
  }

  @override
  Future<ApiResponse<UserModel?>> signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return const ApiResponse.canceled();
      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
          idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);
      final userCredential =
          await _firebaseAuth.signInWithCredential(credential);
      final user = userCredential.user;
      return ApiResponse.success(
          user != null ? UserModel.fromFirebaseUser(user) : null);
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
  Future<ApiResponse<UserModel?>> getCurrentUser() async {
    try {
      final user = _firebaseAuth.currentUser;
      return ApiResponse.success(
          user != null ? UserModel.fromFirebaseUser(user) : null);
    } catch (e) {
      return ApiResponse.unexpected(
          ApiResponseError(code: 'unknown', message: e.toString(), errors: []));
    }
  }
}
