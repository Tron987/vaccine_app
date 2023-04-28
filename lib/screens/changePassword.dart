import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController =
      TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isCurrentPasswordObscured = true;
  bool _isNewPasswordObscured = true;
  bool _isConfirmPasswordObscured = true;

  String _currentPasswordError = '';
  String _newPasswordError = '';
  String _confirmPasswordError = '';

  void _toggleCurrentPasswordVisibility() {
    setState(() {
      _isCurrentPasswordObscured = !_isCurrentPasswordObscured;
    });
  }

  void _toggleNewPasswordVisibility() {
    setState(() {
      _isNewPasswordObscured = !_isNewPasswordObscured;
    });
  }

  void _toggleConfirmPasswordVisibility() {
    setState(() {
      _isConfirmPasswordObscured = !_isConfirmPasswordObscured;
    });
  }

  bool _isFormValid() {
    setState(() {
      _currentPasswordError =
          _currentPasswordController.text.trim().isEmpty ? 'Enter your current password' : '';
      _newPasswordError =
          _newPasswordController.text.trim().isEmpty ? 'Enter your new password' : '';
      _confirmPasswordError = _confirmPasswordController.text.trim().isEmpty
          ? 'Confirm your new password'
          : _newPasswordController.text != _confirmPasswordController.text
              ? 'Passwords do not match'
              : '';
    });
    return _currentPasswordError.isEmpty && _newPasswordError.isEmpty && _confirmPasswordError.isEmpty;
  }

  void _changePassword() async {
    if (_isFormValid()) {
      try {
        final currentUser = FirebaseAuth.instance.currentUser!;
        final credential = EmailAuthProvider.credential(
          email: currentUser.email!,
          password: _currentPasswordController.text,
        );
        await currentUser.reauthenticateWithCredential(credential);
        await currentUser.updatePassword(_newPasswordController.text);
        Navigator.pop(context);
      } on FirebaseAuthException catch (e) {
        setState(() {
          switch (e.code) {
            case 'wrong-password':
              _currentPasswordError = 'The current password is incorrect';
              break;
            case 'requires-recent-login':
              _currentPasswordError = 'You need to re-login to change the password';
              break;
            default:
              _currentPasswordError = 'An error occurred. Please try again later.';
          }
        });
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Center(child: Text('Change Password',
        style: TextStyle(color: Colors.black),)),
        elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            color: Colors.black,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
      ),
      body: SingleChildScrollView(
       child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 90,),
            TextFormField(
              controller: _currentPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: "Current Password",
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
                      contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                      suffixIcon: Icon(Icons.visibility_off),
                    ),
                    validator: (value) {
                      // Add necessary validation here
                      return null;
                    },
            ),
            
            SizedBox(height: 16,),
            TextFormField(
              controller: _newPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: "New Password",
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
                      contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                      suffixIcon: Icon(Icons.visibility_off),
                    ),
                    validator: (value) {
                      // Add necessary validation here
                      return null;
                    },
            ),
            
            SizedBox(height: 16.0),
            
            TextFormField(
              controller: _confirmPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: "Confirm New Password",
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
                      contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                      suffixIcon: Icon(Icons.visibility_off),
                    ),
                    validator: (value) {
                      // Add necessary validation here
                      return null;
                    },
            
            ),
            SizedBox(height: 32.0),
            Center(
              child: ElevatedButton(
                onPressed: _changePassword,
                child: Text('Change Password'),
              ),
            ),
          ],
        ),
      ),
    ));
    
  }
}
