import 'package:flutter_dotenv/flutter_dotenv.dart';

final apiUrl = dotenv.env['apiUrl'];

final userUrl = "$apiUrl/user";
final equipmentUrl = "$apiUrl/equipment";

final loginUrl = "$userUrl/login";

//Equipment related urls
final addEquipmentUrl = "$equipmentUrl/";
final deleteEquipmentUrl = "$equipmentUrl/";
final getAvailableEquipmentUrl = "$equipmentUrl/available";
final postingHistoryUrl = "$equipmentUrl/postings";
final rentalHistoryUrl = "$equipmentUrl/rentals";
final rentEquipmentUrl = "$equipmentUrl/rent";
