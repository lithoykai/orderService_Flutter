import 'package:flutter/material.dart';

class AddOrderPage extends StatelessWidget {
  const AddOrderPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adicionar ordem de Serviço.'),
      ),
      body: const Center(child: CircularProgressIndicator()),
    );
  }
}
