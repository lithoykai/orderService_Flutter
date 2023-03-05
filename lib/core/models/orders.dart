import 'package:flutter/material.dart';

class Orders with ChangeNotifier {
  String id;
  // DateTime date;
  String nameClient;
  String adressClient;
  String? loginPPOE = '';
  String? passwordPPOE = '';
  String? description = '';
  Pri priority;
  final Type type;
  String dateTime;

  Orders({
    // required this.date,
    required this.id,
    required this.nameClient,
    required this.adressClient,
    this.description,
    this.loginPPOE,
    this.passwordPPOE,
    required this.priority,
    required this.type,
    required this.dateTime,
  });

  Color? get priorityColor {
    switch (priority) {
      case Pri.alta:
        return Colors.red;
      case Pri.normal:
        return Colors.green;
      case Pri.baixa:
        return Colors.yellow;
      default:
        return Colors.green;
    }
  }

  String get priorityText {
    switch (priority) {
      case Pri.alta:
        return 'Alta';
      case Pri.normal:
        return 'Normal';
      case Pri.baixa:
        return 'Baixa';
      default:
        return 'Normal';
    }
  }

  int get priorityNumber {
    switch (priority) {
      case Pri.alta:
        return 1;
      case Pri.normal:
        return 2;
      case Pri.baixa:
        return 3;
      default:
        return 2;
    }
  }

  String get typeText {
    switch (type) {
      case Type.instalacao:
        return 'Instalação';
      case Type.reparo:
        return 'Reparo';
      case Type.cancelamento:
        return 'Cancelamento';
      default:
        return 'Desconhecida';
    }
  }

  get items => null;
}

enum Pri { alta, normal, baixa }

enum Type { instalacao, reparo, cancelamento }
