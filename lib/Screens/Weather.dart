import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> getWeather() async {
  Map<String, dynamic> data = {};
  final apiKey = '76918b053ea345b79fb4d6b085825286';
  data = await getLongAndLat();
  final latitude = data['lat'];
  final longitude = data['long'];
  final url =
      'https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&appid=$apiKey';

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to load weather data');
  }
}

Future<Map<String, dynamic>> getLongAndLat() async {
  LocationPermission permission = await Geolocator.checkPermission();
  print(permission);
  Map<String, dynamic> data = {};

  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      print('Location permissions  denied');
      return {'error': 'Location permissions are denied'};
    } else if (permission == LocationPermission.deniedForever) {
      print('Location permissions are permanently denied');
      return {'error': 'Location permissions are permanently denied'};
    } else {
      print('GPS Location service is granted');
    }
  } else {
    print('GPS Location permission granted.');
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    double long = position.longitude;
    double lat = position.latitude;
    data['long'] = long;
    data['lat'] = lat;
    // Return the longitude and latitude as a Map
    return data;
  }

  // Return an error Map in case something goes wrong
  return {'error': 'Unable to fetch location'};
}
