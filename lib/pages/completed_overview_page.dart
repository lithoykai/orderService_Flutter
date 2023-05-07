import 'package:flutter/material.dart';
import 'package:orders_project/components/completed_order_widget.dart';
import 'package:orders_project/components/menu_drawer.dart';

import 'package:orders_project/core/services/completed_orders_services.dart';
import 'package:provider/provider.dart';

import '../components/loading_component.dart';
import '../components/no_order.dart';

class CompletedOrderOverviewPage extends StatefulWidget {
  const CompletedOrderOverviewPage({Key? key}) : super(key: key);

  @override
  State<CompletedOrderOverviewPage> createState() =>
      _CompletedOrderOverviewPageState();
}

class _CompletedOrderOverviewPageState extends State<CompletedOrderOverviewPage>
    with TickerProviderStateMixin {
  final String _findOrder = '';
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 2),
    vsync: this,
  )..forward();
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeIn,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: const Color.fromARGB(255, 240, 240, 240),
        centerTitle: true,
        elevation: 0,
        title: const Text(
          'Ordens concluídas',
          style: TextStyle(color: Colors.black),
        ),
      ),
      drawer: const MenuDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder(
          future: Provider.of<CompletedOrderServices>(
            context,
            listen: false,
          ).fetchCompletedOrdersData(),
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: LoadingComponent(),
              );
            } else if (snapshot.error != null) {
              return const Scaffold(
                body: Center(
                  child: Text('Ocorreu um erro!!'),
                ),
              );
            } else {
              return Consumer<CompletedOrderServices>(
                builder: (ctx, completeOrders, child) => completeOrders
                        .items.isEmpty
                    ? FadeTransition(
                        opacity: _animation,
                        child: const NoOrder(),
                      )
                    : ListView.builder(
                        itemBuilder: (context, index) => CompletedOrderWidget(
                            completedOrder: completeOrders.items[index]),
                        itemCount: completeOrders.items.length,
                      ),
              );
            }
          },
        ),
      ),
    );
  }
}
