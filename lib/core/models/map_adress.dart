import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class MapAdress with ChangeNotifier {
  static Future<void> openMap(String adress) async {
    // final response = await http.get(
    //   Uri.parse(
    //       'https://nominatim.openstreetmap.org/search/$adress%20Recife%20Pernambuco?format=json&addressdetails=1&limit=1&polygon_svg=1'),
    // );

    // final body = jsonDecode(response.body);
    // final lat = double.parse(body[0]['lat']);
    // final lon = double.parse(body[0]['lon']);

    final googleMapUrl =
        Uri.parse('https://www.google.com/maps/search/?api=1&query=$adress');

    if (await canLaunchUrl(googleMapUrl)) {
      await launchUrl(googleMapUrl, mode: LaunchMode.externalApplication);
    } else {
      throw '';
    }
  }
}
