class CompanyClient {
  String id;
  String name; //nome da empresa
  String? tradingName; // nome fantasia
  String district;
  String city;
  String address;
  String? complement;
  String? landmark;
  int cnpj;
  int stateRegistration;

  CompanyClient(
      {required this.id,
      required this.name,
      this.tradingName,
      required this.district,
      required this.city,
      required this.address,
      required this.cnpj,
      required this.stateRegistration,
      this.complement,
      this.landmark});

  factory CompanyClient.fromJson(Map json, id) {
    return CompanyClient(
      id: id,
      name: json['name'],
      tradingName: json['tradingName'] ?? '',
      district: json['district'],
      city: json['city'],
      address: json['address'],
      cnpj: json['cnpj'],
      stateRegistration: json['stateRegistration'],
      complement: json['complement'] ?? '',
      landmark: json['landmark'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'tradingName': tradingName ?? '',
        'district': district,
        'city': city,
        'address': address,
        'cnpj': cnpj,
        'stateRegistration': stateRegistration,
        'complement': complement ?? '',
        'landmark': landmark ?? ''
      };
}


// 1 - cód_cliente
// 2 - Nome
// 3 - Nome Fantasia
// 4 - Cidade
// 5 - Bairro
// 6 - Endereço
// 7 - Complemento
// 8 - Ponto de Referencia
// 9 - Cnpj
// 10 - Incrição Estadual