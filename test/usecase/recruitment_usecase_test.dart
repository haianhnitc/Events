import 'package:dartz/dartz.dart';
import 'package:events_app/api_template/services/failure.dart';
import 'package:events_app/feature/recruitment/domain/entity/ctv_recruitment_entity.dart';
import 'package:events_app/feature/recruitment/domain/repository/ctv_recruitment_repository.dart';
import 'package:events_app/feature/recruitment/domain/usecase/ctv_recruitment_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCtvRecruitmentRepository extends Mock implements CtvRecruitmentRepository {}

void main() {
  late MockCtvRecruitmentRepository mockRepository;
  late GetRecruitmentsUsecase getRecruitmentsUsecase;
  late GetRecruitmentByIdUsecase getRecruitmentByIdUsecase;

  setUp(() {
    mockRepository = MockCtvRecruitmentRepository();
    getRecruitmentsUsecase = GetRecruitmentsUsecase(mockRepository);
    getRecruitmentByIdUsecase = GetRecruitmentByIdUsecase(mockRepository);
  });

  group('GetRecruitmentsUsecase', () {
    test('trả về list CtvRecruitmentEntity khi repository thành công', () async {
      final entities = [
        CtvRecruitmentEntity(ctvRecruitmentId: 1, title: 'Recruitment 1'),
        CtvRecruitmentEntity(ctvRecruitmentId: 2, title: 'Recruitment 2'),
      ];
      when(() => mockRepository.getRecruitments(any()))
          .thenAnswer((_) async => Right(entities));

      final result = await getRecruitmentsUsecase(
        const GetRecruitmentsParams(page: 0, size: 20),
      );

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Expected Right'),
        (recruitments) {
          expect(recruitments.length, equals(2));
          expect(recruitments.first.ctvRecruitmentId, equals(1));
        },
      );
    });

    test('trả về empty list khi repository trả rỗng', () async {
      when(() => mockRepository.getRecruitments(any()))
          .thenAnswer((_) async => const Right([]));

      final result = await getRecruitmentsUsecase(
        const GetRecruitmentsParams(page: 0, size: 20),
      );

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Expected Right'),
        (recruitments) => expect(recruitments, isEmpty),
      );
    });

    test('trả về failure khi repository thất bại', () async {
      when(() => mockRepository.getRecruitments(any()))
          .thenAnswer((_) async =>
              const Left(FailureEntity.serverFailure('500', 'Server error')));

      final result = await getRecruitmentsUsecase(
        const GetRecruitmentsParams(page: 0, size: 20),
      );

      expect(result.isLeft(), isTrue);
    });

    test('trả về CtvRecruitmentEntity khi repository thành công', () async {
      final entity = CtvRecruitmentEntity(ctvRecruitmentId: 7, title: 'Recruitment 7');
      when(() => mockRepository.getRecruitmentById(any()))
          .thenAnswer((_) async => Right(entity));

      final result = await getRecruitmentByIdUsecase(7);

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Expected Right'),
        (recruitment) => expect(recruitment.ctvRecruitmentId, equals(7)),
      );
    });

    test('trả về Left khi repository trả notFound', () async {
      when(() => mockRepository.getRecruitmentById(any()))
          .thenAnswer((_) async =>
              const Left(FailureEntity.serverFailure('404', 'Not found')));

      final result = await getRecruitmentByIdUsecase(9999);

      expect(result.isLeft(), isTrue);
    });
  });
}
