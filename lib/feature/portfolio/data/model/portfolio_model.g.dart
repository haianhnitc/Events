// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'portfolio_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PortfolioModelImpl _$$PortfolioModelImplFromJson(Map<String, dynamic> json) =>
    _$PortfolioModelImpl(
      portfolioId: (json['portfolioId'] as num?)?.toInt(),
      user: json['user'] == null
          ? null
          : UserSummaryModel.fromJson(json['user'] as Map<String, dynamic>),
      userId: (json['userId'] as num?)?.toInt(),
      price: (json['price'] as num?)?.toInt(),
      title: json['title'] as String?,
      description: json['description'] as String?,
      portfolioCode: json['portfolioCode'] as String?,
      isPublished: json['isPublished'] as bool?,
      viewCount: (json['viewCount'] as num?)?.toInt(),
      downloadCount: (json['downloadCount'] as num?)?.toInt(),
      thumbnail: json['thumbnail'] as String?,
      itemCount: (json['itemCount'] as num?)?.toInt(),
      items: (json['items'] as List<dynamic>?)
          ?.map((e) => PortfolioItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdTime: json['createdTime'] == null
          ? null
          : DateTime.parse(json['createdTime'] as String),
      publishTime: json['publishTime'] == null
          ? null
          : DateTime.parse(json['publishTime'] as String),
    );

Map<String, dynamic> _$$PortfolioModelImplToJson(
        _$PortfolioModelImpl instance) =>
    <String, dynamic>{
      'portfolioId': instance.portfolioId,
      'user': instance.user,
      'userId': instance.userId,
      'price': instance.price,
      'title': instance.title,
      'description': instance.description,
      'portfolioCode': instance.portfolioCode,
      'isPublished': instance.isPublished,
      'viewCount': instance.viewCount,
      'downloadCount': instance.downloadCount,
      'thumbnail': instance.thumbnail,
      'itemCount': instance.itemCount,
      'items': instance.items,
      'createdTime': instance.createdTime?.toIso8601String(),
      'publishTime': instance.publishTime?.toIso8601String(),
    };
