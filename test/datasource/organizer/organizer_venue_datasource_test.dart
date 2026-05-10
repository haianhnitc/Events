import 'package:flutter_test/flutter_test.dart';
import 'package:events_app/api_template/base_response/api_response.dart';
import 'package:events_app/api_template/base_response/api_response_forwarder.dart';
import 'package:events_app/api_template/services/rest_clients.dart';
import 'package:events_app/feature/organizer/event/data/datasource/organizer_venue_datasource.dart';
import 'package:events_app/feature/organizer/event/domain/usecase/venue_params.dart';
import 'package:events_app/feature/venue/data/model/venue_model.dart';

class TestOrganizerVenueDatasource extends OrganizerVenueDatasourceImpl {
  ApiResponse<Map<String, dynamic>>? getVenuesStub;
  ApiResponse<Map<String, dynamic>>? createStub;

  TestOrganizerVenueDatasource({
    this.getVenuesStub,
    this.createStub,
  }) : super(client: StubRestClient());

  @override
  Future<ApiResponse<VenuePage>> getVenues(VenueListParams params) async {
    final envelope = getVenuesStub ??
        const ApiResponse.success({
          'errorCode': 0,
          'statusCode': 200,
          'message': 'OK',
          'object': {
            'content': <Map<String, dynamic>>[],
            'totalElements': 0,
            'totalPages': 0,
            'page': 0,
            'size': 20,
          },
        });
    return forwardEnvelopeResponse<VenuePage>(
      envelope,
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
  }

  @override
  Future<ApiResponse<VenueModel>> createVenue(VenueCreateParams params) async {
    final envelope = createStub ??
        ApiResponse.success({
          'errorCode': 0,
          'statusCode': 200,
          'message': 'OK',
          'object': {
            'venueId': 1,
            'name': params.name,
            'address': params.address,
            'capacity': params.capacity,
          },
        });
    return forwardEnvelopeResponse<VenueModel>(
      envelope,
      (object) {
        if (object is! Map<String, dynamic>) {
          throw const FormatException('Invalid object payload');
        }
        return VenueModel.fromJson(object);
      },
      fallbackError: 'Tạo địa điểm thất bại',
    );
  }
}

void main() {
  group('getVenues', () {
    test('success with content', () async {
      final datasource = TestOrganizerVenueDatasource(
        getVenuesStub: const ApiResponse.success({
          'errorCode': 0,
          'statusCode': 200,
          'message': 'OK',
          'object': {
            'content': [
              {
                'venueId': 1,
                'name': 'Main Hall',
                'address': '123 Street',
                'capacity': 500,
              }
            ],
            'totalElements': 1,
            'totalPages': 1,
            'page': 0,
            'size': 20,
          },
        }),
      );

      const params = VenueListParams(page: 0, size: 20);
      final result = await datasource.getVenues(params);

      result.when(
        success: (page) {
          expect(page.content.length, equals(1));
        },
        unexpected: (_) => fail('Expected success'),
        badRequest: (_) => fail('Expected success'),
        unauthorized: (_) => fail('Expected success'),
        forbidden: (_) => fail('Expected success'),
        notFound: (_) => fail('Expected success'),
        conflict: (_) => fail('Expected success'),
        internalServerError: () => fail('Expected success'),
        badGateway: () => fail('Expected success'),
        serviceUnavailable: () => fail('Expected success'),
        gatewayTimeout: () => fail('Expected success'),
        canceled: () => fail('Expected success'),
        responseParsing: () => fail('Expected success'),
      );
    });

    test('empty', () async {
      final datasource = TestOrganizerVenueDatasource(
        getVenuesStub: const ApiResponse.success({
          'errorCode': 0,
          'statusCode': 200,
          'message': 'OK',
          'object': {
            'content': <Map<String, dynamic>>[],
            'totalElements': 0,
            'totalPages': 0,
            'page': 0,
            'size': 20,
          },
        }),
      );

      const params = VenueListParams(page: 0, size: 20);
      final result = await datasource.getVenues(params);

      result.when(
        success: (page) {
          expect(page.content, isEmpty);
        },
        unexpected: (_) => fail('Expected success'),
        badRequest: (_) => fail('Expected success'),
        unauthorized: (_) => fail('Expected success'),
        forbidden: (_) => fail('Expected success'),
        notFound: (_) => fail('Expected success'),
        conflict: (_) => fail('Expected success'),
        internalServerError: () => fail('Expected success'),
        badGateway: () => fail('Expected success'),
        serviceUnavailable: () => fail('Expected success'),
        gatewayTimeout: () => fail('Expected success'),
        canceled: () => fail('Expected success'),
        responseParsing: () => fail('Expected success'),
      );
    });
  });

  group('createVenue', () {
    test('success', () async {
      final datasource = TestOrganizerVenueDatasource(
        createStub: const ApiResponse.success({
          'errorCode': 0,
          'statusCode': 200,
          'message': 'OK',
          'object': {
            'venueId': 1,
            'name': 'New Venue',
            'address': '456 Avenue',
            'capacity': 300,
          },
        }),
      );

      const params = VenueCreateParams(
        name: 'New Venue',
        address: '456 Avenue',
        capacity: 300,
      );
      final result = await datasource.createVenue(params);

      result.when(
        success: (venue) {
          expect(venue.venueId, equals(1));
        },
        unexpected: (_) => fail('Expected success'),
        badRequest: (_) => fail('Expected success'),
        unauthorized: (_) => fail('Expected success'),
        forbidden: (_) => fail('Expected success'),
        notFound: (_) => fail('Expected success'),
        conflict: (_) => fail('Expected success'),
        internalServerError: () => fail('Expected success'),
        badGateway: () => fail('Expected success'),
        serviceUnavailable: () => fail('Expected success'),
        gatewayTimeout: () => fail('Expected success'),
        canceled: () => fail('Expected success'),
        responseParsing: () => fail('Expected success'),
      );
    });

    test('400 bad request', () async {
      final datasource = TestOrganizerVenueDatasource(
        createStub: const ApiResponse.badRequest(
          ApiResponseError(code: '400', message: 'Bad request', errors: []),
        ),
      );

      const params = VenueCreateParams(name: '');
      final result = await datasource.createVenue(params);

      expect(
        result.when(
          success: (_) => false,
          badRequest: (_) => true,
          unauthorized: (_) => false,
          forbidden: (_) => false,
          notFound: (_) => false,
          conflict: (_) => false,
          internalServerError: () => false,
          badGateway: () => false,
          serviceUnavailable: () => false,
          gatewayTimeout: () => false,
          canceled: () => false,
          responseParsing: () => false,
          unexpected: (_) => false,
        ),
        isTrue,
      );
    });

    test('401 unauthorized', () async {
      final datasource = TestOrganizerVenueDatasource(
        createStub: const ApiResponse.unauthorized(
          ApiResponseError(code: '401', message: 'Unauthorized', errors: []),
        ),
      );

      const params = VenueCreateParams(name: 'Unauthorized Venue');
      final result = await datasource.createVenue(params);

      expect(
        result.when(
          success: (_) => false,
          unauthorized: (_) => true,
          forbidden: (_) => false,
          notFound: (_) => false,
          badRequest: (_) => false,
          conflict: (_) => false,
          internalServerError: () => false,
          badGateway: () => false,
          serviceUnavailable: () => false,
          gatewayTimeout: () => false,
          canceled: () => false,
          responseParsing: () => false,
          unexpected: (_) => false,
        ),
        isTrue,
      );
    });
  });
}
