import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AdaptativeDatePicker extends StatelessWidget {
  final DateTime firstData;
  final DateTime lastDate;
  final DateTime selectedDate;
  final Function(DateTime) onChangeDate;

  const AdaptativeDatePicker({
    Key? key,
    required this.selectedDate,
    required this.onChangeDate,
    required this.firstData,
    required this.lastDate,
  }) : super(key: key);

  _showDatePicker(
    BuildContext context,
    DateTime firstData,
    DateTime lastDate,
  ) {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2005),
      lastDate: DateTime(2025),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }

      onChangeDate(pickedDate);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? SizedBox(
            height: 180,
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.date,
              initialDateTime: DateTime.now(),
              minimumDate: DateTime(2020),
              maximumDate: DateTime.now(),
              onDateTimeChanged: onChangeDate,
            ),
          )
        : SizedBox(
            height: 70,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Data selecionada: ${DateFormat('dd/MM/yy').format(selectedDate)}',
                    style: const TextStyle(fontFamily: 'AvenirNext'),
                  ),
                ),
                ElevatedButton(
                  onPressed: () =>
                      _showDatePicker(context, firstData, lastDate),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                  ),
                  child: const Text(
                    'Selecionar data',
                    style: TextStyle(
                      fontFamily: 'AvenirNext',
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}
