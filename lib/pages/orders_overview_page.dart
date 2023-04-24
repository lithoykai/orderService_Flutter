import 'package:flutter/material.dart';
import 'package:orders_project/components/no_order.dart';
import 'package:orders_project/components/order_box_widget.dart';
import 'package:orders_project/core/models/auth.dart';
import 'package:orders_project/core/services/completed_orders_services.dart';
import 'package:orders_project/core/services/firebase_services.dart';

import 'package:orders_project/core/services/order_services.dart';
import 'package:orders_project/utils/app_routers.dart';

import 'package:provider/provider.dart';

import '../components/loading_component.dart';

class OrderOverview extends StatefulWidget {
  const OrderOverview({Key? key}) : super(key: key);

  @override
  State<OrderOverview> createState() => _OrderOverviewState();
}

class _OrderOverviewState extends State<OrderOverview>
    with TickerProviderStateMixin {
  final bool _isLoading = true;
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 2),
    vsync: this,
  )..forward();
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeIn,
  );
  bool? returnPage;

  Future<void> _refreshOrders(BuildContext context) {
    return Provider.of<OrderService>(context, listen: false).fetchOrdersData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 240, 240, 240),
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
            icon: const Icon(Icons.add_alarm),
          ),
          IconButton(
            onPressed: () async {
              Navigator.of(context).pushNamed(AppRoutes.ADD_COMPANY_PAGE);
            },
            icon: const Icon(Icons.add_a_photo),
          ),
          IconButton(
            onPressed: () async {
              Provider.of<Auth>(context, listen: false).logout();
            },
            icon: const Icon(Icons.logout),
          ),
          IconButton(
            onPressed: () async {
              Navigator.of(context).pushNamed(AppRoutes.COMPLETED_ORDER_OVERVIEW_PAGE);
            },
            icon: const Icon(Icons.check),
          ),
        ],
      ),
      body: FutureBuilder(
        future: Provider.of<FirebaseServices>(context, listen: false)
            .fetchAllData(context),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: LoadingComponent(),
            );
          } else if (snapshot.error != null) {
            return const Scaffold(
              body: Center(
                child: Text('Ocorreu um erro!!'),
              ),
            );
          } else {
            return Consumer<OrderService>(
              builder: (ctx, orders, child) => orders.items.isEmpty
                  ? FadeTransition(
                      opacity: _animation,
                      child: const NoOrder(),
                    )
                  : RefreshIndicator(
                      onRefresh: () => _refreshOrders(context),
                      child: ListView.builder(
                        itemCount: orders.itemsCount,
                        itemBuilder: (ctx, i) =>
                            OrderBoxWidget(orders.items[i]),
                      ),
                    ),
            );
          }
        },
      ),
    );
  }
}
