import 'package:flutter/material.dart';
import 'package:orders_project/core/services/company_client_services.dart';
import 'package:provider/provider.dart';


class AddCompanyPage extends StatefulWidget {
  const AddCompanyPage({Key? key}) : super(key: key);

  @override
  _AddCompanyPageState createState() => _AddCompanyPageState();
}

class _AddCompanyPageState extends State<AddCompanyPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _formData = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adicionar nova empresa'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 16.0),
                  const Text(
                    'Informações da empresa',
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16.0),
                  _buildNameField(),
                  const SizedBox(height: 16.0),
                  _buildTradingNameField(),
                  const SizedBox(height: 16.0),
                  _buildAddressField(),
                  const SizedBox(height: 16.0),
                  _buildDistrictField(),
                  const SizedBox(height: 16.0),
                  _buildCityField(),
                  const SizedBox(height: 16.0),
                  _buildComplementField(),
                  const SizedBox(height: 16.0),
                  _buildLandmarkField(),
                  const SizedBox(height: 16.0),
                  _buildCnpjField(),
                  const SizedBox(height: 16.0),
                  _buildStateRegistrationField(),
                  const SizedBox(height: 32.0),
                  _buildSubmitButton(),
                  const SizedBox(height: 16.0),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNameField() {
    return TextFormField(
      onSaved: (name) => _formData['name'] = name,
      decoration: const InputDecoration(
        labelText: 'Nome da empresa',
        hintText: 'Digite o nome da empresa',
      ),
      validator: (name) {
        if (name == null || name.isEmpty) {
          return 'Por favor, digite o nome da empresa';
        }
        return null;
      },
    );
  }

  Widget _buildTradingNameField() {
    return TextFormField(
      onSaved: (tradingName) => _formData['tradingName'] = tradingName,
      decoration: const InputDecoration(
        labelText: 'Nome fantasia (opcional)',
        hintText: 'Digite o nome fantasia da empresa (opcional)',
      ),
    );
  }

  Widget _buildDistrictField() {
    return TextFormField(
      onSaved: (district) => _formData['district'] = district,
      decoration: const InputDecoration(
        labelText: 'Bairro',
        hintText: 'Digite o bairro onde a empresa está localizada',
      ),
      validator: (district) {
        if (district == null || district.isEmpty) {
          return 'Por favor, digite o bairro onde a empresa está localizada';
        }
        return null;
      },
    );
  }

  Widget _buildCityField() {
    return TextFormField(
      onSaved: (city) => _formData['city'] = city,
      decoration: const InputDecoration(
        labelText: 'Cidade',
        hintText: 'Digite a cidade onde a empresa está localizada',
      ),
      validator: (city) {
        if (city == null || city.isEmpty) {
          return 'Por favor, digite a cidade onde a empresa está localizada';
        }
        return null;
      },
    );
  }

  Widget _buildAddressField() {
    return TextFormField(
      onSaved: (address) => _formData['address'] = address,
      decoration: const InputDecoration(
        labelText: 'Endereço',
        hintText: 'Digite o endereço da empresa',
      ),
      validator: (address) {
        if (address == null || address.isEmpty) {
          return 'Por favor, digite o endereço da empresa';
        }
        return null;
      },
    );
  }

  Widget _buildComplementField() {
    return TextFormField(
      onSaved: (complement) => _formData['complement'] = complement,
      decoration: const InputDecoration(
        labelText: 'Complemento (opcional)',
        hintText: 'Digite o complemento (se houver)',
      ),
    );
  }

  Widget _buildLandmarkField() {
    return TextFormField(
      onSaved: (landmark) => _formData['landmark'] = landmark,
      decoration: const InputDecoration(
        labelText: 'Ponto de referência (opcional)',
        hintText: 'Digite um ponto de referência (se houver)',
      ),
    );
  }

  Widget _buildCnpjField() {
    return TextFormField(
      onSaved: (cnpj) => _formData['cnpj'] = int.parse(cnpj ?? ''),
      decoration: const InputDecoration(
        labelText: 'CNPJ',
        hintText: 'Digite o CNPJ da empresa',
      ),
      validator: (cnpj) {
        if (cnpj == null || cnpj.isEmpty) {
          return 'Por favor, digite o CNPJ da empresa';
        }
        if (cnpj.length != 14) {
          return 'O CNPJ deve conter 14 dígitos';
        }
        if (int.tryParse(cnpj) == null) {
          return 'O CNPJ deve conter apenas números';
        }
        return null;
      },
    );
  }

  Widget _buildStateRegistrationField() {
    return TextFormField(
      onSaved: (stateRegistration) =>
          _formData['stateRegistration'] = int.parse(stateRegistration ?? ''),
      decoration: const InputDecoration(
        labelText: 'Inscrição estadual',
        hintText: 'Digite a inscrição estadual da empresa',
      ),
      validator: (stateRegistration) {
        if (stateRegistration == null || stateRegistration.isEmpty) {
          return 'Por favor, digite a inscrição estadual da empresa';
        }
        if (int.tryParse(stateRegistration) == null) {
          return 'A inscrição estadual deve conter apenas números';
        }
        return null;
      },
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed: onSubmit,
      child: const Text('Salvar'),
    );
  }

  void onSubmit() async {
    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }
    if (_formData['type'] == 1) {}

    _formKey.currentState?.save();
    try {
      await Provider.of<CompanyClientServices>(
        context,
        listen: false,
      ).addData(_formData);
      Navigator.of(context).pop(true);
    } catch (error) {
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
    } finally {}
  }
}
