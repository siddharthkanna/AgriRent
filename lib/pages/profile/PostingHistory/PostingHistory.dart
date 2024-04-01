import 'package:agrirent/config/dio.dart';
import 'package:agrirent/config/url.dart';
import 'package:agrirent/models/equipment.model.dart';
import 'package:agrirent/pages/profile/PostingHistory/ProductDetail.dart';
import 'package:agrirent/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PostingHistoryPage extends ConsumerStatefulWidget {
  const PostingHistoryPage({Key? key}) : super(key: key);

  @override
  _PostingHistoryPageState createState() => _PostingHistoryPageState();
}

class _PostingHistoryPageState extends ConsumerState<PostingHistoryPage> {
  late Future<List<Equipment>> _equipmentFuture;
  late String _userId;

  @override
  void initState() {
    super.initState();
    _userId = ref.read(authProvider).userId ?? '';
    _equipmentFuture = fetchEquipment();
  }

  Future<List<Equipment>> fetchEquipment() async {
    try {
      final response = await dio.get(postingHistoryUrl + _userId);
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => Equipment.fromJson(json)).toList();
      } else {
        throw Exception('Failed to fetch equipment');
      }
    } catch (e) {
      throw Exception('Failed to fetch equipment: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Posting History',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: FutureBuilder<List<Equipment>>(
        future: _equipmentFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.data!.isEmpty) {
            return const Center(child: Text("Looks like you haven't posted any equipment yet."));
          } else {
            final equipmentList = snapshot.data!;
            return ListView.builder(
              itemCount: equipmentList.length,
              itemBuilder: (context, index) {
                final equipment = equipmentList[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ProductInfoPagePost(equipment: equipment),
                      ),
                    );
                  },
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: Card(
                      elevation: 0,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(12),
                        leading: CircleAvatar(
                          radius: 32,
                          backgroundImage:
                              NetworkImage(equipment.images?.first ?? ''),
                        ),
                        title: Text(
                          equipment.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          equipment.description,
                          style: const TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
