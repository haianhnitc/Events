// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'portfolio_create_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PortfolioItemCreateModelImpl _$$PortfolioItemCreateModelImplFromJson(
        Map<String, dynamic> json) =>
    _$PortfolioItemCreateModelImpl(
      eventParticipantId: (json['eventParticipantId'] as num).toInt(),
      displayTitle: json['displayTitle'] as String?,
      displayRole: json['displayRole'] as String?,
      displayNote: json['displayNote'] as String?,
      displayOrder: (json['displayOrder'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$PortfolioItemCreateModelImplToJson(
        _$PortfolioItemCreateModelImpl instance) =>
    <String, dynamic>{
      'eventParticipantId': instance.eventParticipantId,
      'displayTitle': instance.displayTitle,
      'displayRole': instance.displayRole,
      'displayNote': instance.displayNote,
      'displayOrder': instance.displayOrder,
    };

_$PortfolioCreateModelImpl _$$PortfolioCreateModelImplFromJson(
        Map<String, dynamic> json) =>
    _$PortfolioCreateModelImpl(
      title: json['title'] as String,
      description: json['description'] as String?,
      price: (json['price'] as num?)?.toInt() ?? 0,
      coinUsed: (json['coinUsed'] as num?)?.toInt() ?? 0,
      items: (json['items'] as List<dynamic>?)
          ?.map((e) =>
              PortfolioItemCreateModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$PortfolioCreateModelImplToJson(
        _$PortfolioCreateModelImpl instance) =>
    <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'price': instance.price,
      'coinUsed': instance.coinUsed,
      'items': instance.items,
    };
