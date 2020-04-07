class ProductData {
  String id, additionalNote, name, color, size, description, tag;
  List images, colors, category, sizes;
  num rating, off, quantities, quantity, price, oldPrice;
  ProductData(
      {this.id,
      this.additionalNote,
      this.off,
      this.name,
      this.images,
      this.description,
      this.tag,
      this.price,
      this.colors,
      this.sizes,
      this.category,
      this.quantity,
      this.color,
      this.rating,
      this.size,
      this.oldPrice,
      this.quantities});
  ProductData.fromMap(Map map, String uid) {
    name = map['name'];
    images = map['images'];
    off = map['percentageOff'];
    additionalNote = map['additionalNote'];
    description = map['description'];
    price = map['price'];
    oldPrice = map['oldPrice'];
    quantities = map['quantities'];
    quantity = map['quantity'];
    colors = map['colors'];
    sizes = map['sizes'];
    size = map['size'];
    color = map['color'];
    category = map['category'];
    tag = map['tag'];
    rating = map['rating'];
    id = uid;
  }
  Map<String, dynamic> toMap(ProductData data) {
    return {
      'id': data.id,
      'name': data.name,
      'images': data.images,
      'description': data.description,
      'price': data.price,
      'oldPrice': data.oldPrice,
      'quantity': data.quantity,
      'color': data.color,
      'size': data.size,
      'tag': data.tag,
      'rating': data.rating,
      'quantities': data.quantities,
      'colors': data.colors,
      'sizes': data.sizes,
      'category': data.category,
      'off': data.off,
      'additionalNote': data.additionalNote
    };
  }
}
