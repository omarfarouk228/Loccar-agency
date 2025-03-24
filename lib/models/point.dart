class Point {
  late int id;
  late String name, latitude, longitude;

  Point() {
    id = 0;
    name = "";
    latitude = "";
    longitude = "";
  }

  Point.copyContructor(this.id, this.name, this.latitude, this.longitude);
}
