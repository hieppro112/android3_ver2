class User {
  final int? id;
  final String email;
  final String password;
  final String? name;
  final String? avatarPath; // Thêm trường mới

  User({
    this.id,
    required this.email,
    required this.password,
    this.name,
    this.avatarPath,
  });

  // Thêm avatarPath vào fromMap/toMap
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      email: map['email'],
      password: map['password'],
      name: map['name'],
      avatarPath: map['avatarPath'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'password': password,
      'name': name,
      'avatarPath': avatarPath,
    };
  }
}
