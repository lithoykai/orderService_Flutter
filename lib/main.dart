import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:orders_project/components/battery_place_form.dart';
import 'package:orders_project/core/services/company_client_services.dart';
import 'package:orders_project/core/services/completed_orders_services.dart';
import 'package:orders_project/core/services/employee_services.dart';
import 'package:orders_project/core/services/firebase_services.dart';
import 'package:orders_project/core/services/order_services.dart';
import 'package:orders_project/firebase_options.dart';
import 'package:orders_project/pages/add_employee_page.dart';
import 'package:orders_project/pages/add_order_page.dart';
import 'package:orders_project/pages/auth_or_home.dart';
import 'package:orders_project/pages/completed_order_page.dart';
import 'package:orders_project/pages/completed_overview_page.dart';
import 'package:orders_project/pages/detail_order_page.dart';
import 'package:orders_project/pages/orders_overview_page.dart';
import 'package:orders_project/utils/app_routers.dart';
import 'package:orders_project/utils/map_adress.dart';
import 'package:provider/provider.dart';
import 'core/models/auth.dart';
import 'pages/add_company_page.dart';
import 'package:intl/date_symbol_data_local.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  initializeDateFormatting('pt_BR', null).then((_) => runApp(MyApp()));
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
          AppRoutes.DETAIL_ORDER_PAGE: (ctx) => const DetailOrderPage(),
          AppRoutes.COMPLETED_ORDER_PAGE: (ctx) => const CompletedOrderForm(),
          AppRoutes.ADD_EMPLOYEES_PAGE: (ctx) => const AddEmployeePage(),
          AppRoutes.ADD_COMPANY_PAGE: (ctx) => const AddCompanyPage(),
          AppRoutes.BATTERY_PLACE_FORM: (ctx) => const BatteryPlaceForm(),
          AppRoutes.COMPLETED_ORDER_OVERVIEW_PAGE: (ctx) =>
              const CompletedOrderOverviewPage(),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
