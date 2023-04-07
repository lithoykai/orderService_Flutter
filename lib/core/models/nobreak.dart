class Nobreak {
  final String id;
  final Voltage voltage;
  final UPSCurrent upsCurrent;
  final String frequencyEquip;
  final String? ipCommunication;
  final String? passwordCommunication;
  final bool display;
  final bool nobreakWasOpened;
  final bool hasCommunicationBoard;

  Nobreak({
    required this.id,
    required this.display,
    required this.nobreakWasOpened,
    required this.hasCommunicationBoard,
    required this.upsCurrent,
    required this.voltage,
    required this.frequencyEquip,
    this.ipCommunication,
    this.passwordCommunication,
  });

  factory Nobreak.fromJson(Map<String, dynamic> json) {
    return Nobreak(
      id: json['id'],
      display: json['display'] ?? false,
      nobreakWasOpened: json['nobreakWasOpened'] ?? false,
      hasCommunicationBoard: json['hasCommunicationBoard'] ?? false,
      upsCurrent: UPSCurrent.fromJson(json['upsCurrent']),
      voltage: Voltage.fromJson(json['voltage']),
      frequencyEquip: json['frequencyEquip'],
      ipCommunication: json['ipCommunication'] ?? '',
      passwordCommunication: json['passwordCommunication'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'display': display,
        'nobreakWasOpened': nobreakWasOpened,
        'hasCommunicationBoard': hasCommunicationBoard,
        'upsCurrent': upsCurrent.toJson(),
        'voltage': voltage.toJson(),
        'frequencyEquip': frequencyEquip,
        'ipCommunication': ipCommunication ?? '',
        'passwordCommunication': passwordCommunication ?? '',
      };
}

class Voltage {
  final String input;
  final String output;

  Voltage({
    required this.input,
    required this.output,
  });

  factory Voltage.fromJson(Map<dynamic, dynamic> json) {
    return Voltage(
      input: json['input'],
      output: json['output'],
    );
  }

  Map<String, dynamic> toJson() => {
        'input': input,
        'output': output,
      };
}

class UPSCurrent {
  final String input;
  final String output;

  UPSCurrent({
    required this.input,
    required this.output,
  });

  factory UPSCurrent.fromJson(Map<dynamic, dynamic> json) {
    return UPSCurrent(
      input: json['input'],
      output: json['output'],
    );
  }

  Map<String, dynamic> toJson() => {
        'input': input,
        'output': output,
      };
}
//--------Nobreak 
//Enum - display funcional - enum (yes or not)
//String - tensão de entrada do nobreak
//String - tensão de saída do nobreak
//String - corrente de entrada do nobreak
//String - corrente de saida do nobreak
//String - frequencia do equipamento.
//Enum - abertura do nobreak
//Enum - placa de comunicação => Se sim = String IP e senha.