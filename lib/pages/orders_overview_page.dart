import 'package:flutter/material.dart';
import 'package:orders_project/components/order_box.dart';
import 'package:orders_project/core/models/auth.dart';
import 'package:orders_project/core/models/completed_order.dart';
import 'package:orders_project/core/services/completed_orders_services.dart';

import 'package:provider/provider.dart';

import '../core/services/orders_list.dart';

class OrderOverview extends StatefulWidget {
  const OrderOverview({Key? key}) : super(key: key);

  @override
  State<OrderOverview> createState() => _OrderOverviewState();
}

class _OrderOverviewState extends State<OrderOverview> {
  bool _isLoading = true;
  @override
  void initState() {
    super.initState();
    Provider.of<OrderList>(
      context,
      listen: false,
    ).loadOrder().then((value) {
      setState(() => _isLoading = false);
    });
  }

  Future<void> _refreshOrders(BuildContext context) {
    return Provider.of<OrderList>(context, listen: false).loadOrder();
  }

  @override
  Widget build(BuildContext context) {
    OrderList orders = Provider.of<OrderList>(context);
    return _isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : orders.itemsCount == 0
            ? const Center(
                child: Text('Não há ordens de serviços!'),
              )
            : Scaffold(
                appBar: AppBar(
                  title: Text('Ordens de serviço'),
                  actions: [
                    IconButton(
                      onPressed: () async {
                        CompletedOrderServices().saveData();
                        // Provider.of<Auth>(context, listen: false).logout();
                      },
                      icon: Icon(Icons.logout),
                    )
                  ],
                ),
                body: RefreshIndicator(
                  onRefresh: () => _refreshOrders(context),
                  child: ListView.builder(
                      itemCount: orders.itemsCount,
                      itemBuilder: (ctx, i) => OrderBox(orders.items[i])),
                ),
              );
  }
}
