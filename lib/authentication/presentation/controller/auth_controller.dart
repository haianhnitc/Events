import 'dart:async';

import 'package:events_app/api_template/services/failure.dart';
import 'package:events_app/app_layout.dart';
import 'package:events_app/authentication/data/datasource/auth_datasource.dart';
import 'package:events_app/authentication/domain/auth_constants.dart';
import 'package:events_app/authentication/domain/usecase/get_current_user_usecase.dart';
import 'package:events_app/authentication/domain/usecase/send_password_reset_email_usecase.dart';
import 'package:events_app/authentication/domain/usecase/signin_with_email_and_password_usecase.dart';
import 'package:events_app/authentication/domain/usecase/signin_with_google_usecase.dart';
import 'package:events_app/authentication/domain/usecase/signout_usecase.dart';
import 'package:events_app/authentication/domain/usecase/signup_params.dart';
import 'package:events_app/authentication/domain/usecase/signup_with_email_and_password_usecase.dart';
import 'package:events_app/authentication/domain/usecase/signup_with_google_usecase.dart';
import 'package:events_app/authentication/domain/usecase/upload_verification_document_usecase.dart';
import 'package:events_app/authentication/presentation/pages/login_screen.dart';
import 'package:events_app/authentication/presentation/pages/organizer_pending_approval_screen.dart';
import 'package:events_app/authentication/presentation/pages/organizer_rejected_screen.dart';
import 'package:events_app/routes/organizer_app_layout.dart';
import 'package:events_app/authentication/presentation/widget/dialog/google_account_type_dialog.dart';
import 'package:events_app/common/helpers/no_params.dart';
import 'package:events_app/common/utils/upload_helper.dart';
import 'package:events_app/dependency_injection/injection.dart';
import 'package:events_app/feature/common/domain/enum/app_enum.dart';
import 'package:events_app/feature/common/usecase/upload_file_params.dart';
import 'package:events_app/feature/common/usecase/upload_file_usecase.dart';
import 'package:events_app/feature/common/utils/app_snackbar_utils.dart';
import 'package:events_app/feature/user_management/domain/entity/user_entity.dart';
import 'package:events_app/feature/user_management/domain/usecase/get_current_user_usecase.dart'
    as user_management;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum AuthSignInResult {
  success,
  canceled,
  failure,
}

enum GoogleAuthState {
  none,
  loading,
  success,
  canceled,
  error,
}

class GoogleAuthSession {
  final String firebaseUid;
  final String idToken;
  final String email;
  final bool isNewUser;
  final GoogleAuthState state;
  final String? errorMessage;

  const GoogleAuthSession({
    required this.firebaseUid,
    required this.idToken,
    required this.email,
    required this.isNewUser,
    required this.state,
    this.errorMessage,
  });

  factory GoogleAuthSession.none() => const GoogleAuthSession(
        firebaseUid: '',
        idToken: '',
        email: '',
        isNewUser: false,
        state: GoogleAuthState.none,
      );

  factory GoogleAuthSession.loading() => const GoogleAuthSession(
        firebaseUid: '',
        idToken: '',
        email: '',
        isNewUser: false,
        state: GoogleAuthState.loading,
      );

  factory GoogleAuthSession.canceled() => const GoogleAuthSession(
        firebaseUid: '',
        idToken: '',
        email: '',
        isNewUser: false,
        state: GoogleAuthState.canceled,
      );

  factory GoogleAuthSession.error(String message) => GoogleAuthSession(
        firebaseUid: '',
        idToken: '',
        email: '',
        isNewUser: false,
        state: GoogleAuthState.error,
        errorMessage: message,
      );

  factory GoogleAuthSession.fromSignInResult(GoogleSignInResult result) {
    if (result.isCanceled) return GoogleAuthSession.canceled();
    if (!result.isSuccess) {
      return GoogleAuthSession.error(result.errorMessage ?? 'Lỗi');
    }
    return GoogleAuthSession(
      firebaseUid: result.firebaseUid ?? '',
      idToken: result.idToken ?? '',
      email: result.email ?? '',
      isNewUser: result.isNewUser,
      state: GoogleAuthState.success,
    );
  }

  bool get isSuccess => state == GoogleAuthState.success;
  bool get isCanceled => state == GoogleAuthState.canceled;
  bool get isLoading => state == GoogleAuthState.loading;
  bool get isError => state == GoogleAuthState.error;
}

class AuthController extends GetxController {
  StreamSubscription<User?>? _authStateSubscription;
  final StreamController<AuthEvent> _authEventController =
      StreamController<AuthEvent>.broadcast();
  bool _isLoggingOut = false;

  Stream<AuthEvent> get authEvents => _authEventController.stream;

  /// In tests, set this static field to provide a mock FirebaseAuth.
  @visibleForTesting
  static FirebaseAuth? testFirebaseAuth;

  /// Test-only factory: creates instance without calling Get.put().
  @visibleForTesting
  factory AuthController.internal() => AuthController._();

  /// Creates an instance for normal (production) use.
  factory AuthController() => AuthController._();

  AuthController._();

  @override
  void onInit() {
    super.onInit();
    final auth = testFirebaseAuth ?? FirebaseAuth.instance;
    _authStateSubscription = auth.authStateChanges().listen(
      (user) {
        if (user == null && currentUser.value != null && !_isLoggingOut) {
          _emitAuthEvent(AuthEvent.sessionExpired);
        }
      },
    );
  }

  final SignInWithGoogleOnlyUsecase _signInWithGoogleOnlyUsecase =
      networkGetIt<SignInWithGoogleOnlyUsecase>();
  final SignInWithGoogleExistingUserUsecase
      _signInWithGoogleExistingUserUsecase =
      networkGetIt<SignInWithGoogleExistingUserUsecase>();

  final SigninWithEmailAndPasswordUsecase _signinUsecase =
      networkGetIt<SigninWithEmailAndPasswordUsecase>();
  final SignupWithEmailAndPasswordUsecase _signupUsecase =
      networkGetIt<SignupWithEmailAndPasswordUsecase>();
  final SignoutUsecase _signoutUsecase = networkGetIt<SignoutUsecase>();
  final GetCurrentUserUsecase _getCurrentUserUsecase =
      networkGetIt<GetCurrentUserUsecase>();
  final SendPasswordResetEmailUsecase _sendPasswordResetEmailUsecase =
      networkGetIt<SendPasswordResetEmailUsecase>();
  final UploadVerificationDocumentUsecase _uploadVerificationDocumentUsecase =
      networkGetIt<UploadVerificationDocumentUsecase>();
  final UploadFileUsecase _uploadFileUsecase =
      networkGetIt<UploadFileUsecase>();
  final user_management.GetCurrentUserUsecase _refreshCurrentUserUsecase =
      networkGetIt<user_management.GetCurrentUserUsecase>();

  final Rx<UserEntity?> currentUser = Rx<UserEntity?>(null);
  final RxBool isLoadingSession = true.obs;

  final RxBool isLoadingEmail = false.obs;
  final RxBool isLoadingGoogle = false.obs;

  final Rx<GoogleAuthSession> googleAuthResult = GoogleAuthSession.none().obs;

  FormState? loginFormState;
  final TextEditingController loginEmailController = TextEditingController();
  final TextEditingController loginPasswordController = TextEditingController();
  final RxBool loginObscurePassword = true.obs;

  final GlobalKey<FormState> registerStudentFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> registerOrganizerFormKey = GlobalKey<FormState>();

  final TextEditingController registerFullNameController =
      TextEditingController();
  final TextEditingController registerEmailController = TextEditingController();
  final TextEditingController registerPhoneController = TextEditingController();
  final TextEditingController registerPasswordController =
      TextEditingController();
  final TextEditingController registerConfirmPasswordController =
      TextEditingController();

  final TextEditingController registerStudentIdController =
      TextEditingController();
  final TextEditingController registerUniversityController =
      TextEditingController();
  final TextEditingController registerFacultyController =
      TextEditingController();
  final TextEditingController registerMajorController = TextEditingController();

  final Rx<int?> registerAvatarFileId = Rx<int?>(null);
  final Rx<String?> registerAvatarPreviewUrl = Rx<String?>(null);
  final Rx<int?> registerLogoFileId = Rx<int?>(null);
  final Rx<String?> registerLogoPreviewUrl = Rx<String?>(null);
  final RxBool isUploadingAvatarInRegister = false.obs;

  final TextEditingController organizationNameController =
      TextEditingController();
  final TextEditingController organizationAddressController =
      TextEditingController();
  final TextEditingController organizationDescriptionController =
      TextEditingController();
  final TextEditingController organizationContactPhoneController =
      TextEditingController();
  final TextEditingController organizationContactEmailController =
      TextEditingController();

  final RxBool registerObscurePassword = true.obs;
  final RxBool registerObscureConfirmPassword = true.obs;

  final RxBool registerAsOrganization = false.obs;
  final Rx<OrganizationType> organizationType = OrganizationType.club.obs;
  final Rx<String?> selectedGender = Rx<String?>(null);
  final Rx<DateTime?> selectedBirthDate = Rx<DateTime?>(null);

  final RxList<Map<String, dynamic>> uploadedVerificationDocs =
      <Map<String, dynamic>>[].obs;
  final RxBool isUploadingDoc = false.obs;
  final ImagePickerService _imagePickerService = ImagePickerService();
  final FilePickerService _filePickerService = FilePickerService();

  final GlobalKey<FormState> forgotPasswordFormKey = GlobalKey<FormState>();
  final TextEditingController forgotPasswordEmailController =
      TextEditingController();

  static AuthController get to => Get.find<AuthController>();

  static AuthController ensureInstance() {
    if (!Get.isRegistered<AuthController>()) {
      Get.put(AuthController());
    }
    return Get.find<AuthController>();
  }

  @override
  void onClose() {
    _authStateSubscription?.cancel();
    _authEventController.close();
    loginEmailController.dispose();
    loginPasswordController.dispose();
    registerEmailController.dispose();
    registerFullNameController.dispose();
    registerPhoneController.dispose();
    registerPasswordController.dispose();
    registerConfirmPasswordController.dispose();
    registerStudentIdController.dispose();
    registerUniversityController.dispose();
    registerFacultyController.clear();
    registerMajorController.clear();
    organizationNameController.dispose();
    organizationAddressController.dispose();
    organizationDescriptionController.dispose();
    organizationContactPhoneController.dispose();
    organizationContactEmailController.dispose();
    forgotPasswordEmailController.dispose();
    super.onClose();
  }

  void _emitAuthEvent(AuthEvent event) {
    if (!_authEventController.isClosed) {
      _authEventController.add(event);
    }
  }

  void emitAuthEvent(AuthEvent event) => _emitAuthEvent(event);

  void _navigateAfterLoginSuccess(
      UserRole? role, VerificationStatus? verificationStatus) {
    if (role == UserRole.organization) {
      if (verificationStatus == VerificationStatus.pending) {
        Get.offAll(() => const OrganizerPendingApprovalScreen());
      } else if (verificationStatus == VerificationStatus.rejected) {
        Get.offAll(() => const OrganizerRejectedScreen());
      } else {
        Get.offAll(() => const OrganizerAppLayout());
      }
    } else {
      Get.offAll(() => AppLayout());
    }
  }

  void resetUserFormFields() {
    registerFullNameController.clear();
    registerEmailController.clear();
    registerPhoneController.clear();
    registerPasswordController.clear();
    registerConfirmPasswordController.clear();
    registerStudentIdController.clear();
    registerUniversityController.clear();
    registerFacultyController.clear();
    registerMajorController.clear();
    registerAvatarFileId.value = null;
    registerAvatarPreviewUrl.value = null;
    selectedGender.value = null;
    selectedBirthDate.value = null;
  }

  void resetOrganizationFormFields() {
    organizationNameController.clear();
    organizationAddressController.clear();
    organizationDescriptionController.clear();
    organizationType.value = OrganizationType.club;
    uploadedVerificationDocs.clear();
    registerLogoFileId.value = null;
    registerLogoPreviewUrl.value = null;
  }

  void resetAllRegisterFields() {
    resetUserFormFields();
    resetOrganizationFormFields();
    registerAsOrganization.value = false;
  }

  void clearRegisterForm() {
    resetAllRegisterFields();
    googleAuthResult.value = GoogleAuthSession.none();
  }

  void toggleLoginPasswordVisibility() {
    loginObscurePassword.value = !loginObscurePassword.value;
  }

  void toggleRegisterPasswordVisibility() {
    registerObscurePassword.value = !registerObscurePassword.value;
  }

  void toggleRegisterConfirmPasswordVisibility() {
    registerObscureConfirmPassword.value =
        !registerObscureConfirmPassword.value;
  }

  void setRegisterAsOrganization(bool value) {
    registerAsOrganization.value = value;
  }

  void setOrganizationType(OrganizationType type) {
    organizationType.value = type;
  }

  void setSelectedGender(String? gender) {
    selectedGender.value = gender;
  }

  void setSelectedBirthDate(DateTime? date) {
    selectedBirthDate.value = date;
  }

  Future<void> uploadVerificationDocument(String documentType) async {
    if (isUploadingDoc.value) return;

    try {
      final UploadResult? result = await _filePickerService.pickDocument(
        allowedExtensions: ['jpg', 'jpeg', 'png', 'gif', 'webp', 'pdf'],
      );

      if (result == null) return;

      isUploadingDoc.value = true;
      AppSnackbarUtils.showInfo('Đang tải lên', 'Đang xử lý tài liệu...');

      final fileResult = await _uploadFileUsecase(UploadFileParams(
        filePath: result.filePath,
        fileType: FileType.verificationDocument,
      ));

      final fileId = fileResult.fold(
        (failure) {
          final message = failure.when(
            serverFailure: (_, msg) => msg,
            dataParsingFailure: () => 'Lỗi xử lý dữ liệu',
            noConnectionFailure: () => 'Không có kết nối mạng',
            systemFailure: (_, msg) => msg,
          );
          AppSnackbarUtils.showError('Tải lên thất bại', message);
          return null;
        },
        (fileEntity) => fileEntity.fileId,
      );

      if (fileId == null) return;

      final uploadResponse = await _uploadVerificationDocumentUsecase(
        UploadVerificationDocumentParams(
          fileId: fileId,
          documentType: documentType,
        ),
      );

      uploadResponse.fold(
        (failure) {
          final message = failure.when(
            serverFailure: (_, msg) => msg,
            dataParsingFailure: () => 'Lỗi xử lý dữ liệu',
            noConnectionFailure: () => 'Không có kết nối mạng',
            systemFailure: (_, msg) => msg,
          );
          AppSnackbarUtils.showError('Tải lên thất bại', message);
        },
        (uploadResult) {
          uploadedVerificationDocs.add({
            'id': uploadResult.verificationDocumentId,
            'type': _getDocumentTypeName(documentType),
            'documentType': documentType,
            'fileName': result.fileName,
            'url': uploadResult.fileUrl,
            'createdAt': DateTime.now(),
          });
          AppSnackbarUtils.showSuccess(
              'Thành công', 'Tài liệu đã được tải lên');
        },
      );
    } catch (e) {
      AppSnackbarUtils.showError('Lỗi', 'Không thể chọn tài liệu');
    } finally {
      isUploadingDoc.value = false;
    }
  }

  void removeVerificationDoc(int docId) {
    uploadedVerificationDocs.removeWhere((doc) => doc['id'] == docId);
  }

  void onAvatarUploadedInRegister(int fileId, String url) {
    registerAvatarFileId.value = fileId;
    registerAvatarPreviewUrl.value = url;
  }

  void onLogoUploadedInRegister(int fileId, String url) {
    registerLogoFileId.value = fileId;
    registerLogoPreviewUrl.value = url;
  }

  String _getDocumentTypeName(String type) {
    switch (type) {
      case 'BUSINESS_LICENSE':
        return 'Giấy phép kinh doanh';
      case 'UNIVERSITY_DECISION':
        return 'Quyết định trường đại học';
      case 'CLUB_CERTIFICATE':
        return 'Giấy phép câu lạc bộ';
      case 'TAX_CODE':
        return 'Mã số thuế';
      default:
        return 'Tài liệu khác';
    }
  }

  String? validateEmail(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return 'Vui lòng nhập email';
    if (!text.contains('@')) return 'Email không hợp lệ';
    return null;
  }

  String? validateLoginPassword(String? value) {
    if ((value ?? '').isEmpty) return 'Vui lòng nhập mật khẩu';
    return null;
  }

  String? validateRegisterPassword(String? value) {
    if ((value ?? '').length < 6) return 'Mật khẩu tối thiểu 6 ký tự';
    return null;
  }

  String? validateRegisterConfirmPassword(String? value) {
    if (value != registerPasswordController.text) {
      return 'Mật khẩu nhập lại không khớp';
    }
    return null;
  }

  String? validateFullName(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return 'Vui lòng nhập họ tên';
    if (text.length < 2) return 'Họ tên tối thiểu 2 ký tự';
    return null;
  }

  String? validateOrganizationName(String? value) {
    if (!registerAsOrganization.value) return null;
    final text = value?.trim() ?? '';
    if (text.isEmpty) return 'Vui lòng nhập tên tổ chức';
    if (text.length < 3) return 'Tên tổ chức tối thiểu 3 ký tự';
    return null;
  }

  String? validateVerificationDocumentIds(String? value) {
    if (!registerAsOrganization.value) return null;
    final text = value?.trim() ?? '';
    if (text.isEmpty) return 'Vui lòng nhập ít nhất 1 document id';
    final ids = text
        .split(',')
        .map((e) => int.tryParse(e.trim()))
        .whereType<int>()
        .toList();
    if (ids.isEmpty) return 'Document ids không hợp lệ';
    return null;
  }

  Future<void> submitLogin() async {
    final formState = loginFormState;
    if (formState == null) return;
    if (!formState.mounted) return;
    if (!formState.validate()) return;
    if (isClosed) return;
    await login();
  }

  Future<void> submitRegister({required bool isStudent}) async {
    final formState = isStudent
        ? registerStudentFormKey.currentState
        : registerOrganizerFormKey.currentState;
    if (formState == null) return;
    if (!formState.mounted) return;
    if (!formState.validate()) return;
    if (isClosed) return;
    await register();
  }

  Future<void> submitGoogleRegister({required bool isStudent}) async {
    final formState = isStudent
        ? registerStudentFormKey.currentState
        : registerOrganizerFormKey.currentState;
    if (formState == null) return;
    if (!formState.mounted) return;
    if (!formState.validate()) return;
    if (isClosed) return;

    final googleResult = googleAuthResult.value;
    if (googleResult.firebaseUid.isEmpty) {
      AppSnackbarUtils.showError(
          'Lỗi', 'Phiên Google đã hết hạn. Vui lòng thử lại.');
      return;
    }

    final userProfile = isStudent ? _buildUserProfileParams() : null;
    final organizationProfile = !isStudent ? _buildOrganizationProfile() : null;
    final verificationDocIds = !isStudent
        ? uploadedVerificationDocs.map((doc) => doc['id'] as int).toList()
        : <int>[];

    await signUpWithGoogle(
      signupParams: SignupParams(
        idToken: googleResult.idToken,
        isUser: isStudent,
        email: googleResult.email,
        userProfile: userProfile,
        organizationProfile: organizationProfile,
        verificationDocumentIds: verificationDocIds,
      ),
    );
  }

  Future<void> submitForgotPassword() async {
    if (!forgotPasswordFormKey.currentState!.validate()) return;
    await sendResetPasswordEmail(email: forgotPasswordEmailController.text);
  }

  Future<GoogleAuthSession> signInWithGoogleOnly() async {
    if (isLoadingEmail.value) return GoogleAuthSession.error('Đang xử lý...');

    try {
      AppSnackbarUtils.showInfo('Google', 'Đang kết nối với Google...');

      final result = await _signInWithGoogleOnlyUsecase(NoParams());

      return result.fold(
        (failure) {
          AppSnackbarUtils.showError('Lỗi', 'Kết nối Google thất bại.');
          return GoogleAuthSession.error(failure.toString());
        },
        (signInResult) {
          return GoogleAuthSession.fromSignInResult(signInResult);
        },
      );
    } catch (e) {
      return GoogleAuthSession.error('Lỗi: $e');
    }
  }

  Future<AuthSignInResult> signInWithGoogleExistingUser(
      String firebaseUid) async {
    isLoadingGoogle.value = true;
    try {
      final result = await _signInWithGoogleExistingUserUsecase(firebaseUid);

      return result.fold(
        (failure) {
          final failureCode = _extractFailureCode(failure);
          if (failureCode == 'USER_NOT_FOUND' || failureCode == '404') {
            return _handleIncompleteGoogleRegistration(firebaseUid);
          }

          final failureTuple = _extractFailureInfo(
            failure,
            dataParsingMessage: 'Đăng nhập Google thất bại.',
          );
          _handleSignInFailure(failureTuple);
          return AuthSignInResult.failure;
        },
        (user) {
          if (user == null) {
            return _handleIncompleteGoogleRegistration(firebaseUid);
          }
          if (user.status == UserStatus.disabled) {
            _emitAuthEvent(AuthEvent.accountDisabled);
            return AuthSignInResult.failure;
          }
          _populateCurrentUser(user);
          AppSnackbarUtils.showSuccess('Thành công', 'Đăng nhập thành công.');
          _emitAuthEvent(AuthEvent.loginSuccess);
          return AuthSignInResult.success;
        },
      );
    } catch (e) {
      AppSnackbarUtils.showError('Lỗi', 'Đăng nhập Google thất bại.');
      return AuthSignInResult.failure;
    } finally {
      isLoadingGoogle.value = false;
    }
  }

  Future<AuthSignInResult> _handleIncompleteGoogleRegistration(
      String firebaseUid) async {
    final firebaseUser = FirebaseAuth.instance.currentUser;

    if (firebaseUser == null || firebaseUser.email == null) {
      AppSnackbarUtils.showError(
        'Đăng nhập không thành công',
        'Phiên Google đã hết hạn. Vui lòng thử đăng nhập lại.',
      );
      await FirebaseAuth.instance.signOut();
      return AuthSignInResult.failure;
    }

    final idToken = await firebaseUser.getIdToken(true);

    googleAuthResult.value = GoogleAuthSession(
      firebaseUid: firebaseUid,
      idToken: idToken ?? '',
      email: firebaseUser.email ?? '',
      isNewUser: false,
      state: GoogleAuthState.success,
    );

    registerEmailController.text = firebaseUser.email ?? '';

    AppSnackbarUtils.showInfo(
      'Đăng ký chưa hoàn tất',
      'Vui lòng hoàn thành thông tin để tiếp tục.',
    );

    final isUser = await _showGoogleAccountTypeDialog();
    if (isUser == null) {
      await FirebaseAuth.instance.signOut();
      googleAuthResult.value = GoogleAuthSession.none();
      return AuthSignInResult.canceled;
    }

    _navigateToGoogleRegister(isUser, googleAuthResult.value);
    return AuthSignInResult.success;
  }

  String _extractFailureCode(FailureEntity failure) {
    return failure.errorCode() ?? '';
  }

  Future<AuthSignInResult> signInWithGoogle() async {
    final googleResult = await signInWithGoogleOnly();
    if (!googleResult.isSuccess) {
      return AuthSignInResult.failure;
    }
    if (googleResult.isNewUser) {
      final isUser = await _showGoogleAccountTypeDialog();
      if (isUser == null) return AuthSignInResult.canceled;
      _navigateToGoogleRegister(isUser, googleResult);
      return AuthSignInResult.success;
    } else {
      return await signInWithGoogleExistingUser(googleResult.firebaseUid);
    }
  }

  void _navigateToGoogleRegister(bool isUser, GoogleAuthSession googleResult) {
    registerEmailController.text = googleResult.email;
    googleAuthResult.value = googleResult;
    registerAsOrganization.value = !isUser;

    if (isUser) {
      Get.toNamed('/register/google', arguments: {'isStudent': true});
    } else {
      Get.toNamed('/register/google', arguments: {'isStudent': false});
    }
  }

  Future<AuthSignInResult> signUpWithGoogle({
    required SignupParams signupParams,
  }) async {
    isLoadingGoogle.value = true;
    try {
      final result =
          await networkGetIt<SignUpWithGoogleUsecase>()(signupParams);

      return result.fold(
        (failure) {
          final failureTuple = _extractFailureInfo(
            failure,
            dataParsingMessage: 'Đăng ký Google thất bại.',
          );
          _handleSignInFailure(failureTuple);
          return AuthSignInResult.failure;
        },
        (user) {
          if (user == null) {
            AppSnackbarUtils.showError(
              'Đăng ký Google thất bại',
              'Không tìm thấy thông tin người dùng.',
            );
            return AuthSignInResult.failure;
          }
          if (user.status == UserStatus.disabled) {
            _emitAuthEvent(AuthEvent.accountDisabled);
            return AuthSignInResult.failure;
          }
          _populateCurrentUser(user);
          AppSnackbarUtils.showSuccess('Thành công', 'Đăng ký thành công.');
          _emitAuthEvent(AuthEvent.loginSuccess);
          return AuthSignInResult.success;
        },
      );
    } catch (e) {
      AppSnackbarUtils.showError('Lỗi', 'Đăng ký Google thất bại.');
      return AuthSignInResult.failure;
    } finally {
      isLoadingGoogle.value = false;
    }
  }

  Future<bool?> _showGoogleAccountTypeDialog() async {
    return showGoogleAccountTypeDialog();
  }

  Future<void> login() async {
    if (isLoadingEmail.value) return;

    isLoadingEmail.value = true;
    final result = await _signinUsecase(
      SigninWithEmailAndPasswordParams(
        email: loginEmailController.text.trim(),
        password: loginPasswordController.text,
      ),
    );

    result.fold(
      (failure) {
        final failureTuple = _extractFailureInfo(
          failure,
          dataParsingMessage: 'Không đọc được dữ liệu người dùng từ hệ thống.',
        );
        _handleSignInFailure(failureTuple);
      },
      (user) {
        if (user == null) {
          AppSnackbarUtils.showError(
            'Đăng nhập thất bại',
            'Không tìm thấy thông tin người dùng sau khi xác thực.',
          );
          return;
        }

        loginPasswordController.clear();
        if (user.status == UserStatus.disabled) {
          _emitAuthEvent(AuthEvent.accountDisabled);
          return;
        }
        _populateCurrentUser(user);
        AppSnackbarUtils.showSuccess('Thành công', 'Đăng nhập thành công.');
        _navigateAfterLoginSuccess(
            user.role, user.organizationProfile?.verificationStatus);
        _emitAuthEvent(AuthEvent.loginSuccess);
      },
    );

    isLoadingEmail.value = false;
  }

  void _handleSignInFailure((String?, String) failureTuple) {
    if (failureTuple.$1 == AuthConstants.organizerPendingCode) {
      _emitAuthEvent(AuthEvent.organizerPending);
      return;
    }

    if (failureTuple.$1 == AuthConstants.organizerRejectedCode) {
      _emitAuthEvent(AuthEvent.organizerRejected);
      return;
    }

    if (failureTuple.$1 == AuthConstants.userDisabledCode) {
      _emitAuthEvent(AuthEvent.accountDisabled);
      return;
    }

    if (failureTuple.$1 == AuthConstants.profileNotFoundCode) {
      _navigateToIncompleteEmailRegistration();
      return;
    }

    if (failureTuple.$1 == AuthConstants.accountConflictCode) {
      AppSnackbarUtils.showError(
        'Tài khoản đã tồn tại',
        'Email này đã được đăng ký. Vui lòng đăng nhập.',
      );
      FirebaseAuth.instance.signOut();
      Future.delayed(const Duration(seconds: 1));
      Get.offAll(() => const LoginScreen());
      return;
    }

    AppSnackbarUtils.showError(
      'Đăng nhập thất bại',
      'Email hoặc mật khẩu không đúng. Vui lòng thử lại.',
    );
  }

  void _navigateToIncompleteEmailRegistration() async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser == null || firebaseUser.email == null) {
      AppSnackbarUtils.showError(
        'Lỗi',
        'Phiên xác thực đã hết. Vui lòng thử lại.',
      );
      return;
    }

    loginPasswordController.clear();

    AppSnackbarUtils.showInfo(
      'Đăng ký chưa hoàn tất',
      'Tài khoản đã tồn tại. Vui lòng hoàn thành thông tin để tiếp tục.',
    );

    final isUser = await _showGoogleAccountTypeDialog();
    if (isUser == null) {
      await FirebaseAuth.instance.signOut();
      return;
    }

    final idToken = await firebaseUser.getIdToken(true);
    googleAuthResult.value = GoogleAuthSession(
      firebaseUid: firebaseUser.uid,
      idToken: idToken ?? '',
      email: firebaseUser.email ?? '',
      isNewUser: false,
      state: GoogleAuthState.success,
    );
    registerEmailController.text = firebaseUser.email ?? '';
    registerAsOrganization.value = !isUser;

    Get.toNamed('/register/google', arguments: {'isStudent': isUser});
  }

  Future<void> register() async {
    if (isLoadingEmail.value) return;

    final userProfileParams = _buildUserProfileParams();
    final verificationDocIds = _parseVerificationDocumentIds();
    final organizationProfileParams = _buildOrganizationProfile();

    if (registerAsOrganization.value && verificationDocIds.isEmpty) {
      AppSnackbarUtils.showError(
        'Thiếu minh chứng',
        'Tổ chức phải có ít nhất 1 tài liệu minh chứng.',
      );
      isLoadingEmail.value = false;
      return;
    }

    isLoadingEmail.value = true;
    final result = await _signupUsecase(
      SignupWithEmailAndPasswordParams(
        password: registerPasswordController.text,
        signupParams: SignupParams(
          idToken: '',
          isUser: !registerAsOrganization.value,
          email: registerEmailController.text.trim(),
          phoneNumber: _nullableTrim(registerPhoneController),
          userProfile: userProfileParams,
          organizationProfile: organizationProfileParams,
          verificationDocumentIds: verificationDocIds,
        ),
      ),
    );

    result.fold(
      (failure) {
        final failureTuple = _extractFailureInfo(
          failure,
          dataParsingMessage: 'Không đọc được dữ liệu người dùng từ hệ thống.',
        );

        if (failureTuple.$1 == AuthConstants.organizerPendingCode) {
          _clearRegisterSensitiveFields();
          _emitAuthEvent(AuthEvent.organizerPending);
          return;
        }

        if (failureTuple.$1 == AuthConstants.accountConflictCode) {
          AppSnackbarUtils.showError(
            'Tài khoản đã tồn tại',
            'Email này đã được đăng ký. Vui lòng đăng nhập.',
          );
          return;
        }

        AppSnackbarUtils.showError(
          'Đăng ký thất bại',
          failureTuple.$2,
        );
      },
      (user) {
        if (user == null) {
          AppSnackbarUtils.showError(
            'Đăng ký thất bại',
            'Không tìm thấy thông tin người dùng sau khi xác thực.',
          );
          return;
        }

        _clearRegisterSensitiveFields();
        if (user.status == UserStatus.disabled) {
          _emitAuthEvent(AuthEvent.accountDisabled);
          return;
        }
        _populateCurrentUser(user);
        AppSnackbarUtils.showSuccess('Thành công', 'Tạo tài khoản thành công.');
        _emitAuthEvent(AuthEvent.loginSuccess);
      },
    );

    isLoadingEmail.value = false;
  }

  SignupUserProfileParams? _buildUserProfileParams() {
    if (registerAsOrganization.value) {
      return null;
    }

    final fullName = registerFullNameController.text.trim();
    return SignupUserProfileParams(
      fullName: fullName.isNotEmpty
          ? fullName
          : _resolvedFullName(registerEmailController.text),
      studentCode: _nullableTrim(registerStudentIdController),
      university: _nullableTrim(registerUniversityController),
      faculty: _nullableTrim(registerFacultyController),
      major: _nullableTrim(registerMajorController),
      avatarFileId: registerAvatarFileId.value,
      gender: _normalizeGender(selectedGender.value),
      dateOfBirth: selectedBirthDate.value,
    );
  }

  String? _normalizeGender(String? gender) {
    if (gender == null) return null;
    final normalized = gender.trim().toUpperCase();
    if (normalized == 'NAM' || normalized == 'NU' || normalized == 'KHAC') {
      return normalized;
    }
    return gender;
  }

  SignupOrganizationProfileParams? _buildOrganizationProfile() {
    if (!registerAsOrganization.value) {
      return null;
    }

    return SignupOrganizationProfileParams(
      organizationName: organizationNameController.text.trim(),
      organizationType: organizationType.value,
      address: _nullableTrim(organizationAddressController),
      logoFileId: registerLogoFileId.value,
      description: _nullableTrim(organizationDescriptionController),
    );
  }

  (String?, String) _extractFailureInfo(
    FailureEntity failure, {
    required String dataParsingMessage,
  }) {
    return failure.when(
      serverFailure: (code, message) => (code, message),
      dataParsingFailure: () => (null, dataParsingMessage),
      noConnectionFailure: () => (null, 'Không có kết nối mạng.'),
      systemFailure: (code, message) => (code, message),
    );
  }

  static void handleAccountDisabled() {
    AppSnackbarUtils.showError(
      'Tài khoản bị khóa',
      'Tài khoản của bạn đã bị khóa. Liên hệ Admin để được hỗ trợ.',
    );
    Get.offAll(() => const LoginScreen());
  }

  static void handleFailure(FailureEntity failure) {
    final code = failure.errorCode();
    if (code == AuthConstants.userDisabledCode) {
      handleAccountDisabled();
      return;
    }

    // Defensive: if backend returns generic 403 with "user disabled" message,
    // treat as account disabled (fallback for older/unpatched backend)
    if (code == '403') {
      final message = failure.when(
        serverFailure: (_, m) => m,
        dataParsingFailure: () => null,
        noConnectionFailure: () => null,
        systemFailure: (_, m) => m,
      );
      if (message != null &&
          message.toLowerCase().contains('user is disabled')) {
        handleAccountDisabled();
        return;
      }
    }

    failure.when(
      serverFailure: (_, message) =>
          AppSnackbarUtils.showError('Lỗi', message ?? 'Có lỗi xảy ra'),
      dataParsingFailure: () =>
          AppSnackbarUtils.showError('Lỗi', 'Không đọc được dữ liệu'),
      noConnectionFailure: () =>
          AppSnackbarUtils.showError('Lỗi', 'Không có kết nối mạng'),
      systemFailure: (_, message) =>
          AppSnackbarUtils.showError('Lỗi', message ?? 'Lỗi hệ thống'),
    );
  }

  String _resolvedFullName(String email) {
    final fullName = registerFullNameController.text.trim();
    if (fullName.isNotEmpty) {
      return fullName;
    }
    return email.split('@').first;
  }

  List<int> _parseVerificationDocumentIds() {
    return uploadedVerificationDocs
        .map((doc) => doc['id'] as int?)
        .whereType<int>()
        .toList();
  }

  void _populateCurrentUser(UserEntity? user) {
    currentUser.value = user;
  }

  String? _nullableTrim(TextEditingController controller) {
    final value = controller.text.trim();
    if (value.isEmpty) return null;
    return value;
  }

  void _clearRegisterSensitiveFields() {
    registerPasswordController.clear();
    registerConfirmPasswordController.clear();
  }

  Future<void> sendResetPasswordEmail({required String email}) async {
    if (isLoadingEmail.value) return;

    isLoadingEmail.value = true;
    final result = await _sendPasswordResetEmailUsecase(
      SendPasswordResetEmailParams(email: email.trim()),
    );

    result.fold(
      (failure) {
        AppSnackbarUtils.showError(
          'Không gửi được email',
          failure.when(
            serverFailure: (_, message) => message,
            dataParsingFailure: () =>
                'Có lỗi dữ liệu khi gửi yêu cầu đặt lại mật khẩu.',
            noConnectionFailure: () => 'Không có kết nối mạng.',
            systemFailure: (_, message) => message,
          ),
        );
      },
      (_) {
        forgotPasswordEmailController.clear();
        AppSnackbarUtils.showSuccess(
          'Thành công',
          'Đã gửi email đặt lại mật khẩu. Vui lòng kiểm tra hộp thư.',
        );
        Get.back();
      },
    );

    isLoadingEmail.value = false;
  }

  void bootstrapSession() {
    isLoadingSession.value = true;
    _refreshCurrentUserUsecase(const NoParams()).then((fullUserResult) {
      fullUserResult.fold(
        (failure) {
          final failureTuple =
              _extractFailureInfo(failure, dataParsingMessage: '');
          if (failureTuple.$1 == AuthConstants.userDisabledCode) {
            _emitAuthEvent(AuthEvent.accountDisabled);
          }
        },
        (fullUser) {
          if (fullUser == null) return;
          _populateCurrentUser(fullUser);
        },
      );
      isLoadingSession.value = false;
    });
  }

  Future<UserEntity?> refreshCurrentUser() async {
    final result = await _refreshCurrentUserUsecase(const NoParams());

    return result.fold(
      (failure) {
        final failureTuple =
            _extractFailureInfo(failure, dataParsingMessage: '');
        if (failureTuple.$1 == AuthConstants.userDisabledCode) {
          _emitAuthEvent(AuthEvent.accountDisabled);
          return null;
        }
        AppSnackbarUtils.showError(
          'Lỗi',
          failureTuple.$2.isNotEmpty
              ? failureTuple.$2
              : 'Không đọc được dữ liệu',
        );
        return null;
      },
      (user) {
        _populateCurrentUser(user);
        return user;
      },
    );
  }

  Future<void> logout() async {
    if (isLoadingEmail.value) return;

    isLoadingEmail.value = true;
    _isLoggingOut = true;

    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );

    final result = await _signoutUsecase(const NoParams());

    result.fold(
      (failure) {
        AppSnackbarUtils.showError(
          'Lỗi',
          failure.when(
            serverFailure: (_, message) => message,
            dataParsingFailure: () => 'Không thể xử lý phản hồi đăng xuất.',
            noConnectionFailure: () => 'Không có kết nối mạng.',
            systemFailure: (_, message) => message,
          ),
        );
      },
      (_) {
        _populateCurrentUser(null);
        resetAllRegisterFields();
        loginFormState = null;
      },
    );

    try {
      await FirebaseAuth.instance.signOut();
    } catch (_) {}

    isLoadingEmail.value = false;
    isLoadingGoogle.value = false;
    _isLoggingOut = false;

    Get.back();
    AppSnackbarUtils.showInfo('Đăng xuất', 'Bạn đã đăng xuất thành công.');
    await Future.delayed(const Duration(milliseconds: 500));
    Get.offAll(() => const LoginScreen());
  }

  Future<void> printAccessTokenForPostman() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      debugPrint('[TOKEN] No user logged in');
      return;
    }
    final token = await user.getIdToken(true);
    debugPrint('[TOKEN] =========================================');
    debugPrint('[TOKEN] Access Token for Postman:');
    debugPrint(token);
    debugPrint('[TOKEN] =========================================');
  }
}
