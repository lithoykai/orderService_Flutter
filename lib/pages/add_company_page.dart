import 'package:flutter/material.dart';
import 'package:orders_project/core/services/company_client_services.dart';
import 'package:provider/provider.dart';

class AddCompanyPage extends StatefulWidget {
  const AddCompanyPage({Key? key}) : super(key: key);

  @override
  _AddCompanyPageState createState() => _AddCompanyPageState();
}

class _AddCompanyPageState extends State<AddCompanyPage> {
  final FocusNode _nameFocus = FocusNode();
  final FocusNode _tradingNameFocus = FocusNode();
  final FocusNode _districtFocus = FocusNode();
  final FocusNode _cityFocus = FocusNode();
  final FocusNode _andressFocus = FocusNode();
  final FocusNode _complementFocus = FocusNode();
  final FocusNode _landmarkFocus = FocusNode();
  final FocusNode _cnpjFocus = FocusNode();
  final FocusNode _stateRegistrationFocus = FocusNode();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _formData = {};

  @override
  void dispose() {
    super.dispose();
    _nameFocus.dispose();
    _tradingNameFocus.dispose();
    _districtFocus.dispose();
    _cityFocus.dispose();
    _andressFocus.dispose();
    _complementFocus.dispose();
    _landmarkFocus.dispose();
    _cnpjFocus.dispose();
    _stateRegistrationFocus.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adicionar uma nova empresa'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Card(
            margin: const EdgeInsets.all(5),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 16.0),
                    Text(
                      'Informações da empresa'.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 20.0,
                        fontFamily: 'AvenirNext',
                        color: Colors.black38,
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    textFieldFormPattern(
                      focusNode: _nameFocus,
                      label: 'Nome da empresa',
                      nameData: 'name',
                      msgValidator: 'O nome da empresa é obrigatório.',
                      isOptional: false,
                    ),
                    const SizedBox(height: 16.0),
                    textFieldFormPattern(
                      focusNode: _tradingNameFocus,
                      label: 'Nome fantasia (opcional)',
                      nameData: 'trandingName',
                      isOptional: true,
                    ),
                    const SizedBox(height: 16.0),
                    textFieldFormPattern(
                        focusNode: _andressFocus,
                        label: 'Endereço',
                        nameData: 'address',
                        isOptional: false,
                        msgValidator: 'O endereço é obrigatório.'),
                    const SizedBox(height: 16.0),
                    textFieldFormPattern(
                        focusNode: _districtFocus,
                        label: 'Bairro',
                        nameData: 'district',
                        isOptional: false,
                        msgValidator: 'O bairro é obrigatório.'),
                    const SizedBox(height: 16.0),
                    textFieldFormPattern(
                        focusNode: _cityFocus,
                        label: 'Cidade',
                        nameData: 'city',
                        isOptional: false,
                        msgValidator: 'A cidade é obrigatório.'),
                    const SizedBox(height: 16.0),
                    textFieldFormPattern(
                      focusNode: _complementFocus,
                      label: 'Complemento (opcional)',
                      nameData: 'complement',
                      isOptional: true,
                    ),
                    const SizedBox(height: 16.0),
                    textFieldFormPattern(
                      focusNode: _landmarkFocus,
                      label: 'Ponto de Referência (opcional)',
                      nameData: 'landmark',
                      isOptional: true,
                    ),
                    const SizedBox(height: 16.0),
                    textFieldFormPattern(
                        focusNode: _cnpjFocus,
                        label: 'CNPJ da empresa',
                        nameData: 'cnpj',
                        isOptional: false,
                        isNumber: true),
                    const SizedBox(height: 16.0),
                    textFieldFormPattern(
                        focusNode: _stateRegistrationFocus,
                        label: 'Inscrição estadual',
                        nameData: 'stateRegistration',
                        isOptional: false,
                        isNumber: true),
                    const SizedBox(height: 16.0),
                    _saveButton(),
                    const SizedBox(height: 16.0),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _saveButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: SizedBox(
        height: 45,
        child: ElevatedButton(
          child: Text(
            'Salvar'.toUpperCase(),
            style: const TextStyle(
              fontFamily: 'AvenirNext',
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          onPressed: onSubmit,
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
      onSaved: (msg) {
        isNumber == true
            ? _formData[nameData.toString()] = int.parse(msg ?? '')
            : _formData[nameData.toString()] = msg ?? '';
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: label,
      ),
      validator: isOptional
          ? null
          : (String? value) {
              if (nameData == 'cnpj') {
                if (nameData.isEmpty) {
                  return 'Por favor, digite o CNPJ da empresa';
                }
                if (nameData.length != 14) {
                  return 'O CNPJ deve conter 14 dígitos';
                }
                if (int.tryParse(nameData) == null) {
                  return 'O CNPJ deve conter apenas números';
                }
                return null;
              } else {
                if (value == null || value.isEmpty) {
                  return msgValidator ?? 'Há algum problema na sua resposta.';
                }
                return null;
              }
            },
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
