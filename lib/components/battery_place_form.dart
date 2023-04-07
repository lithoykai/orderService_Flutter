import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/models/battery_place.dart';
import '../core/services/completed_orders_services.dart';

class BatteryPlaceForm extends StatefulWidget {
  const BatteryPlaceForm({Key? key}) : super(key: key);

  @override
  _BatteryPlaceFormState createState() => _BatteryPlaceFormState();
}

class _BatteryPlaceFormState extends State<BatteryPlaceForm> {
  final _formKey = GlobalKey<FormState>();
  final _formData = <String, dynamic>{};

  final FocusNode _tempFocus = FocusNode();
  final FocusNode _lightFocus = FocusNode();
  final FocusNode _ventilationFocus = FocusNode();
  final FocusNode _cleanPlaceFocus = FocusNode();
  final FocusNode _reverseKeyFocus = FocusNode();
  final FocusNode _inputFrameFocus = FocusNode();
  final FocusNode _outputFrameFocus = FocusNode();
  final FocusNode _hasMaterialsCloseFocus = FocusNode();
  final FocusNode _materialsCloseFocus = FocusNode();

  void _submitForm() {
    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }

    _formKey.currentState!.save();

    _formData['id'] = UniqueKey().toString();
    print(_formData);
    Provider.of<CompletedOrderServices>(context, listen: false)
        .saveBatteryPlaceFormData(_formData)
        .then((value) =>
            Provider.of<CompletedOrderServices>(context, listen: false)
                .switchPageForm());
  }

  Ventilation? _ventilationValue;
  Ilumination? _illuminationValue;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Card(
          margin: const EdgeInsets.all(5),
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Informações do local'.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 20.0,
                      fontFamily: 'AvenirNext',
                      color: Colors.black38,
                    ),
                  ),
                  const SizedBox(height: 16),
                  textFieldFormPattern(
                    focusNode: _tempFocus,
                    label: 'Temperatura do local (opcional).',
                    nameData: 'temp',
                    isOptional: true,
                  ),
                  const SizedBox(height: 16),
                  _dropDownVentilation(),
                  const SizedBox(height: 16),
                  _dropDownLight(),
                  const SizedBox(height: 16),
                  CheckboxListTile(
                    title: const Text('Local limpo.'),
                    value: _formData['cleanPlace'] ?? false,
                    onChanged: (value) {
                      setState(() {
                        _formData['cleanPlace'] = value;
                      });
                    },
                  ),
                  CheckboxListTile(
                    title: const Text('Chave reversora externa'),
                    value: _formData['reverseKey'] ?? false,
                    onChanged: (value) {
                      setState(() {
                        _formData['reverseKey'] = value;
                      });
                    },
                  ),
                  CheckboxListTile(
                    title: const Text('Quadro de Entrada'),
                    value: _formData['inputFrame'] ?? false,
                    onChanged: (value) {
                      setState(() {
                        _formData['inputFrame'] = value;
                      });
                    },
                  ),
                  CheckboxListTile(
                    title: const Text('Quadro de Saída'),
                    value: _formData['outputFrame'] ?? false,
                    onChanged: (value) {
                      setState(() {
                        _formData['outputFrame'] = value;
                      });
                    },
                  ),
                  CheckboxListTile(
                    title: const Text('Materiais próximos ao equipamento?'),
                    value: _formData['hasMaterialsClose'] ?? false,
                    onChanged: (value) {
                      setState(() {
                        _formData['hasMaterialsClose'] = value;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Quais materias',
                    ),
                    enabled: _formData['hasMaterialsClose'] ?? false,
                    onSaved: (value) {
                      _formData['materialsClose'] = value ?? '';
                    },
                  ),
                  const SizedBox(height: 16.0),
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

  Widget textFieldFormPattern({
    required FocusNode focusNode,
    required String label,
    required String nameData,
    String? msgValidator,
    required bool isOptional,
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
      validator: isOptional
          ? null
          : (String? value) {
              if (value == null || value.isEmpty) {
                return msgValidator ?? 'Há algum problema na sua resposta.';
              }
              return null;
            },
    );
  }

  Widget _dropDownVentilation() {
    return DropdownButtonFormField<Ventilation>(
      borderRadius: BorderRadius.circular(8),
      elevation: 0,
      focusColor: Colors.transparent,
      style: const TextStyle(
          fontFamily: 'AvenirNext',
          color: Colors.black,
          fontWeight: FontWeight.w400),
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Ventilação do local.',
      ),
      value: _ventilationValue,
      onChanged: (value) {
        setState(() {
          _ventilationValue = value;
        });
      },
      onSaved: (value) {
        _formData['Ventilação do local.'] = value;
      },
      validator: (value) {
        if (value == null) {
          return 'Por favor, selecione a ventilação do local.';
        }
        return null;
      },
      items: const [
        DropdownMenuItem(
          child: Text('Ar-condicionado'),
          value: Ventilation.arcondicionado,
        ),
        DropdownMenuItem(
          child: Text('Exaustor'),
          value: Ventilation.exautor,
        ),
        DropdownMenuItem(
          child: Text('Não possui ventilação.'),
          value: Ventilation.naotem,
        ),
      ],
    );
  }

  Widget _dropDownLight() {
    return DropdownButtonFormField<Ilumination>(
      borderRadius: BorderRadius.circular(8),
      elevation: 0,
      focusColor: Colors.transparent,
      style: const TextStyle(
          fontFamily: 'AvenirNext',
          color: Colors.black,
          fontWeight: FontWeight.w400),
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Ventilação do local.',
      ),
      value: _illuminationValue,
      onChanged: (value) {
        setState(() {
          _illuminationValue = value;
        });
      },
      onSaved: (value) {
        _formData['lights'] = value;
      },
      validator: (value) {
        if (value == null) {
          return 'Por favor, selecione a iluminação do local.';
        }
        return null;
      },
      items: const [
        DropdownMenuItem(
          child: Text('Boa'),
          value: Ilumination.good,
        ),
        DropdownMenuItem(
          child: Text('Moderada'),
          value: Ilumination.moderate,
        ),
        DropdownMenuItem(
          child: Text('Normal'),
          value: Ilumination.normal,
        ),
        DropdownMenuItem(
          child: Text('Ruim'),
          value: Ilumination.bad,
        ),
      ],
    );
  }
}
