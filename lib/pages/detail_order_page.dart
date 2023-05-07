import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:orders_project/core/models/company_client.dart';
import 'package:orders_project/core/models/map_adress.dart';
import 'package:orders_project/utils/location_util.dart';

import '../core/models/order.dart';

class DetailOrderPage extends StatelessWidget {
  const DetailOrderPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List _detailData = ModalRoute.of(context)!.settings.arguments as List;
    final CompanyClient _company = _detailData[0];
    final Order _order = _detailData[1];

    return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.black),
          backgroundColor: const Color.fromARGB(255, 240, 240, 240),
          centerTitle: true,
          elevation: 0,
          title: const Text(
            'Detalhes',
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            color: const Color.fromARGB(255, 240, 240, 240),
            padding: const EdgeInsets.all(1.0),
            child: Card(
              elevation: 0,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Informações do Cliente'.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 20.0,
                        fontFamily: 'AvenirNext',
                        color: Colors.black38,
                      ),
                    ),
                    const Divider(),
                    const SizedBox(height: 10.0),
                    Row(
                      children: [
                        const Icon(Icons.business, size: 20),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          _company.name.toString(),
                          style: const TextStyle(
                            // fontFamily: 'Gotham',
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.map, size: 20),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Text(
                            _company.address.toString(),
                            style: const TextStyle(
                              // fontFamily: 'Gotham',
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    const Text(
                      'Clique no mapa para abrir rota.',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    GestureDetector(
                      onTap: () =>
                          MapAdress.openMap(_company.address + _company.city),
                      child: Image.network(
                        LocationUtil.generateLocationPreviewImage(
                            address: _company.address + _company.city),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    Text(
                      'Informações do Serviço'.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 20.0,
                        fontFamily: 'AvenirNext',
                        color: Colors.black38,
                      ),
                    ),
                    const Divider(),
                    const SizedBox(height: 10.0),
                    Row(
                      children: [
                        const Icon(Icons.title, size: 20),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          _order.title.toString(),
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10.0),
                    Row(
                      children: [
                        const Icon(Icons.date_range_outlined, size: 20),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Data de criação: ${DateFormat(DateFormat.YEAR_MONTH_DAY, 'pt_Br').format(_order.creationDate)}',
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10.0),
                    Row(
                      children: [
                        const Icon(Icons.date_range, size: 20),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Prazo: ${DateFormat(DateFormat.YEAR_MONTH_DAY, 'pt_Br').format(_order.deadline)}',
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10.0),
                    Row(
                      children: [
                        const Icon(Icons.description, size: 20),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Text(
                            _order.problem.toString(),
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
