import 'package:events_app/api_template/api_provider.dart';
import 'package:events_app/api_template/api_path.dart';
import 'package:events_app/api_template/base_request/api_request.dart';
import 'package:events_app/api_template/base_response/api_response.dart';
import 'package:events_app/api_template/base_response/api_response_forwarder.dart';
import 'package:events_app/api_template/services/rest_clients.dart';
import 'package:events_app/feature/venue/data/model/venue_model.dart';
import 'package:events_app/feature/organizer/event/domain/usecase/venue_params.dart';
import 'package:injectable/injectable.dart';

abstract class OrganizerVenueDatasource {
  Future<ApiResponse<VenuePage>> getVenues(VenueListParams params);
  Future<ApiResponse<VenueModel>> createVenue(VenueCreateParams params);
}

class VenuePage {
  final List<VenueModel> content;
  final int totalElements;
  final int totalPages;
  final int page;
  final int size;

  const VenuePage({
    required this.content,
    required this.totalElements,
    required this.totalPages,
    required this.page,
    required this.size,
  });
}

@Injectable(as: OrganizerVenueDatasource)
class OrganizerVenueDatasourceImpl extends ApiProvider implements OrganizerVenueDatasource {
  OrganizerVenueDatasourceImpl({RestClient? client})
      : super(client: client ?? NRDRestClient());

  @override
  Future<ApiResponse<VenuePage>> getVenues(VenueListParams params) async {
    try {
      final response = await get<Map<String, dynamic>>(
        ApiPath.venuesList,
        (data) => Map<String, dynamic>.from(data as Map),
        queryParameters: {
          'page': params.page,
          'size': params.size,
        },
        requireAuth: true,
      );

      return forwardEnvelopeResponse<VenuePage>(
        response,
        (object) {
          if (object is! Map<String, dynamic>) {
            throw const FormatException('Invalid object payload');
          }
          final contentList = object['content'] as List<dynamic>? ?? [];
          return VenuePage(
            content: contentList
                .map((e) => VenueModel.fromJson(e as Map<String, dynamic>))
                .toList(),
            totalElements: object['totalElements'] as int? ?? 0,
            totalPages: object['totalPages'] as int? ?? 0,
            page: object['page'] as int? ?? 0,
            size: object['size'] as int? ?? params.size,
          );
        },
        fallbackError: 'Không thể tải danh sách địa điểm',
      );
    } catch (e) {
      return mapExceptionToApiResponse(e);
    }
  }

  @override
  Future<ApiResponse<VenueModel>> createVenue(VenueCreateParams params) async {
    try {
      final response = await post<Map<String, dynamic>>(
        ApiPath.venues,
        (data) => Map<String, dynamic>.from(data as Map),
        body: ApiRequestBody.json(params.toJson()),
        requireAuth: true,
      );

      return forwardEnvelopeResponse<VenueModel>(
        response,
        (object) {
          if (object is! Map<String, dynamic>) {
            throw const FormatException('Invalid object payload');
          }
          return VenueModel.fromJson(object);
        },
        fallbackError: 'Tạo địa điểm thất bại',
      );
    } catch (e) {
      return mapExceptionToApiResponse(e);
    }
  }
}
