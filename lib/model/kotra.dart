class Kotra {
  int no;
  int capacity;
  int numOfItems;

  Kotra(this.no, this.capacity, this.numOfItems);

  factory Kotra.fromJson(Map<dynamic, dynamic> json) {
    return Kotra(
      json["no"] as int,
      json["capacity"] as int,
      json["numOfItems"] as int,
    );
  }
}
