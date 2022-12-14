import 'package:flutter/material.dart';
import 'package:orders_project/components/order_detail.dart';
import 'package:orders_project/models/orders_list.dart';
import 'package:provider/provider.dart';

import '../models/orders.dart';

class OrderDetailPage extends StatelessWidget {
  OrderDetailPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Orders order = ModalRoute.of(context)!.settings.arguments as Orders;

    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes do Serviço'),
      ),
      body: SingleChildScrollView(child: OrderDetail(order: order)),
    );
    //
    //
    //
  }
}
