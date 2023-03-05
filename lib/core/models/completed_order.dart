class CompletedOrder {
  Map<String, dynamic> battery;
  Map<String, dynamic> place;
  Map<String, dynamic> nobreak;

  CompletedOrder({
    required this.battery,
    required this.nobreak,
    required this.place,
  });

  factory CompletedOrder.fromJson(Map<String, dynamic> json) {
    return CompletedOrder(
        battery: json['battery'],
        nobreak: json['nobreak'],
        place: json['place']);
  }

  Map<String, dynamic> toJson() => {
        'battery': battery,
        'nobreak': nobreak,
        'place': place,
      };
}
