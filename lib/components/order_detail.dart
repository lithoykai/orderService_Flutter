import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:orders_project/models/finish_order_list.dart';
import 'package:orders_project/models/orders.dart';
import 'package:orders_project/models/orders_list.dart';
import 'package:provider/provider.dart';
import '../models/map_adress.dart';
// import '../models/sizeConfig.dart';
import '../utils/app_routers.dart';
import '../utils/text_theme.dart';

class OrderDetail extends StatelessWidget {
  Orders order;
  OrderDetail({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final heigh = MediaQuery.of(context).size.height;
    final key = new GlobalKey<ScaffoldState>();

    DateTime _dateTime = DateTime.parse(order.dateTime);
    return Container(
      height: heigh * 0.65,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tipo de serviço:',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          color: Colors.grey[600],
                        ),
                      ),
                      Text(
                        order.typeText,
                        // DateFormat('dd/MM/yy HH:mm').format(_dateTime),
                        textAlign: TextAlign.start,
                        style: TextThemeClass.styleTextBold,
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        'Prioridade:',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          color: Colors.grey[600],
                        ),
                      ),
                      Text(
                        order.priorityText,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          color: order.priorityColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Lato',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                'Nome do Cliente:',
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: Colors.grey[600],
                ),
              ),
              Text(
                order.nameClient,
                textAlign: TextAlign.start,
                style: TextThemeClass.styleTextBold,
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                'Endereço do Cliente:',
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: Colors.grey[600],
                ),
              ),
              Text(
                order.adressClient,
                textAlign: TextAlign.start,
                style: TextThemeClass.styleTextBold,
              ),
              const SizedBox(
                height: 10,
              ),
              order.description == ''
                  ? Container()
                  : formDetailViewDescription(),
              order.typeText == 'Instalação' || order.typeText == 'Reparo'
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Login PPOE:',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(
                          height: 2,
                        ),
                        SelectableText(
                          order.loginPPOE ?? 'Sem informações.',
                          style: TextThemeClass.styleTextBold,
                          toolbarOptions: ToolbarOptions(
                            copy: true,
                            cut: true,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Senha PPOE:',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(
                          height: 2,
                        ),
                        SelectableText(
                          order.passwordPPOE ?? 'Sem informações.',
                          style: TextThemeClass.styleTextBold,
                          toolbarOptions: ToolbarOptions(
                            copy: true,
                            cut: true,
                          ),
                        ),
                      ],
                    )
                  : Container(),
              SizedBox(
                height: 10,
              ),
              ElevatedButton.icon(
                icon: Icon(Icons.beenhere),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.green),
                ),
                onPressed: () {
                  if (order.type == Type.cancelamento) {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        content: Text(
                            'Deseja finalizar este ${order.typeText.toLowerCase()}?'),
                        actions: [
                          TextButton(
                              onPressed: () async {
                                Navigator.of(context).pop();
                                Map<String, Object> _formData = {
                                  'id': order.id,
                                  'nameClient': order.nameClient,
                                  'adressClient': order.adressClient,
                                  'priority': order.priority,
                                  'type': order.type,
                                  'description': order.description ?? '',
                                  'loginPPOE': order.loginPPOE ?? '',
                                  'passwordPPOE': order.passwordPPOE ?? '',
                                  'signalClient': 0.0,
                                  'signalStreet': 0.0,
                                  'rede': 0,
                                  'ctoBox': 0,
                                  'port': 0,
                                  'popInternet': '',
                                  // 'date': DateTime.now(),
                                };
                                await Provider.of<FinishOrderList>(
                                  context,
                                  listen: false,
                                ).saveOrderFinished(_formData, order).then(
                                    (value) => Provider.of<OrderList>(
                                          context,
                                          listen: false,
                                        )
                                            .deleteOrder(order)
                                            .then((value) =>
                                                Navigator.of(context).pop())
                                            .then((value) =>
                                                Provider.of<OrderList>(context,
                                                        listen: false)
                                                    .loadOrder()));
                              },
                              child: Text('Sim')),
                          TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('Não')),
                        ],
                      ),
                    );
                  } else {
                    Navigator.of(context).popAndPushNamed(
                      AppRoutes.FINISH_FORM_PAGE,
                      arguments: order,
                    );
                  }
                },
                label: Text('FINALIZAR ${order.typeText.toUpperCase()}'),
              ),
              SizedBox(
                height: 10,
              ),
              ElevatedButton.icon(
                icon: Icon(Icons.location_pin),
                label: Text('SEGUIR ROTA'),
                onPressed: () async {
                  MapAdress.openMap(
                      (order.adressClient.toUpperCase()).toString());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Column formDetailViewDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Descrição:',
          textAlign: TextAlign.start,
          style: TextStyle(
            color: Colors.grey[600],
          ),
        ),
        Text(
          order.description ?? '',
          textAlign: TextAlign.start,
          style: const TextStyle(
            fontSize: 18,
            fontFamily: 'Lato',
          ),
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
