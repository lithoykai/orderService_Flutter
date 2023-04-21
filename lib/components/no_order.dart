import 'package:flutter/material.dart';

class NoOrder extends StatelessWidget {
  const NoOrder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 240, 240, 240),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(500),
              child: Image.asset(
                'assets/img/no_orders.jpg',
                height: 250,
                // width: 100,
                fit: BoxFit.fill,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Sem ordens de serviços.',
              style: TextStyle(
                fontSize: 20.0,
                fontFamily: 'AvenirNext',
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
