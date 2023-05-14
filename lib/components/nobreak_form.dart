import 'package:flutter/material.dart';
import 'package:orders_project/core/services/order_services.dart';
import 'package:orders_project/utils/app_routers.dart';
import 'package:provider/provider.dart';

import '../core/models/order.dart';
import '../core/services/completed_orders_services.dart';

class NobreakForm extends StatefulWidget {
  const NobreakForm({
    Key? key,
  }) : super(key: key);

  @override
  _NobreakFormState createState() => _NobreakFormState();
}

class _NobreakFormState extends State<NobreakForm> {
  final _formKey = GlobalKey<FormState>();
  final _formData = <String, dynamic>{
    'upsCurrent': {},
    'voltage': {},
  };
  final _inputVoltageFocus = FocusNode();
  final _outputVoltageFocus = FocusNode();
  final _inputUPSCurrentFocus = FocusNode();
  final _outputUPSCurrentFocus = FocusNode();
  final _frequencyEquipFocus = FocusNode();
  final _ipCommunicationFocus = FocusNode();
  final _passwordCommunicationFocus = FocusNode();
  final _hasCommunicationBoardFocus = FocusNode();

  @override
  void dispose() {
    _inputVoltageFocus.dispose();
    _hasCommunicationBoardFocus.dispose();
    _outputVoltageFocus.dispose();
    _inputUPSCurrentFocus.dispose();
    _outputUPSCurrentFocus.dispose();
    _frequencyEquipFocus.dispose();
    _ipCommunicationFocus.dispose();
    _passwordCommunicationFocus.dispose();
    super.dispose();
    context.mounted;
  }

  void _submitForm() async {
    Order order = ModalRoute.of(context)?.settings.arguments as Order;
    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }

    _formData['id'] = UniqueKey().toString();
    _formKey.currentState!.save();
    try {
      await Provider.of<CompletedOrderServices>(context, listen: false)
          .saveNobreakFormData(_formData)
          .then((value) async =>
              await Provider.of<OrderService>(context, listen: false)
                  .removeOrder(order));
      Navigator.pushNamedAndRemoveUntil(
          context, AppRoutes.COMPLETED_ORDER_OVERVIEW_PAGE, (route) => false);
    } catch (error) {
      if (mounted) {
        await showDialog<void>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Ocorreu um erro!'),
            content: Text(error.toString()),
            actions: [
              TextButton(
                child: const Text('Ok'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
      } else {}
    } finally {}
  }

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
                  const Text(
                    'Tensão do Nobreak:',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontFamily: 'AvenirNext',
                      color: Colors.black38,
                    ),
                  ),
                  const Divider(),
                  const SizedBox(height: 16.0),
                  Row(
                    children: [
                      Expanded(
                        child: voltageOrCurrentForm(
                          focusNode: _inputVoltageFocus,
                          labelText: 'Tensão de Entrada',
                          inputOrOutput: 'input',
                          isCurrent: false,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: voltageOrCurrentForm(
                          focusNode: _outputVoltageFocus,
                          labelText: 'Tensão de Saída',
                          inputOrOutput: 'output',
                          isCurrent: false,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  const Text(
                    'Corrente do Nobreak:',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontFamily: 'AvenirNext',
                      color: Colors.black38,
                    ),
                  ),
                  const Divider(),
                  const SizedBox(height: 16.0),
                  Row(
                    children: [
                      Expanded(
                        child: voltageOrCurrentForm(
                          focusNode: _inputUPSCurrentFocus,
                          labelText: 'Corrente de Entrada',
                          inputOrOutput: 'input',
                          isCurrent: true,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: voltageOrCurrentForm(
                          focusNode: _outputUPSCurrentFocus,
                          labelText: 'Corrente de Saída',
                          inputOrOutput: 'output',
                          isCurrent: true,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  textFieldFormPattern(
                    label: 'Frequência do Equipamento.',
                    focusNode: _frequencyEquipFocus,
                    nameData: 'frequencyEquip',
                    msgValidator: 'Informe uma frequência válida',
                    isOptional: false,
                  ),
                  const SizedBox(height: 16.0),
                  SwitchListTile(
                    focusNode: _hasCommunicationBoardFocus,
                    title: const Text(
                      'Possui placa de comunicação?',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontFamily: 'AvenirNext',
                        color: Colors.black87,
                      ),
                    ),
                    value: _formData['hasCommunicationBoard'] ?? false,
                    onChanged: (bool? value) {
                      if (value != null) {
                        setState(() {
                          _formData['hasCommunicationBoard'] = value;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 16.0),
                  textFieldFormPattern(
                    label: 'Endereço IP de comunicação.',
                    isNumber: true,
                    enabled: _formData['hasCommunicationBoard'] ?? false,
                    focusNode: _ipCommunicationFocus,
                    nameData: 'ip',
                    msgValidator: 'Informe um endereço IP válido',
                    isOptional: true,
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    enabled: _formData['hasCommunicationBoard'] ?? false,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Senha de comunicação.',
                    ),
                    focusNode: _passwordCommunicationFocus,
                    obscureText: true,
                    onFieldSubmitted: (_) {
                      _submitForm();
                    },
                    onSaved: (value) {
                      _formData['password'] = value!.trim();
                    },
                  ),
                  const SizedBox(height: 16),
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
    bool? isNumber = false,
    bool? enabled,
  }) {
    return TextFormField(
      enabled: enabled,
      focusNode: focusNode,
      keyboardType: isNumber == true ? TextInputType.number : null,
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

  Widget voltageOrCurrentForm({
    required FocusNode focusNode,
    required String labelText,
    required bool isCurrent,
    required String inputOrOutput,
  }) {
    return TextFormField(
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: labelText.toString(),
      ),
      focusNode: focusNode,
      validator: (value) {
        if (value!.trim().isEmpty) {
          return 'Informe um valor válido.';
        }
        return null;
      },
      onSaved: (value) {
        if (isCurrent == true) {
          if (_formData['upsCurrent'] == null) {
            _formData['upsCurrent'] = {};
          }
          _formData['upsCurrent'][inputOrOutput] = value!.trim();
        } else {
          if (_formData['voltage'] == null) {
            _formData['voltage'] = {};
          }
          _formData['voltage'][inputOrOutput] = value!.trim();
        }
      },
    );
  }
}
