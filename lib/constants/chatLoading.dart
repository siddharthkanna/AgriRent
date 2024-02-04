import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SkeletonChatLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      child: ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) {
          return Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.grey[300],
              ),
              title: Container(
                height: 10,
                width: double.infinity,
                color: Colors.grey[300],
              ),
              subtitle: Container(
                height: 10,
                width: double.infinity,
                color: Colors.grey[300],
              ),
            ),
          );
        },
      ),
    );
  }
}
