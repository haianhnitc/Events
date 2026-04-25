import 'package:events_app/api_template/api_provider.dart';
import 'package:events_app/api_template/api_path.dart';
import 'package:events_app/api_template/base_response/api_response.dart';
import 'package:events_app/api_template/base_response/api_response_forwarder.dart';
import 'package:events_app/api_template/services/rest_clients.dart';
import 'package:events_app/feature/common/data/model/category_model.dart';
import 'package:injectable/injectable.dart';

abstract class CategoryDatasource {
  Future<ApiResponse<List<CategoryModel>>> getCategories();
}

@Injectable(as: CategoryDatasource)
class CategoryDatasourceImpl extends ApiProvider implements CategoryDatasource {
  CategoryDatasourceImpl({RestClient? client})
      : super(client: client ?? NRDRestClient());

  @override
  Future<ApiResponse<List<CategoryModel>>> getCategories() async {
    try {
      final response = await get<Map<String, dynamic>>(
        ApiPath.categories,
        (data) => Map<String, dynamic>.from(data as Map),
        requireAuth: false,
      );

      return forwardEnvelopeResponse<List<CategoryModel>>(
        response,
        (object) {
          if (object is! Map<String, dynamic>) {
            throw const FormatException('Invalid object payload');
          }
          final content = object['content'] as List<dynamic>? ?? [];
          return content
              .map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
              .toList();
        },
        fallbackError: 'Lấy danh sách danh mục thất bại',
      );
    } catch (e) {
      return mapExceptionToApiResponse(e);
    }
  }
}
