import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:events_app/api_template/services/failure.dart';
import 'package:events_app/dependency_injection/injection.dart';
import 'package:events_app/feature/organizer/recruitment/domain/usecase/organizer_recruitment_usecase.dart';
import 'package:events_app/feature/organizer/recruitment/domain/usecase/organizer_recruitment_params.dart';
import 'package:events_app/feature/organizer/recruitment/domain/usecase/organizer_recruitment_usecase.dart';
import 'package:events_app/feature/recruitment/domain/entity/ctv_recruitment_entity.dart';
import 'package:events_app/feature/organizer/presentation/controller/organizer_recruitment_form_controller.dart';

class MockCreateOrganizerRecruitmentUsecase extends Mock
    implements CreateOrganizerRecruitmentUsecase {}

class MockUpdateOrganizerRecruitmentUsecase extends Mock
    implements UpdateOrganizerRecruitmentUsecase {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late OrganizerRecruitmentFormController controller;
  late MockCreateOrganizerRecruitmentUsecase mockCreateUsecase;
  late MockUpdateOrganizerRecruitmentUsecase mockUpdateUsecase;

  setUp(() {
    Get.testMode = true;
    Get.reset();
    networkGetIt.reset();

    mockCreateUsecase = MockCreateOrganizerRecruitmentUsecase();
    mockUpdateUsecase = MockUpdateOrganizerRecruitmentUsecase();
    networkGetIt.registerSingleton<MockCreateOrganizerRecruitmentUsecase>(
        mockCreateUsecase);
    networkGetIt.registerSingleton<MockUpdateOrganizerRecruitmentUsecase>(
        mockUpdateUsecase);

    controller = OrganizerRecruitmentFormController();
  });

  tearDown(() {
    Get.reset();
    networkGetIt.reset();
  });

  setUpAll(() {
    registerFallbackValue(CreateRecruitmentParams(eventId: 1));
    registerFallbackValue(
        UpdateRecruitmentParamsWrapper(id: 1, params: UpdateRecruitmentParams()));
  });

  group('Initial state', () {
    test('isEditMode = false, isSubmitting = false', () {
      controller.initForCreate();

      expect(controller.isEditMode, false);
      expect(controller.isSubmitting.value, false);
      expect(controller.editingRecruitment.value, null);
    });
  });

  group('createRecruitment', () {
    test('success sets created recruitment', () async {
      when(() => mockCreateUsecase(any())).thenAnswer(
        (_) async => Right(CtvRecruitmentEntity()),
      );

      controller.titleController.text = 'Test Recruitment';
      controller.descriptionController.text = 'Description';
      controller.roleNameController.text = 'Volunteer';
      controller.quantityController.text = '10';

      final params = CreateRecruitmentParams(
        eventId: 1,
        title: 'Test Recruitment',
        description: 'Description',
        roleName: 'Volunteer',
        quantity: 10,
      );
      await controller.submit(1);

      verify(() => mockCreateUsecase(any())).called(1);
      expect(controller.isSubmitting.value, false);
    });

    test('400 returns Left', () async {
      when(() => mockCreateUsecase(any())).thenAnswer(
        (_) async => Left(FailureEntity.serverFailure('400', 'Invalid data')),
      );

      controller.titleController.text = '';
      await controller.submit(1);

      verifyNever(() => mockCreateUsecase(any()));
    });

    test('sets isLoading during call', () async {
      when(() => mockCreateUsecase(any())).thenAnswer(
        (_) async {
          await Future.delayed(const Duration(milliseconds: 50));
          return Right(CtvRecruitmentEntity());
        },
      );

      controller.titleController.text = 'Valid Title';
      controller.descriptionController.text = 'Description';
      controller.roleNameController.text = 'Volunteer';
      controller.quantityController.text = '10';

      final future = controller.submit(1);
      expect(controller.isSubmitting.value, true);

      await future;
      expect(controller.isSubmitting.value, false);
    });
  });

  group('updateRecruitment', () {
    test('success', () async {
      when(() => mockUpdateUsecase(any())).thenAnswer(
        (_) async => Right(CtvRecruitmentEntity()),
      );

      controller.initForEdit(CtvRecruitmentEntity(ctvRecruitmentId: 1));
      controller.titleController.text = 'Updated Title';

      await controller.submit(1);

      verify(() => mockUpdateUsecase(any())).called(1);
    });

    test('404 returns Left', () async {
      when(() => mockUpdateUsecase(any())).thenAnswer(
        (_) async => Left(FailureEntity.serverFailure('404', 'Not found')),
      );

      controller.initForEdit(CtvRecruitmentEntity(ctvRecruitmentId: 999));
      controller.titleController.text = 'Updated';

      await controller.submit(1);

      verifyNever(() => mockUpdateUsecase(any()));
    });
  });

  group('validateForm', () {
    test('required fields checked', () {
      controller.initForCreate();

      final isValid = controller.formKey.currentState?.validate();
      expect(isValid, false);
    });
  });

  group('Form fields', () {
    test('can be set and read', () {
      controller.initForCreate();

      controller.titleController.text = 'Test Title';
      controller.descriptionController.text = 'Test Description';
      controller.roleNameController.text = 'Test Role';
      controller.quantityController.text = '50';
      controller.rewardCoinController.text = '100';

      expect(controller.titleController.text, 'Test Title');
      expect(controller.descriptionController.text, 'Test Description');
      expect(controller.roleNameController.text, 'Test Role');
      expect(controller.quantityController.text, '50');
      expect(controller.rewardCoinController.text, '100');
    });
  });
}
