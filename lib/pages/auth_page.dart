import 'package:flutter/material.dart';
import 'package:orders_project/components/auth_form.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                // color: Colors.white,
                gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(124, 137, 173, 252),
                    Color.fromARGB(255, 255, 255, 255),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            Center(
              child: SizedBox(
                width: double.infinity,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: mediaQuery.size.height * 0.3,
                        child: Image.asset('assets/img/logo.png'),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const AuthForm()
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
