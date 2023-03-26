import 'package:flutter/material.dart';

enum BatteryType { estacionaria, selada, litio }

class Charger {
  final double voltage;
  final double current;

  Charger(this.voltage, this.current);
}

class BatteryForm extends StatefulWidget {
  const BatteryForm({Key? key}) : super(key: key);

  @override
  _BatteryFormState createState() => _BatteryFormState();
}

class _BatteryFormState extends State<BatteryForm> {
  final _formKey = GlobalKey<FormState>();
  final _formData = <String, dynamic>{};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Battery Form'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Right Place'),
                  onSaved: (value) => _formData['rightPlace'] = value,
                ),
                const SizedBox(height: 16.0),
                DropdownButtonFormField<BatteryType>(
                  decoration: const InputDecoration(labelText: 'Type'),
                  items: BatteryType.values
                      .map((type) => DropdownMenuItem(
                            value: type,
                            child: Text(type.toString().split('.')[1]),
                          ))
                      .toList(),
                  onChanged: (value) =>
                      _formData['whatType'] = value?.toString(),
                  onSaved: (value) => _formData['whatType'] = value?.toString(),
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Right Place Image'),
                  onSaved: (value) => _formData['rightPlaceImage'] = value,
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Manufacture'),
                  onSaved: (value) => _formData['manufacture'] = value,
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Capacity'),
                  onSaved: (value) => _formData['capacity'] = value,
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Model'),
                  onSaved: (value) => _formData['model'] = value,
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Bank'),
                  keyboardType: TextInputType.number,
                  onSaved: (value) =>
                      _formData['bank'] = int.tryParse(value ?? ''),
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Battery for Bank'),
                  keyboardType: TextInputType.number,
                  onSaved: (value) =>
                      _formData['batteryForBank'] = int.tryParse(value ?? ''),
                ),
                const SizedBox(height: 16.0),
                // TextFormField(
                //   decoration: InputDecoration(labelText: 'Charger Voltage'),
                //   keyboardType: TextInputType.number,
                //   onSaved: (value) {
                //     final voltage = double.tryParse(value ?? '');
                //     final current = _formData['charger']?['current'] ?? 0.0;
                //     _formData['charger'] = Charger(voltage, current);
                //   },
                // ),
                const SizedBox(height: 16.0),
                // TextFormField(
                //   decoration: InputDecoration(labelText: 'Charger Current'),
                //   keyboardType: TextInputType.number,
                //   onSaved: (value) {
                //     final current = double.tryParse(value ?? '');
                //     final voltage = _formData['charger']?['voltage'] ?? 0.0;
                //     _formData['charger'] = Charger(voltage, current);
                //   },
                // ),
                const SizedBox(height: 16.0),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Manufacturing Date'),
                  keyboardType: TextInputType.datetime,
                  onSaved: (value) => _formData['manufacturingDate'] =
                      DateTime.tryParse(value ?? ''),
                ),
                const SizedBox(height: 16.0),
                SwitchListTile(
                  title: const Text('Has Breaker'),
                  value: _formData['hasBreaker'] ?? false,
                  onChanged: (value) =>
                      setState(() => _formData['hasBreaker'] = value),
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  child: const Text('Save'),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // void _submitForm() {
  //   if (_formKey.currentState.validate()) {
  //     _formKey.currentState.save();
  //     print(_formData);
  //   }
  // }
}
