import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:linos/core/utils/context_extensions.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    const CameraPosition osijekCoordinates = CameraPosition(target: LatLng(45.55111, 18.69389), zoom: 11);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 280,
              child: GoogleMap(initialCameraPosition: osijekCoordinates, mapType: MapType.normal),
            ),
            SizedBox(height: 16.0),
            SearchBar(
              hintText: context.l10n.homePage_searchHint,
              trailing: [Icon(Icons.search, color: Colors.grey)],
            ),
            SizedBox(height: 16.0),
            Text(context.l10n.homePage_popularDestinationsTitle, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text(context.l10n.homePage_popularDestinationsSubtitle),
            Expanded(
              child: ListView(
                shrinkWrap: true,
                children: [
                  ListTile(
                    leading: Icon(Icons.place),
                    title: Text(context.l10n.homePage_osijekCitadelTitle),
                    subtitle: Text(context.l10n.homePage_osijekCitadelSubtitle),
                    onTap: () {
                      // Handle tap
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.place),
                    title: Text(context.l10n.homePage_kingTomislavSquareTitle),
                    subtitle: Text(context.l10n.homePage_kingTomislavSquareSubtitle),
                    onTap: () {
                      // Handle tap
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.place),
                    title: Text(context.l10n.homePage_shoppingCenterTitle),
                    subtitle: Text(context.l10n.homePage_shoppingCenterSubtitle),
                    onTap: () {
                      // Handle tap
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.0),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: FloatingActionButton(onPressed: () {}, child: Text(context.l10n.homePage_startNavigationButton)),
            ),
            SizedBox(height: 16.0),
          ],
        ),
      ),
    );
  }
}
