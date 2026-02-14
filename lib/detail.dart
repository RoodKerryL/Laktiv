import 'package:flutter/material.dart';

class DetailScreen extends StatelessWidget {
  final String data;

  const DetailScreen({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ekran detay'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          data,
          style: const TextStyle(fontSize: 18),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}