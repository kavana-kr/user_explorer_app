class UserModel {
  // basic user information from the API
  final int id;
  final String name;
  final String username;
  final String email;
  final String phone;
  final String website;

  // address-related fields (flattened for easier access)
  final String city;
  final String street;
  final String suite;
  final String zipcode;

  UserModel({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    required this.phone,
    required this.website,
    required this.city,
    required this.street,
    required this.suite,
    required this.zipcode,
  });

  // creates UserModel from JSON response
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      username: json['username'],
      email: json['email'],
      phone: json['phone'],
      website: json['website'],
      // extracting address details from nested JSON
      city: json['address']['city'],
      street: json['address']['street'],
      suite: json['address']['suite'],
      zipcode: json['address']['zipcode'],
    );
  }
}
