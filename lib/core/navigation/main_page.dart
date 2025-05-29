import 'package:flutter/material.dart';
import 'package:linos/core/utils/context_extensions.dart';
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
    return Scaffold(
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
    );
  }
}
