import 'package:flutter/material.dart';

import '../utils/app_routers.dart';

class MenuDrawer extends StatelessWidget {
  const MenuDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            title: Row(
              children: [
                SizedBox(
                  height: 50,
                  child: Image.asset('assets/img/logo.png'),
                ),
                const Spacer(),
                const Text(
                  'MENU',
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'AvenirNext',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            automaticallyImplyLeading: false,
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.work_outline_rounded),
            title: const Text('Minhas ordens'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(
                AppRoutes.AUTH_OR_HOME,
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.workspace_premium),
            title: const Text('Ordens finalizadas'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(
                AppRoutes.COMPLETED_ORDER_OVERVIEW_PAGE,
              );
            },
          ),
          // Divider(),
          // ListTile(
          //   leading: Icon(Icons.payments),
          //   title: Text('Gerenciar Pedidos'),
          //   onTap: () {
          //     Navigator.of(context).pushReplacementNamed(
          //       AppRoutes.PRODUCTS,
          //     );
          //   },
          // ),
          // Divider(),
          // ListTile(
          //   leading: Icon(Icons.exit_to_app),
          //   title: Text('Sair'),
          //   onTap: () {
          //     Provider.of<Auth>(
          //       context,
          //       listen: false,
          //     ).logout();

          //     Navigator.of(context)
          //         .pushReplacementNamed(AppRoutes.AUTH_OR_HOME);
          //   },
          // ),
        ],
      ),
    );
  }
}
