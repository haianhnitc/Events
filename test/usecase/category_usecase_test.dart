import 'package:dartz/dartz.dart';
import 'package:events_app/api_template/services/failure.dart';
import 'package:events_app/feature/common/data/repository/category_repository.dart';
import 'package:events_app/feature/common/domain/entity/category_entity.dart';
import 'package:events_app/feature/common/domain/usecase/category_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCategoryRepository extends Mock implements CategoryRepository {}

void main() {
  late MockCategoryRepository mockRepository;
  late GetCategoriesUsecase usecase;

  setUp(() {
    mockRepository = MockCategoryRepository();
    usecase = GetCategoriesUsecase(mockRepository);
  });

  group('GetCategoriesUsecase', () {
    test('trả về list category entity khi repository thành công', () async {
      final entities = [
        CategoryEntity(categoryId: 1, name: 'Category 1'),
        CategoryEntity(categoryId: 2, name: 'Category 2'),
        CategoryEntity(categoryId: 3, name: 'Category 3'),
      ];
      when(() => mockRepository.getCategories())
          .thenAnswer((_) async => Right(entities));

      final result = await usecase(null);

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Expected Right'),
        (categories) {
          expect(categories.length, equals(3));
          expect(categories.first.categoryId, equals(1));
          expect(categories.last.categoryId, equals(3));
        },
      );
    });

    test('trả về empty list khi repository trả rỗng', () async {
      when(() => mockRepository.getCategories())
          .thenAnswer((_) async => const Right([]));

      final result = await usecase(null);

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Expected Right'),
        (categories) => expect(categories, isEmpty),
      );
    });

    test('trả về Left(FailureEntity) khi repository trả unauthorized', () async {
      when(() => mockRepository.getCategories())
          .thenAnswer((_) async => const Left(FailureEntity.serverFailure('401', 'Unauthorized')));

      final result = await usecase(null);

      expect(result.isLeft(), isTrue);
    });

    test('trả về Left(FailureEntity) khi repository trả notFound', () async {
      when(() => mockRepository.getCategories())
          .thenAnswer((_) async => const Left(FailureEntity.serverFailure('404', 'Not found')));

      final result = await usecase(null);

      expect(result.isLeft(), isTrue);
    });

    test('trả về Left(FailureEntity) khi repository trả serverFailure', () async {
      when(() => mockRepository.getCategories())
          .thenAnswer((_) async => const Left(FailureEntity.serverFailure('500', 'Server error')));

      final result = await usecase(null);

      expect(result.isLeft(), isTrue);
    });

    test('trả về Left(FailureEntity) khi repository trả dataParsingFailure', () async {
      when(() => mockRepository.getCategories())
          .thenAnswer((_) async => const Left(FailureEntity.dataParsingFailure()));

      final result = await usecase(null);

      expect(result.isLeft(), isTrue);
    });
  });
}
