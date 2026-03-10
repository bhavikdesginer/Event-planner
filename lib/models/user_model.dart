class UserModel {
  final String uid;
  final String name;
  final String email;
  final String phone;
  final String gender;
  final int age;
  final List<String> interests;
  final String location;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.phone,
    required this.gender,
    required this.age,
    required this.interests,
    required this.location,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'phone': phone,
      'gender': gender,
      'age': age,
      'interests': interests,
      'location': location,
      'createdAt': DateTime.now().toIso8601String(),
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      gender: map['gender'] ?? '',
      age: map['age'] ?? 0,
      interests: List<String>.from(map['interests'] ?? []),
      location: map['location'] ?? '',
    );
  }
}