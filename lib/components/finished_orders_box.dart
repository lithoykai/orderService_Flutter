import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:orders_project/utils/app_routers.dart';

import '../core/models/old_models/finish_order.dart';

class FinishedOrdersBox extends StatelessWidget {
  final FinishOrder finishedOrder;
  const FinishedOrdersBox(this.finishedOrder, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime _dateTime = DateTime.parse(finishedOrder.dateTime);
    final _dateTimeString = DateFormat('dd/MM/yy').format(_dateTime);
    return Container(
      child: Column(
        children: [
          ListTile(
            onTap: () {
              Navigator.of(context).pushNamed(AppRoutes.FINISHED_DETAILS,
                  arguments: finishedOrder);
            },
            title: Text(finishedOrder.nameClient),
            subtitle: Text(finishedOrder.typeText),
            trailing: Column(
              children: [
                const Text('Finalizado:'),
                Text(_dateTimeString),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
