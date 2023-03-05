class Nobreak {
  bool display;
  bool nobreakWasOpened;
  bool hasCommunicationBoard;
  String inputVoltage;
  String outputVoltage;
  String inputCurrent;
  String outputCurrent;
  String frequencyEquip;
  String? ipCommunication;
  String? passwordCommunication;

  Nobreak({
    required this.display,
    required this.nobreakWasOpened,
    required this.hasCommunicationBoard,
    required this.inputCurrent,
    required this.outputCurrent,
    required this.outputVoltage,
    required this.inputVoltage,
    required this.frequencyEquip,
    this.ipCommunication,
    this.passwordCommunication,
  });

  // factory Nobreak.fromJson(Map<String, dynamic> json) {}

  Map<String, dynamic> toJson() => {
        'display': display,
        'nobreakWasOpened': nobreakWasOpened,
        'hasCommunicationBoard': hasCommunicationBoard,
        'inputCurrent': inputCurrent,
        'outputCurrent': outputCurrent,
        'outputVoltage': outputVoltage,
        'inputVoltage': inputVoltage,
        'frequencyEquip': frequencyEquip,
        'ipCommunication': ipCommunication ?? '',
        'passwordCommunication': passwordCommunication ?? '',
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