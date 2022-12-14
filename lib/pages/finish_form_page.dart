import 'package:flutter/material.dart';
import 'package:orders_project/models/finish_order_list.dart';
import 'package:provider/provider.dart';

import '../models/orders.dart';
import '../models/orders_list.dart';

class FinishFormPage extends StatelessWidget {
  const FinishFormPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _redeFocus = FocusNode();
    final _ctoBoxFocus = FocusNode();
    final _portFocus = FocusNode();
    final _popInternetFocus = FocusNode();
    final _signalStreetFocus = FocusNode();
    final _signalClientFocus = FocusNode();
    final _descriptionFocus = FocusNode();
    ///////////////////////////////
    final _formData = Map<String, Object>();
    final _formKey = GlobalKey<FormState>();
    ////////////////////////////////
    final Orders order = ModalRoute.of(context)!.settings.arguments as Orders;
    TextEditingController signalController = TextEditingController();
    TextStyle style = const TextStyle(
      fontFamily: 'Lato',
      fontSize: 18,
    );
    ////////////////////
    Future<void> _submitForm() async {
      final isValid = _formKey.currentState?.validate() ?? false;

      // print(_formData);
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
            'description': _formData['description'] as String,
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
            title: Text('Ocorreu um erro!'),
            content: Text(error.toString()),
            actions: [
              TextButton(
                child: Text('Ok'),
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

      print(_formData);
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
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        title: Text(
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
                      'Tipo de servi??o:',
                      style: TextStyle(
                        color: Colors.grey.shade700,
                      ),
                    ),
                    Text(
                      order.typeText,
                      style: style,
                    ),
                    SizedBox(
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
                    SizedBox(
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
                                decoration: InputDecoration(labelText: 'Rede:'),
                                keyboardType: TextInputType.numberWithOptions(),
                                onSaved: (rede) {
                                  _formData['rede'] = int.tryParse(rede!) ?? 0;
                                },
                                validator: (_rede) {
                                  final rede = _rede ?? '';
                                  if (rede.trim().isEmpty) {
                                    return 'O n??mero da rede ?? obrigat??rio';
                                  }

                                  return null;
                                },
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Flexible(
                              child: TextFormField(
                                focusNode: _ctoBoxFocus,
                                decoration:
                                    InputDecoration(labelText: 'Caixa:'),
                                onSaved: (ctoBox) {
                                  _formData['ctoBox'] =
                                      int.tryParse(ctoBox!) ?? 0;
                                },
                                keyboardType: TextInputType.numberWithOptions(),
                                validator: (_caixa) {
                                  final caixa = _caixa ?? '';
                                  if (caixa.trim().isEmpty) {
                                    return 'O n??mero da caixa ?? obrigat??rio';
                                  }

                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                      if (order.type.index == 0)
                        SizedBox(
                          height: 10,
                        ),
                      if (order.type.index == 0)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Flexible(
                              child: TextFormField(
                                focusNode: _portFocus,
                                decoration: InputDecoration(labelText: 'Port:'),
                                keyboardType: TextInputType.numberWithOptions(),
                                onSaved: (port) {
                                  _formData['port'] =
                                      int.tryParse(port ?? '') ?? 0;
                                },
                                validator: (_port) {
                                  final port = _port ?? '';
                                  if (port.trim().isEmpty) {
                                    return 'O n??mero da caixa ?? obrigat??rio';
                                  }

                                  return null;
                                },
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Flexible(
                              child: TextFormField(
                                focusNode: _popInternetFocus,
                                decoration: InputDecoration(labelText: 'POP:'),
                                onSaved: (popInternet) {
                                  _formData['popInternet'] =
                                      popInternet ?? 'N??o informado.';
                                },
                                validator: (_popInternet) {
                                  final popInternet = _popInternet ?? '';
                                  if (popInternet.trim().isEmpty) {
                                    return 'O pop ?? obrigat??rio';
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
                          decoration:
                              InputDecoration(labelText: 'Sinal na Caixa:'),
                          onSaved: (signalStreet) {
                            _formData['signalStreet'] =
                                double.tryParse(signalStreet ?? '') ?? 0.0;
                          },
                          keyboardType: TextInputType.numberWithOptions(),
                          controller: signalController,
                        ),
                      if (order.type.index == 0)
                        SizedBox(
                          height: 10,
                        ),
                      if (order.type.index == 0)
                        TextFormField(
                          focusNode: _signalClientFocus,
                          decoration:
                              InputDecoration(labelText: 'Sinal no Cliente:'),
                          keyboardType: TextInputType.numberWithOptions(),
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
                              return 'O n??mero da caixa ?? obrigat??rio';
                            }
                            if (_signalClientDouble! < _signalController!) {
                              return 'O valor do sinal no cliente est?? mais baixo que o valor da caixa!';
                            }

                            return null;
                          },
                        ),
                      SizedBox(
                        height: 10,
                      ),
                      if (order.type.index == 1)
                        TextFormField(
                          focusNode: _descriptionFocus,
                          decoration: InputDecoration(
                              labelText: 'Descri????o do que foi feito:'),
                          onSaved: (description) {
                            _formData['description'] =
                                description ?? 'N??o informado';
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
                          child: Text('Enviar'),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.orangeAccent.shade200,
                            fixedSize: Size(400, 40),
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
