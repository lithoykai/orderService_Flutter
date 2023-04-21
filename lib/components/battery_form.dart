import 'dart:io';

import 'package:flutter/material.dart';
import 'package:orders_project/components/image_input.dart';
import 'package:provider/provider.dart';

import '../core/models/battery.dart';
import '../core/services/completed_orders_services.dart';
import 'adaptative_date_picker.dart';

class BatteryForm extends StatefulWidget {
  const BatteryForm({Key? key}) : super(key: key);

  @override
  State<BatteryForm> createState() => _BatteryFormState();
}

class _BatteryFormState extends State<BatteryForm> {
  DateTime _selectedDate = DateTime.now();
  final FocusNode _batteryTypeFocus = FocusNode();
  final FocusNode _rightPlaceObsFocus = FocusNode();
  final FocusNode _manufactureFocus = FocusNode();
  final FocusNode _capacityFocus = FocusNode();
  final FocusNode _modelFocus = FocusNode();
  final FocusNode _bankFocus = FocusNode();
  final FocusNode _batteryForBankFocus = FocusNode();
  final FocusNode _chargerCurrentFocus = FocusNode();
  final FocusNode _chargerVoltageFocus = FocusNode();
  final FocusNode _hasBreakFocus = FocusNode();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _formData = {
    'charger': {},
  };

  File? _pickedImage;
  void _selectImage(File pickedImage) {
    _pickedImage = pickedImage;
  }

  BatteryType _dropDownValue = BatteryType.estacionaria;
  BatteryType _selectedValue = BatteryType.estacionaria;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_formData.isEmpty) {
      final arg =
          Provider.of<CompletedOrderServices>(context, listen: false).battery;

      if (arg != null) {
        final battery =
            Provider.of<CompletedOrderServices>(context, listen: false)
                .battery!;

        _formData['id'] = battery.id;
        _formData['rightPlace'] = battery.rightPlace;
        _formData['rightPlaceImage'] = battery.rightPlaceImage;
        _formData['manufacture'] = battery.manufacture;
        _formData['capacity'] = battery.capacity;
        _formData['model'] = battery.model;
        _formData['bank'] = battery.bank;
        _formData['batteryForBank'] = battery.batteryForBank;
        _formData['charger'] = battery.charger;
        _formData['manufacturingDate'] = battery.manufacturingDate;
        _formData['hasBreaker'] = battery.hasBreaker;
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _batteryTypeFocus.dispose();
    _rightPlaceObsFocus.dispose();
    _manufactureFocus.dispose();
    _capacityFocus.dispose();
    _modelFocus.dispose();
    _bankFocus.dispose();
    _batteryForBankFocus.dispose();
    _chargerCurrentFocus.dispose();
    _chargerVoltageFocus.dispose();
    _hasBreakFocus.dispose();
  }

  void _handleImagePick(File image) {
    _formData['rightPlaceImage'] = image;
  }

  @override
  Widget build(BuildContext context) {
    BatteryType whatType;
    return SafeArea(
      child: SingleChildScrollView(
        child: Card(
          margin: EdgeInsets.all(5),
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Informações da Bateria'.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 20.0,
                      fontFamily: 'AvenirNext',
                      color: Colors.black38,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  _batteryTypeDropdown(),
                  const SizedBox(height: 16.0),
                  textFieldFormPattern(
                    focusNode: _manufactureFocus,
                    label: 'Fabricante da bateria.',
                    nameData: 'manufacture',
                    msgValidator: 'Por favor, digite o fabricante da bateria',
                  ),
                  const SizedBox(height: 16.0),
                  textFieldFormPattern(
                    focusNode: _modelFocus,
                    label: 'Modelo da bateria.',
                    nameData: 'model',
                    msgValidator: 'Por favor, digite o fabricante da bateria',
                  ),
                  const SizedBox(height: 16.0),
                  textFieldFormPattern(
                    focusNode: _capacityFocus,
                    label: 'Capacidade da bateria (Ah)',
                    nameData: 'capacity',
                    msgValidator: 'Por favor, informe um valor válido.',
                  ),
                  const SizedBox(height: 16.0),
                  bank(),
                  const SizedBox(height: 16.0),
                  batteryForBank(),
                  const SizedBox(height: 16.0),
                  const Text('Foto do local de armazenamento:'),
                  const SizedBox(height: 16.0),
                  UserImagePicker(
                    onImagePick: _handleImagePick,
                  ),
                  const SizedBox(height: 16.0),
                  textFieldFormPattern(
                    focusNode: _rightPlaceObsFocus,
                    label: 'Obersevação sobre o local de armazenamento.',
                    nameData: 'rightPlace',
                    msgValidator:
                        'Por favor, digite alguma observação do local de armazenamento das baterias',
                  ),
                  const SizedBox(height: 16.0),
                  const Text(
                    'Data de fabricação da bateria:',
                    style: TextStyle(
                        fontSize: 15.0,
                        fontFamily: 'AvenirNext',
                        fontWeight: FontWeight.bold),
                  ),
                  AdaptativeDatePicker(
                      firstData: DateTime(2005),
                      lastDate: DateTime.now(),
                      selectedDate: _selectedDate,
                      onChangeDate: (newDate) {
                        setState(() {
                          _selectedDate = newDate;
                        });
                      }),
                  const SizedBox(height: 16.0),
                  Text(
                    'Informações do Carregador'.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 20.0,
                      fontFamily: 'AvenirNext',
                      color: Colors.black38,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  chargerCurrent(),
                  const SizedBox(height: 16.0),
                  chargerVoltage(),
                  const SizedBox(height: 16.0),
                  hasBreaker(),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: SizedBox(
                      height: 45,
                      child: ElevatedButton(
                        child: Text(
                          'Salvar e continuar.'.toUpperCase(),
                          style: const TextStyle(
                            fontFamily: 'AvenirNext',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: _submitForm,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _batteryTypeDropdown() {
    return DropdownButtonFormField(
      focusNode: _batteryTypeFocus,
      borderRadius: BorderRadius.circular(8),
      elevation: 0,
      focusColor: Colors.transparent,
      style: const TextStyle(
          fontFamily: 'AvenirNext',
          color: Colors.black,
          fontWeight: FontWeight.w400),
      onSaved: (whatType) =>
          _formData['whatType'] = whatType ?? BatteryType.estacionaria,
      // elevation: 5,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Tipo da bateria',
      ),
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

  Widget textFieldFormPattern({
    required FocusNode focusNode,
    required String label,
    required String nameData,
    String? msgValidator,
  }) {
    return TextFormField(
      initialValue: _formData[nameData]?.toString(),
      focusNode: focusNode,
      onSaved: (msg) => _formData[nameData.toString()] = msg,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: label,
      ),
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return msgValidator ?? 'Há algum problema na sua resposta.';
        }
        return null;
      },
    );
  }

  Widget bank() {
    return TextFormField(
      focusNode: _bankFocus,
      onSaved: (bank) => _formData['bank'] = int.tryParse(bank!) ?? 0,
      textInputAction: TextInputAction.next,
      keyboardType: const TextInputType.numberWithOptions(),
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Banco de baterias',
        hintText: 'Digite o banco de baterias.',
      ),
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return 'Por favor, digite o banco de baterias';
        }
        return null;
      },
    );
  }

  Widget batteryForBank() {
    return TextFormField(
      focusNode: _batteryForBankFocus,
      onSaved: (batteryForBank) =>
          _formData['batteryForBank'] = int.tryParse(batteryForBank!) ?? 0,
      textInputAction: TextInputAction.next,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Número da bateria no banco',
        hintText: 'Digite o número da bateria no banco.',
      ),
      keyboardType: TextInputType.number,
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return 'Por favor, digite o número da bateria no banco';
        }
        final n = num.tryParse(value);
        if (n == null) {
          return 'Por favor, digite um número válido para o número da bateria no banco';
        }
        return null;
      },
    );
  }

  Widget chargerCurrent() {
    return TextFormField(
      focusNode: _chargerCurrentFocus,
      onSaved: (chargerCurrent) {
        if (_formData['charger'] == null) {
          _formData['charger'] = {};
        }
        _formData['charger']['current'] =
            double.tryParse(chargerCurrent!) ?? 0.0;
      },
      textInputAction: TextInputAction.next,
      keyboardType: const TextInputType.numberWithOptions(),
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Valor da corrente do carregador.',
        hintText: 'Digite a corrente do carregador.',
      ),
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return 'Por favor, digite o valor da corrente do carregador';
        }
        return null;
      },
    );
  }

  Widget chargerVoltage() {
    return TextFormField(
      focusNode: _chargerVoltageFocus,
      onSaved: (chargerVoltage) {
        if (_formData['charger'] == null) {
          _formData['charger'] = {};
        }
        _formData['charger']['voltage'] =
            double.tryParse(chargerVoltage!) ?? 0.0;
      },
      textInputAction: TextInputAction.next,
      keyboardType: const TextInputType.numberWithOptions(),
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Valor da voltagem do carregador.',
        hintText: 'Digite a voltagem do carregador.',
      ),
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return 'Por favor, digite o valor da voltagem do carregador';
        }
        return null;
      },
    );
  }

  Widget hasBreaker() {
    return SwitchListTile(
      hoverColor: Colors.transparent,
      focusNode: _hasBreakFocus,
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
    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }
    _formData['id'] = UniqueKey().toString();
    _formData['manufacturingDate'] = _selectedDate.toIso8601String();
    _formKey.currentState!.save();
    print(_formData['rightPlaceImage'] ?? 'BATTERY_FORM: NO IMAGE');
    print(_formData['rightPlaceImage']?.path ?? 'BATTERY_FORM: NO IMAGEPATH');
    Provider.of<CompletedOrderServices>(context, listen: false)
        .saveBatteryFormData(_formData, _formData['rightPlaceImage'])
        .then((value) =>
            Provider.of<CompletedOrderServices>(context, listen: false)
                .switchPageForm());
  }
}
