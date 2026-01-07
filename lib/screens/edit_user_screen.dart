import 'package:flutter/material.dart';

class EditUserScreen extends StatefulWidget {
  const EditUserScreen({super.key});

  @override
  State<EditUserScreen> createState() => _EditUserScreenState();
}

class _EditUserScreenState extends State<EditUserScreen> {
  final TextEditingController _editUserNameController = TextEditingController();

  @override
  void dispose() {
    _editUserNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit User Info"), 
        centerTitle: true
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children:[
              TextField(
                controller:_editUserNameController,
                decoration: InputDecoration(
                  labelText: "Enter updated user name",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height:20),
              ElevatedButton(
                onPressed: () {
                  if(_editUserNameController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        behavior: SnackBarBehavior.floating,
                    margin: const EdgeInsets.all(16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    content: Center(child: Text('User Successfully Edited')),
                      ),
                    );
                  } else {
                    final updatedUserName = _editUserNameController.text.trim();
                    Navigator.pop(context, updatedUserName);
                  }
                },
                child: const Text('Save Changes'),
              ),
            ],
          ),
        ),


    );
  }
}
