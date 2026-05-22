// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:events_app/api_template/services/rest_clients.dart' as _i609;
import 'package:events_app/authentication/data/datasource/auth_datasource.dart'
    as _i674;
import 'package:events_app/authentication/data/repository/auth_repository_impl.dart'
    as _i950;
import 'package:events_app/authentication/domain/repository/auth_repository.dart'
    as _i313;
import 'package:events_app/authentication/domain/usecase/get_current_user_usecase.dart'
    as _i865;
import 'package:events_app/authentication/domain/usecase/send_password_reset_email_usecase.dart'
    as _i116;
import 'package:events_app/authentication/domain/usecase/signin_with_email_and_password_usecase.dart'
    as _i749;
import 'package:events_app/authentication/domain/usecase/signin_with_google_usecase.dart'
    as _i1005;
import 'package:events_app/authentication/domain/usecase/signout_usecase.dart'
    as _i824;
import 'package:events_app/authentication/domain/usecase/signup_with_email_and_password_usecase.dart'
    as _i390;
import 'package:events_app/authentication/domain/usecase/signup_with_google_usecase.dart'
    as _i24;
import 'package:events_app/authentication/domain/usecase/upload_verification_document_usecase.dart'
    as _i600;
import 'package:events_app/dependency_injection/firebase_module.dart' as _i183;
import 'package:events_app/feature/attendance/data/datasource/attendance_datasource.dart'
    as _i967;
import 'package:events_app/feature/attendance/data/repository/attendance_repository_impl.dart'
    as _i432;
import 'package:events_app/feature/attendance/domain/repository/attendance_repository.dart'
    as _i531;
import 'package:events_app/feature/attendance/domain/usecase/attendance_usecase.dart'
    as _i429;
import 'package:events_app/feature/common/data/datasource/category_datasource.dart'
    as _i796;
import 'package:events_app/feature/common/data/datasource/file_datasource.dart'
    as _i563;
import 'package:events_app/feature/common/data/repository/category_repository.dart'
    as _i413;
import 'package:events_app/feature/common/data/repository/file_repository_impl.dart'
    as _i663;
import 'package:events_app/feature/common/domain/repository/file_repository.dart'
    as _i318;
import 'package:events_app/feature/common/domain/usecase/category_usecase.dart'
    as _i214;
import 'package:events_app/feature/common/usecase/upload_file_usecase.dart'
    as _i407;
import 'package:events_app/feature/event_management/data/datasource/event_datasource.dart'
    as _i459;
import 'package:events_app/feature/event_management/data/repository/event_repository_impl.dart'
    as _i577;
import 'package:events_app/feature/event_management/domain/repository/event_repository.dart'
    as _i438;
import 'package:events_app/feature/event_management/domain/usecase/get_event_by_id_usecase.dart'
    as _i606;
import 'package:events_app/feature/event_management/domain/usecase/get_events_usecase.dart'
    as _i59;
import 'package:events_app/feature/event_management/domain/usecase/get_featured_events_usecase.dart'
    as _i264;
import 'package:events_app/feature/feedback/data/datasource/feedback_datasource.dart'
    as _i883;
import 'package:events_app/feature/feedback/data/repository/feedback_repository_impl.dart'
    as _i176;
import 'package:events_app/feature/feedback/domain/repository/feedback_repository.dart'
    as _i217;
import 'package:events_app/feature/feedback/domain/usecase/feedback_usecase.dart'
    as _i436;
import 'package:events_app/feature/news/data/datasource/news_datasource.dart'
    as _i48;
import 'package:events_app/feature/news/data/datasource/notification_datasource.dart'
    as _i780;
import 'package:events_app/feature/news/data/repository/news_repository_impl.dart'
    as _i1019;
import 'package:events_app/feature/news/data/repository/notification_repository_impl.dart'
    as _i489;
import 'package:events_app/feature/news/domain/repository/news_repository.dart'
    as _i688;
import 'package:events_app/feature/news/domain/repository/notification_repository.dart'
    as _i58;
import 'package:events_app/feature/news/domain/usecase/news_usecase.dart'
    as _i168;
import 'package:events_app/feature/news/domain/usecase/notification_usecase.dart'
    as _i332;
import 'package:events_app/feature/organizer/attendance/data/datasource/organizer_attendance_datasource.dart'
    as _i355;
import 'package:events_app/feature/organizer/attendance/data/repository/organizer_attendance_repository_impl.dart'
    as _i414;
import 'package:events_app/feature/organizer/attendance/domain/repository/organizer_attendance_repository.dart'
    as _i851;
import 'package:events_app/feature/organizer/attendance/domain/usecase/organizer_attendance_usecase.dart'
    as _i1028;
import 'package:events_app/feature/organizer/event/data/datasource/organizer_event_datasource.dart'
    as _i418;
import 'package:events_app/feature/organizer/event/data/datasource/organizer_venue_datasource.dart'
    as _i8;
import 'package:events_app/feature/organizer/event/data/repository/organizer_event_repository_impl.dart'
    as _i72;
import 'package:events_app/feature/organizer/event/data/repository/organizer_venue_repository_impl.dart'
    as _i866;
import 'package:events_app/feature/organizer/event/domain/repository/organizer_event_repository.dart'
    as _i723;
import 'package:events_app/feature/organizer/event/domain/repository/organizer_venue_repository.dart'
    as _i323;
import 'package:events_app/feature/organizer/event/domain/usecase/organizer_event_usecase.dart'
    as _i1073;
import 'package:events_app/feature/organizer/event/domain/usecase/organizer_venue_usecase.dart'
    as _i1027;
import 'package:events_app/feature/organizer/feedback/data/datasource/organizer_feedback_datasource.dart'
    as _i827;
import 'package:events_app/feature/organizer/feedback/data/repository/organizer_feedback_repository_impl.dart'
    as _i937;
import 'package:events_app/feature/organizer/feedback/domain/repository/organizer_feedback_repository.dart'
    as _i610;
import 'package:events_app/feature/organizer/feedback/domain/usecase/organizer_feedback_usecase.dart'
    as _i804;
import 'package:events_app/feature/organizer/organization/data/datasource/organizer_organization_datasource.dart'
    as _i189;
import 'package:events_app/feature/organizer/organization/data/repository/organizer_organization_repository_impl.dart'
    as _i102;
import 'package:events_app/feature/organizer/organization/domain/repository/organizer_organization_repository.dart'
    as _i721;
import 'package:events_app/feature/organizer/organization/domain/usecase/organizer_organization_usecase.dart'
    as _i816;
import 'package:events_app/feature/organizer/participant/data/datasource/organizer_participant_datasource.dart'
    as _i749;
import 'package:events_app/feature/organizer/participant/data/repository/organizer_participant_repository_impl.dart'
    as _i338;
import 'package:events_app/feature/organizer/participant/domain/repository/organizer_participant_repository.dart'
    as _i988;
import 'package:events_app/feature/organizer/participant/domain/usecase/organizer_participant_usecase.dart'
    as _i527;
import 'package:events_app/feature/organizer/recruitment/data/datasource/organizer_recruitment_datasource.dart'
    as _i384;
import 'package:events_app/feature/organizer/recruitment/data/repository/organizer_recruitment_repository_impl.dart'
    as _i219;
import 'package:events_app/feature/organizer/recruitment/domain/repository/organizer_recruitment_repository.dart'
    as _i959;
import 'package:events_app/feature/organizer/recruitment/domain/usecase/organizer_recruitment_usecase.dart'
    as _i621;
import 'package:events_app/feature/organizer/staff_application/data/datasource/organizer_staff_application_datasource.dart'
    as _i397;
import 'package:events_app/feature/organizer/staff_application/data/repository/organizer_staff_application_repository_impl.dart'
    as _i802;
import 'package:events_app/feature/organizer/staff_application/domain/repository/organizer_staff_application_repository.dart'
    as _i62;
import 'package:events_app/feature/organizer/staff_application/domain/usecase/organizer_staff_application_usecase.dart'
    as _i286;
import 'package:events_app/feature/participant/data/datasource/participant_datasource.dart'
    as _i863;
import 'package:events_app/feature/participant/data/repository/participant_repository_impl.dart'
    as _i234;
import 'package:events_app/feature/participant/domain/repository/participant_repository.dart'
    as _i693;
import 'package:events_app/feature/participant/domain/usecase/participant_usecase.dart'
    as _i997;
import 'package:events_app/feature/payment/data/datasource/coin_datasource.dart'
    as _i588;
import 'package:events_app/feature/payment/data/datasource/sepay_payment_datasource.dart'
    as _i671;
import 'package:events_app/feature/payment/data/repository/coin_repository_impl.dart'
    as _i781;
import 'package:events_app/feature/payment/data/repository/sepay_payment_repository_impl.dart'
    as _i188;
import 'package:events_app/feature/payment/domain/repository/coin_repository.dart'
    as _i78;
import 'package:events_app/feature/payment/domain/repository/sepay_payment_repository.dart'
    as _i674;
import 'package:events_app/feature/payment/domain/usecase/coin_history_usecase.dart'
    as _i395;
import 'package:events_app/feature/payment/domain/usecase/sepay_payment_usecase.dart'
    as _i789;
import 'package:events_app/feature/recruitment/data/datasource/ctv_recruitment_datasource.dart'
    as _i954;
import 'package:events_app/feature/recruitment/data/repository/ctv_recruitment_repository_impl.dart'
    as _i520;
import 'package:events_app/feature/recruitment/domain/repository/ctv_recruitment_repository.dart'
    as _i472;
import 'package:events_app/feature/recruitment/domain/usecase/ctv_recruitment_usecase.dart'
    as _i62;
import 'package:events_app/feature/registration/data/datasource/registration_datasource.dart'
    as _i721;
import 'package:events_app/feature/registration/data/repository/registration_repository_impl.dart'
    as _i78;
import 'package:events_app/feature/registration/domain/repository/registration_repository.dart'
    as _i240;
import 'package:events_app/feature/registration/domain/usecase/registration_usecase.dart'
    as _i65;
import 'package:events_app/feature/staff_application/data/datasource/staff_application_datasource.dart'
    as _i401;
import 'package:events_app/feature/staff_application/data/repository/staff_application_repository_impl.dart'
    as _i46;
import 'package:events_app/feature/staff_application/domain/repository/staff_application_repository.dart'
    as _i498;
import 'package:events_app/feature/staff_application/domain/usecase/staff_application_usecase.dart'
    as _i827;
import 'package:events_app/feature/ticket/data/datasource/ticket_datasource.dart'
    as _i311;
import 'package:events_app/feature/ticket/data/repository/ticket_repository_impl.dart'
    as _i297;
import 'package:events_app/feature/ticket/domain/repository/ticket_repository.dart'
    as _i60;
import 'package:events_app/feature/ticket/domain/usecase/ticket_usecase.dart'
    as _i246;
import 'package:events_app/feature/user_management/data/datasource/user_datasource.dart'
    as _i145;
import 'package:events_app/feature/user_management/data/repository/user_repository_impl.dart'
    as _i232;
import 'package:events_app/feature/user_management/domain/repository/user_repository.dart'
    as _i459;
import 'package:events_app/feature/user_management/domain/usecase/get_current_user_usecase.dart'
    as _i634;
import 'package:events_app/feature/user_management/domain/usecase/get_user_participated_events_usecase.dart'
    as _i682;
import 'package:events_app/feature/user_management/domain/usecase/update_current_user_usecase.dart'
    as _i521;
import 'package:firebase_auth/firebase_auth.dart' as _i59;
import 'package:get_it/get_it.dart' as _i174;
import 'package:google_sign_in/google_sign_in.dart' as _i116;
import 'package:injectable/injectable.dart' as _i526;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final firebaseModule = _$FirebaseModule();
    gh.lazySingleton<_i59.FirebaseAuth>(() => firebaseModule.firebaseAuth);
    gh.lazySingleton<_i116.GoogleSignIn>(() => firebaseModule.googleSignIn);
    gh.factory<_i796.CategoryDatasource>(
        () => _i796.CategoryDatasourceImpl(client: gh<_i609.RestClient>()));
    gh.factory<_i563.FileDatasource>(
        () => _i563.FileDatasourceImpl(client: gh<_i609.RestClient>()));
    gh.factory<_i189.OrganizerOrganizationDatasource>(() =>
        _i189.OrganizerOrganizationDatasourceImpl(
            client: gh<_i609.RestClient>()));
    gh.factory<_i721.RegistrationDatasource>(
        () => _i721.RegistrationDatasourceImpl(client: gh<_i609.RestClient>()));
    gh.factory<_i401.StaffApplicationDatasource>(() =>
        _i401.StaffApplicationDatasourceImpl(client: gh<_i609.RestClient>()));
    gh.factory<_i749.OrganizerParticipantDatasource>(() =>
        _i749.OrganizerParticipantDatasourceImpl(
            client: gh<_i609.RestClient>()));
    gh.factory<_i355.OrganizerAttendanceDatasource>(() =>
        _i355.OrganizerAttendanceDatasourceImpl(
            client: gh<_i609.RestClient>()));
    gh.factory<_i418.OrganizerEventDatasource>(() =>
        _i418.OrganizerEventDatasourceImpl(client: gh<_i609.RestClient>()));
    gh.factory<_i145.UserDatasource>(
        () => _i145.UserDatasourceImpl(client: gh<_i609.RestClient>()));
    gh.factory<_i397.OrganizerStaffApplicationDatasource>(() =>
        _i397.OrganizerStaffApplicationDatasourceImpl(
            client: gh<_i609.RestClient>()));
    gh.factory<_i384.OrganizerRecruitmentDatasource>(() =>
        _i384.OrganizerRecruitmentDatasourceImpl(
            client: gh<_i609.RestClient>()));
    gh.factory<_i671.SePayPaymentDatasource>(
        () => _i671.SePayPaymentDatasourceImpl(client: gh<_i609.RestClient>()));
    gh.factory<_i588.CoinDatasource>(
        () => _i588.CoinDatasourceImpl(client: gh<_i609.RestClient>()));
    gh.factory<_i78.CoinRepository>(
        () => _i781.CoinRepositoryImpl(gh<_i588.CoinDatasource>()));
    gh.factory<_i48.NewsDatasource>(
        () => _i48.NewsDatasourceImpl(client: gh<_i609.RestClient>()));
    gh.factory<_i954.CtvRecruitmentDatasource>(() =>
        _i954.CtvRecruitmentDatasourceImpl(client: gh<_i609.RestClient>()));
    gh.factory<_i311.TicketDatasource>(
        () => _i311.TicketDatasourceImpl(client: gh<_i609.RestClient>()));
    gh.factory<_i60.TicketRepository>(
        () => _i297.TicketRepositoryImpl(gh<_i311.TicketDatasource>()));
    gh.factory<_i780.NotificationDatasource>(
        () => _i780.NotificationDatasourceImpl(client: gh<_i609.RestClient>()));
    gh.factory<_i863.ParticipantDatasource>(
        () => _i863.ParticipantDatasourceImpl(client: gh<_i609.RestClient>()));
    gh.factory<_i827.OrganizerFeedbackDatasource>(() =>
        _i827.OrganizerFeedbackDatasourceImpl(client: gh<_i609.RestClient>()));
    gh.factory<_i959.OrganizerRecruitmentRepository>(() =>
        _i219.OrganizerRecruitmentRepositoryImpl(
            gh<_i384.OrganizerRecruitmentDatasource>()));
    gh.factory<_i693.ParticipantRepository>(() =>
        _i234.ParticipantRepositoryImpl(gh<_i863.ParticipantDatasource>()));
    gh.factory<_i318.FileRepository>(
        () => _i663.FileRepositoryImpl(gh<_i563.FileDatasource>()));
    gh.factory<_i883.FeedbackDatasource>(
        () => _i883.FeedbackDatasourceImpl(client: gh<_i609.RestClient>()));
    gh.factory<_i8.OrganizerVenueDatasource>(
        () => _i8.OrganizerVenueDatasourceImpl(client: gh<_i609.RestClient>()));
    gh.factory<_i967.AttendanceDatasource>(
        () => _i967.AttendanceDatasourceImpl(client: gh<_i609.RestClient>()));
    gh.factory<_i472.CtvRecruitmentRepository>(() =>
        _i520.CtvRecruitmentRepositoryImpl(
            gh<_i954.CtvRecruitmentDatasource>()));
    gh.factory<_i217.FeedbackRepository>(
        () => _i176.FeedbackRepositoryImpl(gh<_i883.FeedbackDatasource>()));
    gh.factory<_i721.OrganizerOrganizationRepository>(() =>
        _i102.OrganizerOrganizationRepositoryImpl(
            gh<_i189.OrganizerOrganizationDatasource>()));
    gh.factory<_i459.EventDatasource>(
        () => _i459.EventDatasourceImpl(client: gh<_i609.RestClient>()));
    gh.factory<_i851.OrganizerAttendanceRepository>(() =>
        _i414.OrganizerAttendanceRepositoryImpl(
            gh<_i355.OrganizerAttendanceDatasource>()));
    gh.factory<_i498.StaffApplicationRepository>(() =>
        _i46.StaffApplicationRepositoryImpl(
            gh<_i401.StaffApplicationDatasource>()));
    gh.factory<_i62.GetRecruitmentsUsecase>(() =>
        _i62.GetRecruitmentsUsecase(gh<_i472.CtvRecruitmentRepository>()));
    gh.factory<_i62.GetRecruitmentByIdUsecase>(() =>
        _i62.GetRecruitmentByIdUsecase(gh<_i472.CtvRecruitmentRepository>()));
    gh.factory<_i62.GetRecruitmentQuestionsUsecase>(() =>
        _i62.GetRecruitmentQuestionsUsecase(
            gh<_i472.CtvRecruitmentRepository>()));
    gh.factory<_i438.EventRepository>(
        () => _i577.EventRepositoryImpl(gh<_i459.EventDatasource>()));
    gh.factory<_i610.OrganizerFeedbackRepository>(() =>
        _i937.OrganizerFeedbackRepositoryImpl(
            gh<_i827.OrganizerFeedbackDatasource>()));
    gh.factory<_i240.RegistrationRepository>(() =>
        _i78.RegistrationRepositoryImpl(gh<_i721.RegistrationDatasource>()));
    gh.factory<_i436.GetFeedbackQuestionsUsecase>(() =>
        _i436.GetFeedbackQuestionsUsecase(gh<_i217.FeedbackRepository>()));
    gh.factory<_i436.SubmitFeedbackUsecase>(
        () => _i436.SubmitFeedbackUsecase(gh<_i217.FeedbackRepository>()));
    gh.factory<_i58.NotificationRepository>(() =>
        _i489.NotificationRepositoryImpl(gh<_i780.NotificationDatasource>()));
    gh.factory<_i723.OrganizerEventRepository>(() =>
        _i72.OrganizerEventRepositoryImpl(
            gh<_i418.OrganizerEventDatasource>()));
    gh.factory<_i674.AuthDatasource>(() => _i674.AuthDatasourceImpl(
          firebaseAuth: gh<_i59.FirebaseAuth>(),
          googleSignIn: gh<_i116.GoogleSignIn>(),
          client: gh<_i609.RestClient>(),
        ));
    gh.factory<_i459.UserRepository>(
        () => _i232.UserRepositoryImpl(gh<_i145.UserDatasource>()));
    gh.factory<_i1028.GetOrganizerParticipantQrUsecase>(() =>
        _i1028.GetOrganizerParticipantQrUsecase(
            gh<_i851.OrganizerAttendanceRepository>()));
    gh.factory<_i1028.GetOrganizerEventQrUsecase>(() =>
        _i1028.GetOrganizerEventQrUsecase(
            gh<_i851.OrganizerAttendanceRepository>()));
    gh.factory<_i1028.OrganizerManualCheckInUsecase>(() =>
        _i1028.OrganizerManualCheckInUsecase(
            gh<_i851.OrganizerAttendanceRepository>()));
    gh.factory<_i1028.OrganizerManualCheckOutUsecase>(() =>
        _i1028.OrganizerManualCheckOutUsecase(
            gh<_i851.OrganizerAttendanceRepository>()));
    gh.factory<_i1028.GetOrganizerAttendanceLogsUsecase>(() =>
        _i1028.GetOrganizerAttendanceLogsUsecase(
            gh<_i851.OrganizerAttendanceRepository>()));
    gh.factory<_i688.NewsRepository>(
        () => _i1019.NewsRepositoryImpl(gh<_i48.NewsDatasource>()));
    gh.factory<_i621.GetOrganizerRecruitmentsUsecase>(() =>
        _i621.GetOrganizerRecruitmentsUsecase(
            gh<_i959.OrganizerRecruitmentRepository>()));
    gh.factory<_i621.GetOrganizerRecruitmentByIdUsecase>(() =>
        _i621.GetOrganizerRecruitmentByIdUsecase(
            gh<_i959.OrganizerRecruitmentRepository>()));
    gh.factory<_i621.CreateOrganizerRecruitmentUsecase>(() =>
        _i621.CreateOrganizerRecruitmentUsecase(
            gh<_i959.OrganizerRecruitmentRepository>()));
    gh.factory<_i621.UpdateOrganizerRecruitmentUsecase>(() =>
        _i621.UpdateOrganizerRecruitmentUsecase(
            gh<_i959.OrganizerRecruitmentRepository>()));
    gh.factory<_i621.CloseOrganizerRecruitmentUsecase>(() =>
        _i621.CloseOrganizerRecruitmentUsecase(
            gh<_i959.OrganizerRecruitmentRepository>()));
    gh.factory<_i621.DeleteOrganizerRecruitmentUsecase>(() =>
        _i621.DeleteOrganizerRecruitmentUsecase(
            gh<_i959.OrganizerRecruitmentRepository>()));
    gh.factory<_i332.GetNotificationListUsecase>(() =>
        _i332.GetNotificationListUsecase(gh<_i58.NotificationRepository>()));
    gh.factory<_i332.GetNotificationByIdUsecase>(() =>
        _i332.GetNotificationByIdUsecase(gh<_i58.NotificationRepository>()));
    gh.factory<_i332.MarkNotificationAsReadUsecase>(() =>
        _i332.MarkNotificationAsReadUsecase(gh<_i58.NotificationRepository>()));
    gh.factory<_i332.MarkAllNotificationsAsReadUsecase>(() =>
        _i332.MarkAllNotificationsAsReadUsecase(
            gh<_i58.NotificationRepository>()));
    gh.factory<_i634.GetCurrentUserUsecase>(
        () => _i634.GetCurrentUserUsecase(gh<_i459.UserRepository>()));
    gh.factory<_i682.GetUserParticipatedEventsUsecase>(() =>
        _i682.GetUserParticipatedEventsUsecase(gh<_i459.UserRepository>()));
    gh.factory<_i521.UpdateCurrentUserUsecase>(
        () => _i521.UpdateCurrentUserUsecase(gh<_i459.UserRepository>()));
    gh.factory<_i413.CategoryRepository>(
        () => _i413.CategoryRepositoryImpl(gh<_i796.CategoryDatasource>()));
    gh.factory<_i827.CreateStaffApplicationUsecase>(() =>
        _i827.CreateStaffApplicationUsecase(
            gh<_i498.StaffApplicationRepository>()));
    gh.factory<_i827.GetStaffApplicationByIdUsecase>(() =>
        _i827.GetStaffApplicationByIdUsecase(
            gh<_i498.StaffApplicationRepository>()));
    gh.factory<_i62.OrganizerStaffApplicationRepository>(() =>
        _i802.OrganizerStaffApplicationRepositoryImpl(
            gh<_i397.OrganizerStaffApplicationDatasource>()));
    gh.factory<_i674.SePayPaymentRepository>(() =>
        _i188.SePayPaymentRepositoryImpl(gh<_i671.SePayPaymentDatasource>()));
    gh.factory<_i1073.GetOrganizerEventListUsecase>(() =>
        _i1073.GetOrganizerEventListUsecase(
            gh<_i723.OrganizerEventRepository>()));
    gh.factory<_i1073.CreateOrganizerEventUsecase>(() =>
        _i1073.CreateOrganizerEventUsecase(
            gh<_i723.OrganizerEventRepository>()));
    gh.factory<_i1073.UpdateOrganizerEventUsecase>(() =>
        _i1073.UpdateOrganizerEventUsecase(
            gh<_i723.OrganizerEventRepository>()));
    gh.factory<_i1073.DeleteOrganizerEventUsecase>(() =>
        _i1073.DeleteOrganizerEventUsecase(
            gh<_i723.OrganizerEventRepository>()));
    gh.factory<_i1073.PublishOrganizerEventUsecase>(() =>
        _i1073.PublishOrganizerEventUsecase(
            gh<_i723.OrganizerEventRepository>()));
    gh.factory<_i1073.GetOrganizerEventByIdUsecase>(() =>
        _i1073.GetOrganizerEventByIdUsecase(
            gh<_i723.OrganizerEventRepository>()));
    gh.factory<_i1073.GetOrganizerEventStatisticsUsecase>(() =>
        _i1073.GetOrganizerEventStatisticsUsecase(
            gh<_i723.OrganizerEventRepository>()));
    gh.factory<_i1073.GetOrganizerEventAnalyticsUsecase>(() =>
        _i1073.GetOrganizerEventAnalyticsUsecase(
            gh<_i723.OrganizerEventRepository>()));
    gh.factory<_i1073.CreateOrganizerEventCategoryOptionUsecase>(() =>
        _i1073.CreateOrganizerEventCategoryOptionUsecase(
            gh<_i723.OrganizerEventRepository>()));
    gh.factory<_i1073.UpdateOrganizerEventCategoryOptionUsecase>(() =>
        _i1073.UpdateOrganizerEventCategoryOptionUsecase(
            gh<_i723.OrganizerEventRepository>()));
    gh.factory<_i1073.DeleteOrganizerEventCategoryOptionUsecase>(() =>
        _i1073.DeleteOrganizerEventCategoryOptionUsecase(
            gh<_i723.OrganizerEventRepository>()));
    gh.factory<_i395.GetCoinHistoryUsecase>(
        () => _i395.GetCoinHistoryUsecase(gh<_i78.CoinRepository>()));
    gh.factory<_i988.OrganizerParticipantRepository>(() =>
        _i338.OrganizerParticipantRepositoryImpl(
            gh<_i749.OrganizerParticipantDatasource>()));
    gh.factory<_i246.GetMyTicketsUsecase>(
        () => _i246.GetMyTicketsUsecase(gh<_i60.TicketRepository>()));
    gh.factory<_i246.GetTicketByIdUsecase>(
        () => _i246.GetTicketByIdUsecase(gh<_i60.TicketRepository>()));
    gh.factory<_i246.UpdateTicketStatusUsecase>(
        () => _i246.UpdateTicketStatusUsecase(gh<_i60.TicketRepository>()));
    gh.factory<_i313.AuthRepository>(
        () => _i950.AuthRepositoryImpl(gh<_i674.AuthDatasource>()));
    gh.factory<_i997.GetMyParticipantsUsecase>(() =>
        _i997.GetMyParticipantsUsecase(gh<_i693.ParticipantRepository>()));
    gh.factory<_i997.GetParticipantByIdUsecase>(() =>
        _i997.GetParticipantByIdUsecase(gh<_i693.ParticipantRepository>()));
    gh.factory<_i323.OrganizerVenueRepository>(() =>
        _i866.OrganizerVenueRepositoryImpl(gh<_i8.OrganizerVenueDatasource>()));
    gh.factory<_i59.GetEventsUsecase>(
        () => _i59.GetEventsUsecase(gh<_i438.EventRepository>()));
    gh.factory<_i606.GetEventByIdUsecase>(
        () => _i606.GetEventByIdUsecase(gh<_i438.EventRepository>()));
    gh.factory<_i264.GetFeaturedEventsUsecase>(
        () => _i264.GetFeaturedEventsUsecase(gh<_i438.EventRepository>()));
    gh.factory<_i214.GetCategoriesUsecase>(
        () => _i214.GetCategoriesUsecase(gh<_i413.CategoryRepository>()));
    gh.factory<_i407.UploadFileUsecase>(
        () => _i407.UploadFileUsecase(gh<_i318.FileRepository>()));
    gh.factory<_i531.AttendanceRepository>(
        () => _i432.AttendanceRepositoryImpl(gh<_i967.AttendanceDatasource>()));
    gh.factory<_i804.CreateOrganizerFeedbackQuestionUsecase>(() =>
        _i804.CreateOrganizerFeedbackQuestionUsecase(
            gh<_i610.OrganizerFeedbackRepository>()));
    gh.factory<_i804.GetOrganizerFeedbackQuestionByIdUsecase>(() =>
        _i804.GetOrganizerFeedbackQuestionByIdUsecase(
            gh<_i610.OrganizerFeedbackRepository>()));
    gh.factory<_i804.GetOrganizerFeedbackQuestionsUsecase>(() =>
        _i804.GetOrganizerFeedbackQuestionsUsecase(
            gh<_i610.OrganizerFeedbackRepository>()));
    gh.factory<_i804.DeleteFeedbackQuestionsUsecase>(() =>
        _i804.DeleteFeedbackQuestionsUsecase(
            gh<_i610.OrganizerFeedbackRepository>()));
    gh.factory<_i804.GetOrganizerFeedbacksUsecase>(() =>
        _i804.GetOrganizerFeedbacksUsecase(
            gh<_i610.OrganizerFeedbackRepository>()));
    gh.factory<_i804.GetOrganizerFeedbackByIdUsecase>(() =>
        _i804.GetOrganizerFeedbackByIdUsecase(
            gh<_i610.OrganizerFeedbackRepository>()));
    gh.factory<_i816.UpdateOrganizerProfileUsecase>(() =>
        _i816.UpdateOrganizerProfileUsecase(
            gh<_i721.OrganizerOrganizationRepository>()));
    gh.factory<_i816.GetOrganizerDashboardUsecase>(() =>
        _i816.GetOrganizerDashboardUsecase(
            gh<_i721.OrganizerOrganizationRepository>()));
    gh.factory<_i429.GetParticipantQrUsecase>(
        () => _i429.GetParticipantQrUsecase(gh<_i531.AttendanceRepository>()));
    gh.factory<_i429.GetEventQrUsecase>(
        () => _i429.GetEventQrUsecase(gh<_i531.AttendanceRepository>()));
    gh.factory<_i429.ScanQrUsecase>(
        () => _i429.ScanQrUsecase(gh<_i531.AttendanceRepository>()));
    gh.factory<_i429.SelfCheckInUsecase>(
        () => _i429.SelfCheckInUsecase(gh<_i531.AttendanceRepository>()));
    gh.factory<_i168.GetNewsListUsecase>(
        () => _i168.GetNewsListUsecase(gh<_i688.NewsRepository>()));
    gh.factory<_i168.GetNewsByIdUsecase>(
        () => _i168.GetNewsByIdUsecase(gh<_i688.NewsRepository>()));
    gh.factory<_i168.ClaimNewsUsecase>(
        () => _i168.ClaimNewsUsecase(gh<_i688.NewsRepository>()));
    gh.factory<_i527.GetOrganizerParticipantsUsecase>(() =>
        _i527.GetOrganizerParticipantsUsecase(
            gh<_i988.OrganizerParticipantRepository>()));
    gh.factory<_i527.GetOrganizerParticipantByIdUsecase>(() =>
        _i527.GetOrganizerParticipantByIdUsecase(
            gh<_i988.OrganizerParticipantRepository>()));
    gh.factory<_i527.CreateOrganizerParticipantUsecase>(() =>
        _i527.CreateOrganizerParticipantUsecase(
            gh<_i988.OrganizerParticipantRepository>()));
    gh.factory<_i527.DeleteOrganizerParticipantUsecase>(() =>
        _i527.DeleteOrganizerParticipantUsecase(
            gh<_i988.OrganizerParticipantRepository>()));
    gh.factory<_i65.CreateRegistrationUsecase>(() =>
        _i65.CreateRegistrationUsecase(gh<_i240.RegistrationRepository>()));
    gh.factory<_i65.GetMyRegistrationsUsecase>(() =>
        _i65.GetMyRegistrationsUsecase(gh<_i240.RegistrationRepository>()));
    gh.factory<_i65.GetRegistrationByIdUsecase>(() =>
        _i65.GetRegistrationByIdUsecase(gh<_i240.RegistrationRepository>()));
    gh.factory<_i65.CancelRegistrationUsecase>(() =>
        _i65.CancelRegistrationUsecase(gh<_i240.RegistrationRepository>()));
    gh.factory<_i600.UploadVerificationDocumentUsecase>(() =>
        _i600.UploadVerificationDocumentUsecase(gh<_i313.AuthRepository>()));
    gh.factory<_i286.GetOrganizerStaffApplicationsUsecase>(() =>
        _i286.GetOrganizerStaffApplicationsUsecase(
            gh<_i62.OrganizerStaffApplicationRepository>()));
    gh.factory<_i286.GetOrganizerStaffApplicationByIdUsecase>(() =>
        _i286.GetOrganizerStaffApplicationByIdUsecase(
            gh<_i62.OrganizerStaffApplicationRepository>()));
    gh.factory<_i286.ApproveStaffApplicationUsecase>(() =>
        _i286.ApproveStaffApplicationUsecase(
            gh<_i62.OrganizerStaffApplicationRepository>()));
    gh.factory<_i789.CreateSePayPaymentUsecase>(() =>
        _i789.CreateSePayPaymentUsecase(gh<_i674.SePayPaymentRepository>()));
    gh.factory<_i789.GetTransactionStatusUsecase>(() =>
        _i789.GetTransactionStatusUsecase(gh<_i674.SePayPaymentRepository>()));
    gh.factory<_i789.GetTransactionsUsecase>(
        () => _i789.GetTransactionsUsecase(gh<_i674.SePayPaymentRepository>()));
    gh.factory<_i1027.GetOrganizerVenuesUsecase>(() =>
        _i1027.GetOrganizerVenuesUsecase(gh<_i323.OrganizerVenueRepository>()));
    gh.factory<_i1027.CreateOrganizerVenueUsecase>(() =>
        _i1027.CreateOrganizerVenueUsecase(
            gh<_i323.OrganizerVenueRepository>()));
    gh.factory<_i865.GetCurrentUserUsecase>(
        () => _i865.GetCurrentUserUsecase(gh<_i313.AuthRepository>()));
    gh.factory<_i116.SendPasswordResetEmailUsecase>(
        () => _i116.SendPasswordResetEmailUsecase(gh<_i313.AuthRepository>()));
    gh.factory<_i749.SigninWithEmailAndPasswordUsecase>(() =>
        _i749.SigninWithEmailAndPasswordUsecase(gh<_i313.AuthRepository>()));
    gh.factory<_i1005.SignInWithGoogleOnlyUsecase>(
        () => _i1005.SignInWithGoogleOnlyUsecase(gh<_i313.AuthRepository>()));
    gh.factory<_i1005.SignInWithGoogleExistingUserUsecase>(() =>
        _i1005.SignInWithGoogleExistingUserUsecase(gh<_i313.AuthRepository>()));
    gh.factory<_i1005.SigninWithGoogleUsecase>(
        () => _i1005.SigninWithGoogleUsecase(gh<_i313.AuthRepository>()));
    gh.factory<_i824.SignoutUsecase>(
        () => _i824.SignoutUsecase(gh<_i313.AuthRepository>()));
    gh.factory<_i390.SignupWithEmailAndPasswordUsecase>(() =>
        _i390.SignupWithEmailAndPasswordUsecase(gh<_i313.AuthRepository>()));
    gh.factory<_i24.SignUpWithGoogleUsecase>(
        () => _i24.SignUpWithGoogleUsecase(gh<_i313.AuthRepository>()));
    return this;
  }
}

class _$FirebaseModule extends _i183.FirebaseModule {}
