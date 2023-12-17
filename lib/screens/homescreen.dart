import 'package:agrirent/components/card.dart';
import 'package:agrirent/components/category_card.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final String userName = 'Siddharth';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                const SizedBox(height: 30),
                const CircleAvatar(
                  radius: 25,
                  backgroundImage: NetworkImage(
                    'https://i.insider.com/5ae71c8c19ee865b008b469d?width=712&format=jpeg',
                  ),
                ),
                const SizedBox(width: 14),
                const Text(
                  'Welcome, ',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  userName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                color: Colors.grey[200],
                border: Border.all(
                  color: Colors.black12,
                  width: 0.5,
                ),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      // Implement search functionality here
                    },
                  ),
                  const Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search equipment',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.filter_list),
                    onPressed: () {
                      // Implement filter functionality here
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Popular Equipment',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 150,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      EquipmentCard(
                        name: 'Equipment 1',
                        rating: '4.5',
                        imageUrl: 'https://www.rushlane.com/wp-content/uploads/2021/03/tractor-sales-feb-2021-fada.jpg',
                      ),
                      const SizedBox(width: 5),
                      EquipmentCard(
                        name: 'Equipment 2',
                        rating: '4.2',
                        imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSMa5H6ze7MVFPJjbOutY4K0TyQh-dDeLzZ3Q&usqp=CAU',
                      ),
                      const SizedBox(width: 5),
                      EquipmentCard(
                        name: 'Equipment 3',
                        rating: '4.8',
                        imageUrl: 'https://www.cropfertilityservices.com/wp-content/uploads/2021/08/Hatzenbichler-Tine-Weeder-2.jpeg',
                      ),
                      const SizedBox(width: 20),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Equipment Categories',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 100,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      EquipmentCategoryCard(
                        title: 'Tractors',
                        iconUrl: 'https://cdn-icons-png.flaticon.com/512/6678/6678123.png',
                      ),
                     const  SizedBox(width: 5),
                      EquipmentCategoryCard(
                        title: 'Harvesters',
                        iconUrl: 'https://cdn-icons-png.flaticon.com/512/9236/9236346.png',
                      ),
                      const SizedBox(width: 5),
                      EquipmentCategoryCard(
                        title: 'Plows',
                        iconUrl: 'https://cdn-icons-png.flaticon.com/512/6678/6678111.png',
                      ),
                      const SizedBox(width: 20),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
