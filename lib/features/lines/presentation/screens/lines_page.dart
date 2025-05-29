import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:linos/core/utils/context_extensions.dart';

class LinesPage extends StatelessWidget {
  const LinesPage({super.key});

  @override
  Widget build(BuildContext context) {
    const CameraPosition osijekCoordinates = CameraPosition(target: LatLng(45.55111, 18.69389), zoom: 11);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
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
                      border: Border.all(color: context.theme.colorScheme.primaryContainer, width: 1.0),
                    ),
                    child: Column(
                      children: [
                        Icon(Icons.train, size: 32, color: context.theme.colorScheme.onPrimaryContainer),
                        Text(
                          context.l10n.linesPage_tramLinesTitle,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: context.theme.colorScheme.onPrimaryContainer,
                          ),
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
                      color: context.theme.colorScheme.primaryContainer,
                    ),
                    child: Column(
                      children: [
                        Icon(Icons.directions_bus, size: 32, color: context.theme.colorScheme.onPrimaryContainer),
                        Text(
                          context.l10n.linesPage_busLinesTitle,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: context.theme.colorScheme.onPrimaryContainer,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: GoogleMap(initialCameraPosition: osijekCoordinates, mapType: MapType.normal),
            ),
            SizedBox(height: 16.0),
            Column(
              spacing: 12.0,
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: FloatingActionButton(onPressed: () {}, child: Text(context.l10n.linesPage_realTimeButton)),
                ),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: FloatingActionButton(onPressed: () {}, child: Text(context.l10n.linesPage_viewScheduleButton)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
