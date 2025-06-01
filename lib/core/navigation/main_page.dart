import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linos/core/di/injection.dart';
import 'package:linos/core/utils/context_extensions.dart';
import 'package:linos/features/home/data/repositories/search_history_repository.dart';
import 'package:linos/features/home/data/services/google_directions_api_service.dart';
import 'package:linos/features/home/data/services/google_places_api_service.dart';
import 'package:linos/features/home/presentation/cubit/home_map_cubit.dart';
import 'package:linos/features/home/presentation/cubit/popular_destinations_cubit.dart';
import 'package:linos/features/home/presentation/cubit/search_destination_cubit.dart';
import 'package:linos/features/home/presentation/cubit/transit_route_cubit.dart';
import 'package:linos/features/home/presentation/screens/home_page.dart';
import 'package:linos/features/lines/presentation/screens/lines_page.dart';
import 'package:linos/features/schedule/presentation/screens/schedule_page.dart';
import 'package:linos/features/settings/presentation/screens/settings_page.dart';
import 'package:linos/features/tickets/presentation/screens/tickets_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => HomeMapCubit()..fetchUserLocation()),
        BlocProvider(create: (context) => SearchDestinationCubit(getIt<GooglePlacesApiService>())),
        BlocProvider(
          create: (context) => PopularDestinationsCubit(getIt<SearchHistoryRepository>())..loadPopularDestinations(),
        ),
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
                  backgroundColor: context.theme.colorScheme.primary,
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.confirmation_number_outlined),
                  label: context.l10n.mainPage_ticketsLabel,
                  backgroundColor: context.theme.colorScheme.primary,
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.directions),
                  label: context.l10n.mainPage_linesLabel,
                  backgroundColor: context.theme.colorScheme.primary,
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.schedule),
                  label: context.l10n.mainPage_scheduleLabel,
                  backgroundColor: context.theme.colorScheme.primary,
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.settings),
                  label: context.l10n.mainPage_settingsLabel,
                  backgroundColor: context.theme.colorScheme.primary,
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
