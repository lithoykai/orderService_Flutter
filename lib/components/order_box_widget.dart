import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:orders_project/core/services/company_client_services.dart';

import 'package:provider/provider.dart';

import '../core/models/order.dart';
import '../core/services/completed_orders_services.dart';
import '../utils/app_routers.dart';

class OrderBoxWidget extends StatelessWidget {
  final Order order;
  const OrderBoxWidget(this.order, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final company = Provider.of<CompanyClientServices>(context);
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Card(
        margin: const EdgeInsets.all(5.0),
        elevation: 2,
        child: Container(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                order.title,
                style: const TextStyle(
                  // fontFamily: 'Gotham',
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              Row(
                children: [
                  const Icon(Icons.business, size: 15),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    company.clients
                        .firstWhere((element) => element.id == order.clientID)
                        .name
                        .toString(),
                  ),
                ],
              ),
              Row(
                children: [
                  const Icon(Icons.date_range_rounded, size: 15),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                      'Prazo: ${DateFormat(DateFormat.YEAR_MONTH_DAY, 'pt_Br').format(order.deadline)}'),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    width: mediaQuery.size.width * 0.40,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context)
                            .pushNamed(AppRoutes.DETAIL_ORDER_PAGE, arguments: [
                          company.clients.firstWhere(
                              (element) => element.id == order.clientID),
                          order
                        ]);
                      },
                      child: const Text('DETALHES'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 124, 170, 251),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: mediaQuery.size.width * 0.40,
                    child: ElevatedButton(
                      onPressed: () {
                        Provider.of<CompletedOrderServices>(context,
                                listen: false)
                            .addOrderData(order);
                        Provider.of<CompletedOrderServices>(context,
                                listen: false)
                            .indexToSwitch = 0;
                        Navigator.of(context).pushNamed(
                          AppRoutes.COMPLETED_ORDER_PAGE,
                          arguments: order,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      child: const Text('FINALIZAR',
                          style: TextStyle(
                            // fontFamily: 'Gotham',
                            fontFamily: 'AvenirNext',
                          )),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
