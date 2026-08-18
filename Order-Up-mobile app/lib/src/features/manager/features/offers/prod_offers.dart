import 'package:flutter/material.dart';
import 'package:orderly_ecom/src/theme/colors.dart';

class ProductList extends StatelessWidget {
  const ProductList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: false,
        title: const Text(
          'Product List',
          style: TextStyle(
            color: AppColor.blackColor,
          ),
        ),
      ),
    );
  }
}
