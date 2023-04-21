import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/models/auth.dart';

class AddEmployeePage extends StatefulWidget {
  const AddEmployeePage({Key? key}) : super(key: key);

  @override
  _AddEmployeePageState createState() => _AddEmployeePageState();
}

class _AddEmployeePageState extends State<AddEmployeePage> {
  final FocusNode _nameFocus = FocusNode();
  final FocusNode _districtFocus = FocusNode();
  final FocusNode _andressFocus = FocusNode();
  final FocusNode _cityFocus = FocusNode();
  final FocusNode _complementFocus = FocusNode();
  final FocusNode _landmarkFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _cpfFocus = FocusNode();

  bool isLoading = false;
  final _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _formData = {};

  @override
  void dispose() {
    super.dispose();
    _nameFocus.dispose();
    _districtFocus.dispose();
    _emailFocus.dispose();
    _andressFocus.dispose();
    _complementFocus.dispose();
    _landmarkFocus.dispose();
    _cityFocus.dispose();
    _passwordFocus.dispose();
    _cpfFocus.dispose();
  }

  Future<void> _onSubmit() async {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) {
      return;
    }
    setState(() {
      isLoading = true;
    });

    _formKey.currentState?.save();
    Auth _auth = Provider.of(context, listen: false);

    try {
      await _auth
          .signupEmployee(_formData)
          .then((value) => Navigator.of(context).pop(true));
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

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adicionar novo funcionário'),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SafeArea(
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
                            'Informações do funcionário'.toUpperCase(),
                            style: const TextStyle(
                              fontSize: 20.0,
                              fontFamily: 'AvenirNext',
                              color: Colors.black38,
                            ),
                          ),
                          const SizedBox(height: 16),
                          textFieldFormPattern(
                            focusNode: _nameFocus,
                            isOptional: false,
                            label: 'Nome do funcionário',
                            nameData: 'name',
                            isNumber: false,
                            msgValidator:
                                'Por favor, digite o nome do funcionário.',
                          ),
                          const SizedBox(height: 16),
                          textFieldFormPattern(
                            focusNode: _cpfFocus,
                            isOptional: false,
                            label: 'CPF',
                            nameData: 'cpf',
                            isNumber: true,
                          ),
                          const SizedBox(height: 16.0),
                          Text(
                            'Informações de endereço'.toUpperCase(),
                            style: const TextStyle(
                              fontSize: 20.0,
                              fontFamily: 'AvenirNext',
                              color: Colors.black38,
                            ),
                          ),
                          const SizedBox(height: 16),
                          textFieldFormPattern(
                            focusNode: _andressFocus,
                            isOptional: false,
                            label: 'Endereço',
                            nameData: 'andress',
                            isNumber: false,
                            msgValidator:
                                'Por favor, digite o endereço onde o funcionário mora.',
                          ),
                          const SizedBox(height: 16),
                          textFieldFormPattern(
                            focusNode: _districtFocus,
                            isOptional: false,
                            label: 'Bairro',
                            nameData: 'district',
                            isNumber: false,
                            msgValidator:
                                'Por favor, digite o bairro onde o funcionário mora.',
                          ),
                          const SizedBox(height: 16),
                          textFieldFormPattern(
                            focusNode: _complementFocus,
                            isOptional: true,
                            label: 'Complemento (opcional)',
                            nameData: 'complement',
                            isNumber: false,
                          ),
                          const SizedBox(height: 16),
                          textFieldFormPattern(
                            focusNode: _landmarkFocus,
                            isOptional: true,
                            label: 'Ponto de referência (opcional)',
                            nameData: 'landmark',
                            isNumber: false,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Informações de login'.toUpperCase(),
                            style: const TextStyle(
                              fontSize: 20.0,
                              fontFamily: 'AvenirNext',
                              color: Colors.black38,
                            ),
                          ),
                          const SizedBox(height: 16),
                          _emailField(),
                          const SizedBox(height: 16),
                          _passwordFiel(),
                          _saveButton(),
                        ],
                      ),
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
              if (value == null || value.isEmpty) {
                return msgValidator ?? 'Há algum problema na sua resposta.';
              }
              return null;
            },
    );
  }

  Widget _emailField() {
    return TextFormField(
      focusNode: _emailFocus,
      textInputAction: TextInputAction.next,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'E-mail',
        hintText: 'Digite o e-mail do funcionário',
      ),
      onSaved: (email) => _formData['email'] = email,
      validator: (_email) {
        final email = _email ?? '';
        if (email.trim().isEmpty || !email.contains('@')) {
          return 'Informe um email válido';
        }
        return null;
      },
      keyboardType: TextInputType.emailAddress,
    );
  }

  Widget _passwordFiel() {
    return TextFormField(
      focusNode: _passwordFocus,
      textInputAction: TextInputAction.next,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Senha do funcionário',
        hintText: 'Digite a senha que o funcionário usará',
      ),
      controller: _passwordController,
      obscureText: true,
      onSaved: (password) => _formData['password'] = password,
      validator: (_password) {
        final password = _password ?? '';
        if (password.isEmpty || password.length < 5) {
          return 'Informe uma senha válida (no minímo 5 caracteres)';
        }
        return null;
      },
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
          onPressed: _onSubmit,
        ),
      ),
    );
  }
}
