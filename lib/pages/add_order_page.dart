import 'package:flutter/material.dart';
import 'package:orders_project/core/models/order.dart';
import 'package:orders_project/core/services/company_client_services.dart';
import 'package:orders_project/core/services/employee_services.dart';
import 'package:orders_project/core/services/order_services.dart';
import 'package:provider/provider.dart';

import '../components/adaptative_date_picker.dart';

class AddOrderPage extends StatefulWidget {
  const AddOrderPage({Key? key}) : super(key: key);

  @override
  State<AddOrderPage> createState() => _AddOrderPageState();
}

class _AddOrderPageState extends State<AddOrderPage> {
  DateTime _selectedDate = DateTime.now();

  List<String> companyNames = [];
  bool _isLoading = false;

  String dropdownValueClients = '';
  String dropdownValueEmployees = '';

  final _formData = <String, Object>{};
  final _formKey = GlobalKey<FormState>();
  final _titleFocus = FocusNode();
  final _clientFocus = FocusNode();
  final _problemFocus = FocusNode();
  final _employeeFocus = FocusNode();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_formData.isEmpty) {
      final arg = ModalRoute.of(context)?.settings.arguments;

      if (arg != null) {
        final order = arg as Order;
        _formData['_clientFocus'] = order.clientID;
        _formData['_employeeFocus'] = order.technicalID;
        _formData['_problemFocus'] = order.problem;
        _formData['id'] = order.id;
        _formData['title'] = order.title;
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _clientFocus.dispose();
    _problemFocus.dispose();
    _employeeFocus.dispose();
  }

  void onSubmit() async {
    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }

    _formData['creationDate'] = DateTime.now();
    _formData['deadline'] = _selectedDate;
    _formKey.currentState?.save();
    setState(() {
      _isLoading = true;
    });

    try {
      await Provider.of<OrderService>(
        context,
        listen: false,
      ).saveData(_formData).then((value) => setState(() {
            _isLoading = false;
          }));
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

  @override
  Widget build(BuildContext context) {
    final companyNames = Provider.of<CompanyClientServices>(context);
    dropdownValueClients = companyNames.clientNamesList.isNotEmpty
        ? companyNames.clientNamesList.first
        : 'Sem dados.';

    final employees = Provider.of<EmployeeServices>(context);
    dropdownValueEmployees = employees.employeesNames.isNotEmpty
        ? employees.employeesNames.first
        : 'Sem dados.';
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: const Color.fromARGB(255, 240, 240, 240),
        centerTitle: true,
        elevation: 0,
        title: const Text(
          'Adicionar ordem de serviço.',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: _isLoading
          ? Container(
              color: const Color.fromARGB(255, 240, 240, 240),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            )
          : Container(
              color: const Color.fromARGB(255, 240, 240, 240),
              child: SafeArea(
                child: SingleChildScrollView(
                  child: Card(
                    elevation: 1,
                    borderOnForeground: true,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Form(
                        key: _formKey,
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                const SizedBox(height: 16.0),
                                Text(
                                  'Qual técnico efetuará o serviço?'
                                      .toUpperCase(),
                                  style: const TextStyle(
                                    fontSize: 15.0,
                                    fontFamily: 'AvenirNext',
                                    color: Colors.black38,
                                  ),
                                ),
                                const SizedBox(height: 16.0),
                                dropDowntechnical(employees),
                                const SizedBox(height: 16.0),
                                Text(
                                  'Qual cliente está com problemas?'
                                      .toUpperCase(),
                                  style: const TextStyle(
                                    fontSize: 15.0,
                                    fontFamily: 'AvenirNext',
                                    color: Colors.black38,
                                  ),
                                ),
                                const SizedBox(height: 16.0),
                                _dropDownClient(companyNames),
                                const SizedBox(height: 16.0),
                                textFieldFormPattern(
                                  focusNode: _titleFocus,
                                  isOptional: false,
                                  label: 'Título da Ordem',
                                  nameData: 'title',
                                  isNumber: false,
                                  msgValidator:
                                      'Por favor, detalhe com poucas palavras o título para ordem de serviço.',
                                ),
                                const SizedBox(height: 16.0),
                                Text(
                                  'Detalhe o problema.'.toUpperCase(),
                                  style: const TextStyle(
                                    fontSize: 15.0,
                                    fontFamily: 'AvenirNext',
                                    color: Colors.black38,
                                  ),
                                ),
                                const SizedBox(height: 16.0),
                                textFieldFormPattern(
                                  maxLines: true,
                                  focusNode: _problemFocus,
                                  isOptional: false,
                                  label: 'Detalhe o problema.',
                                  nameData: 'problem',
                                  isNumber: false,
                                  msgValidator:
                                      'Por favor, detalhe qual problema está ocorrendo.',
                                ),
                                const SizedBox(height: 16.0),
                                const Text(
                                  'Prazo estimado:',
                                  style: TextStyle(
                                      fontSize: 15.0,
                                      fontFamily: 'AvenirNext',
                                      fontWeight: FontWeight.bold),
                                ),
                                AdaptativeDatePicker(
                                    firstData: DateTime(2022),
                                    lastDate: DateTime(2023),
                                    selectedDate: _selectedDate,
                                    onChangeDate: (newDate) {
                                      setState(() {
                                        _selectedDate = newDate;
                                      });
                                    }),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  child: SizedBox(
                                    height: 45,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.lightGreen),
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
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  Widget textFieldFormPattern(
      {required FocusNode focusNode,
      required String label,
      required String nameData,
      String? msgValidator,
      required bool isOptional,
      bool? isNumber = false,
      bool? enabled,
      bool? maxLines}) {
    return TextFormField(
      maxLines: maxLines == true ? 5 : null,
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

  Widget dropDowntechnical(EmployeeServices employees) {
    return DropdownButtonFormField(
      borderRadius: BorderRadius.circular(8),
      elevation: 0,
      focusColor: Colors.transparent,
      style: const TextStyle(
          fontFamily: 'AvenirNext',
          color: Colors.black,
          fontWeight: FontWeight.w400),
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Técnico responsável.',
      ),
      focusNode: _employeeFocus,
      onSaved: (_employee) {
        String newEmployee = employees.items
            .firstWhere((element) => element.name == _employee)
            .userID;
        _formData['technicalID'] = newEmployee;
      },
      value: dropdownValueEmployees,
      onChanged: (String? newValue) {
        dropdownValueEmployees = newValue!;
      },
      items: employees.employeesNames.map<DropdownMenuItem<String>>(
        (String value) {
          return DropdownMenuItem<String>(
            key: ValueKey<String>(value),
            value: value,
            child: Text(value),
          );
        },
      ).toList(),
    );
  }

  Widget _dropDownClient(CompanyClientServices companyNames) {
    return DropdownButtonFormField(
      borderRadius: BorderRadius.circular(8),
      elevation: 0,
      focusColor: Colors.transparent,
      style: const TextStyle(
          fontFamily: 'AvenirNext',
          color: Colors.black,
          fontWeight: FontWeight.w400),
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Cliente',
      ),
      focusNode: _clientFocus,
      onSaved: (_companyNames) => _formData['clientID'] = companyNames.clients
          .firstWhere((client) => client.name == _companyNames)
          .id,
      value: dropdownValueClients,
      onChanged: (String? newValue) {
        dropdownValueClients = newValue!;
      },
      items: companyNames.clientNamesList.map<DropdownMenuItem<String>>(
        (String value) {
          return DropdownMenuItem<String>(
            key: ValueKey<String>(value),
            value: value,
            child: Text(value),
          );
        },
      ).toList(),
    );
  }
}
