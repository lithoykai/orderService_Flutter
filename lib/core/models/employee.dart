class Employee {
  final String id;
  final String userID;
  final String name;
  final String district;
  final String city;
  final String address;
  final String email;
  final String? complement;
  final String? landmark;
  final int CPF;

  Employee({
    required this.id,
    required this.userID,
    required this.name,
    required this.district,
    required this.address,
    required this.city,
    required this.email,
    required this.CPF,
    this.complement,
    this.landmark,
  });

  factory Employee.fromJson(Map json, String id, String? userID) {
    return Employee(
      id: id,
      userID: userID ?? json['userID'],
      name: json['name'],
      district: json['district'],
      address: json['address'],
      city: json['city'] ?? '',
      email: json['email'],
      CPF: json['CPF'],
      complement: json['complement'] ?? '',
      landmark: json['landmark'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'userID': userID,
        'name': name,
        'district': district,
        'address': address,
        'city': city,
        'email': email,
        'CPF': CPF,
        'complement': complement ?? '',
        'landmark': landmark ?? '',
      };
//   Técnico

// 1 - Cód
// 2 - Nome
// 3 - Cidade
// 4 - Bairro
// 5 - Endereço
// 6 - Complemento
// 7 - Ponto de Referencia
// 8 - CPF
// 9 - email
}
