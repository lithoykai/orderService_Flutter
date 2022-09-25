import 'package:flutter/material.dart';
import 'package:orders_project/components/finished_orders_box.dart';
import 'package:orders_project/models/finish_order_list.dart';
import 'package:provider/provider.dart';

import '../models/finish_order.dart';

class FinishedOrdersPage extends StatefulWidget {
  const FinishedOrdersPage({Key? key}) : super(key: key);

  @override
  State<FinishedOrdersPage> createState() => _FinishedOrdersPageState();
}

class _FinishedOrdersPageState extends State<FinishedOrdersPage> {
  bool _isLoading = true;
  @override
  void initState() {
    super.initState();
    Provider.of<FinishOrderList>(
      context,
      listen: false,
    ).loadFinishedOrder().then((value) {
      setState(() => _isLoading = false);
    });
  }

  Future<void> _refreshOrders(BuildContext context) {
    return Provider.of<FinishOrderList>(context, listen: false)
        .loadFinishedOrder();
  }

  @override
  Widget build(BuildContext context) {
    FinishOrderList finishedOrder = Provider.of<FinishOrderList>(context);
    List<FinishOrder> items = finishedOrder.items;
    TextEditingController _controller = TextEditingController();
    if (_controller.text.isNotEmpty)
      items = finishedOrder.items
          .where(
            (e) => e.nameClient.toString().toLowerCase().contains(
                  _controller.text.toLowerCase(),
                ),
          )
          .toList();
    else
      items = finishedOrder.items;
    return Scaffold(
      backgroundColor: Colors.white,
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: () => _refreshOrders(context),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 10),
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: 'Procurar por ordem finalizada.',
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(width: 0, color: Colors.black),
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onChanged: finishedOrder.onChanged,
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                        itemCount: items.length,
                        itemBuilder: (ctx, i) {
                          return FinishedOrdersBox(items[i]);
                        }),
                  ),
                ],
              ),
            ),
    );
  }
}
