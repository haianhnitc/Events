import 'package:flutter_test/flutter_test.dart';
import 'package:events_app/api_template/base_response/api_response.dart';
import 'package:events_app/api_template/base_response/api_response_forwarder.dart';
import 'package:events_app/api_template/services/rest_clients.dart';
import 'package:events_app/feature/organizer/event/data/datasource/organizer_event_datasource.dart';
import 'package:events_app/feature/organizer/event/domain/usecase/event_params.dart';
import 'package:events_app/feature/event_management/data/model/event_model.dart';
import 'package:events_app/feature/event_management/data/model/event_analytics_model.dart';
import 'package:events_app/feature/event_management/data/model/event_summary_model.dart';

import '../../helpers/fake_data.dart';

class TestOrganizerEventDatasource extends OrganizerEventDatasourceImpl {
  ApiResponse<Map<String, dynamic>>? getOrganizerEventsStub;
  ApiResponse<Map<String, dynamic>>? createEventStub;
  ApiResponse<Map<String, dynamic>>? updateEventStub;
  ApiResponse<Map<String, dynamic>>? deleteEventStub;
  ApiResponse<Map<String, dynamic>>? publishEventStub;
  ApiResponse<Map<String, dynamic>>? getEventByIdStub;
  ApiResponse<Map<String, dynamic>>? getEventStatisticsStub;
  ApiResponse<Map<String, dynamic>>? getEventAnalyticsStub;
  ApiResponse<Map<String, dynamic>>? createCategoryOptionStub;
  ApiResponse<Map<String, dynamic>>? updateCategoryOptionStub;
  ApiResponse<Map<String, dynamic>>? deleteCategoryOptionStub;

  TestOrganizerEventDatasource({
    this.getOrganizerEventsStub,
    this.createEventStub,
    this.updateEventStub,
    this.deleteEventStub,
    this.publishEventStub,
    this.getEventByIdStub,
    this.getEventStatisticsStub,
    this.getEventAnalyticsStub,
    this.createCategoryOptionStub,
    this.updateCategoryOptionStub,
    this.deleteCategoryOptionStub,
  }) : super(client: StubRestClient());

  @override
  Future<ApiResponse<EventSummaryPage>> getOrganizerEvents(
      OrganizerEventListParams params) async {
    final envelope = getOrganizerEventsStub ??
        ApiResponse.success({
          'errorCode': 0,
          'statusCode': 200,
          'message': 'OK',
          'object': {
            'content': [fakeEventSummaryJson()],
            'totalElements': 1,
            'totalPages': 1,
            'page': 0,
            'size': 20,
          },
        });
    return forwardEnvelopeResponse<EventSummaryPage>(
      envelope,
      (object) {
        if (object is! Map<String, dynamic>) {
          throw const FormatException('Invalid object payload');
        }
        final contentList = object['content'] as List<dynamic>? ?? [];
        return EventSummaryPage(
          content: contentList
              .map((e) => EventSummaryModel.fromJson(e as Map<String, dynamic>))
              .toList(),
          totalElements: object['totalElements'] as int? ?? 0,
          totalPages: object['totalPages'] as int? ?? 0,
          page: object['page'] as int? ?? 0,
          size: object['size'] as int? ?? params.size,
        );
      },
      fallbackError: 'Không thể tải danh sách sự kiện',
    );
  }

  @override
  Future<ApiResponse<EventModel>> createEvent(EventCreateParams params) async {
    final envelope = createEventStub ??
        ApiResponse.success({
          'errorCode': 0,
          'statusCode': 200,
          'message': 'OK',
          'object': fakeEventJson(),
        });
    return forwardEnvelopeResponse<EventModel>(
      envelope,
      (object) {
        if (object is! Map<String, dynamic>) {
          throw const FormatException('Invalid object payload');
        }
        return EventModel.fromJson(object);
      },
      fallbackError: 'Tạo sự kiện thất bại',
    );
  }

  @override
  Future<ApiResponse<EventModel>> updateEvent(
      int eventId, EventUpdateParams params) async {
    final envelope = updateEventStub ??
        ApiResponse.success({
          'errorCode': 0,
          'statusCode': 200,
          'message': 'OK',
          'object': fakeEventJson(id: eventId),
        });
    return forwardEnvelopeResponse<EventModel>(
      envelope,
      (object) {
        if (object is! Map<String, dynamic>) {
          throw const FormatException('Invalid object payload');
        }
        return EventModel.fromJson(object);
      },
      fallbackError: 'Cập nhật sự kiện thất bại',
    );
  }

  @override
  Future<ApiResponse<void>> deleteEvent(int eventId) async {
    final envelope = deleteEventStub ??
        const ApiResponse.success({
          'errorCode': 0,
          'statusCode': 200,
          'message': 'OK',
          'object': null,
        });
    return forwardEnvelopeResponse<void>(
      envelope,
      (_) {},
      fallbackError: 'Xóa sự kiện thất bại',
    );
  }

  @override
  Future<ApiResponse<EventModel>> publishEvent(int eventId) async {
    final envelope = publishEventStub ??
        ApiResponse.success({
          'errorCode': 0,
          'statusCode': 200,
          'message': 'OK',
          'object': fakeEventJson(),
        });
    return forwardEnvelopeResponse<EventModel>(
      envelope,
      (object) {
        if (object is! Map<String, dynamic>) {
          throw const FormatException('Invalid object payload');
        }
        return EventModel.fromJson(object);
      },
      fallbackError: 'Xuất bản sự kiện thất bại',
    );
  }

  @override
  Future<ApiResponse<EventModel>> getEventById(int eventId) async {
    final envelope = getEventByIdStub ??
        ApiResponse.success({
          'errorCode': 0,
          'statusCode': 200,
          'message': 'OK',
          'object': fakeEventJson(id: eventId),
        });
    return forwardEnvelopeResponse<EventModel>(
      envelope,
      (object) {
        if (object is! Map<String, dynamic>) {
          throw const FormatException('Invalid object payload');
        }
        return EventModel.fromJson(object);
      },
      fallbackError: 'Lấy chi tiết sự kiện thất bại',
    );
  }

  @override
  Future<ApiResponse<Map<String, dynamic>>> getEventStatistics(
      int eventId) async {
    final envelope = getEventStatisticsStub ??
        ApiResponse.success({
          'errorCode': 0,
          'statusCode': 200,
          'message': 'OK',
          'object': {
            'eventId': eventId,
            'totalRegistered': 100,
            'totalCheckedIn': 80,
          },
        });
    return forwardEnvelopeResponse<Map<String, dynamic>>(
      envelope,
      (object) {
        if (object is! Map<String, dynamic>) {
          throw const FormatException('Invalid object payload');
        }
        return object;
      },
      fallbackError: 'Lấy thống kê sự kiện thất bại',
    );
  }

  @override
  Future<ApiResponse<EventAnalyticsModel>> getEventAnalytics(
      int eventId) async {
    final envelope = getEventAnalyticsStub ??
        ApiResponse.success({
          'errorCode': 0,
          'statusCode': 200,
          'message': 'OK',
          'object': fakeEventAnalyticsJson(),
        });
    return forwardEnvelopeResponse<EventAnalyticsModel>(
      envelope,
      (object) {
        if (object is! Map<String, dynamic>) {
          throw const FormatException('Invalid object payload');
        }
        return EventAnalyticsModel.fromJson(object);
      },
      fallbackError: 'Lấy phân tích sự kiện thất bại',
    );
  }

  @override
  Future<ApiResponse<Map<String, dynamic>>> createEventCategoryOption(
      EventCategoryOptionCreateParams params) async {
    final envelope = createCategoryOptionStub ??
        const ApiResponse.success({
          'errorCode': 0,
          'statusCode': 200,
          'message': 'OK',
          'object': {'success': true},
        });
    return forwardEnvelopeResponse<Map<String, dynamic>>(
      envelope,
      (object) {
        if (object is! Map<String, dynamic>) {
          throw const FormatException('Invalid object payload');
        }
        return object;
      },
      fallbackError: 'Tạo category option thất bại',
    );
  }

  @override
  Future<ApiResponse<Map<String, dynamic>>> updateEventCategoryOption(
      int eventId,
      int categoryOptionId,
      EventCategoryOptionUpdateParams params) async {
    final envelope = updateCategoryOptionStub ??
        const ApiResponse.success({
          'errorCode': 0,
          'statusCode': 200,
          'message': 'OK',
          'object': {'success': true},
        });
    return forwardEnvelopeResponse<Map<String, dynamic>>(
      envelope,
      (object) {
        if (object is! Map<String, dynamic>) {
          throw const FormatException('Invalid object payload');
        }
        return object;
      },
      fallbackError: 'Cập nhật category option thất bại',
    );
  }

  @override
  Future<ApiResponse<void>> deleteEventCategoryOption(
      int eventId, int categoryOptionId) async {
    final envelope = deleteCategoryOptionStub ??
        const ApiResponse.success({
          'errorCode': 0,
          'statusCode': 200,
          'message': 'OK',
          'object': null,
        });
    return forwardEnvelopeResponse<void>(
      envelope,
      (_) {},
      fallbackError: 'Xóa category option thất bại',
    );
  }
}

Map<String, dynamic> fakeEventAnalyticsJson() {
  return {
    'eventId': 1,
    'eventTitle': 'Test Event',
    'genderDistribution': {'male': 50, 'female': 50},
    'majorDistribution': <Map<String, dynamic>>[],
    'schoolDistribution': <Map<String, dynamic>>[],
    'ageDistribution': <Map<String, dynamic>>[],
    'checkInTimeline': <Map<String, dynamic>>[],
    'lastUpdateTime': '2024-06-01T12:00:00Z',
  };
}

void main() {
  group('getOrganizerEvents', () {
    test('success returns EventSummaryPage with content list', () async {
      final datasource = TestOrganizerEventDatasource(
        getOrganizerEventsStub: ApiResponse.success({
          'errorCode': 0,
          'statusCode': 200,
          'message': 'OK',
          'object': {
            'content': [fakeEventSummaryJson()],
            'totalElements': 1,
            'totalPages': 1,
            'page': 0,
            'size': 20,
          },
        }),
      );

      const params = OrganizerEventListParams(
        organizerId: 1,
        page: 0,
        size: 20,
      );
      final result = await datasource.getOrganizerEvents(params);

      result.when(
        success: (page) {
          expect(page.content.length, equals(1));
          expect(page.totalElements, equals(1));
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

    test('empty content', () async {
      final datasource = TestOrganizerEventDatasource(
        getOrganizerEventsStub: const ApiResponse.success({
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

      const params = OrganizerEventListParams(
        organizerId: 1,
        page: 0,
        size: 20,
      );
      final result = await datasource.getOrganizerEvents(params);

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

  group('createEvent', () {
    test('success returns EventModel', () async {
      final datasource = TestOrganizerEventDatasource(
        createEventStub: ApiResponse.success({
          'errorCode': 0,
          'statusCode': 200,
          'message': 'OK',
          'object': fakeEventJson(),
        }),
      );

      final params = EventCreateParams(
        title: 'Test Event',
        description: 'Description',
        startTime: DateTime(2024, 6, 1),
        endTime: DateTime(2024, 6, 2),
        venueId: 1,
      );
      final result = await datasource.createEvent(params);

      result.when(
        success: (event) {
          expect(event.eventId, equals(1));
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
      final datasource = TestOrganizerEventDatasource(
        createEventStub: const ApiResponse.badRequest(
          ApiResponseError(code: '400', message: 'Bad request', errors: []),
        ),
      );

      const params = EventCreateParams(title: '');
      final result = await datasource.createEvent(params);

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
  });

  group('updateEvent', () {
    test('success', () async {
      final datasource = TestOrganizerEventDatasource(
        updateEventStub: ApiResponse.success({
          'errorCode': 0,
          'statusCode': 200,
          'message': 'OK',
          'object': fakeEventJson(),
        }),
      );

      const params = EventUpdateParams(title: 'Updated Event');
      final result = await datasource.updateEvent(1, params);

      result.when(
        success: (event) {
          expect(event.eventId, equals(1));
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

    test('404 not found', () async {
      final datasource = TestOrganizerEventDatasource(
        updateEventStub: const ApiResponse.notFound(
          ApiResponseError(code: '404', message: 'Not found', errors: []),
        ),
      );

      const params = EventUpdateParams(title: 'Updated');
      final result = await datasource.updateEvent(999, params);

      expect(
        result.when(
          success: (_) => false,
          notFound: (_) => true,
          unauthorized: (_) => false,
          forbidden: (_) => false,
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

  group('deleteEvent', () {
    test('success returns void', () async {
      final datasource = TestOrganizerEventDatasource(
        deleteEventStub: const ApiResponse.success({
          'errorCode': 0,
          'statusCode': 200,
          'message': 'OK',
          'object': null,
        }),
      );

      final result = await datasource.deleteEvent(1);

      expect(
        result.when(
          success: (_) => true,
          badRequest: (_) => false,
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

    test('404', () async {
      final datasource = TestOrganizerEventDatasource(
        deleteEventStub: const ApiResponse.notFound(
          ApiResponseError(code: '404', message: 'Not found', errors: []),
        ),
      );

      final result = await datasource.deleteEvent(999);

      expect(
        result.when(
          success: (_) => false,
          notFound: (_) => true,
          unauthorized: (_) => false,
          forbidden: (_) => false,
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

  group('publishEvent', () {
    test('success', () async {
      final datasource = TestOrganizerEventDatasource(
        publishEventStub: ApiResponse.success({
          'errorCode': 0,
          'statusCode': 200,
          'message': 'OK',
          'object': fakeEventJson(),
        }),
      );

      final result = await datasource.publishEvent(1);

      result.when(
        success: (event) {
          expect(event.eventId, equals(1));
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

    test('400 bad request validation error', () async {
      final datasource = TestOrganizerEventDatasource(
        publishEventStub: const ApiResponse.badRequest(
          ApiResponseError(code: '400', message: 'Bad request', errors: []),
        ),
      );

      final result = await datasource.publishEvent(1);

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
  });

  group('getEventById', () {
    test('success', () async {
      final datasource = TestOrganizerEventDatasource(
        getEventByIdStub: ApiResponse.success({
          'errorCode': 0,
          'statusCode': 200,
          'message': 'OK',
          'object': fakeEventJson(),
        }),
      );

      final result = await datasource.getEventById(1);

      result.when(
        success: (event) {
          expect(event.eventId, equals(1));
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

    test('404', () async {
      final datasource = TestOrganizerEventDatasource(
        getEventByIdStub: const ApiResponse.notFound(
          ApiResponseError(code: '404', message: 'Not found', errors: []),
        ),
      );

      final result = await datasource.getEventById(999);

      expect(
        result.when(
          success: (_) => false,
          notFound: (_) => true,
          unauthorized: (_) => false,
          forbidden: (_) => false,
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

  group('getEventStatistics', () {
    test('success returns map', () async {
      final datasource = TestOrganizerEventDatasource(
        getEventStatisticsStub: const ApiResponse.success({
          'errorCode': 0,
          'statusCode': 200,
          'message': 'OK',
          'object': {
            'eventId': 1,
            'eventTitle': 'Test Event',
            'totalRegistered': 100,
            'totalCheckedIn': 80,
            'totalCheckedOut': 70,
          },
        }),
      );

      final result = await datasource.getEventStatistics(1);

      result.when(
        success: (data) {
          expect(data['totalRegistered'], equals(100));
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

  group('getEventAnalytics', () {
    test('success returns EventAnalyticsModel', () async {
      final datasource = TestOrganizerEventDatasource(
        getEventAnalyticsStub: ApiResponse.success({
          'errorCode': 0,
          'statusCode': 200,
          'message': 'OK',
          'object': fakeEventAnalyticsJson(),
        }),
      );

      final result = await datasource.getEventAnalytics(1);

      result.when(
        success: (analytics) {
          expect(analytics.eventId, equals(1));
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

  group('createEventCategoryOption', () {
    test('success', () async {
      final datasource = TestOrganizerEventDatasource(
        createCategoryOptionStub: const ApiResponse.success({
          'errorCode': 0,
          'statusCode': 200,
          'message': 'OK',
          'object': {'success': true},
        }),
      );

      const params = EventCategoryOptionCreateParams(
        eventId: 1,
        categoryOptionId: 5,
      );
      final result = await datasource.createEventCategoryOption(params);

      result.when(
        success: (data) {
          expect(data['success'], isTrue);
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

  group('updateEventCategoryOption', () {
    test('success', () async {
      final datasource = TestOrganizerEventDatasource(
        updateCategoryOptionStub: const ApiResponse.success({
          'errorCode': 0,
          'statusCode': 200,
          'message': 'OK',
          'object': {'success': true},
        }),
      );

      const params = EventCategoryOptionUpdateParams(categoryOptionId: 5);
      final result = await datasource.updateEventCategoryOption(1, 5, params);

      result.when(
        success: (data) {
          expect(data['success'], isTrue);
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

  group('deleteEventCategoryOption', () {
    test('success', () async {
      final datasource = TestOrganizerEventDatasource(
        deleteCategoryOptionStub: const ApiResponse.success({
          'errorCode': 0,
          'statusCode': 200,
          'message': 'OK',
          'object': null,
        }),
      );

      final result = await datasource.deleteEventCategoryOption(1, 5);

      expect(
        result.when(
          success: (_) => true,
          badRequest: (_) => false,
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
  });
}
