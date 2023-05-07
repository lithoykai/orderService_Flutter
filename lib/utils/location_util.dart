import 'package:orders_project/utils/constants.dart';

class LocationUtil {
  static String generateLocationPreviewImage({
    String? address,
  }) {
    return 'https://maps.googleapis.com/maps/api/staticmap?center=$address&zoom=18&size=600x300&maptype=roadmap&markers=color:red%7Clabel:A%$address&key=${Constants.MAPTOKEN}';
  }
}
