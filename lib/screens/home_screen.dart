import 'package:flutter/material.dart';
import '../models/user.dart';
import '../db/database_helper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _controller = TextEditingController();
  final dbHelper = DatabaseHelper();
  List<User> users = [];

  Future<void> _loadUsers() async {
    final data = await dbHelper.getAllUsers();
    setState(() {
      users = data;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('User Manager'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            final user = users[index];

            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                leading: CircleAvatar(child: Text(user.name[0].toUpperCase())),
                title: Text(user.name),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.person),
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          '/profile',
                          arguments: user,
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () async {
                        final updatedName = await Navigator.pushNamed(
                          context,
                          '/edit',
                          arguments: user,
                        );
                        if (updatedName != null && updatedName is String) {
                          final updatedUser = User(
                            id: users[index].id,
                            name: updatedName,
                            age: users[index].age,
                            gender: users[index].gender,
                            profession: users[index].profession,
                          );
                          await dbHelper.updateUser(updatedUser);
                          await _loadUsers();
                        }
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () async {
                        await dbHelper.deleteUser(users[index].id);
                        await _loadUsers();
                        if (!mounted) return;
                        // ignore: use_build_context_synchronously
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            behavior: SnackBarBehavior.floating,
                            margin: const EdgeInsets.all(12.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            content: Center(
                              child: Text("User deleted Successfully"),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              final newUser = await Navigator.pushNamed(context, '/add');
              if (newUser != null && newUser is User) {
                await dbHelper.insertUser(newUser);
                await _loadUsers();
                if (!mounted) return;
                // ignore: use_build_context_synchronously
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    behavior: SnackBarBehavior.floating,
                    margin: const EdgeInsets.all(16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    content: Center(child: Text('User Successfully Added')),
                  ),
                );
              }
            },
            child: const Text('Add User'),
          ),
        ),
      ),
    );
  }
}
