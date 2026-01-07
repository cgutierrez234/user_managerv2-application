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
  final TextEditingController _professionController = TextEditingController();
  String? _selectedGender;

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    _ageController.dispose();
    _professionController.dispose();
  }
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(12.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        content: Center(child: Text(message)),
      ),
    );
  }

  void _saveUser() {
    final name = _controller.text.trim();
    final age = int.tryParse(_ageController.text.trim()) ?? 0;
    final gender = _selectedGender;
    final profession = _professionController.text.trim();

    if (name.isEmpty) {
      _showSnackBar('Please enter a name');
      return;
    }

    if(_ageController.text.trim().isEmpty) {
      _showSnackBar("Please enter an age");
    }

    if(_selectedGender == null) {
      _showSnackBar('Please select your gender');
    }

    if(profession.isEmpty) {
      _showSnackBar('Please enter your profession');
    }

    final newUser = User(id: const Uuid().v4(), name: name, age: age, gender: gender!, profession: profession);
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
            DropdownButtonFormField<String>(
              initialValue: _selectedGender,
              decoration: const InputDecoration(
                labelText: 'Select Gender',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'Male', child: Text('Male')),
                DropdownMenuItem(value: 'Female', child: Text('Female')),
                DropdownMenuItem(value: 'Non-Binary', child: Text('Non-binary')),
                DropdownMenuItem(value: 'Other', child: Text('Other')),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedGender = value;
                });
              },
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
