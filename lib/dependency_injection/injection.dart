import 'package:events_app/api_template/services/rest_clients.dart';
import 'package:events_app/dependency_injection/injection.config.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

final GetIt getIt = GetIt.instance;
final GetIt networkGetIt = getIt;

@InjectableInit()
void configureDependencies({String env = 'dev'}) {
  getIt.registerLazySingleton<RestClient>(() => NRDRestClient());
  getIt.init(environment: env);
}
