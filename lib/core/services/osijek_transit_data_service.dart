import 'package:google_maps_flutter/google_maps_flutter.dart';

class OsijekTransitDataService {
  static Map<String, List<LatLng>> getTramRoutes() {
    return {
      '1': [
        LatLng(45.55246068712782, 18.729819674727093), // ZELENO POLJE area
        LatLng(45.553892821324794, 18.72498427806678), // Tramvajska stanica Donja
        LatLng(45.55492143882817, 18.720294827667875), // bana Josipa Jelačića
        LatLng(45.55595856522575, 18.71662494313781), // cara Hadrijana
        LatLng(45.55718881584692, 18.711174085262257), // KBC
        LatLng(45.55904098049919, 18.7030606095715), // Remiza
        LatLng(45.558561685960484, 18.69884854392559), // VIM
        LatLng(45.55883901033378, 18.693897587603054), // Europska avenija Tvrđa
        LatLng(45.55962245049111, 18.690176197400707), // Dom zdravlja
        LatLng(45.560411126920656, 18.685826833247457), // Pošta
        LatLng(45.56096092548518, 18.682080945154535), // Sakuntala Park
        LatLng(45.561510196358114, 18.677260528203842), // Trg Ante Starčevića
      ],
    };
  }

  static Map<String, List<LatLng>> getBusRoutes() {
    return {};
  }

  static List<String> getTramLineNumbers() => getTramRoutes().keys.toList();
  static List<String> getBusLineNumbers() => getBusRoutes().keys.toList();
}
