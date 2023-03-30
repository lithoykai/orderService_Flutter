import 'dart:io';

import 'package:flutter/material.dart';
import 'package:orders_project/components/battery_place_form.dart';
import 'package:orders_project/components/image_input.dart';
import 'package:orders_project/utils/app_routers.dart';
import 'package:provider/provider.dart';

import '../core/models/battery.dart';
import '../core/services/completed_orders_services.dart';

class BatteryForm extends StatefulWidget {
  const BatteryForm({Key? key}) : super(key: key);

  @override
  State<BatteryForm> createState() => _BatteryFormState();
}

class _BatteryFormState extends State<BatteryForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _formData = {};
  File? _pickedImage;

  void _selectImage(File pickedImage) {
    _pickedImage = pickedImage;
  }

  FocusNode _batteryTypeFocus = FocusNode();
  BatteryType _dropDownValue = BatteryType.estacionaria;
  BatteryType _selectedValue = BatteryType.estacionaria;

  @override
  Widget build(BuildContext context) {
    BatteryType whatType;
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16.0),
              const Text(
                'Informações da Bateria',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16.0),
              _batteryTypeDropdown(),
              const SizedBox(height: 16.0),
              Text('Foto do local de armazenamento:'),
              const SizedBox(height: 16.0),
              ImageInput(this._selectImage),
              const SizedBox(height: 16.0),
              _rightPlaceObs(),
              const SizedBox(height: 16.0),
              manufacture(),
              const SizedBox(height: 16.0),
              capacity(),
              const SizedBox(height: 16.0),
              model(),
              const SizedBox(height: 16.0),
              bank(),
              const SizedBox(height: 16.0),
              batteryForBank(),
              const SizedBox(height: 16.0),
              charger(),
              const SizedBox(height: 16.0),
              manufacturingDate(),
              const SizedBox(height: 16.0),
              hasBreaker(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: ElevatedButton(
                  child: const Text('Salvar'),
                  onPressed: _submitForm,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _batteryTypeDropdown() {
    return DropdownButtonFormField(
      focusNode: _batteryTypeFocus,
      onSaved: (whatType) =>
          _formData['whatType'] = whatType ?? BatteryType.litio,
      decoration: const InputDecoration(labelText: 'Tipo da bateria'),
      items: const [
        DropdownMenuItem(
          child: Text('Estacionária'),
          value: BatteryType.estacionaria,
        ),
        DropdownMenuItem(
          child: Text('Lítio'),
          value: BatteryType.litio,
        ),
        DropdownMenuItem(
          child: Text('Selada'),
          value: BatteryType.selada,
        ),
      ],
      value: _dropDownValue,
      onChanged: dropDownCallBack,
    );
  }

  void dropDownCallBack(BatteryType? selectedValue) {
    if (selectedValue is Type) {
      _dropDownValue = selectedValue!;
      setState(() {
        _selectedValue = selectedValue;
      });
    }
  }

  Widget _rightPlaceObs() {
    return TextFormField(
      onSaved: (rightPlace) => _formData['rightPlace'] = rightPlace,
      decoration: const InputDecoration(
        labelText: 'Observação do local de armazenamento.',
        hintText:
            'Digite alguma observação do local de armazenamento das baterias.',
      ),
    );
  }

  Widget manufacture() {
    return TextFormField(
      onSaved: (manufacture) => _formData['manufacture'] = manufacture,
      decoration: const InputDecoration(
        labelText: 'Fabricante da bateria.',
        hintText: 'Digite o fabricante da bateria.',
      ),
    );
  }

  Widget capacity() {
    return TextFormField(
      onSaved: (capacity) => _formData['capacity'] = capacity,
      decoration: const InputDecoration(
        labelText: 'Capacidade da bateria (Ah)',
        hintText: 'Digite a capacidade da bateria em Ah.',
      ),
      keyboardType: TextInputType.number,
    );
  }

  Widget model() {
    return TextFormField(
      onSaved: (model) => _formData['model'] = model,
      decoration: const InputDecoration(
        labelText: 'Modelo da bateria',
        hintText: 'Digite o modelo da bateria.',
      ),
    );
  }

  Widget bank() {
    return TextFormField(
      onSaved: (bank) => _formData['bank'] = bank,
      decoration: const InputDecoration(
        labelText: 'Banco de baterias',
        hintText: 'Digite o banco de baterias.',
      ),
    );
  }

  Widget batteryForBank() {
    return TextFormField(
      onSaved: (batteryForBank) => _formData['batteryForBank'] = batteryForBank,
      decoration: const InputDecoration(
        labelText: 'Número da bateria no banco',
        hintText: 'Digite o número da bateria no banco.',
      ),
      keyboardType: TextInputType.number,
    );
  }

  Widget charger() {
    return TextFormField(
      onSaved: (charger) => _formData['charger'] = charger,
      decoration: const InputDecoration(
        labelText: 'Carregador',
        hintText: 'Digite o carregador.',
      ),
    );
  }

  Widget manufacturingDate() {
    return TextFormField(
      onSaved: (manufacturingDate) =>
          _formData['manufacturingDate'] = manufacturingDate,
      decoration: const InputDecoration(
        labelText: 'Data de fabricação da bateria',
        hintText: 'Digite a data de fabricação da bateria.',
      ),
    );
  }

  Widget hasBreaker() {
    return SwitchListTile(
      title: const Text('Possui Disjuntor?'),
      value: _formData['hasBreaker'] ?? false,
      onChanged: (bool? value) {
        if (value != null) {
          setState(() {
            _formData['hasBreaker'] = value;
          });
        }
      },
    );
  }

  void _submitForm() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    _formData['righPlaceImage'] = _pickedImage;
    _formKey.currentState!.save();

    Provider.of<CompletedOrderServices>(context, listen: false)
        .switchPageForm();
  }
}
