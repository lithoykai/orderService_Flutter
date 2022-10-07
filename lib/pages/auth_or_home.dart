import 'package:flutter/material.dart';
import 'package:orders_project/pages/home_page.dart';
import 'package:orders_project/pages/orders_overview_page.dart';
import 'package:provider/provider.dart';

import '../models/auth.dart';
import 'auth_page.dart';

class AuthOrHomePage extends StatelessWidget {
  const AuthOrHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Auth auth = Provider.of(context);
    return FutureBuilder(
      future: auth.tryAutoLogin(),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.error != null) {
          return Center(
            child: Text('Ocorreu um erro!'),
          );
        } else {
          return auth.isAuth ? HomePage() : AuthPage();
        }
      },
    );
  }
}
