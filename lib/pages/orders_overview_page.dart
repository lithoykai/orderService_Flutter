import 'package:flutter/material.dart';
import 'package:orders_project/components/order_box_widget.dart';
import 'package:orders_project/core/models/auth.dart';

import 'package:orders_project/core/services/order_services.dart';
import 'package:orders_project/utils/app_routers.dart';

import 'package:provider/provider.dart';

class OrderOverview extends StatefulWidget {
  const OrderOverview({Key? key}) : super(key: key);

  @override
  State<OrderOverview> createState() => _OrderOverviewState();
}

class _OrderOverviewState extends State<OrderOverview> {
  final bool _isLoading = true;

  Future<void> _refreshOrders(BuildContext context) {
    return Provider.of<OrderService>(context, listen: false).fetchOrdersData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ordens de serviço'),
        actions: [
          IconButton(
            onPressed: () async {
              Navigator.of(context).pushNamed(AppRoutes.ADD_ORDER_PAGE);
            },
            icon: const Icon(Icons.add),
          ),
          IconButton(
            onPressed: () async {
              Navigator.of(context).pushNamed(AppRoutes.ADD_EMPLOYEES_PAGE);
            },
            icon: const Icon(Icons.refresh),
          ),
          IconButton(
            onPressed: () async {
              Provider.of<Auth>(context, listen: false).logout();
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: FutureBuilder(
        future:
            Provider.of<OrderService>(context, listen: false).fetchOrdersData(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  CircularProgressIndicator(),
                  SizedBox(
                    height: 15,
                  ),
                  Text('Carregando as ordens de serviço...'),
                ],
              ),
            );
          } else if (snapshot.error != null) {
            return const Center(
              child: Text('Ocorreu um erro!'),
            );
          } else {
            return Consumer<OrderService>(
              builder: (ctx, orders, child) => RefreshIndicator(
                onRefresh: () => _refreshOrders(context),
                child: ListView.builder(
                  itemCount: orders.itemsCount,
                  itemBuilder: (ctx, i) => OrderBoxWidget(orders.items[i]),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
