import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:orders_project/pages/orders_overview_page.dart';
import 'package:provider/provider.dart';

import '../models/orders_list.dart';
import '../utils/app_routers.dart';
import 'add_form_page.dart';
import 'finihed_orders_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

int _currentIndex = 0;

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    OrderList orderList = Provider.of<OrderList>(context);
    final tabs = [
      OrderOverview(),
      FinishedOrdersPage(),
      AddFormPage(),
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
        // leading: Padding(
        //   padding: const EdgeInsets.all(5.0),
        //   child: Image.asset('assets/img/logo.png'),
        // ),
        // // leadingWidth: 40,
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
      bottomNavigationBar: BubbleBottomBar(
        opacity: .2,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {});
          setState(() {
            _currentIndex = index!;
          });
        },
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        elevation: 10,
        fabLocation: BubbleBottomBarFabLocation.end, //new
        hasNotch: true, //new
        hasInk: true, //new, gives a cute ink effect
        backgroundColor: Colors.white,
        inkColor: Colors.black, //optional, uses theme color if not specified
        items: <BubbleBottomBarItem>[
          BubbleBottomBarItem(
              showBadge: orderList.itemsCount == 0 ? false : true,
              badge: Text(orderList.itemsCount.toString()),
              badgeColor: Colors.red,
              backgroundColor: Colors.black,
              icon: Icon(
                Icons.dashboard,
                color: Colors.black,
              ),
              activeIcon: Icon(
                Icons.dashboard,
                color: Colors.black,
              ),
              title: Text("Ordens")),
          BubbleBottomBarItem(
              backgroundColor: Colors.green,
              icon: Icon(
                Icons.access_time,
                color: Colors.black,
              ),
              activeIcon: Icon(
                Icons.access_time,
                color: Colors.green,
              ),
              title: Text("Finalizadas")),
        ],
      ),
      body: tabs[_currentIndex],
    );
  }
}
      // appBar: AppBar(
      //   title: Text('Ordens de Serviço'),
      //   actions: [
      //     Center(
      //       child: Stack(
      //         children: [
      //           Text(
      //             'Total de ordens: ${orders.itemsCount.toString()}',
      //           ),
      //         ],
      //       ),
      //     ),
      //     IconButton(
      //         onPressed: () async {
      //           Navigator.of(context)
      //               .pushNamed(
      //                 AppRoutes.ADD_ORDERS_PAGE,
      //               )
      //               .then((value) =>
      //                   Provider.of<OrderList>(context).loadProducts());
      //         },
      //         icon: Icon(Icons.add))
      //   ],
      // ),
      // body: tabs[_currentIndex],