import 'package:flutter/material.dart';

class SkeletonCardList extends StatelessWidget {
  final int itemCount;

  const SkeletonCardList({required this.itemCount});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return CardSkeleton();
      },
    );
  }
}

class CardSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        height: 120.0,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Row(
          children: [
            // Left side (Image)
            Container(
              width: 150.0,
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8.0),
                  bottomLeft: Radius.circular(8.0),
                ),
              ),
            ),
            // Right side (Description)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 12.0,
                      width: double.infinity,
                      color: Colors.grey[400],
                      margin: const EdgeInsets.only(bottom: 8.0),
                    ),
                    Container(
                      height: 8.0,
                      width: 100.0,
                      color: Colors.grey[400],
                      margin: const EdgeInsets.only(bottom: 8.0),
                    ),
                    Container(
                      height: 12.0,
                      width: 150.0,
                      color: Colors.grey[400],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
