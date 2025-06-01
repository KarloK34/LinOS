import 'package:url_launcher/url_launcher.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class NavigationService {
  static Future<bool> navigateToDestinationWithTransit({
    required LatLng origin,
    required LatLng destination,
    required String destinationName,
  }) async {
    final String googleMapsUrl =
        'https://www.google.com/maps/dir/${origin.latitude},${origin.longitude}/${destination.latitude},${destination.longitude}/@${destination.latitude},${destination.longitude},15z/data=!3m1!4b1!4m2!4m1!3e3';

    final String googleMapsApp =
        'comgooglemaps://?saddr=${origin.latitude},${origin.longitude}&daddr=${destination.latitude},${destination.longitude}&directionsmode=transit';

    try {
      if (await canLaunchUrl(Uri.parse(googleMapsApp))) {
        return await launchUrl(Uri.parse(googleMapsApp));
      }
      if (await canLaunchUrl(Uri.parse(googleMapsUrl))) {
        return await launchUrl(Uri.parse(googleMapsUrl), mode: LaunchMode.externalApplication);
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}
