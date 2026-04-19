import 'dart:async';

import 'package:events_app/app_layout.dart';
import 'package:events_app/authentication/domain/auth_constants.dart';
import 'package:events_app/authentication/presentation/controller/auth_controller.dart';
import 'package:events_app/authentication/presentation/pages/login_screen.dart';
import 'package:events_app/authentication/presentation/pages/organizer_pending_approval_screen.dart';
import 'package:events_app/authentication/presentation/pages/organizer_rejected_screen.dart';
import 'package:events_app/feature/common/domain/enum/app_enum.dart';
import 'package:events_app/feature/common/utils/app_snackbar_utils.dart';
import 'package:events_app/routes/organizer_app_layout.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  late final AuthController _authController;
  StreamSubscription<AuthEvent>? _authEventSubscription;

  @override
  void initState() {
    super.initState();
    _authController = AuthController.ensureInstance();
    _authController.bootstrapSession();
    _authEventSubscription =
        _authController.authEvents.listen(_handleAuthEvent);
  }

  @override
  void dispose() {
    _authEventSubscription?.cancel();
    super.dispose();
  }

  void _navigateByUser(UserRole? role, VerificationStatus? status) {
    if (role == UserRole.organization) {
      if (status == VerificationStatus.pending) {
        Get.offAll(() => const OrganizerPendingApprovalScreen());
      } else if (status == VerificationStatus.rejected) {
        Get.offAll(() => const OrganizerRejectedScreen());
      } else {
        Get.offAll(() => const OrganizerAppLayout());
      }
    } else {
      Get.offAll(() => AppLayout());
    }
  }

  void _handleAuthEvent(AuthEvent event) {
    switch (event) {
      case AuthEvent.logoutComplete:
      case AuthEvent.sessionExpired:
        _authController.resetAllRegisterFields();
        AppSnackbarUtils.showError(
          'Phiên đăng nhập hết hạn',
          'Phiên đăng nhập đã hết hạn. Vui lòng đăng nhập lại.',
        );
        Get.offAll(() => const LoginScreen());

      case AuthEvent.accountDisabled:
        _authController.currentUser.value = null;
        try {
          _authController.logout();
        } catch (_) {}
        AppSnackbarUtils.showError(
          'Tài khoản bị khóa',
          'Tài khoản của bạn đã bị khóa. Liên hệ Admin để được hỗ trợ.',
        );
        Get.offAll(() => const LoginScreen());

      case AuthEvent.organizerPending:
        Get.to(() => const OrganizerPendingApprovalScreen());

      case AuthEvent.organizerRejected:
        Get.to(() => const OrganizerRejectedScreen());

      case AuthEvent.loginSuccess:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final user = _authController.currentUser.value;

      if (user == null) {
        return const LoginScreen();
      }

      if (user.role == UserRole.organization) {
        final status = user.organizationProfile?.verificationStatus;
        if (status == VerificationStatus.pending) {
          return const OrganizerPendingApprovalScreen();
        }
        if (status == VerificationStatus.rejected) {
          return const OrganizerRejectedScreen();
        }
      }

      return user.role == UserRole.organization
          ? const OrganizerAppLayout()
          : AppLayout();
    });
  }
}
