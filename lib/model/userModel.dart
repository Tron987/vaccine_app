import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class User {
  String firstName;
  String lastName;
  String email;
  String password;
  PhoneNumber phoneNumber;
  String location;

  User({required this.firstName, required this.lastName, required this.email, required this.password, required this.phoneNumber, required this.location});

  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'password': password,
      'phoneNumber': phoneNumber,
      'photoUrl' : location
    };
  }
}
