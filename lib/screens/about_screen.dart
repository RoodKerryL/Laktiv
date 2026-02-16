import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("À Propos"),
        backgroundColor: Colors.orange[800],
        foregroundColor: Colors.white,
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Icon(Icons.restaurant_menu, size: 80, color: Colors.orange),
            const SizedBox(height: 10),
            const Text("LAKResèt",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text("LAKResèt se yon aplikasyon ki fèt pou ede w dekouvri pi bèl resèt manje. Objektif nou se fè kizin lan vin pi fasil ak pi gou pou tout moun.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
            const SizedBox(height: 30),
            const Divider(),
            
            const SizedBox(height: 30),
            const Text("© 2026 LAKResèt Inc.",
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}