import 'package:flutter/material.dart';
import '../models/user.dart';

class EditUserScreen extends StatefulWidget {
  const EditUserScreen({super.key});

  @override
  State<EditUserScreen> createState() => _EditUserScreenState();
}

class _EditUserScreenState extends State<EditUserScreen> {
  late User user; // reserves space for the user that we will get later
  final TextEditingController _editUserNameController = TextEditingController();
  final TextEditingController _editAgeController = TextEditingController();
  final TextEditingController _editProfessionController =
      TextEditingController();
  String? _editSelectedGender;

  // I only want didChangeDependencies to run once, as to not override updated values with saved values. That's why we use the _isInitialized variable. Check to see if not initialized, then snag the saved user in the 
  // passedUser variable. Set the local user variable to passedUser and then set all the local controllers to the edit screen to the old values. Set initialized flag to true. Now it won't run again. 
  bool _isInitialized = false;

  @override
  void didChangeDependencies() { // runs once the widget is mounted and context is available
    super.didChangeDependencies();
    if (!_isInitialized) {
      final passedUser = ModalRoute.of(context)!.settings.arguments as User;
      setState(() {
        user = passedUser;
        _editUserNameController.text = user.name;
        _editAgeController.text = user.age.toString();
        _editProfessionController.text = user.profession;
        _editSelectedGender = user.gender;
      });
      _isInitialized = true;
    }
  }

  @override
  void dispose() {
    _editUserNameController.dispose();
    _editAgeController.dispose();
    _editProfessionController.dispose();
    super.dispose();
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
    final updatedName = _editUserNameController.text.trim();
    final updatedAge = int.tryParse(_editAgeController.text.trim()) ?? 0;
    final updatedGender = _editSelectedGender;
    final updatedProfession = _editProfessionController.text.trim();

    if (updatedName.isEmpty) {
      _showSnackBar('Please enter an updated name');
      return;
    }

    if (_editAgeController.text.trim().isEmpty) {
      _showSnackBar("Please enter an updated age");
      return;
    }

    if (_editSelectedGender == null) {
      _showSnackBar('Please select your gender');
      return;
    }

    if (updatedProfession.isEmpty) {
      _showSnackBar('Please enter your profession');
      return;
    }

    final updatedUser = User(
      id: user.id,
      name: updatedName,
      age: updatedAge,
      gender: updatedGender!,
      profession: updatedProfession,
    );
    
    Navigator.pop(context, updatedUser);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit User Info"), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _editUserNameController,
              decoration: InputDecoration(
                labelText: "Enter updated user name",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _editAgeController,
              decoration: InputDecoration(
                labelText: "Enter updated user age",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _editProfessionController,
              decoration: InputDecoration(
                labelText: "Enter updated user profession",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: _editSelectedGender,
              decoration: const InputDecoration(
                labelText: 'Select Gender',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'Male', child: Text('Male')),
                DropdownMenuItem(value: 'Female', child: Text('Female')),
                DropdownMenuItem(
                  value: 'Non-Binary',
                  child: Text('Non-binary'),
                ),
                DropdownMenuItem(value: 'Other', child: Text('Other')),
              ],
              onChanged: (value) {
                setState(() {
                  _editSelectedGender = value;
                });
              
              },
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                _saveUser();
              },
              child: const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
