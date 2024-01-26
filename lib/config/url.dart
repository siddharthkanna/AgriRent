import 'package:flutter_dotenv/flutter_dotenv.dart';


final apiUrl = dotenv.env['apiUrl'];

final userUrl = "$apiUrl/user";
final equipmentUrl = "$apiUrl/equipment";

final loginUrl = "$userUrl/login";



//equipment
final addEquipmentUrl = "$equipmentUrl/addEquipment";
final getEquipmentUrl = "$equipmentUrl/allEquipment";
