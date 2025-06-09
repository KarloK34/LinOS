import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:linos/core/data/enums/vehicle_type.dart';
import 'package:linos/features/schedule/data/models/transit_stop.dart';

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

  static List<TransitStop> getTramStops() {
    return [
      TransitStop(
        id: '1',
        name: 'Zeleno polje',
        latitude: 45.55246068712782,
        longitude: 18.729819674727093,
        vehicleType: VehicleType.tram,
      ),
      TransitStop(
        id: '2',
        name: 'Donja Tramvajska stanica',
        latitude: 45.553892821324794,
        longitude: 18.72498427806678,
        vehicleType: VehicleType.tram,
      ),
      TransitStop(
        id: '3',
        name: 'bana Josipa Jelačića',
        latitude: 45.55492143882817,
        longitude: 18.720294827667875,
        vehicleType: VehicleType.tram,
      ),
      TransitStop(
        id: '4',
        name: 'cara Hadrijana',
        latitude: 45.55595856522575,
        longitude: 18.71662494313781,
        vehicleType: VehicleType.tram,
      ),
      TransitStop(
        id: '5',
        name: 'KBC',
        latitude: 45.55718881584692,
        longitude: 18.711174085262257,
        vehicleType: VehicleType.tram,
      ),
      TransitStop(
        id: '6',
        name: 'Remiza',
        latitude: 45.55904098049919,
        longitude: 18.7030606095715,
        vehicleType: VehicleType.tram,
      ),
      TransitStop(
        id: '7',
        name: 'VIM',
        latitude: 45.558561685960484,
        longitude: 18.69884854392559,
        vehicleType: VehicleType.tram,
      ),
      TransitStop(
        id: '8',
        name: 'Europska avenija Tvrđa',
        latitude: 45.55883901033378,
        longitude: 18.693897587603054,
        vehicleType: VehicleType.tram,
      ),
      TransitStop(
        id: '9',
        name: 'Dom zdravlja',
        latitude: 45.55962245049111,
        longitude: 18.690176197400707,
        vehicleType: VehicleType.tram,
      ),
      TransitStop(
        id: '10',
        name: 'Pošta',
        latitude: 45.560411126920656,
        longitude: 18.685826833247457,
        vehicleType: VehicleType.tram,
      ),
      TransitStop(
        id: '11',
        name: 'Sakuntala Park',
        latitude: 45.56096092548518,
        longitude: 18.682080945154535,
        vehicleType: VehicleType.tram,
      ),
      TransitStop(
        id: '12',
        name: 'Trg Ante Starčevića',
        latitude: 45.561510196358114,
        longitude: 18.677260528203842,
        vehicleType: VehicleType.tram,
      ),
    ];
  }

  static List<TransitStop> getBusStops() {
    return [
      TransitStop(
        id: '1',
        name: 'Bus Stop 1',
        latitude: 45.55246068712782,
        longitude: 18.729819674727093,
        vehicleType: VehicleType.bus,
      ),
      TransitStop(
        id: '2',
        name: 'Bus Stop 2',
        latitude: 45.553892821324794,
        longitude: 18.72498427806678,
        vehicleType: VehicleType.bus,
      ),
      TransitStop(
        id: '3',
        name: 'Bus Stop 3',
        latitude: 45.55492143882817,
        longitude: 18.720294827667875,
        vehicleType: VehicleType.bus,
      ),
      TransitStop(
        id: '4',
        name: 'Bus Stop 4',
        latitude: 45.55595856522575,
        longitude: 18.71662494313781,
        vehicleType: VehicleType.bus,
      ),
      TransitStop(
        id: '5',
        name: 'Bus Stop 5',
        latitude: 45.55718881584692,
        longitude: 18.711174085262257,
        vehicleType: VehicleType.bus,
      ),
      TransitStop(
        id: '6',
        name: 'Bus Stop 6',
        latitude: 45.55904098049919,
        longitude: 18.7030606095715,
        vehicleType: VehicleType.bus,
      ),
    ];
  }

  static List<String> getTramLineNumbers() => getTramRoutes().keys.toList();
  static List<String> getBusLineNumbers() => getBusRoutes().keys.toList();
}
