import 'dart:convert';

import 'package:fgrestaurant/api/api.dart';
import 'package:fgrestaurant/data/place.dart';
import 'package:http/http.dart';

class GooglePlace extends Api {
  void searchPlaces(String keyword,
      {Function(List<Place>) onData, Function onError}) async {
    var places = <Place>[];
    get("https://maps.googleapis.com/maps/api/place/autocomplete/json?input=${Uri.encodeQueryComponent(keyword)}&language=$language&key=$apiKey")
        .then((res) {
      var decodedBody = json.decode(res.body);
      print(decodedBody);
      if (decodedBody['status'] == 'REQUEST_DENIED') {
        onError(decodedBody['error_message']);
      }
      decodedBody['predictions'].forEach((data) {
        places.add(Place.fromMap(data));
      });
      onData(places);
    }).catchError((err) {
      onError(err);
    });
  }

  Future<dynamic> getPlaceById(String id) async {
    try {
      var place = await get(
          'https://maps.googleapis.com/maps/api/place/details/json?placeid=$id&key=$apiKey');
      var decodedBody = json.decode(place.body);
      return decodedBody;
    } catch (e) {
      return e;
    }
  }

  Future<Response> getDirectionBetweenPlaces(
      List<double> origin, List<double> destination) {
    var direction = get(
        'https://maps.googleapis.com/maps/api/directions/json?origin=${origin[0]},${origin[1]}&destination=${destination[0]},${destination[1]}&units=metric&key=$apiKey');
    return direction;
  }

  Future<Response> getDirectionBetweenPlacesWithId(
      String origin, String destination) {
    var direction = get(
        'https://maps.googleapis.com/maps/api/directions/json?origin=place_id:$origin&destination=place_id:$destination&units=metric&key=$apiKey');
    return direction;
  }

  Future<dynamic> getPlaceWithLatLng(double lat, double lng) async {
    try {
      var place = await get(
          'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$apiKey');
      var decodedBody = json.decode(place.body);
      return decodedBody;
    } catch (e) {
      return e;
    }
  }
}
