import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import '../../utils/constants.dart';

class MapAdress with ChangeNotifier {
  Future<void> getLatitude(String address) async {
    final response = await http.get(Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?address=$address&key=${Constants.MAPTOKEN}'));
    Map<String, dynamic> data = jsonDecode(response.body);
    data.forEach((key, value) {
      // print(value[0]['geometry']['location']['']);
    });
  }

  static Future<void> openMap(String adress) async {
    final googleMapUrl =
        Uri.parse('https://www.google.com/maps/search/?api=1&query=$adress');

    if (await canLaunchUrl(googleMapUrl)) {
      await launchUrl(googleMapUrl, mode: LaunchMode.externalApplication);
    } else {
      throw '';
    }
  }
}
