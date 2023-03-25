import 'package:flutter/material.dart';
import 'package:orders_project/exceptions/auth_exception.dart';
import 'package:provider/provider.dart';

import '../core/models/auth.dart';

class AddEmployeePage extends StatefulWidget {
  const AddEmployeePage({Key? key}) : super(key: key);

  @override
  _AddEmployeePageState createState() => _AddEmployeePageState();
}

class _AddEmployeePageState extends State<AddEmployeePage> {
  bool isLoading = false;
  final _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _formData = {};

  Future<void> _submit() async {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) {
      return;
    }
    setState(() {
      isLoading = true;
    });

    _formKey.currentState?.save();
    Auth _auth = Provider.of(context, listen: false);
    print(_formData);

    print('Enviando para o SignUpEmployee');
    await _auth
        .signupEmployee(_formData)
        .then((value) => print('Funcionário adicionado com sucesso.'));

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
                    'Informações do funcionário',
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12.0),
                  _buildNameField(),
                  const SizedBox(height: 12.0),
                  _buildEmailField(),
                  const SizedBox(height: 12.0),
                  _buildDistrictField(),
                  const SizedBox(height: 12.0),
                  _buildAddressField(),
                  const SizedBox(height: 12.0),
                  _buildComplementField(),
                  const SizedBox(height: 12.0),
                  _buildLandmarkField(),
                  const SizedBox(height: 12.0),
                  _buildCpfField(),
                  const SizedBox(height: 12.0),
                  _buildPassword(),
                  if (isLoading)
                    const CircularProgressIndicator()
                  else
                    const SizedBox(height: 32.0),
                  _buildSubmitButton(),
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
      decoration: const InputDecoration(
        labelText: 'Nome completo',
        hintText: 'Digite o nome completo do funcionário',
      ),
      onSaved: (name) => _formData['name'] = name,
    );
  }

  Widget _buildDistrictField() {
    return TextFormField(
      onSaved: (district) => _formData['district'] = district,
      decoration: const InputDecoration(
        labelText: 'Bairro',
        hintText: 'Digite o bairro onde o funcionário mora',
      ),
    );
  }

  Widget _buildAddressField() {
    return TextFormField(
      onSaved: (address) => _formData['address'] = address,
      decoration: const InputDecoration(
        labelText: 'Endereço',
        hintText: 'Digite o endereço do funcionário',
      ),
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      decoration: const InputDecoration(
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

  Widget _buildComplementField() {
    return TextFormField(
      onSaved: (complement) => _formData['complement'] = complement ?? '',
      decoration: const InputDecoration(
        labelText: 'Complemento (opcional)',
        hintText: 'Digite o complemento do endereço (opcional)',
      ),
    );
  }

  Widget _buildLandmarkField() {
    return TextFormField(
      onSaved: (landmark) => _formData['landmark'] = landmark,
      decoration: const InputDecoration(
        labelText: 'Ponto de referência (opcional)',
        hintText:
            'Digite um ponto de referência próximo ao endereço (opcional)',
      ),
    );
  }

  Widget _buildCpfField() {
    return TextFormField(
      onSaved: (cpf) => _formData['CPF'] = int.tryParse(cpf ?? '') ?? 0,
      decoration: const InputDecoration(
        labelText: 'CPF',
        hintText: 'Digite o CPF do funcionário',
      ),
      keyboardType: TextInputType.number,
    );
  }

  Widget _buildPassword() {
    return TextFormField(
      decoration: const InputDecoration(
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

  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed: _submit,
      child: const Text('Adicionar funcionário'),
    );
  }
}
