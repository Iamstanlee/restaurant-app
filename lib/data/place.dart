class Place {
  String name, description, address, placeId;
  double lat, lng;
  Place(this.name, this.description, this.placeId, this.address, this.lat,
      this.lng);
  Place.fromMap(Map map) {
    description = map['description'];
    address = map['structured_formatting']['main_text'];
    this.placeId = map['place_id'];
  }
}
