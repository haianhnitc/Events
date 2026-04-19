import 'package:events_app/feature/common/domain/entity/category_entity.dart';
import 'package:events_app/feature/common/domain/entity/category_option_entity.dart';
import 'package:events_app/feature/common/domain/enum/app_enum.dart';

final List<CategoryEntity> categoriesMock = [
  CategoryEntity(
    categoryId: 1,
    name: 'Trường đại học',
    type: CategoryType.school,
    options: [
      CategoryOptionEntity(
        categoryOptionId: 1,
        categoryId: 1,
        value: 'ĐH Bách Khoa TP.HCM',
      ),
      CategoryOptionEntity(
        categoryOptionId: 2,
        categoryId: 1,
        value: 'ĐH Thể dục Thể thao Hà Nội',
      ),
      CategoryOptionEntity(
        categoryOptionId: 3,
        categoryId: 1,
        value: 'ĐH Ngoại thương',
      ),
      CategoryOptionEntity(
        categoryOptionId: 4,
        categoryId: 1,
        value: 'ĐH Ngoại ngữ - ĐHQGHN',
      ),
      CategoryOptionEntity(
        categoryOptionId: 5,
        categoryId: 1,
        value: 'ĐH Công nghệ - ĐHQGHN',
      ),
      CategoryOptionEntity(
        categoryOptionId: 6,
        categoryId: 1,
        value: 'ĐH Y Hà Nội',
      ),
      CategoryOptionEntity(
        categoryOptionId: 7,
        categoryId: 1,
        value: 'ĐH FPT Hà Nội',
      ),
      CategoryOptionEntity(
        categoryOptionId: 8,
        categoryId: 1,
        value: 'ĐH Quốc gia TP.HCM',
      ),
    ],
  ),
  CategoryEntity(
    categoryId: 2,
    name: 'Lĩnh vực',
    type: CategoryType.field,
    options: [
      CategoryOptionEntity(
        categoryOptionId: 9,
        categoryId: 2,
        value: 'Công nghệ',
      ),
      CategoryOptionEntity(
        categoryOptionId: 10,
        categoryId: 2,
        value: 'Văn hóa - Nghệ thuật',
      ),
      CategoryOptionEntity(
        categoryOptionId: 11,
        categoryId: 2,
        value: 'Kỹ năng mềm',
      ),
      CategoryOptionEntity(
        categoryOptionId: 12,
        categoryId: 2,
        value: 'Khởi nghiệp',
      ),
      CategoryOptionEntity(
        categoryOptionId: 13,
        categoryId: 2,
        value: 'Thể thao',
      ),
      CategoryOptionEntity(
        categoryOptionId: 14,
        categoryId: 2,
        value: 'Định hướng nghề nghiệp',
      ),
      CategoryOptionEntity(
        categoryOptionId: 15,
        categoryId: 2,
        value: 'Học thuật',
      ),
      CategoryOptionEntity(
        categoryOptionId: 16,
        categoryId: 2,
        value: 'Tình nguyện',
      ),
    ],
  ),
  CategoryEntity(
    categoryId: 3,
    name: 'Giá / Lương',
    type: CategoryType.price,
    options: [
      CategoryOptionEntity(
        categoryOptionId: 17,
        categoryId: 3,
        value: 'Miễn phí',
      ),
      CategoryOptionEntity(
        categoryOptionId: 18,
        categoryId: 3,
        value: '0 - 150,000đ',
      ),
      CategoryOptionEntity(
        categoryOptionId: 19,
        categoryId: 3,
        value: '150,000đ - 300,000đ',
      ),
    ],
  ),
  CategoryEntity(
    categoryId: 4,
    name: 'Tiêu chí',
    type: CategoryType.criterion,
    options: [
      CategoryOptionEntity(
        categoryOptionId: 20,
        categoryId: 4,
        value: 'Chứng chỉ 5 tốt',
      ),
      CategoryOptionEntity(
        categoryOptionId: 21,
        categoryId: 4,
        value: 'Cộng điểm đoàn',
      ),
    ],
  ),
];
