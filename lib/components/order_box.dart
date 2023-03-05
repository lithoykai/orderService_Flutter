import 'package:flutter/material.dart';
import 'package:orders_project/components/order_detail.dart';
import 'package:orders_project/utils/app_routers.dart';
import 'package:provider/provider.dart';
import '../core/models/map_adress.dart';
import '../core/models/orders.dart';
import '../core/services/finish_order_list.dart';
import '../core/services/orders_list.dart';

class OrderBox extends StatefulWidget {
  final Orders order;

  OrderBox(this.order);

  @override
  State<OrderBox> createState() => _OrderBoxState(order);
}

class _OrderBoxState extends State<OrderBox> {
  Orders order;

  _OrderBoxState(this.order);

  MapAdress mapAdress = MapAdress();
  bool _expanded = false;

  _openTransactionFormModal(BuildContext context) {
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      isScrollControlled: true,
      context: context,
      builder: (_) {
        return OrderDetail(order: order);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          onTap: () async {
            _openTransactionFormModal(context);
            // Provider.of<OrderList>(context, listen: false).reloadOrder();
          },
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.order.typeText,
                style: TextStyle(
                    fontSize: 14, fontFamily: 'Lato', color: Colors.grey),
              ),
              Text(
                widget.order.nameClient,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          subtitle: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                        width: 75,
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: widget.order.priorityColor,
                        ),
                        constraints:
                            BoxConstraints(minHeight: 16, minWidth: 16),
                        child: Text(
                          widget.order.priorityText,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 14),
                        )),
                  ],
                ),
                // Text(widget.order.adressClient),
              ],
            ),
          ),
          // leading: CircleAvatar(
          //   backgroundColor: widget.order.priorityColor ?? Colors.black,
          // ),
          trailing: IconButton(
            icon: Icon(Icons.expand_more),
            onPressed: () {
              setState(() {
                _expanded = !_expanded;
              });
            },
          ),
        ),
        if (_expanded)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 17),
                child: Text(
                  widget.order.adressClient,
                  style: const TextStyle(
                      color: Colors.black54, fontFamily: 'Lato'),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 4,
                ),
                height: 45,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton.icon(
                      icon: Icon(
                        Icons.beenhere,
                        color: Colors.green,
                      ),
                      label: const Text(
                        'Finalizar serviço',
                        style: TextStyle(
                          color: Colors.green,
                        ),
                      ),
                      onPressed: () {
                        if (order.type == Type.cancelamento) {
                          showDialog(
                            context: context,
                            builder: (ctx) => StatefulBuilder(
                              builder: (ctx, setState) {
                                return AlertDialog(
                                  content: Text(
                                      'Deseja finalizar este ${order.typeText.toLowerCase()}?'),
                                  actions: [
                                    TextButton(
                                        onPressed: () async {
                                          Map<String, Object> _formData = {
                                            'id': order.id,
                                            'nameClient': order.nameClient,
                                            'adressClient': order.adressClient,
                                            'priority': order.priority,
                                            'type': order.type,
                                            'description':
                                                order.description ?? '',
                                            'loginPPOE': order.loginPPOE ?? '',
                                            'passwordPPOE':
                                                order.passwordPPOE ?? '',
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
                                          )
                                              .saveOrderFinished(
                                                  _formData, order)
                                              .then((ctx) {
                                            Provider.of<OrderList>(
                                              context,
                                              listen: false,
                                            ).deleteOrder(order);
                                          }).then((value) =>
                                                  Navigator.pop(context, true));
                                          if (true) {
                                            Provider.of<OrderList>(
                                              context,
                                              listen: false,
                                            ).loadOrder();
                                          }
                                        },
                                        child: Text('Sim')),
                                    TextButton(
                                        onPressed: () async {
                                          Navigator.pop(context);
                                        },
                                        child: Text('Não')),
                                  ],
                                );
                              },
                            ),
                          );
                        } else {
                          Navigator.of(context)
                              .pushNamed(
                                AppRoutes.FINISH_FORM_PAGE,
                                arguments: order,
                              )
                              .then((value) =>
                                  Provider.of<OrderList>(context, listen: false)
                                      .loadOrder());
                        }
                      },
                    ),
                    TextButton.icon(
                      icon: Icon(Icons.location_pin),
                      label: Text('Seguir rota.'),
                      onPressed: () async {
                        MapAdress.openMap(
                            (widget.order.adressClient.toUpperCase())
                                .toString());
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        Container(
          color: Colors.grey,
          width: double.infinity,
          height: 0.5,
        ),
      ],
    );
  }
}
