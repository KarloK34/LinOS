// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:firebase_auth/firebase_auth.dart' as _i59;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:linos/core/navigation/app_router_config.dart' as _i494;
import 'package:linos/core/services/localization_service.dart' as _i443;
import 'package:linos/core/services/notification_service.dart' as _i992;
import 'package:linos/core/services/notifications_refresh_service.dart'
    as _i736;
import 'package:linos/features/auth/cubit/auth_cubit.dart' as _i53;
import 'package:linos/features/auth/data/repositories/auth_repository.dart'
    as _i376;
import 'package:linos/features/home/data/repositories/search_history_repository.dart'
    as _i724;
import 'package:linos/features/home/data/services/google_directions_api_service.dart'
    as _i189;
import 'package:linos/features/home/data/services/google_places_api_service.dart'
    as _i423;
import 'package:linos/features/lines/data/services/transit_lines_api_service.dart'
    as _i737;
import 'package:linos/features/lines/data/services/transit_lines_cache_service.dart'
    as _i278;
import 'package:linos/features/lines/data/services/vehicle_simulation_service.dart'
    as _i401;
import 'package:linos/features/lines/presentation/cubit/lines_map_cubit.dart'
    as _i448;
import 'package:linos/features/schedule/data/repositories/firebase_favorite_stops_repository.dart'
    as _i721;
import 'package:linos/features/tickets/data/repositories/firebase_tickets_repository.dart'
    as _i854;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    gh.singleton<_i494.AppRouterConfig>(() => _i494.AppRouterConfig());
    gh.singleton<_i724.SearchHistoryRepository>(
      () => _i724.SearchHistoryRepository(),
    );
    gh.singleton<_i189.GoogleDirectionsApiService>(
      () => _i189.GoogleDirectionsApiService(),
    );
    gh.singleton<_i423.GooglePlacesApiService>(
      () => _i423.GooglePlacesApiService(),
    );
    gh.singleton<_i737.TransitLinesApiService>(
      () => _i737.TransitLinesApiService(),
    );
    gh.singleton<_i278.TransitLinesCacheService>(
      () => _i278.TransitLinesCacheService(),
    );
    gh.singleton<_i401.VehicleSimulationService>(
      () => _i401.VehicleSimulationService(),
    );
    gh.lazySingleton<_i443.LocalizationService>(
      () => _i443.LocalizationService(),
    );
    gh.lazySingleton<_i736.NotificationRefreshService>(
      () => _i736.NotificationRefreshService(),
    );
    gh.lazySingleton<_i992.NotificationService>(
      () => _i992.NotificationService(),
    );
    gh.lazySingleton<_i721.FirebaseFavoriteStopsRepository>(
      () => _i721.FirebaseFavoriteStopsRepository(),
    );
    gh.lazySingleton<_i854.FirebaseTicketsRepository>(
      () => _i854.FirebaseTicketsRepository(),
    );
    gh.factoryParam<_i376.AuthRepository, _i59.FirebaseAuth?, dynamic>(
      (firebaseAuth, _) => _i376.AuthRepository(firebaseAuth),
    );
    gh.factory<_i53.AuthCubit>(
      () => _i53.AuthCubit(gh<_i376.AuthRepository>()),
    );
    gh.lazySingleton<_i448.LinesMapCubit>(
      () => _i448.LinesMapCubit(
        gh<_i737.TransitLinesApiService>(),
        gh<_i401.VehicleSimulationService>(),
      ),
    );
    return this;
  }
}
