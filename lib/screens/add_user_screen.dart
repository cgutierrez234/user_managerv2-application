import 'package:flutter/material.dart';
import '../models/user.dart';
import 'package:uuid/uuid.dart';

class AddUserScreen extends StatefulWidget {
  const AddUserScreen({super.key});

  @override
  State<AddUserScreen> createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen> {
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _professionController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    _ageController.dispose();
    _genderController.dispose();
    _professionController.dispose();
  }

  void _saveUser() {
    final name = _controller.text.trim();
    final age = _ageController.text.trim();
    final gender = _genderController.text.trim();
    final profession = _professionController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Center(child: Text("You must enter a name"))),
      );
      return;
    }
    final newUser = User(id: const Uuid().v4(), name: name, age: age, gender: gender, professio: profession);
    Navigator.pop(context, newUser);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add user'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Enter user name',
                border: OutlineInputBorder(),
              ),
            ),
            ElevatedButton(
              onPressed: _saveUser,
              child: const Text('Save User'),
            ),
          ],
        ),
      ),
    );
  }
}
