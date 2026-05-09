import 'package:dartz/dartz.dart';
import 'package:events_app/api_template/base_response/api_response_forwarder.dart';
import 'package:events_app/api_template/services/failure.dart';
import 'package:events_app/feature/event_management/data/model/event_summary_model.dart';
import 'package:events_app/feature/event_management/domain/entity/event_summary_entity.dart';
import 'package:events_app/feature/user_management/data/datasource/user_datasource.dart';
import 'package:events_app/feature/user_management/data/model/rank_model.dart';
import 'package:events_app/feature/user_management/data/model/user_model.dart';
import 'package:events_app/feature/user_management/data/model/user_package_model.dart';
import 'package:events_app/feature/user_management/domain/entity/rank_entity.dart';
import 'package:events_app/feature/user_management/domain/entity/user_entity.dart';
import 'package:events_app/feature/user_management/domain/entity/user_package_entity.dart';
import 'package:events_app/feature/participant/domain/entity/participant_entity.dart';
import 'package:events_app/feature/user_management/domain/repository/user_repository.dart';
import 'package:events_app/feature/user_management/domain/usecase/update_current_user_usecase.dart';
import 'package:events_app/feature/participant/data/model/participant_model.dart';
import 'package:events_app/feature/participant/domain/entity/participant_entity.dart';
import 'package:events_app/feature/portfolio/data/model/portfolio_model.dart';
import 'package:events_app/feature/portfolio/data/model/portfolio_detail_model.dart';
import 'package:events_app/feature/portfolio/domain/entity/portfolio_entity.dart';
import 'package:events_app/feature/portfolio/domain/entity/portfolio_detail_entity.dart';
import 'package:events_app/feature/common/domain/entity/package_entity.dart';
import 'package:events_app/feature/common/data/model/package_model.dart';
import 'package:events_app/feature/payment/domain/entity/transaction_entity.dart';
import 'package:events_app/feature/payment/data/model/transaction_model.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: UserRepository)
class UserRepositoryImpl implements UserRepository {
  final UserDatasource _datasource;

  UserRepositoryImpl(this._datasource);

  @override
  Future<Either<FailureEntity, UserEntity?>> getCurrentUser() async {
    final response = await _datasource.getCurrentUser();
    return response.toEitherNullable().map((m) => m?.toEntity());
  }

  @override
  Future<Either<FailureEntity, UserEntity?>> getUserById(int userId) async {
    final response = await _datasource.getUserById(userId);
    return response.toEitherNullable().map((m) => m?.toEntity());
  }

  @override
  Future<Either<FailureEntity, UserEntity?>> updateCurrentUser(
      UpdateCurrentUserParams params) async {
    final response = await _datasource.updateCurrentUser(params);
    return response.toEitherNullable().map((m) => m?.toEntity());
  }

  @override
  Future<Either<FailureEntity, List<EventSummaryEntity>>>
      getUserParticipatedEvents({
    required int userId,
    String? participantType,
    int page = 0,
    int size = 20,
  }) async {
    final response = await _datasource.getUserParticipatedEvents(
      userId: userId,
      participantType: participantType,
      page: page,
      size: size,
    );
    return response.toEither().fold(
      (failure) => Left(failure),
      (data) {
        if (data is! Map<String, dynamic>) return const Right([]);
        final content = data['content'] as List<dynamic>? ?? [];
        return Right(content
            .map((e) =>
                EventSummaryModel.fromJson(e as Map<String, dynamic>).toEntity())
            .toList());
      },
    );
  }

  @override
  Future<Either<FailureEntity, RankEntity?>> getUserRank(int userId) async {
    final response = await _datasource.getUserRank(userId);
    return response.toEitherNullable().map((m) => m?.toEntity());
  }

  @override
  Future<Either<FailureEntity, List<RankEntity>>> getRanks({
    String? levelName,
    int page = 0,
    int size = 20,
  }) async {
    final response = await _datasource.getRanks(
      levelName: levelName,
      page: page,
      size: size,
    );
    return response.toEither().fold(
      (failure) => Left(failure),
      (data) {
        if (data is! Map<String, dynamic>) return const Right([]);
        final content = data['content'] as List<dynamic>? ?? [];
        return Right(content
            .map((e) => RankModel.fromJson(e as Map<String, dynamic>).toEntity())
            .toList());
      },
    );
  }

  @override
  Future<Either<FailureEntity, List<PackageEntity>>> getPackages({
    int page = 0,
    int size = 20,
    String? sort,
  }) async {
    final response = await _datasource.getPackages(
      page: page,
      size: size,
      sort: sort,
    );
    return response.toEither().fold(
      (failure) => Left(failure),
      (data) {
        if (data is! Map<String, dynamic>) return const Right([]);
        final content = data['content'] as List<dynamic>? ?? [];
        return Right(content
            .map((e) =>
                PackageModel.fromJson(e as Map<String, dynamic>).toEntity())
            .toList());
      },
    );
  }

  @override
  Future<Either<FailureEntity, List<UserPackageEntity>>> getUserPackages({
    int page = 0,
    int size = 20,
    String? status,
  }) async {
    final response = await _datasource.getUserPackages(page: page, size: size, status: status);
    return response.toEither().fold(
      (failure) => Left(failure),
      (data) {
        if (data is! Map<String, dynamic>) return const Right([]);
        final content = data['content'] as List<dynamic>? ?? [];
        return Right(content
            .map((e) =>
                UserPackageModel.fromJson(e as Map<String, dynamic>).toEntity())
            .toList());
      },
    );
  }

  @override
  Future<Either<FailureEntity, List<PortfolioEntity>>> getPortfolios({
    int? userId,
    bool? isPublished,
    int page = 0,
    int size = 20,
  }) async {
    final response = await _datasource.getPortfolios(
      userId: userId,
      isPublished: isPublished,
      page: page,
      size: size,
    );
    return response.toEither().fold(
      (failure) => Left(failure),
      (data) {
        if (data is! Map<String, dynamic>) return const Right([]);
        final content = data['content'] as List<dynamic>? ?? [];
        return Right(content
            .map((e) =>
                PortfolioModel.fromJson(e as Map<String, dynamic>).toEntity())
            .toList());
      },
    );
  }

  @override
  Future<Either<FailureEntity, PortfolioDetailEntity?>> getPortfolioDetail(
      int id) async {
    final response = await _datasource.getPortfolioDetail(id);
    return response.toEitherNullable().map((m) => m?.toEntity());
  }

  @override
  Future<Either<FailureEntity, TransactionEntity?>> createPortfolio(
      Map<String, dynamic> body) async {
    final response = await _datasource.createPortfolio(body);
    return response.toEitherNullable().map((m) => m?.toEntity());
  }

  @override
  Future<Either<FailureEntity, List<ParticipantEntity>>>
      getRegistrations({
    required int eventId,
    required int userId,
  }) async {
    final response = await _datasource.getRegistrations(
      eventId: eventId,
      userId: userId,
    );
    return response.toEither().fold(
      (failure) => Left(failure),
      (data) {
        if (data is! Map<String, dynamic>) return const Right([]);
        final content = data['content'] as List<dynamic>? ?? [];
        return Right(content
            .map((e) => ParticipantModel.fromJson(e as Map<String, dynamic>).toEntity())
            .toList());
      },
    );
  }
}
