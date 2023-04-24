import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:orders_project/core/services/completed_orders_services.dart';
import 'package:provider/provider.dart';

import '../components/loading_component.dart';
import '../components/no_order.dart';

class CompletedOrderOverviewPage extends StatefulWidget {
  const CompletedOrderOverviewPage({Key? key}) : super(key: key);

  @override
  State<CompletedOrderOverviewPage> createState() => _CompletedOrderOverviewPageState();
}

class _CompletedOrderOverviewPageState extends State<CompletedOrderOverviewPage>     with TickerProviderStateMixin {
  final bool _isLoading = true;
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 2),
    vsync: this,
  )..forward();
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeIn,
  );

    Future<void> _refreshOrders(BuildContext context) {
    return Provider.of<CompletedOrderServices>(context, listen: false).fetchCompletedOrdersData();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Ordens concluídas'), 
      ),
      body: FutureBuilder(future: Provider.of<CompletedOrderServices>(context, listen: false).fetchCompletedOrdersData(),
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
            return Consumer<CompletedOrderServices>(
              builder: (ctx, completeOrders, child) => completeOrders.items.isEmpty
                  ? FadeTransition(
                      opacity: _animation,
                      child: const NoOrder(),
                    )
                  : RefreshIndicator(
                      onRefresh: () => _refreshOrders(context),
                      child: ListView.builder(
                        itemCount: completeOrders.items.length,
                        itemBuilder: (ctx, i) =>
                            Text(completeOrders.items[i].clientID ?? ''),
                      ),
                    ),
            );
          }
        },
      ),
    );
  }
}