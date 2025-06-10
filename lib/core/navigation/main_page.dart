import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linos/core/di/injection.dart';
import 'package:linos/core/services/notification_service.dart';
import 'package:linos/core/utils/app_error_handler.dart';
import 'package:linos/core/utils/app_error_logger.dart';
import 'package:linos/core/utils/context_extensions.dart';
import 'package:linos/features/home/data/repositories/search_history_repository.dart';
import 'package:linos/features/home/data/services/google_directions_api_service.dart';
import 'package:linos/features/home/data/services/google_places_api_service.dart';
import 'package:linos/features/home/presentation/cubit/home_map_cubit.dart';
import 'package:linos/features/home/presentation/cubit/popular_destinations_cubit.dart';
import 'package:linos/features/home/presentation/cubit/search_destination_cubit.dart';
import 'package:linos/features/home/presentation/cubit/transit_route_cubit.dart';
import 'package:linos/features/home/presentation/screens/home_page.dart';
import 'package:linos/features/lines/presentation/cubit/lines_map_cubit.dart';
import 'package:linos/features/lines/presentation/screens/lines_page.dart';
import 'package:linos/features/schedule/data/repositories/firebase_favorite_stops_repository.dart';
import 'package:linos/features/schedule/presentation/cubit/schedule_cubit.dart';
import 'package:linos/features/schedule/presentation/screens/schedule_page.dart';
import 'package:linos/features/settings/presentation/screens/settings_page.dart';
import 'package:linos/features/tickets/data/repositories/firebase_tickets_repository.dart';
import 'package:linos/features/tickets/presentation/cubit/tickets_cubit.dart';
import 'package:linos/features/tickets/presentation/screens/tickets_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with WidgetsBindingObserver, AutomaticKeepAliveClientMixin {
  static int _selectedIndex = 0;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _preloadLinesData();
  }

  void _preloadLinesData() {
    Future.microtask(() async {
      try {
        final linesMapCubit = getIt<LinesMapCubit>();
        await linesMapCubit.preloadLines();
      } catch (e, stackTrace) {
        final errorKey = AppErrorHandler.getErrorKey(e);
        AppErrorLogger.handleError(errorKey, stackTrace);
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.resumed) {
      // Refresh the current page when app resumes
      setState(() {});
      _refreshNotifications();
    }
  }

  Future<void> _refreshNotifications() async {
    final notificationService = getIt<NotificationService>();
    await notificationService.cleanupExpiredNotifications();

    final favoriteStopsRepo = getIt<FirebaseFavoriteStopsRepository>();
    final tramStops = await favoriteStopsRepo.getFavoriteTramStops();
    final busStops = await favoriteStopsRepo.getFavoriteBusStops();

    for (final stop in [...tramStops, ...busStops]) {
      await notificationService.scheduleNotificationsForFavoriteStop(stop);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => HomeMapCubit()..fetchUserLocation()),
        BlocProvider(create: (context) => SearchDestinationCubit(getIt<GooglePlacesApiService>())),
        BlocProvider(
          create: (context) => PopularDestinationsCubit(getIt<SearchHistoryRepository>())..loadPopularDestinations(),
        ),
        BlocProvider(create: (context) => TicketsCubit(getIt<FirebaseTicketsRepository>())),
        BlocProvider(create: (context) => getIt<LinesMapCubit>()),
        BlocProvider(create: (context) => ScheduleCubit(getIt<FirebaseFavoriteStopsRepository>())..loadStops()),
      ],
      child: Builder(
        builder: (context) => MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => TransitRouteCubit(
                getIt<GoogleDirectionsApiService>(),
                context.read<SearchDestinationCubit>(),
                context.read<HomeMapCubit>(),
              ),
            ),
          ],
          child: Scaffold(
            body: switch (_selectedIndex) {
              0 => HomePage(),
              1 => TicketsPage(),
              2 => LinesPage(),
              3 => SchedulePage(),
              4 => SettingsPage(),
              _ => Center(child: Text(context.l10n.mainPage_unknownPage)),
            },
            bottomNavigationBar: BottomNavigationBar(
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: context.l10n.mainPage_homeLabel,
                  backgroundColor: context.theme.colorScheme.primaryContainer,
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.confirmation_number_outlined),
                  label: context.l10n.mainPage_ticketsLabel,
                  backgroundColor: context.theme.colorScheme.primaryContainer,
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.directions),
                  label: context.l10n.mainPage_linesLabel,
                  backgroundColor: context.theme.colorScheme.primaryContainer,
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.schedule),
                  label: context.l10n.mainPage_scheduleLabel,
                  backgroundColor: context.theme.colorScheme.primaryContainer,
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.settings),
                  label: context.l10n.mainPage_settingsLabel,
                  backgroundColor: context.theme.colorScheme.primaryContainer,
                ),
              ],
              currentIndex: _selectedIndex,
              onTap: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}
