import 'package:flutter/material.dart';
import 'package:orders_project/components/finished_details.dart';
import 'package:orders_project/pages/add_form_page.dart';
import 'package:orders_project/pages/auth_or_home.dart';
import 'package:orders_project/pages/finihed_orders_page.dart';
import 'package:orders_project/pages/finish_form_page.dart';
import 'package:orders_project/pages/order_detail_page.dart';
import 'package:orders_project/pages/orders_overview_page.dart';
import 'package:orders_project/utils/app_routers.dart';
import 'package:provider/provider.dart';
import 'core/models/auth.dart';
import 'core/models/map_adress.dart';
import 'core/services/finish_order_list.dart';
import 'core/services/orders_list.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  final ThemeData theme = ThemeData(
    fontFamily: 'Lato',
  );
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, OrderList>(
          create: (_) => OrderList(),
          update: (context, auth, previous) {
            return OrderList(
              auth.token ?? '',
              auth.userId ?? '',
              previous?.items ?? [],
            );
          },
        ),
        ChangeNotifierProvider(
          create: (_) => MapAdress(),
        ),
        ChangeNotifierProxyProvider<Auth, FinishOrderList>(
            create: (_) => FinishOrderList(),
            update: (context, auth, previous) {
              return FinishOrderList(
                auth.token ?? '',
                auth.userId ?? '',
                previous?.items ?? [],
              );
            }),
      ],
      child: MaterialApp(
        color: Colors.white,
        home: AuthOrHomePage(),
        title: 'Ordens de Serviço',
        theme: theme.copyWith(
          colorScheme: theme.colorScheme.copyWith(
            secondary: Colors.deepOrange,
            primary: Colors.blue,
          ),
        ),
        routes: {
          AppRoutes.AUTH_OR_HOME: (ctx) => AuthOrHomePage(),
          AppRoutes.ORDERS_OVERVIEW_PAGE: (ctx) => OrderOverview(),
          AppRoutes.ADD_ORDERS_PAGE: (ctx) => AddFormPage(),
          AppRoutes.ORDER_DETAIL: (ctx) => OrderDetailPage(),
          AppRoutes.FINISH_FORM_PAGE: (ctx) => FinishFormPage(),
          AppRoutes.FINISHED_ORDER_PAGE: (ctx) => FinishedOrdersPage(),
          AppRoutes.FINISHED_DETAILS: (ctx) => FinishedDetailsWidget(),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
