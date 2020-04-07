import 'package:after_layout/after_layout.dart';
import 'package:ant_icons/ant_icons.dart';
import 'package:fgrestaurant/bloc/mapbloc.dart';
import 'package:fgrestaurant/bloc/searchbloc.dart';
import 'package:fgrestaurant/constants/fonts.dart';
import 'package:fgrestaurant/constants/styles.dart';
import 'package:fgrestaurant/data/place.dart';
import 'package:fgrestaurant/helpers/base_textfield.dart';
import 'package:fgrestaurant/helpers/functions.dart';
import 'package:fgrestaurant/widgets/toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class Location extends StatefulWidget {
  static String tag = '/location';
  @override
  _LocationState createState() => _LocationState();
}

class _LocationState extends State<Location> with AfterLayoutMixin<Location> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  Marker marker;
  LatLng markerLocation = LatLng(0, 0);

  @override
  void afterFirstLayout(BuildContext context) {
    MapBloc mapBloc = Provider.of<MapBloc>(context);
    setState(() {
      markerLocation = LatLng(
          mapBloc.initialPosition.latitude, mapBloc.initialPosition.longitude);
    });
    Toast.show('Drag marker to restaurant location', context);
  }

  void handleMapMove(CameraPosition cameraPosition) {
    setState(() {
      markerLocation = LatLng(
          cameraPosition.target.latitude, cameraPosition.target.longitude);
    });
  }

  void saveLocation() {
    SearchBloc searchBloc = Provider.of<SearchBloc>(context, listen: false);
    Toast.show('Saving location...', context, isTimed: false);
    searchBloc.getPlaceByLatLng(markerLocation, (place) {
      Toast.dismiss();
      pop(context, result: {
        'coordinates': markerLocation,
        'location': place ?? 'Restaurant location'
      });
    }, (err) {
      Toast.show('Error : $err', context);
      pop(context, result: {
        'coordinates': markerLocation,
        'location': 'Restaurant location'
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    MapBloc mapBloc = Provider.of<MapBloc>(context);
    SearchBloc searchBloc = Provider.of<SearchBloc>(context);
    marker = Marker(
      draggable: true,
      consumeTapEvents: true,
      onDragEnd: (LatLng latLng) {
        setState(() {
          markerLocation = LatLng(latLng.latitude, latLng.longitude);
        });
      },
      position: markerLocation,
      markerId: MarkerId('newLocation'),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
    );

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Column(
            children: <Widget>[
              Flexible(
                  child: GoogleMap(
                onMapCreated: (GoogleMapController googleMapController) {
                  mapBloc.onMapCreated(googleMapController, zoom: 18);
                },
                compassEnabled: false,
                mapToolbarEnabled: false,
                myLocationButtonEnabled: false,
                onCameraMove: (CameraPosition cameraPosition) {
                  handleMapMove(cameraPosition);
                },
                mapType: MapType.normal,
                markers: <Marker>[marker].toSet(),
                initialCameraPosition: CameraPosition(
                  target: mapBloc.userLocation == null
                      ? LatLng(0, 0)
                      : mapBloc.initialPosition,
                ),
              )),
            ],
          ),
          Positioned(
            top: getHeight(context, height: 6),
            right: 12,
            left: 12,
            child: appBar(
              context,
              title: Text(
                'Search',
                style: TextStyle(fontSize: 14),
              ),
              doSearch: (query) {
                searchBloc.searchPlace(query);
              },
              function: (Place place) {
                searchBloc.gPlace.sink.add(null);
                Toast.show('Loading...', context, isTimed: false);
                searchBloc.getPlaceById(place.placeId, (coordinates) {
                  Toast.dismiss();
                  setState(() {
                    markerLocation =
                        LatLng(coordinates.latitude, coordinates.longitude);
                  });
                }, (err) {
                  Toast.show('Error : $err', context);
                });
              },
              stream: searchBloc.places,
              loadinStream: searchBloc.loading,
              icon: Icon(
                Icons.menu,
                color: Colors.black,
              ),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        shape: Border.all(style: BorderStyle.none),
        heroTag: 'location',
        onPressed: () {
          saveLocation();
        },
        label: Text('DONE', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 16.0,
      ),
    );
  }
}

Widget appBar(BuildContext context,
    {Function onPressed,
    Widget icon,
    Widget title,
    List<Widget> actions,
    Stream stream,
    Stream loadinStream,
    Function(Place place) function,
    Function(String query) doSearch}) {
  return Card(
    elevation: 2,
    child: Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(0)),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              IconButton(
                icon: ImageIcon(AssetImage(getPng('search')),
                    color: Colors.black),
                onPressed: () {},
              ),
              Container(
                width: getWidth(context) - 80,
                child: Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: TextField(
                    style: TextStyle(color: Colors.black),
                    onChanged: (query) {
                      doSearch(query);
                    },
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(right: 18),
                        border: InputBorder.none,
                        hintText: 'Search '),
                  ),
                ),
              )
            ],
          ),
          searchResult(stream, loadinStream, function)
        ],
      ),
    ),
  );
}

Widget searchResult(
    Stream stream, Stream loadingStream, Function(Place place) function) {
  return StreamBuilder(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Container(
            height: getHeight(context, height: 10),
            child: Column(
              children: <Widget>[
                Divider(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Text('Error: ${snapshot.error}', style: TextStyle()),
                  ),
                )
              ],
            ),
          );
        }
        if (snapshot.hasData) {
          if (snapshot.data.length == 0) {
            return Container(
              height: getHeight(context, height: 10),
              child: Column(
                children: <Widget>[
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Text('Oops, No result found', style: TextStyle()),
                    ),
                  )
                ],
              ),
            );
          }
          List<Place> places = snapshot.data;
          return Container(
            child: Column(
              children: <Widget>[
                Divider(),
                ListView.separated(
                    padding: EdgeInsets.only(top: 0.0, bottom: 12.0),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return ListTile(
                          title: Text(
                            places[index].description,
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 14),
                          ),
                          subtitle: Text(
                            places[index].address,
                            style: TextStyle(
                                fontFamily: primaryFont, fontSize: 11),
                          ),
                          leading: Icon(AntIcons.search_outline),
                          onTap: () {
                            function(places[index]);
                          });
                    },
                    separatorBuilder: (context, index) {
                      return Divider();
                    },
                    itemCount: 3)
              ],
            ),
          );
        }
        return StreamBuilder(
          stream: loadingStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data)
                return Container(
                  height: getHeight(context, height: 10),
                  child: Column(
                    children: <Widget>[
                      Divider(),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Text('Loading...', style: TextStyle()),
                        ),
                      )
                    ],
                  ),
                );
            }
            return Container(height: 0.0);
          },
        );
      });
}
