import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/order_box.dart';
import '../core/services/orders_list.dart';
import '../utils/app_routers.dart';
import 'finihed_orders_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

int _currentIndex = 0;

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    Provider.of<OrderList>(
      context,
      listen: false,
    ).loadOrder();
  }

  @override
  Widget build(BuildContext context) {
    OrderList orderList = Provider.of<OrderList>(context);
    final tabs = <Widget>[
      Scaffold(
        body: RefreshIndicator(
          onRefresh: () => Provider.of<OrderList>(
            context,
            listen: false,
          ).loadOrder(),
          child: ListView.builder(
              itemCount: orderList.itemsCount,
              itemBuilder: (ctx, i) => OrderBox(orderList.items[i])),
        ),
      ),
      FinishedOrdersPage(),
      // AddFormPage(),
    ];
    // return Center(
    //   child: Text('Texto'),
    // );
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          _currentIndex == 0 ? 'Ordens de Serviço' : 'Ordens finalizadas',
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'Oswald',
            fontSize: 22,
          ),
        ),
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(AppRoutes.ADD_ORDERS_PAGE).then(
              (value) =>
                  Provider.of<OrderList>(context, listen: false).loadOrder());
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.orangeAccent,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Ordens',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.access_time),
            label: 'Serviços finalizados',
          ),
        ],
        currentIndex: _currentIndex,
        selectedItemColor: Colors.amber[800],
        onTap: (index) {
          print(index);
          setState(() {
            // Provider.of<OrderList>(context).loadOrder();
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
