import 'package:flutter/material.dart';
import 'package:orders_project/components/battery_form.dart';
import 'package:orders_project/components/battery_place_form.dart';
import 'package:orders_project/core/services/completed_orders_services.dart';
import 'package:provider/provider.dart';

import '../components/nobreak_form.dart';

class CompletedOrderForm extends StatefulWidget {
  const CompletedOrderForm({Key? key}) : super(key: key);

  @override
  State<CompletedOrderForm> createState() => _CompletedOrderFormState();
}

class _CompletedOrderFormState extends State<CompletedOrderForm> {
  @override
  Widget build(BuildContext context) {
    List<Widget> _flowFormPages = [
      const BatteryForm(),
      const BatteryPlaceForm(),
      NobreakForm(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Finalizar ordem de serviço.'),
        actions: [
          IconButton(
              onPressed: () {
                Provider.of<CompletedOrderServices>(context, listen: false)
                    .switchPageForm();
              },
              icon: Icon(Icons.arrow_forward_ios))
        ],
      ),
      body: SingleChildScrollView(
        child: Consumer<CompletedOrderServices>(
            builder: (context, value, child) =>
                _flowFormPages[value.indexToSwitch]),
      ),
    );
  }
}
