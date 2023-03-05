import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/models/orders.dart';
import '../core/services/orders_list.dart';

class AddFormPage extends StatefulWidget {
  AddFormPage({
    Key? key,
  }) : super(key: key);

  @override
  State<AddFormPage> createState() => _AddFormPageState();
}

class _AddFormPageState extends State<AddFormPage> {
  Type _dropDownValue = Type.instalacao;
  Pri _dropDownValuePri = Pri.normal;
  Type _selectedValue = Type.instalacao;
  ////////////Focus
  final _nameFocus = FocusNode();
  final _adressFocus = FocusNode();
  final _descriptionFocus = FocusNode();
  final _priorityFocus = FocusNode();
  final _typeFocus = FocusNode();
  final _loginPPOEFocus = FocusNode();
  final _passwordPPOEFocus = FocusNode();
  /////////////
  final _formData = Map<String, Object>();
  final _formKey = GlobalKey<FormState>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_formData.isEmpty) {
      final arg = ModalRoute.of(context)?.settings.arguments;

      if (arg != null) {
        final order = arg as Orders;
        _formData['id'] = order.id;
        _formData['nameClient'] = order.nameClient;
        _formData['adressClient'] = order.adressClient;
        _formData['loginPPOE'] = order.loginPPOE ?? 'Não informado';
        _formData['passwordPPOE'] = order.passwordPPOE ?? 'Não informado';
        _formData['description'] = order.description ?? '';
        _formData['priority'] = order.priority;
        _formData['type'] = order.type;
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _nameFocus.dispose();
    _adressFocus.dispose();
    _descriptionFocus.dispose();

    _priorityFocus.dispose();
    _typeFocus.dispose();
  }

  Future<void> _submitForm() async {
    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }

    if (_formData['type'] == 1) {}

    _formKey.currentState?.save();

    try {
      await Provider.of<OrderList>(
        context,
        listen: false,
      ).saveOrder(_formData);
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
              onPressed: () => Navigator.of(context).pop(),
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

    // print(_formData);
  }

  void dropDownCallBack(Type? selectedValue) {
    if (selectedValue is Type) {
      _dropDownValue = selectedValue;
      setState(() {
        _selectedValue = selectedValue;
      });
    }
  }

  void dropDownCallBackPri(Pri? selectedValue) {
    if (selectedValue is Pri) {
      _dropDownValuePri = selectedValue;
    }
  }

  @override
  Widget build(BuildContext context) {
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
          'Adicionar Ordem de Serviço',
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'Oswald',
            fontWeight: FontWeight.w300,
            fontSize: 22,
          ),
        ),
        elevation: 1,
        actions: [
          IconButton(
            onPressed: _submitForm,
            icon: Icon(Icons.save),
            color: Colors.black,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              DropdownButtonFormField(
                focusNode: _typeFocus,
                onSaved: (type) => _formData['type'] = type ?? 'Cancelamento',
                decoration: const InputDecoration(labelText: 'Tipo de serviço'),
                items: const [
                  DropdownMenuItem(
                    child: Text('Instalação'),
                    value: Type.instalacao,
                  ),
                  DropdownMenuItem(
                    child: Text('Reparo'),
                    value: Type.reparo,
                  ),
                  DropdownMenuItem(
                    child: Text('Cancelamento'),
                    value: Type.cancelamento,
                  ),
                ],
                value: _dropDownValue,
                onChanged: dropDownCallBack,
              ),
              TextFormField(
                initialValue: _formData['nameClient']?.toString(),
                decoration: const InputDecoration(labelText: 'Nome do cliente'),
                focusNode: _nameFocus,
                onSaved: (nameClient) =>
                    _formData['nameClient'] = nameClient ?? '',
                validator: (_nameClient) {
                  final nameClient = _nameClient ?? '';
                  if (nameClient.trim().isEmpty) {
                    return 'O nome do cliente é obrigatório';
                  }
                  if (nameClient.trim().length < 3) {
                    return 'O nome precisa no mínimo de 3 letras.';
                  }

                  return null;
                },
              ),
              TextFormField(
                  initialValue: _formData['adressClient']?.toString(),
                  decoration: const InputDecoration(labelText: 'Endereço:'),
                  keyboardType: TextInputType.streetAddress,
                  focusNode: _adressFocus,
                  onSaved: (adressClient) =>
                      _formData['adressClient'] = adressClient ?? '',
                  validator: (_adressClient) {
                    final adressClient = _adressClient ?? '';

                    if (adressClient.trim().isEmpty) {
                      return 'O endereço é obrigatório';
                    }
                    if (adressClient.trim().length < 3) {
                      return 'Endereço muito pequeno.';
                    }
                    return null;
                  }),
              DropdownButtonFormField(
                focusNode: _priorityFocus,
                onSaved: (priority) =>
                    _formData['priority'] = priority ?? 'Normal',
                decoration: const InputDecoration(labelText: 'Prioridade'),
                items: const [
                  DropdownMenuItem(
                    child: Text('Alta'),
                    value: Pri.alta,
                  ),
                  DropdownMenuItem(
                    child: Text('Normal'),
                    value: Pri.normal,
                  ),
                  DropdownMenuItem(
                    child: Text('Baixa'),
                    value: Pri.baixa,
                  ),
                ],
                value: _dropDownValuePri,
                onChanged: dropDownCallBackPri,
              ),
              _dropDownValue == Type.instalacao || _dropDownValue == Type.reparo
                  ? TextFormField(
                      initialValue: _formData['loginPPOE']?.toString(),
                      decoration:
                          const InputDecoration(labelText: 'Login PPOE:'),
                      focusNode: _loginPPOEFocus,
                      onSaved: (loginPPOE) =>
                          _formData['loginPPOE'] = loginPPOE ?? '',
                    )
                  : Container(),
              _dropDownValue == Type.instalacao || _dropDownValue == Type.reparo
                  ? TextFormField(
                      initialValue: _formData['passwordPPOE']?.toString(),
                      decoration:
                          const InputDecoration(labelText: 'Senha PPOE:'),
                      focusNode: _passwordPPOEFocus,
                      onSaved: (passwordPPOE) =>
                          _formData['passwordPPOE'] = passwordPPOE ?? '',
                    )
                  : Container(),
              TextFormField(
                focusNode: _descriptionFocus,
                onSaved: (description) =>
                    _formData['description'] = description ?? '',
                decoration: const InputDecoration(
                    labelText: 'Descrição do serviço (opcional):'),
                keyboardType: TextInputType.multiline,
                maxLines: 4,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
