import 'package:flutter/material.dart';
class HomeScreen extends StatelessWidget { 
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ekran akey'),
        centerTitle: true,
      ),
      body: Center(
         child: ElevatedButton(
          onPressed: () {
            print('Bouton');
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => const DetailScreen(
            //       data: 'Bonjou, sa a se yon mesaj ki soti nan ekran akey la.',
            //     ),
            //   ),
            // );
          },
          child: const Text('Antre nan ekran detay'),
        ),
      ),
    );
     
  
  }
}