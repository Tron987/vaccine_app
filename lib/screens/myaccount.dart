import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

import 'homePage.dart';

class MyAccount extends StatefulWidget {
  const MyAccount({Key? key}) : super(key: key);

  @override
  _MyAccountState createState() => _MyAccountState();
}

final TextEditingController _locationController = TextEditingController();

PhoneNumber? _phoneNumber;
final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _usersCollection = 'users';
  late String _firstName;
  late String _lastName;
  late String _email;

class _MyAccountState extends State<MyAccount> {
    @override
  void initState() {
    super.initState();
    // Retrieve user data from the Firestore database.
    _retrieveUserData();
  }

  Future<void> _retrieveUserData() async {
    try {
      final DocumentSnapshot userDoc =
          await _firestore.collection(_usersCollection).doc(user?.uid).get();
      final Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
      setState(() {
        _firstName = userData['First name'] ?? '';
        _lastName = userData['Last Name'] ?? '';
        _email = user?.email ?? '';
      });
    } catch (e) {
      print('Error retrieving user data: $e');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.0),
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            color: Colors.black,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      ),
      body: SingleChildScrollView(
        
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text(
              'My Account',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24.0, // Change the size as needed
              ),
            ),
          ),
          SizedBox(height: 16.0), // Add some spacing between the text and icon
          Center(
            child: Icon(
              Icons.account_circle,
              size: 64.0, // Change the size as needed
            ),
          ),
          TextFormField(
                controller: TextEditingController(text: _firstName),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color.fromARGB(255, 255, 252, 252).withOpacity(0.5),
                  hintText: '  First Name',
                  border:  OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30)
                  ),
                  focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.circular(30),
                      ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your first name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: TextEditingController(text: _lastName),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color.fromARGB(255, 255, 252, 252).withOpacity(0.5),
                  hintText: '  Last Name',
                  border:  OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30)
                  ),
                  focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.circular(30),
                      ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return '  Please enter your Last name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
            InternationalPhoneNumberInput(
              
            inputDecoration: InputDecoration(
              filled: true,
              fillColor: Color.fromARGB(255, 255, 252, 252).withOpacity(0.5),
              hintText: 'Phone Number',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue),
                borderRadius: BorderRadius.circular(30),
              ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.circular(30),
        ),
    ),
    onInputChanged: (PhoneNumber number) {
      _phoneNumber = number;
    },
    selectorConfig: SelectorConfig(
      selectorType: PhoneInputSelectorType.DROPDOWN,
    ),
    ignoreBlank: false,
    autoValidateMode: AutovalidateMode.onUserInteraction,
    selectorTextStyle: TextStyle(color: Colors.black),
    initialValue: _phoneNumber,
    
    formatInput: true,
    keyboardType:
        TextInputType.numberWithOptions(signed: true, decimal: true),
   
    //errorMessage: 'Invalid phone number',
),
const SizedBox(height: 16.0),
              TextFormField(
                controller: TextEditingController(text: _email),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color.fromARGB(255, 255, 252, 252).withOpacity(0.5),
                  hintText: '  Email',
                  border:  OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30)
                  ),
                  focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.circular(30),
                      ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!value.contains('@')) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16,),
                TextFormField(
                controller: _locationController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color.fromARGB(255, 255, 252, 252).withOpacity(0.5),
                  hintText: '  Location',
                  border:  OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30)
                  ),
                  focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.circular(30),
                      ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your city';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10.0,),
              Container(
                    width:  double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        _updateUserData();
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Color.fromARGB(255, 15, 118, 236)
                      ), child: const Text('Update',
                      style: TextStyle(
                        fontSize: 20.0
                      ),),
                    ),
                  ),
              

        ],
        
      ),
      )
    );
    
    
  }
  Future<void> _updateUserData() async {
  try {
    final userRef = _firestore.collection(_usersCollection).doc(user?.uid);
    await userRef.update({
      'First name': TextEditingController(text: _firstName),
      'Last Name': TextEditingController(text: _lastName),
      'Phone Number': _phoneNumber?.phoneNumber,
      'Email': TextEditingController(text: _email),
      'Location': _locationController.text
    });
    // Show a success message.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('User data updated successfully.')),
    );
  } catch (e) {
    print('Error updating user data: $e');
    // Show an error message.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Failed to update user data.')),
    );
  }
}

}
