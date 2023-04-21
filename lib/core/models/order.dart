class Order {
  String id;
  String firebaseID;
  String problem;
  String clientID;
  String technicalID;
  DateTime creationDate;
  DateTime deadline;

  Order({
    required this.id,
    required this.firebaseID,
    required this.problem,
    required this.creationDate,
    required this.deadline,
    required this.clientID,
    required this.technicalID,
  });

  factory Order.fromJson(Map<String, dynamic> json, firebaseID) {
    return Order(
      id: json['id'],
      firebaseID: firebaseID,
      clientID: json['clientID'],
      problem: json['problem'],
      technicalID: json['technicalID'],
      creationDate: DateTime.parse(json['technicalID']),
      deadline: DateTime.parse(json['technicalID']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'firebaseID': firebaseID,
        'problem': problem,
        'clientID': clientID,
        'technicalID': technicalID,
        'creationDate': creationDate.toIso8601String(),
        'deadline': deadline.toIso8601String(),
      };
}
