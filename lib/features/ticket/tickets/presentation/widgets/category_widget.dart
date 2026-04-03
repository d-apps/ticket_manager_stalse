import 'package:flutter/material.dart';

class CategoryWidget extends StatelessWidget {
  final String category;
  const CategoryWidget(this.category, {super.key});

  @override
  Widget build(BuildContext context) {
    return Chip(
      labelPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 1),
      label: Text(category.toUpperCase(), style: TextStyle(fontSize: 12, color: Colors.black),),
      backgroundColor: Colors.grey[300],
    );
  }
}
