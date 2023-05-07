import 'package:flutter/material.dart';

class LoadingComponent extends StatelessWidget {
  const LoadingComponent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
          color: const Color.fromARGB(255, 240, 240, 240),
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              CircularProgressIndicator(
                color: Colors.black,
              ),
              SizedBox(
                height: 10,
              ),
              Text('Carregando informações...'),
            ],
          )),
    );
  }
}
