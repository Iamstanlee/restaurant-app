import 'dart:async';
import 'package:fgrestaurant/api/googleplace.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:latlong/latlong.dart';

class SearchBloc with ChangeNotifier {
  var _googlePlace = StreamController.broadcast();
  var _loading = StreamController<bool>.broadcast();
  GooglePlace googlePlace = new GooglePlace();
  StreamController get gPlace => _googlePlace;
  Stream get places => _googlePlace.stream.asBroadcastStream();
  Stream<bool> get loading => _loading.stream.asBroadcastStream();
  set places(Stream places) {
    this.places = places;
  }

  /// perform search query
  void searchPlace(String keyword) {
    if (keyword.length != 0) {
      _loading.sink.add(true);
      _googlePlace.sink.add(null);
      googlePlace.searchPlaces(keyword, onData: (places) {
        _googlePlace.sink.add(places);
        _loading.sink.add(false);
      }, onError: (err) {
        _googlePlace.sink.addError('${err.toString()}');
        _loading.sink.add(false);
      });
    }
  }

  void getPlaceById(
      String placeId, Function(LatLng) onDone, Function(dynamic) onError) {
    googlePlace.getPlaceById(placeId).then((place) {
      print(place);
      if (place['error_message'] != null) {
        onError(place['error_message']);
      } else {
        var latLng = place['result']['geometry']['location'];
        LatLng coordinates = LatLng(latLng['lat'], latLng['lng']);
        onDone(coordinates);
      }
    }).catchError((err) {
      onError(err);
    });
  }

  void getPlaceByLatLng(
      LatLng latLng, Function(dynamic) onDone, Function(dynamic) onError) {
    googlePlace
        .getPlaceWithLatLng(latLng.latitude, latLng.longitude)
        .then((place) {
      print(place);
      if (place['error_message'] != null) {
        onError(place['error_message']);
      } else {
        // var location = place['result']['geometry']['location'];
        onDone(place);
      }
    }).catchError((err) {
      onError(err);
    });
  }

  void disposeStream() {
    _googlePlace.close();
    _loading.close();
  }
}
