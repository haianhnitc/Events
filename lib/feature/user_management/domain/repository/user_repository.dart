import 'package:dartz/dartz.dart';
import 'package:events_app/api_template/services/failure.dart';
import 'package:events_app/feature/event_management/domain/entity/event_summary_entity.dart';
import 'package:events_app/feature/common/domain/entity/package_entity.dart';
import 'package:events_app/feature/user_management/domain/entity/rank_entity.dart';
import 'package:events_app/feature/user_management/domain/entity/user_entity.dart';
import 'package:events_app/feature/user_management/domain/entity/user_package_entity.dart';
import 'package:events_app/feature/participant/domain/entity/participant_entity.dart';
import 'package:events_app/feature/user_management/domain/usecase/update_current_user_usecase.dart';
import 'package:events_app/feature/portfolio/domain/entity/portfolio_entity.dart';
import 'package:events_app/feature/portfolio/domain/entity/portfolio_detail_entity.dart';
import 'package:events_app/feature/payment/domain/entity/transaction_entity.dart';

abstract class UserRepository {
  Future<Either<FailureEntity, UserEntity?>> getCurrentUser();

  Future<Either<FailureEntity, UserEntity?>> getUserById(int userId);

  Future<Either<FailureEntity, UserEntity?>> updateCurrentUser(
      UpdateCurrentUserParams params);

  Future<Either<FailureEntity, List<EventSummaryEntity>>> getUserParticipatedEvents({
    required int userId,
    String? participantType,
    int page = 0,
    int size = 20,
  });

  Future<Either<FailureEntity, List<ParticipantEntity>>> getRegistrations({
    required int eventId,
    required int userId,
  });

  Future<Either<FailureEntity, RankEntity?>> getUserRank(int userId);
  Future<Either<FailureEntity, List<RankEntity>>> getRanks({String? levelName, int page = 0, int size = 20});
  Future<Either<FailureEntity, List<PackageEntity>>> getPackages({int page, int size, String sort});
  Future<Either<FailureEntity, List<UserPackageEntity>>> getUserPackages({int page = 0, int size = 20});
  Future<Either<FailureEntity, List<UserPackageEntity>>> getExpiredPackages({int page = 0, int size = 20});
  Future<Either<FailureEntity, List<PortfolioEntity>>> getPortfolios({int? userId, bool? isPublished, int page = 0, int size = 20});
  Future<Either<FailureEntity, PortfolioDetailEntity?>> getPortfolioDetail(int id);
  Future<Either<FailureEntity, TransactionEntity?>> createPortfolio(Map<String, dynamic> body);
}
