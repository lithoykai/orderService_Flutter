import 'package:flutter/material.dart';
import 'package:orders_project/components/battery_place_form.dart';
import 'package:orders_project/core/services/company_client_services.dart';
import 'package:orders_project/core/services/completed_orders_services.dart';
import 'package:orders_project/core/services/employee_services.dart';
import 'package:orders_project/core/services/firebase_services.dart';
import 'package:orders_project/core/services/order_services.dart';
import 'package:orders_project/pages/add_employee_page.dart';
import 'package:orders_project/pages/add_order_page.dart';
import 'package:orders_project/pages/auth_or_home.dart';
import 'package:orders_project/pages/completed_order_page.dart';
import 'package:orders_project/pages/orders_overview_page.dart';
import 'package:orders_project/utils/app_routers.dart';
import 'package:provider/provider.dart';
import 'core/models/auth.dart';
import 'core/models/map_adress.dart';
import 'pages/add_company_page.dart';

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
          create: (_) => OrderService('', '', []),
          update: (context, auth, previous) {
            return OrderService(
              auth.token ?? '',
              auth.userId ?? '',
              [],
            );
          },
        ),
        ChangeNotifierProxyProvider<Auth, CompanyClientServices>(
          create: (_) => CompanyClientServices(''),
          update: (context, auth, previous) {
            return CompanyClientServices(auth.token ?? '');
          },
        ),
        ChangeNotifierProxyProvider<Auth, EmployeeServices>(
          create: (_) => EmployeeServices(''),
          update: (context, auth, previous) {
            return EmployeeServices(auth.token ?? '');
          },
        ),
        ChangeNotifierProxyProvider<Auth, CompletedOrderServices>(
          create: (_) => CompletedOrderServices('', [], ''),
          update: (context, auth, previous) {
            return CompletedOrderServices(
                auth.token ?? '', previous?.items ?? [], auth.userId ?? '');
          },
        ),
        ChangeNotifierProvider(
          create: (_) => FirebaseServices(),
        ),
        ChangeNotifierProvider(
          create: (_) => MapAdress(),
        ),
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
          AppRoutes.ADD_ORDER_PAGE: (ctx) => const AddOrderPage(),
          AppRoutes.COMPLETED_ORDER_PAGE: (ctx) => const CompletedOrderForm(),
          AppRoutes.ADD_EMPLOYEES_PAGE: (ctx) => const AddEmployeePage(),
          AppRoutes.ADD_COMPANY_PAGE: (ctx) => const AddCompanyPage(),
          AppRoutes.BATTERY_PLACE_FORM: (ctx) => const BatteryPlaceForm(),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
