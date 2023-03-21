import 'package:flutter/material.dart';
import 'package:orders_project/core/models/employee.dart';
import 'package:orders_project/core/services/company_client_services.dart';
import 'package:orders_project/core/services/employee_services.dart';
import 'package:orders_project/core/services/order_services.dart';
import 'package:provider/provider.dart';

class AddOrderPage extends StatefulWidget {
  @override
  State<AddOrderPage> createState() => _AddOrderPageState();
}

class _AddOrderPageState extends State<AddOrderPage> {
  List<String> companyNames = [];
  bool _isLoading = true;

  String dropdownValueClients = '';
  String dropdownValueEmployees = '';

  final _formData = <String, Object>{};
  final _formKey = GlobalKey<FormState>();

  final _clientFocus = FocusNode();
  final _problemFocus = FocusNode();
  final _employeeFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    Provider.of<CompanyClientServices>(context, listen: false)
        .fetchOrdersData()
        .then((_) => Provider.of<EmployeeServices>(context, listen: false)
                .fetchOrdersData()
                .then((_) {
              setState(() {
                _isLoading = false;
              });
            }));
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
    if (_formData['type'] == 1) {}

    _formKey.currentState?.save();
    print(_formData);

    try {
      await Provider.of<OrderService>(
        context,
        listen: false,
      ).saveData(_formData);
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
        title: const Text('Adicionar ordem de Serviço.'),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Qual técnico efetuará o serviço?'),
                    DropdownButtonFormField(
                      onSaved: (_employee) {
                        Employee newEmployee = employees.items
                            .firstWhere((element) => element.name == _employee);
                        _formData['employee'] = newEmployee;
                      },
                      value: dropdownValueEmployees,
                      onChanged: (String? newValue) {
                        dropdownValueEmployees = newValue!;
                      },
                      items: employees.employeesNames
                          .map<DropdownMenuItem<String>>(
                        (String value) {
                          return DropdownMenuItem<String>(
                            key: ValueKey<String>(value),
                            value: value,
                            child: Text(value),
                          );
                        },
                      ).toList(),
                    ),
                    const Text('Qual cliente está com problemas?'),
                    DropdownButtonFormField(
                      onSaved: (_companyNames) => _formData['companyNames'] =
                          companyNames.clients.firstWhere(
                              (client) => client.name == _companyNames),
                      value: dropdownValueClients,
                      onChanged: (String? newValue) {
                        dropdownValueClients = newValue!;
                      },
                      items: companyNames.clientNamesList
                          .map<DropdownMenuItem<String>>(
                        (String value) {
                          return DropdownMenuItem<String>(
                            key: ValueKey<String>(value),
                            value: value,
                            child: Text(value),
                          );
                        },
                      ).toList(),
                    ),
                    Text('Detalhe o problema.'),
                    TextFormField(
                      onSaved: (problem) => _formData['problem'] =
                          problem ?? 'Problema não detalhado.',
                      focusNode: _problemFocus,
                      maxLines: 5,
                    ),
                    Container(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: onSubmit,
                        child: const Text('Enviar ordem de serviço'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
