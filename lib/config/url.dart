import 'package:flutter_dotenv/flutter_dotenv.dart';

final apiUrl = dotenv.env['apiUrl'];

final userUrl = "$apiUrl/user";
final equipmentUrl = "$apiUrl/equipment";

final loginUrl = "$userUrl/login";
final getUserDataUrl = "$userUrl/getUser";

//equipment
final addEquipmentUrl = "$equipmentUrl/addEquipment";
final getEquipmentUrl = "$equipmentUrl/allEquipment";
final postingHistoryUrl = "$equipmentUrl/postingHistory/";
final rentalHistoryUrl = "$equipmentUrl/rentalHistory/";
final rentEquipmentUrl = "$equipmentUrl/rentEquipment";
