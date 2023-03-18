import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/models/old_models/orders.dart';
import '../../core/services/finish_order_list.dart';
import '../../core/services/orders_list.dart';

class FinishFormPage extends StatelessWidget {
  FinishFormPage({Key? key}) : super(key: key);
  final _redeFocus = FocusNode();
  final _ctoBoxFocus = FocusNode();
  final _portFocus = FocusNode();
  final _popInternetFocus = FocusNode();
  final _signalStreetFocus = FocusNode();
  final _signalClientFocus = FocusNode();
  final _descriptionFocus = FocusNode();
  ///////////////////////////////
  final _formData = <String, Object>{};
  final _formKey = GlobalKey<FormState>();
  ////////////////////////////////
  TextEditingController signalController = TextEditingController();
  TextStyle style = const TextStyle(
    fontFamily: 'Lato',
    fontSize: 18,
  );
  ////////////////////

  @override
  Widget build(BuildContext context) {
    final Orders order = ModalRoute.of(context)!.settings.arguments as Orders;

    Future<void> _submitForm() async {
      final isValid = _formKey.currentState?.validate() ?? false;

      if (!isValid) {
        return;
      }

      if (_formData['type'] == 1) {}

      _formKey.currentState?.save();

      try {
        if (order.type == Type.reparo) {
          Map<String, Object> _formRepair = {
            'id': order.id,
            'nameClient': order.nameClient,
            'adressClient': order.adressClient,
            'priority': order.priority,
            'type': order.type,
            'description': _formData['description'] ?? 'Não informado.',
            'loginPPOE': order.loginPPOE ?? '',
            'passwordPPOE': order.passwordPPOE ?? '',
            'signalClient': 0.0,
            'signalStreet': 0.0,
            'rede': 0,
            'ctoBox': 0,
            'port': 0,
            'popInternet': '',
          };
          await Provider.of<FinishOrderList>(
            context,
            listen: false,
          ).saveOrderFinished(_formRepair, order);
        } else if (order.type == Type.instalacao) {
          await Provider.of<FinishOrderList>(
            context,
            listen: false,
          ).saveOrderFinished(_formData, order);
        }
        Provider.of<OrderList>(
          context,
          listen: false,
        ).deleteOrder(order);
        Navigator.of(context).pop();
      } catch (error) {
        await showDialog<void>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Ocorreu um erro!'),
            content: Text(error.toString()),
            actions: [
              TextButton(
                child: const Text('Ok'),
                onPressed: () => Navigator.of(context).pop(context),
              ),
            ],
          ),
        );
      } finally {}
      // Provider.of<OrderList>(
      //   context,
      //   listen: false,
      // ).saveOrder(_formData);
      // Navigator.of(context).pop();
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        title: const Text(
          'Finalizar O.S',
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'Oswald',
            fontWeight: FontWeight.w300,
            fontSize: 22,
          ),
        ),
        elevation: 1,
      ),
      body: Container(
        padding: const EdgeInsets.all(5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 1,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tipo de serviço:',
                      style: TextStyle(
                        color: Colors.grey.shade700,
                      ),
                    ),
                    Text(
                      order.typeText,
                      style: style,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Cliente:',
                      style: TextStyle(
                        color: Colors.grey.shade700,
                      ),
                    ),
                    Text(
                      order.nameClient,
                      style: style,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (order.type.index == 0)
                        Text(
                          'Envie os dados da ${order.typeText}:',
                          style: style,
                        ),
                      if (order.type.index == 0)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Flexible(
                              child: TextFormField(
                                focusNode: _redeFocus,
                                decoration:
                                    const InputDecoration(labelText: 'Rede:'),
                                keyboardType:
                                    const TextInputType.numberWithOptions(),
                                onSaved: (rede) {
                                  _formData['rede'] = int.tryParse(rede!) ?? 0;
                                },
                                validator: (_rede) {
                                  final rede = _rede ?? '';
                                  if (rede.trim().isEmpty) {
                                    return 'O número da rede é obrigatório';
                                  }

                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Flexible(
                              child: TextFormField(
                                focusNode: _ctoBoxFocus,
                                decoration:
                                    const InputDecoration(labelText: 'Caixa:'),
                                onSaved: (ctoBox) {
                                  _formData['ctoBox'] =
                                      int.tryParse(ctoBox!) ?? 0;
                                },
                                keyboardType:
                                    const TextInputType.numberWithOptions(),
                                validator: (_caixa) {
                                  final caixa = _caixa ?? '';
                                  if (caixa.trim().isEmpty) {
                                    return 'O número da caixa é obrigatório';
                                  }

                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                      if (order.type.index == 0)
                        const SizedBox(
                          height: 10,
                        ),
                      if (order.type.index == 0)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Flexible(
                              child: TextFormField(
                                focusNode: _portFocus,
                                decoration:
                                    const InputDecoration(labelText: 'Port:'),
                                keyboardType:
                                    const TextInputType.numberWithOptions(),
                                onSaved: (port) {
                                  _formData['port'] =
                                      int.tryParse(port ?? '') ?? 0;
                                },
                                validator: (_port) {
                                  final port = _port ?? '';
                                  if (port.trim().isEmpty) {
                                    return 'O número da caixa é obrigatório';
                                  }

                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Flexible(
                              child: TextFormField(
                                focusNode: _popInternetFocus,
                                decoration:
                                    const InputDecoration(labelText: 'POP:'),
                                onSaved: (popInternet) {
                                  _formData['popInternet'] =
                                      popInternet ?? 'Não informado.';
                                },
                                validator: (_popInternet) {
                                  final popInternet = _popInternet ?? '';
                                  if (popInternet.trim().isEmpty) {
                                    return 'O pop é obrigatório';
                                  }

                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                      if (order.type.index == 0)
                        TextFormField(
                          focusNode: _signalStreetFocus,
                          decoration: const InputDecoration(
                              labelText: 'Sinal na Caixa:'),
                          onSaved: (signalStreet) {
                            _formData['signalStreet'] =
                                double.tryParse(signalStreet ?? '') ?? 0.0;
                          },
                          keyboardType: const TextInputType.numberWithOptions(),
                          controller: signalController,
                        ),
                      if (order.type.index == 0)
                        const SizedBox(
                          height: 10,
                        ),
                      if (order.type.index == 0)
                        TextFormField(
                          focusNode: _signalClientFocus,
                          decoration: const InputDecoration(
                              labelText: 'Sinal no Cliente:'),
                          keyboardType: const TextInputType.numberWithOptions(),
                          onSaved: (signalClient) {
                            _formData['signalClient'] =
                                double.tryParse(signalClient ?? '') ?? 0.0;
                          },
                          validator: (_signalClient) {
                            final signalClient = _signalClient ?? '';
                            final _signalClientDouble =
                                double.tryParse(_signalClient ?? '');
                            final _signalController =
                                double.tryParse(signalController.text);
                            if (signalClient.trim().isEmpty) {
                              return 'O número da caixa é obrigatório';
                            }
                            if (_signalClientDouble! < _signalController!) {
                              return 'O valor do sinal no cliente está mais baixo que o valor da caixa!';
                            }

                            return null;
                          },
                        ),
                      const SizedBox(
                        height: 10,
                      ),
                      if (order.type.index == 1)
                        TextFormField(
                          focusNode: _descriptionFocus,
                          decoration: const InputDecoration(
                              labelText: 'Descrição do que foi feito:'),
                          onSaved: (description) {
                            _formData['description'] =
                                description ?? 'Não informado';
                          },
                          maxLines: 5,
                          validator: (_description) {
                            return null;
                          },
                        ),
                      Container(
                        alignment: Alignment.center,
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _submitForm,
                          child: const Text('Enviar'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orangeAccent.shade200,
                            fixedSize: const Size(400, 40),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
