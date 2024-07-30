import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sulala/data/providers/animal_controller.dart';
import 'package:sulala/presentaion/home_screen/home_screen.dart';
import 'package:sulala/presentaion/home_screen/family_tree_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {
        return AnimalController();
      },
      child: MaterialApp(
        title: 'Family Tree Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home:  FamilyTreeScreen(),
      ),
    );
  }
}
