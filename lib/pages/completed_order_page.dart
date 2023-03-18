import 'package:flutter/material.dart';

class CompletedOrderPage extends StatelessWidget {
  const CompletedOrderPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(), body: const CircularProgressIndicator());
  }
}
