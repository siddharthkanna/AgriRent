import 'package:agrirent/api/equipment_api.dart';
import 'package:agrirent/api/user_api.dart';
import 'package:agrirent/constants/snackBar.dart';
import 'package:agrirent/models/equipment.model.dart';
import 'package:agrirent/screens/chat/ChatScreen.dart';

import 'package:agrirent/theme/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:agrirent/providers/auth_provider.dart';
import 'package:agrirent/providers/chat_provider.dart';

class ProductDetailsPage extends ConsumerStatefulWidget {
  final Equipment equipment;

  const ProductDetailsPage({Key? key, required this.equipment})
      : super(key: key);

  @override
  _ProductDetailsPageState createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends ConsumerState<ProductDetailsPage> {
  Future<void> _navigateToChat() async {
    final currentUser = ref.read(authProvider);
    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please sign in to chat with the owner'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final ownerId = widget.equipment.ownerId;
    if (ownerId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Owner information not available'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      final ownerData = await UserApi().getUserData(ownerId);
      
      if (!mounted) return;

      // Create or get chat
      final chatService = ref.read(chatServiceProvider);
      final chatId = await chatService.getOrCreateChat(
        currentUser.id,
        ownerData['id'] ?? '',
      );

      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChatScreen(
            chatId: chatId,
            otherUserId: ownerData['id'] ?? '',
            otherUserName: ownerData['name'] ?? '',
          ),
        ),
      );
    } catch (e) {
      print('Error navigating to chat: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Failed to start chat'),
          backgroundColor: Colors.red[400],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> images = widget.equipment.images ?? [];

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                if (images.isNotEmpty)
                  Image.network(
                    images.first,
                    fit: BoxFit.cover,
                    height: 250.0,
                    width: double.infinity,
                  ),
                Positioned(
                  top: 40,
                  left: 15,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: Center(
                      child: IconButton(
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
            if (images.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.all(16),
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.equipment.name,
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.equipment.category,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Description:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.equipment.description,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Price: \Rs.${widget.equipment.rentalPrice}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Location: ${widget.equipment.location}',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Condition : ${widget.equipment.condition ?? ''}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Available: ${widget.equipment.isAvailable ? 'Yes' : 'No'}',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Availability Dates: ${widget.equipment.availabilityDates?.join(", ") ?? 'N/A'}',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
      persistentFooterButtons: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                ),
                child: ElevatedButton(
                  onPressed: _navigateToChat,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: const BorderSide(color: Colors.black),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.chat_bubble_outline),
                      SizedBox(width: 8),
                      Text(
                        'Chat with Owner',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                ),
                child: ElevatedButton(
                  onPressed: () {
                    String? equipmentId = widget.equipment.id;
                    String? renterId = ref.read(authProvider)?.id;
                    if (renterId == null) {
                      CustomSnackBar.showError(context, 'You need to be logged in to rent equipment');
                      return;
                    }
                    EquipmentApi.rentEquipment(equipmentId!, renterId, context);
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Palette.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text(
                    'Rent Now',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
