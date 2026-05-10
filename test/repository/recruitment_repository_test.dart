import 'package:events_app/feature/recruitment/data/datasource/ctv_recruitment_datasource.dart';
import 'package:events_app/feature/recruitment/data/model/ctv_recruitment_model.dart';
import 'package:events_app/feature/recruitment/data/repository/ctv_recruitment_repository_impl.dart';
import 'package:events_app/feature/recruitment/domain/usecase/ctv_recruitment_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../helpers/fake_data.dart';
import '../helpers/mock_rest_client.dart';

class MockCtvRecruitmentDatasource extends Mock
    implements CtvRecruitmentDatasource {}

void main() {
  late MockCtvRecruitmentDatasource mockDatasource;
  late CtvRecruitmentRepositoryImpl repository;

  setUp(() {
    mockDatasource = MockCtvRecruitmentDatasource();
    repository = CtvRecruitmentRepositoryImpl(mockDatasource);
  });

  group('getRecruitments', () {
    test('trả về list CtvRecruitmentEntity khi datasource thành công',
        () async {
      final models = [
        CtvRecruitmentModel.fromJson(fakeCtvRecruitmentJson(id: 1)),
        CtvRecruitmentModel.fromJson(fakeCtvRecruitmentJson(id: 2)),
      ];
      when(() => mockDatasource.getRecruitments(
            eventId: any(named: 'eventId'),
            page: any(named: 'page'),
            size: any(named: 'size'),
          )).thenAnswer((_) async => successResponse(models));

      final result = await repository.getRecruitments(
        const GetRecruitmentsParams(page: 0, size: 20),
      );

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Expected Right'),
        (entities) {
          expect(entities.length, equals(2));
          expect(entities.first.ctvRecruitmentId, equals(1));
          expect(entities.last.ctvRecruitmentId, equals(2));
        },
      );
    });

    test('trả về empty list khi datasource trả rỗng', () async {
      when(() => mockDatasource.getRecruitments(
                eventId: any(named: 'eventId'),
                page: any(named: 'page'),
                size: any(named: 'size'),
              ))
          .thenAnswer(
              (_) async => successResponse<List<CtvRecruitmentModel>>([]));

      final result = await repository.getRecruitments(
        const GetRecruitmentsParams(page: 0, size: 20),
      );

      expect(result.isRight(), isTrue);
      result.fold((_) => fail('Expected Right'), (entities) {
        expect(entities, isEmpty);
      });
    });

    test('trả về FailureEntity khi datasource trả error', () async {
      when(() => mockDatasource.getRecruitments(
                eventId: any(named: 'eventId'),
                page: any(named: 'page'),
                size: any(named: 'size'),
              ))
          .thenAnswer((_) async =>
              errorResponse<List<CtvRecruitmentModel>>(serverErrorResponse()));

      final result = await repository.getRecruitments(
        const GetRecruitmentsParams(page: 0, size: 20),
      );

      expect(result.isLeft(), isTrue);
    });

    test('maps models sang entities đúng', () async {
      final models = [
        CtvRecruitmentModel.fromJson(fakeCtvRecruitmentJson(id: 5)),
      ];
      when(() => mockDatasource.getRecruitments(
            eventId: any(named: 'eventId'),
            page: any(named: 'page'),
            size: any(named: 'size'),
          )).thenAnswer((_) async => successResponse(models));

      final result = await repository.getRecruitments(
        const GetRecruitmentsParams(page: 0, size: 20),
      );

      result.fold(
        (_) => fail('Expected Right'),
        (entities) {
          expect(entities.first.ctvRecruitmentId, equals(5));
          expect(entities.first.title, equals('Recruitment 5'));
        },
      );
    });
  });

  group('getRecruitmentById', () {
    test('trả về CtvRecruitmentEntity khi datasource thành công', () async {
      final model = CtvRecruitmentModel.fromJson(fakeCtvRecruitmentJson(id: 7));
      when(() => mockDatasource.getRecruitmentById(any()))
          .thenAnswer((_) async => successResponse(model));

      final result = await repository.getRecruitmentById(7);

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Expected Right'),
        (entity) => expect(entity.ctvRecruitmentId, equals(7)),
      );
    });

    test('trả về Left khi datasource trả notFound', () async {
      when(() => mockDatasource.getRecruitmentById(any())).thenAnswer(
          (_) async => errorResponse<CtvRecruitmentModel>(notFoundResponse()));

      final result = await repository.getRecruitmentById(9999);

      expect(result.isLeft(), isTrue);
    });
  });
}
