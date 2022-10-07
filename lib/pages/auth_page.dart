import 'package:flutter/material.dart';
import 'package:orders_project/components/auth_form.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(124, 137, 173, 252),
                  Color.fromARGB(255, 248, 183, 109),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          Container(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 70,
                    ),
                    child: Image(
                      image: AssetImage('assets/img/logo.png'),
                    )),
                SizedBox(
                  height: 10,
                ),
                AuthForm()
              ],
            ),
          )
        ],
      ),
    );
  }
}
