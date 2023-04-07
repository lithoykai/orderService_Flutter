import 'package:flutter/material.dart';
import 'package:orders_project/pages/orders_overview_page.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import '../core/models/auth.dart';
import 'auth_page.dart';

class AuthOrHomePage extends StatelessWidget {
  const AuthOrHomePage({Key? key}) : super(key: key);

  Future<void> init(BuildContext context) async {
    Auth auth = Provider.of(context);
    await Firebase.initializeApp();
    await auth.tryAutoLogin();
  }

  @override
  Widget build(BuildContext context) {
    Auth auth = Provider.of(context);
    return FutureBuilder(
      future: init(context),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.error != null) {
          return const Center(
            child: Text('Ocorreu um erro!'),
          );
        } else {
          return auth.isAuth ? const OrderOverview() : const AuthPage();
        }
      },
    );
  }
}
