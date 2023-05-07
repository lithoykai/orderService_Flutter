import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:orders_project/core/models/completed_order.dart';

class CompletedOrderWidget extends StatelessWidget {
  final CompletedOrder completedOrder;
  const CompletedOrderWidget({Key? key, required this.completedOrder})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        completedOrder.title,
      ),
      subtitle: Row(
        children: [
          const Icon(Icons.date_range_rounded, size: 15),
          const SizedBox(
            width: 5,
          ),
          Text(
              'Finalizado dia ${DateFormat(DateFormat.YEAR_MONTH_DAY, 'pt_Br').format(completedOrder.finishDate)}'),
        ],
      ),
    );
  }
}
