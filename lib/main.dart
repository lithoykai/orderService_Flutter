import 'package:flutter/material.dart';
import 'package:orders_project/components/finished_details.dart';
import 'package:orders_project/core/services/company_client_services.dart';
import 'package:orders_project/core/services/completed_orders_services.dart';
import 'package:orders_project/core/services/employee_services.dart';
import 'package:orders_project/core/services/order_services.dart';
import 'package:orders_project/pages/add_order_page.dart';
import 'package:orders_project/pages/auth_or_home.dart';
import 'package:orders_project/pages/completed_order_page.dart';
import 'package:orders_project/pages/old_pages/finihed_orders_page.dart';
import 'package:orders_project/pages/old_pages/finish_form_page.dart';
import 'package:orders_project/pages/order_detail_page.dart';
import 'package:orders_project/pages/orders_overview_page.dart';
import 'package:orders_project/utils/app_routers.dart';
import 'package:provider/provider.dart';
import 'core/models/auth.dart';
import 'core/models/map_adress.dart';
import 'core/services/old_services/finish_order_list.dart';
import 'core/services/old_services/orders_list.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  final ThemeData theme = ThemeData(
    fontFamily: 'Lato',
  );
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, OrderService>(
            create: (_) => OrderService(),
            update: (context, auth, previous) {
              return OrderService(
                auth.token ?? '',
                auth.userId ?? '',
              );
            }),
        ChangeNotifierProvider(
          create: (_) => CompletedOrderServices(),
        ),
        ChangeNotifierProvider(
          create: (_) => EmployeeServices(),
        ),
        ChangeNotifierProvider(
          create: (_) => CompanyClientServices(),
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
        home: const AuthOrHomePage(),
        title: 'Ordens de Serviço',
        theme: theme.copyWith(
          colorScheme: theme.colorScheme.copyWith(
            secondary: Colors.deepOrange,
            primary: Colors.blue,
          ),
        ),
        routes: {
          AppRoutes.AUTH_OR_HOME: (ctx) => const AuthOrHomePage(),
          AppRoutes.ORDERS_OVERVIEW_PAGE: (ctx) => const OrderOverview(),
          AppRoutes.ADD_ORDER_PAGE: (ctx) => AddOrderPage(),
          AppRoutes.ORDER_DETAIL: (ctx) => const OrderDetailPage(),
          AppRoutes.FINISH_FORM_PAGE: (ctx) => FinishFormPage(),
          AppRoutes.FINISHED_ORDER_PAGE: (ctx) => const FinishedOrdersPage(),
          AppRoutes.FINISHED_DETAILS: (ctx) => const FinishedDetailsWidget(),
          AppRoutes.COMPLETED_ORDER_PAGE: (ctx) => const CompletedOrderPage(),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
