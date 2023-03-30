import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class NobreakForm extends StatefulWidget {
  const NobreakForm({Key? key}) : super(key: key);

  @override
  State<NobreakForm> createState() => _NobreakFormState();
}

class _NobreakFormState extends State<NobreakForm> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Nobreak Form'),
    );
  }
}
