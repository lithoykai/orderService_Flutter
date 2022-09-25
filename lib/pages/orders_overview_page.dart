import 'package:flutter/material.dart';
import 'package:orders_project/components/order_box.dart';
import 'package:orders_project/models/orders_list.dart';
import 'package:orders_project/pages/add_form_page.dart';
import 'package:orders_project/pages/finihed_orders_page.dart';
import 'package:orders_project/utils/app_routers.dart';
import 'package:provider/provider.dart';
import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';

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
    // WidgetsBinding.instance!.addPostFrameCallback((_) {
    //   Provider.of<OrderList>(context, listen: false).reloadOrder;
    //   setState(() {});
    // });

    return _isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : orders.itemsCount == 0
            ? Center(
                child: Text('Não há ordens de serviços!'),
              )
            : RefreshIndicator(
                onRefresh: () => _refreshOrders(context),
                child: ListView.builder(
                    itemCount: orders.itemsCount,
                    itemBuilder: (ctx, i) => OrderBox(orders.items[i])),
              );
  }
}
