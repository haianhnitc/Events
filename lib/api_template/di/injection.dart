import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'injection.config.dart';

GetIt networkGetIt = GetIt.instance;

@InjectableInit(initializerName: r'$initNetworkGetIt')
void injectNetwork(String env) {
  networkGetIt.$initNetworkGetIt(environment: env);
}
