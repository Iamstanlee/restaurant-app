import 'package:fgrestaurant/api/googleplace.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;

class MapBloc with ChangeNotifier {
  GooglePlace googlePlace = GooglePlace();
  LatLng _userLocation = LatLng(0, 0);
  String _userPlaceId;
  String get userPlaceId => _userPlaceId;
  GoogleMapController _googleMapController;
  List<LatLng> _polylineRoutePoints = List();
  List<LatLng> get polylineRoutePoints => _polylineRoutePoints;
  GoogleMapController get googleMapController => _googleMapController;
  LatLng _initialPosition = LatLng(0, 0);

  LatLng get userLocation => _userLocation;
  set userPlaceId(String id) {
    _userPlaceId = id;
    notifyListeners();
  }

  LatLng get initialPosition => _initialPosition;

  set setMapController(GoogleMapController controller) {
    _googleMapController = controller;
    notifyListeners();
  }

  set setInitialPosition(LatLng position) {
    _initialPosition = position;
    notifyListeners();
  }

  set polylineRoutePoints(List<LatLng> points) {
    _polylineRoutePoints = points;
    notifyListeners();
  }

  set setUserLocation(LatLng position) {
    _userLocation = position;
    notifyListeners();
  }

//  called when the map is created
  void onMapCreated(GoogleMapController controller, {double zoom = 14}) {
    setMapController = controller;
    // get userlocation if not available
    if (userLocation == LatLng(0, 0)) this.getUserLocation(controller);
    // move  map camera to user location
    moveCameraToInitialPosition(googleMapController, zoom: zoom);
  }

  ///  check the details of a place with it PlaceId, [onDone] is called after
  void getPlaceById(String placeId, Function onDone) async {
    var place = await googlePlace.getPlaceById(placeId);
    // var placeLatLng = place.data['result']['geometry']['location'];
    // LatLng latLng = LatLng(placeLatLng['lat'], placeLatLng['lng']);
    // setInitialPosition = latLng;
    // onDone();
  }

  /// get the polyline points with the routes array of [LatLng]
  void getPolylinePoints({List<LatLng> points}) {
    polylineRoutePoints = points;
  }

  ///move the map position to the user current location
  void moveCameraToInitialPosition(GoogleMapController controller,
      {double zoom = 14}) {
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(initialPosition?.latitude, initialPosition?.longitude),
          zoom: zoom,
        ),
      ),
    );
  }

  ///move the map position to the user current location
  void moveCameraToUserPosition(GoogleMapController controller,
      {double zoom = 14}) {
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(userLocation?.latitude, userLocation?.longitude),
          zoom: zoom,
        ),
      ),
    );
  }

// handles permission and get users current position
  void getUserLocation(GoogleMapController controller) async {
    var location = loc.Location();
    GeolocationStatus geolocationStatus =
        await Geolocator().checkGeolocationPermissionStatus();
    if (geolocationStatus == GeolocationStatus.granted) {
      Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
          .then((position) {
        setUserLocation = LatLng(position.latitude, position.longitude);
        setInitialPosition = LatLng(position.latitude, position.longitude);
        moveCameraToInitialPosition(controller);
      }).catchError((err) {
        print('could not get location permission');
      });
    } else {
      location.requestService().then((res) {
        if (res) {
          Geolocator()
              .getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
              .then((position) {
            setUserLocation = LatLng(position.latitude, position.longitude);
            setInitialPosition = LatLng(position.latitude, position.longitude);
            moveCameraToInitialPosition(controller);
          }).catchError((err) {
            print('could not get location permission');
          });
        }
      });
    }
  }
}
