import 'package:flutter/material.dart';
import 'package:linos/core/utils/context_extensions.dart';

class SchedulePage extends StatelessWidget {
  const SchedulePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: context.theme.colorScheme.primaryContainer,
                      border: Border.all(color: context.theme.colorScheme.primaryContainer, width: 1.0),
                    ),
                    child: Column(
                      children: [
                        Icon(Icons.train, size: 32, color: context.theme.colorScheme.onPrimaryContainer),
                        Text(
                          context.l10n.schedulePage_tramScheduleTitle,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: context.theme.colorScheme.onPrimaryContainer,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 8.0),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(color: context.theme.colorScheme.primaryContainer, width: 1.0),
                    ),
                    child: Column(
                      children: [
                        Icon(Icons.directions_bus, size: 32, color: context.theme.colorScheme.onPrimaryContainer),
                        Text(
                          context.l10n.schedulePage_busScheduleTitle,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: context.theme.colorScheme.onPrimaryContainer,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Text(
              context.l10n.schedulePage_favoriteStopsTitle,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              children: <Widget>[
                Chip(
                  label: Text('Stop X'),
                  backgroundColor: Colors.grey[200],
                  onDeleted: () {
                    // Handle favorite stop removal
                  },
                ),
                Chip(
                  label: Text('Stop Y'),
                  backgroundColor: Colors.grey[200],
                  onDeleted: () {
                    // Handle favorite stop removal
                  },
                ),
                Chip(
                  label: Text('Stop Z'),
                  backgroundColor: Colors.grey[200],
                  onDeleted: () {
                    // Handle favorite stop removal
                  },
                ),
                ActionChip(
                  label: Text(context.l10n.schedulePage_addFavoriteButton),
                  avatar: Icon(Icons.add_circle_outline, color: context.theme.colorScheme.primary),
                  onPressed: () {
                    // Handle adding a new favorite stop
                  },
                ),
              ],
            ),
            SizedBox(height: 16.0),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: context.l10n.schedulePage_selectStopLabel,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                filled: true,
                fillColor: context.theme.colorScheme.surface,
              ),
              items: <String>['Stop A', 'Stop B', 'Stop C', 'Stop D'].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(value: value, child: Text(value));
              }).toList(),
              onChanged: (String? newValue) {
                // Handle stop selection
              },
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: SingleChildScrollView(
                child: DataTable(
                  columnSpacing: 24.0,
                  horizontalMargin: 12.0,
                  columns: <DataColumn>[
                    DataColumn(
                      label: Expanded(
                        child: Text(
                          context.l10n.schedulePage_tramLineColumn,
                          style: const TextStyle(fontStyle: FontStyle.italic),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Expanded(
                        child: Text(
                          context.l10n.schedulePage_destinationColumn,
                          style: const TextStyle(fontStyle: FontStyle.italic),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Expanded(
                        child: Text(
                          context.l10n.schedulePage_departureTimeColumn,
                          style: TextStyle(fontStyle: FontStyle.italic),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                  rows: const <DataRow>[
                    DataRow(
                      cells: <DataCell>[
                        DataCell(Text('Line 1')),
                        DataCell(Text('City Center')),
                        DataCell(Text('10:00 AM')),
                      ],
                    ),
                    DataRow(
                      cells: <DataCell>[
                        DataCell(Text('Line 2')),
                        DataCell(Text('North Suburb')),
                        DataCell(Text('10:15 AM')),
                      ],
                    ),
                    DataRow(
                      cells: <DataCell>[
                        DataCell(Text('Line 1')),
                        DataCell(Text('City Center')),
                        DataCell(Text('10:30 AM')),
                      ],
                    ),
                    DataRow(
                      cells: <DataCell>[
                        DataCell(Text('Line 3')),
                        DataCell(Text('West End')),
                        DataCell(Text('10:45 AM')),
                      ],
                    ),
                    DataRow(
                      cells: <DataCell>[
                        DataCell(Text('Line 2')),
                        DataCell(Text('North Suburb')),
                        DataCell(Text('11:00 AM')),
                      ],
                    ),
                    DataRow(
                      cells: <DataCell>[
                        DataCell(Text('Line 4')),
                        DataCell(Text('East Side')),
                        DataCell(Text('11:15 AM')),
                      ],
                    ),
                    DataRow(
                      cells: <DataCell>[
                        DataCell(Text('Line 3')),
                        DataCell(Text('West End')),
                        DataCell(Text('11:30 AM')),
                      ],
                    ),
                    DataRow(
                      cells: <DataCell>[
                        DataCell(Text('Line 1')),
                        DataCell(Text('City Center')),
                        DataCell(Text('11:45 AM')),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
