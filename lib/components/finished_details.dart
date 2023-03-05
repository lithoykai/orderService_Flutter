import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:orders_project/components/finished_orders_box.dart';
import 'package:orders_project/utils/text_theme.dart';

import '../core/models/finish_order.dart';

class FinishedDetailsWidget extends StatelessWidget {
  const FinishedDetailsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final finishedOrder =
        ModalRoute.of(context)!.settings.arguments as FinishOrder;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        title: const Text(
          'Detalhes da ordem finalizada',
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'Oswald',
            fontWeight: FontWeight.w300,
            fontSize: 22,
          ),
        ),
        elevation: 1,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Nome do Cliente:',
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: Color.fromARGB(255, 121, 121, 121),
                ),
              ),
              Text(
                finishedOrder.nameClient,
                // DateFormat('dd/MM/yy HH:mm').format(_dateTime),
                textAlign: TextAlign.start,
                style: TextThemeClass.styleTextBold,
              ),
              SizedBox(
                height: 10,
              ),
              const Text(
                'Endereço:',
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: Color.fromARGB(255, 121, 121, 121),
                ),
              ),
              Text(
                finishedOrder.adressClient,
                // DateFormat('dd/MM/yy HH:mm').format(_dateTime),
                textAlign: TextAlign.start,
                style: TextThemeClass.styleTextBold,
              ),
              SizedBox(
                height: 10,
              ),
              const Text(
                'Tipo de Serviço:',
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: Color.fromARGB(255, 121, 121, 121),
                ),
              ),
              Text(
                finishedOrder.typeText,
                // DateFormat('dd/MM/yy HH:mm').format(_dateTime),
                textAlign: TextAlign.start,
                style: TextThemeClass.styleTextBold,
              ),
              SizedBox(
                height: 10,
              ),
              const Text(
                'Data e horario de finalização:',
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: Color.fromARGB(255, 121, 121, 121),
                ),
              ),
              Text(
                DateFormat('dd/MM/yy - HH:mm')
                    .format(DateTime.parse(finishedOrder.dateTime)),
                textAlign: TextAlign.start,
                style: TextThemeClass.styleTextBold,
              ),
              SizedBox(
                height: 10,
              ),
              const Text(
                'Descrição',
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: Color.fromARGB(255, 121, 121, 121),
                ),
              ),
              if (finishedOrder.description == '' ||
                  finishedOrder.description == null)
                Text(
                  'Não informado.',
                  textAlign: TextAlign.start,
                  style: TextThemeClass.styleTextBold,
                ),
              Text(
                finishedOrder.description ?? 'Não informado.',
                textAlign: TextAlign.start,
                style: TextThemeClass.styleTextBold,
              ),
              SizedBox(
                height: 10,
              ),
              finishedOrder.typeText == 'Instalação'
                  ? infoInstalationWidget(finishedOrder: finishedOrder)
                  : Text(''),
            ],
          ),
        ),
      ),
    );
  }
}

class infoInstalationWidget extends StatelessWidget {
  const infoInstalationWidget({
    Key? key,
    required this.finishedOrder,
  }) : super(key: key);

  final FinishOrder finishedOrder;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Login PPOE:',
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: Color.fromARGB(255, 121, 121, 121),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 10.0),
                child: Text(
                  'Senha PPOE:',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: Color.fromARGB(255, 121, 121, 121),
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                finishedOrder.loginPPOE!,
                textAlign: TextAlign.start,
                style: TextThemeClass.styleTextBold,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Text(
                  finishedOrder.passwordPPOE!,
                  textAlign: TextAlign.start,
                  style: TextThemeClass.styleTextBold,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Rede:',
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: Color.fromARGB(255, 121, 121, 121),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 10.0),
                child: Text(
                  'Caixa:',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: Color.fromARGB(255, 121, 121, 121),
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${finishedOrder.rede}',
                textAlign: TextAlign.start,
                style: TextThemeClass.styleTextBold,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Text(
                  finishedOrder.ctoBox.toString(),
                  textAlign: TextAlign.start,
                  style: TextThemeClass.styleTextBold,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Porta:',
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: Color.fromARGB(255, 121, 121, 121),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 10.0),
                child: Text(
                  'POP:',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: Color.fromARGB(255, 121, 121, 121),
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${finishedOrder.port}',
                textAlign: TextAlign.start,
                style: TextThemeClass.styleTextBold,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Text(
                  finishedOrder.popInternet.toString(),
                  textAlign: TextAlign.start,
                  style: TextThemeClass.styleTextBold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
