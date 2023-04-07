import 'package:flutter/material.dart';
import 'package:orders_project/core/models/order.dart';
import 'package:orders_project/core/services/company_client_services.dart';
import 'package:orders_project/core/services/employee_services.dart';
import 'package:orders_project/core/services/order_services.dart';
import 'package:provider/provider.dart';

class AddOrderPage extends StatefulWidget {
  const AddOrderPage({Key? key}) : super(key: key);

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
    Provider.of<CompanyClientServices>(context, listen: false).fetchData().then(
        (_) => Provider.of<EmployeeServices>(context, listen: false)
                .fetchData()
                .then((_) {
              setState(() {
                _isLoading = false;
              });
            }));
  }

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
    if (_formData['type'] == 1) {}

    _formKey.currentState?.save();
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
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Qual técnico efetuará o serviço?'),
                      DropdownButtonFormField(
                        focusNode: _employeeFocus,
                        onSaved: (_employee) {
                          String newEmployee = employees.items
                              .firstWhere(
                                  (element) => element.name == _employee)
                              .userID;
                          _formData['technicalID'] = newEmployee;
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
                        focusNode: _clientFocus,
                        onSaved: (_companyNames) => _formData['clientID'] =
                            companyNames.clients
                                .firstWhere(
                                    (client) => client.name == _companyNames)
                                .id,
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
                      const Text('Detalhe o problema.'),
                      TextFormField(
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_problemFocus);
                        },
                        initialValue: _formData['problem']?.toString(),
                        onSaved: (problem) => _formData['problem'] =
                            problem ?? 'Problema não detalhado.',
                        focusNode: _problemFocus,
                        maxLines: 5,
                      ),
                      SizedBox(
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
            ),
    );
  }
}
