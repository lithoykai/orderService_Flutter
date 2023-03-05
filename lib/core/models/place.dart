enum Ventilation { naotem, arcondicionado, exautor }

enum Ilumination { normal, good, moderate, bad }

class Place {
  String? temp;
  Ilumination? lights;
  Ventilation? ventilation;
  bool cleanPlace;
  bool reverseKey;
  bool inputFrame;
  bool outputFrame;
  bool hasMaterialsClose;
  String? materialsClose;

  Place({
    required this.cleanPlace,
    required this.reverseKey,
    required this.inputFrame,
    required this.outputFrame,
    required this.hasMaterialsClose,
    this.temp,
    this.lights,
    this.ventilation,
    this.materialsClose,
  });

  // factory Place.fromJson(Map<String, dynamic> json) {}

  Map<String, dynamic> toJson() => {
        'cleanPlace': cleanPlace,
        'reverseKey': reverseKey,
        'inputFrame': inputFrame,
        'outputFrame': outputFrame,
        'hasMaterialsClose': hasMaterialsClose,
        'temp': temp,
        'lights': lights?.index ?? 0,
        'ventilation': ventilation?.index ?? 0,
        'materialsClose': materialsClose,
      };
}

// --------------------
//-----Identificador de local
//String? - Temperatura
//Opcional - Iluminação - Bom, razoavel e ruim 
//Enum? - Tipo de ventilação = Arcondicionado, exaustor e não possui ventilação
//Enum? - local limpo yes or not
//Enum - Possui chave reversora externa? bool 
//Enum - Quadro de entrada yes or not bool 
//Enum - Quadro de Saída yes or not bool 
//bool - Materiais depositados proximos ao equipamento. yes or not -> Se sim = String o que é.