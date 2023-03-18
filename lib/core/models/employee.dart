class Employee {
  String id;
  String name;
  String district;
  String address;
  String email;
  String? complement;
  String? landmark;
  int CPF;

  Employee({
    required this.id,
    required this.name,
    required this.district,
    required this.address,
    required this.email,
    required this.CPF,
    this.complement,
    this.landmark,
  });

  factory Employee.fromJson(Map<String, dynamic> json, String id) {
    return Employee(
      id: id,
      name: json['name'],
      district: json['district'],
      address: json['address'],
      email: json['email'],
      CPF: json['CPF'],
      complement: json['complement'] ?? '',
      landmark: json['landmark'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'district': district,
        'address': address,
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
