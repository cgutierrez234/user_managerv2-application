// This is just a plain old dart class, no flutter needed

class User {
  final String id;
  final String name;
  final int age;
  final String gender;
  final String profession;

  User({
    required this.id,
    required this.name,
    required this.age,
    required this.gender,
    required this.profession,
  });

  // Converts an User object to Map to store within SQLite . . . Map<String, dynamic>
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'gender': gender,
      'profession': profession,
    };
  }

  // Take a database row( in this case a map) and converts it back into a user Object
  // The ‘factory’ keyword lets this constructor run custom logic before returning an object, or even return an existing instance instead of always creating a new one.
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      name: map['name'],
      age: map['age'],
      gender: map['gender'],
      profession: map['profession'],
    );
  }
}
