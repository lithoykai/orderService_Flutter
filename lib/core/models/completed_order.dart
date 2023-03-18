class CompletedOrder {
  String id;
  Map<String, dynamic> battery;
  Map<String, dynamic> place;
  Map<String, dynamic> nobreak;

  CompletedOrder({
    required this.id,
    required this.battery,
    required this.nobreak,
    required this.place,
  });

  factory CompletedOrder.fromJson(Map<String, dynamic> json, String id) {
    return CompletedOrder(
        id: id,
        battery: json['battery'],
        nobreak: json['nobreak'],
        place: json['place']);
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'battery': battery,
        'nobreak': nobreak,
        'place': place,
      };
}
