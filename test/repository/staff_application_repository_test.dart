import 'package:dartz/dartz.dart';
import 'package:events_app/api_template/services/failure.dart';
import 'package:events_app/feature/staff_application/data/datasource/staff_application_datasource.dart';
import 'package:events_app/feature/staff_application/data/model/staff_application_model.dart';
import 'package:events_app/feature/staff_application/data/repository/staff_application_repository_impl.dart';
import 'package:events_app/feature/staff_application/domain/usecase/apply_ctv_params.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../helpers/fake_data.dart';
import '../helpers/mock_rest_client.dart';

class MockStaffApplicationDatasource extends Mock
    implements StaffApplicationDatasource {}

class FakeApplyCtvParams extends Fake implements ApplyCtvParams {}

void main() {
  late MockStaffApplicationDatasource mockDatasource;
  late StaffApplicationRepositoryImpl repository;

  setUpAll(() {
    registerFallbackValue(FakeApplyCtvParams());
  });

  setUp(() {
    mockDatasource = MockStaffApplicationDatasource();
    repository = StaffApplicationRepositoryImpl(mockDatasource);
  });

  group('createApplication', () {
    test('trả về StaffApplicationEntity khi datasource thành công', () async {
      final model =
          StaffApplicationModel.fromJson(fakeStaffApplicationJson(id: 5));
      when(() => mockDatasource.createApplication(any()))
          .thenAnswer((_) async => successResponse(model));

      const params = ApplyCtvParams(eventId: 1, answers: []);
      final result = await repository.createApplication(params);

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Expected Right'),
        (entity) => expect(entity.applicationId, equals(5)),
      );
    });

    test('trả về Left khi datasource trả conflict', () async {
      when(() => mockDatasource.createApplication(any())).thenAnswer(
          (_) async =>
              errorResponse<StaffApplicationModel>(conflictResponse()));

      const params = ApplyCtvParams(eventId: 1, answers: []);
      final result = await repository.createApplication(params);

      expect(result.isLeft(), isTrue);
    });

    test('maps model sang entity đúng', () async {
      final model =
          StaffApplicationModel.fromJson(fakeStaffApplicationJson(id: 10));
      when(() => mockDatasource.createApplication(any()))
          .thenAnswer((_) async => successResponse(model));

      const params = ApplyCtvParams(eventId: 1, answers: []);
      final result = await repository.createApplication(params);

      result.fold(
        (_) => fail('Expected Right'),
        (entity) {
          expect(entity.applicationId, equals(10));
          expect(entity.roleName, equals('Tình nguyện viên'));
        },
      );
    });
  });

  group('getApplicationById', () {
    test('trả về StaffApplicationEntity khi datasource thành công', () async {
      final model =
          StaffApplicationModel.fromJson(fakeStaffApplicationJson(id: 20));
      when(() => mockDatasource.getApplicationById(any()))
          .thenAnswer((_) async => successResponse(model));

      final result = await repository.getApplicationById(20);

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Expected Right'),
        (entity) => expect(entity.applicationId, equals(20)),
      );
    });

    test('trả về Left khi datasource trả notFound', () async {
      when(() => mockDatasource.getApplicationById(any())).thenAnswer(
          (_) async =>
              errorResponse<StaffApplicationModel>(notFoundResponse()));

      final result = await repository.getApplicationById(9999);

      expect(result.isLeft(), isTrue);
    });
  });
}
