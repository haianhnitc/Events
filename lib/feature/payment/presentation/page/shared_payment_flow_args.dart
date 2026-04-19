import 'dart:convert';

import 'package:events_app/feature/common/domain/enum/app_enum.dart';
import 'package:events_app/feature/event_management/domain/entity/event_entity.dart';
import 'package:events_app/feature/common/domain/entity/package_entity.dart';
import 'package:events_app/feature/portfolio/domain/entity/portfolio_entity.dart';
import 'package:events_app/feature/venue/domain/entity/venue_entity.dart';

class PaymentItemInfo {
  final EventEntity? event;
  final PackageEntity? package;
  final PortfolioEntity? portfolio;
  final bool autoRenew;

  const PaymentItemInfo._({
    this.event,
    this.package,
    this.portfolio,
    this.autoRenew = false,
  });

  factory PaymentItemInfo.forEvent(EventEntity event) {
    return PaymentItemInfo._(event: event);
  }

  factory PaymentItemInfo.forPackage(PackageEntity package, {bool autoRenew = false}) {
    return PaymentItemInfo._(package: package, autoRenew: autoRenew);
  }

  factory PaymentItemInfo.forPortfolio(PortfolioEntity portfolio) {
    return PaymentItemInfo._(portfolio: portfolio);
  }

  factory PaymentItemInfo.fromJson(Map<String, dynamic> json) {
    return PaymentItemInfo._(
      event: json['event'] != null
          ? EventEntity(
              eventId: json['event']['eventId'],
              title: json['event']['title'],
              banner: json['event']['banner'],
              startTime: json['event']['startTime'] != null
                  ? DateTime.tryParse(json['event']['startTime'])
                  : null,
              endTime: json['event']['endTime'] != null
                  ? DateTime.tryParse(json['event']['endTime'])
                  : null,
              organizerName: json['event']['organizerName'],
              venue: (json['event']['venueName'] != null ||
                      json['event']['venueAddress'] != null)
                  ? VenueEntity(
                      name: json['event']['venueName'],
                      address: json['event']['venueAddress'],
                    )
                  : null,
              price: json['event']['price'],
            )
          : null,
      package: json['package'] != null
          ? PackageEntity(
              packageId: json['package']['packageId'],
              name: json['package']['name'],
              description: json['package']['description'],
              price: json['package']['price'],
              durationDays: json['package']['durationDays'],
            )
          : null,
      portfolio: json['portfolio'] != null
          ? PortfolioEntity(
              portfolioId: json['portfolio']['portfolioId'],
              title: json['portfolio']['title'],
              description: json['portfolio']['description'],
              portfolioCode: json['portfolio']['portfolioCode'],
              price: json['portfolio']['price'],
            )
          : null,
      autoRenew: json['autoRenew'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (event != null)
        'event': {
          'eventId': event!.eventId,
          'title': event!.title,
          'banner': event!.banner,
          'startTime': event!.startTime?.toIso8601String(),
          'endTime': event!.endTime?.toIso8601String(),
          'organizerName': event!.organizerName,
          'venueName': event!.venue?.name,
          'venueAddress': event!.venue?.address,
          'price': event!.price,
        },
      if (package != null)
        'package': {
          'packageId': package!.packageId,
          'name': package!.name,
          'description': package!.description,
          'price': package!.price,
          'durationDays': package!.durationDays,
        },
      if (portfolio != null)
        'portfolio': {
          'portfolioId': portfolio!.portfolioId,
          'title': portfolio!.title,
          'description': portfolio!.description,
          'portfolioCode': portfolio!.portfolioCode,
          'price': portfolio!.price,
        },
      'autoRenew': autoRenew,
    };
  }

  String get itemTitle {
    if (event != null) return event!.title ?? 'Sự kiện';
    if (package != null) return package!.name ?? 'Gói dịch vụ';
    if (portfolio != null) return portfolio!.title ?? 'Portfolio';
    return '';
  }

  String? get itemSubtitle {
    if (event != null) return event!.organizerName;
    if (package != null) return package!.description;
    if (portfolio != null) return portfolio!.description;
    return null;
  }

  String? get itemImageUrl {
    return event?.banner;
  }

  int? get itemPrice {
    if (event != null) return event!.price;
    if (package != null) return package!.price;
    if (portfolio != null) return portfolio!.price;
    return null;
  }
}

class SharedPaymentFlowArgs {
  final String title;
  final String? subtitle;
  final TransactionReferenceType referenceType;
  final int? referenceId;
  final int originalAmount;
  final String currency;
  final String? extraData;
  final int initialCoinUsed;
  final PaymentItemInfo? itemInfo;

  const SharedPaymentFlowArgs({
    required this.title,
    this.subtitle,
    required this.referenceType,
    this.referenceId,
    required this.originalAmount,
    this.currency = 'VND',
    this.extraData,
    this.initialCoinUsed = 0,
    this.itemInfo,
  });

  factory SharedPaymentFlowArgs.forTicket({
    required int ticketId,
    required int originalAmount,
    EventEntity? event,
    String title = 'Thanh toán vé sự kiện',
    String subtitle = 'Thanh toán để hoàn tất đăng ký tham gia sự kiện.',
    int initialCoinUsed = 0,
  }) {
    final payload = <String, dynamic>{};
    if (event != null) {
      payload['event'] = {
        'eventId': event.eventId,
        'title': event.title,
        'banner': event.banner,
        'startTime': event.startTime?.toIso8601String(),
        'endTime': event.endTime?.toIso8601String(),
        'organizerName': event.organizerName,
        'venueName': event.venue?.name,
        'venueAddress': event.venue?.address,
        'price': event.price,
      };
    }
    return SharedPaymentFlowArgs(
      title: title,
      subtitle: subtitle,
      referenceType: TransactionReferenceType.ticket,
      referenceId: ticketId,
      originalAmount: originalAmount,
      extraData: payload.isNotEmpty ? jsonEncode(payload) : null,
      initialCoinUsed: initialCoinUsed,
      itemInfo: event != null ? PaymentItemInfo.forEvent(event) : null,
    );
  }

  factory SharedPaymentFlowArgs.forPortfolio({
    required int originalAmount,
    required String title,
    String? description,
    required String portfolioCode,
    int? referenceId,
    String subtitle = 'Thanh toán để hoàn tất tạo portfolio.',
    int initialCoinUsed = 0,
    PortfolioEntity? portfolio,
  }) {
    final payload = <String, dynamic>{
      'title': title,
      'portfolioCode': portfolioCode,
      'price': originalAmount,
      if (description != null && description.trim().isNotEmpty)
        'description': description,
    };
    if (portfolio != null) {
      payload['portfolio'] = {
        'portfolioId': portfolio.portfolioId,
        'title': portfolio.title,
        'description': portfolio.description,
        'portfolioCode': portfolio.portfolioCode,
        'price': portfolio.price,
      };
    }
    return SharedPaymentFlowArgs(
      title: title,
      subtitle: subtitle,
      referenceType: TransactionReferenceType.portfolio,
      referenceId: referenceId,
      originalAmount: originalAmount,
      extraData: jsonEncode(payload),
      initialCoinUsed: initialCoinUsed,
      itemInfo: portfolio != null ? PaymentItemInfo.forPortfolio(portfolio) : null,
    );
  }

  factory SharedPaymentFlowArgs.forPackagePurchase({
    required int packageId,
    required int originalAmount,
    required bool autoRenew,
    String title = 'Thanh toán mua gói',
    String subtitle = 'Thanh toán để kích hoạt gói dịch vụ.',
    int initialCoinUsed = 0,
    PackageEntity? package,
  }) {
    final payload = <String, dynamic>{'autoRenew': autoRenew};
    if (package != null) {
      payload['package'] = {
        'packageId': package.packageId,
        'name': package.name,
        'description': package.description,
        'price': package.price,
        'durationDays': package.durationDays,
      };
    }
    return SharedPaymentFlowArgs(
      title: title,
      subtitle: subtitle,
      referenceType: TransactionReferenceType.packagePurchase,
      referenceId: packageId,
      originalAmount: originalAmount,
      extraData: jsonEncode(payload),
      initialCoinUsed: initialCoinUsed,
      itemInfo: package != null ? PaymentItemInfo.forPackage(package, autoRenew: autoRenew) : null,
    );
  }

  factory SharedPaymentFlowArgs.forPackageRenewal({
    required int userPackageId,
    required int originalAmount,
    String title = 'Thanh toán gia hạn gói',
    String subtitle = 'Thanh toán để gia hạn gói dịch vụ.',
    int initialCoinUsed = 0,
    PackageEntity? package,
  }) {
    return SharedPaymentFlowArgs(
      title: title,
      subtitle: subtitle,
      referenceType: TransactionReferenceType.packageRenewal,
      referenceId: userPackageId,
      originalAmount: originalAmount,
      initialCoinUsed: initialCoinUsed,
      itemInfo: package != null ? PaymentItemInfo.forPackage(package, autoRenew: false) : null,
    );
  }

  PaymentItemInfo? parseItemInfo() {
    if (itemInfo != null) return itemInfo;
    if (extraData == null || extraData!.trim().isEmpty) return null;
    try {
      final json = jsonDecode(extraData!) as Map<String, dynamic>;
      return PaymentItemInfo.fromJson(json);
    } catch (_) {
      return null;
    }
  }
}
