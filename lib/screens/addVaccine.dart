import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';

class AddVaccine extends StatefulWidget {
  const AddVaccine({Key? key}) : super(key: key);

  @override
  State<AddVaccine> createState() => _AddVaccineState();
}

class _AddVaccineState extends State<AddVaccine> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _vaccineNameController = TextEditingController();
  final TextEditingController _picturePathController = TextEditingController();

  void _capturePhoto() async {
  final ImagePicker _picker = ImagePicker();
  final XFile? photo = await _picker.pickImage(source: ImageSource.gallery);

  if (photo != null) {
    setState(() {
      _picturePathController.text = photo.path;
    });
  }
}


  void _saveVaccineDetails() async {
  if (_formKey.currentState!.validate()) {
    try {
      // Initialize Firebase
      await Firebase.initializeApp();
      String uid = FirebaseAuth.instance.currentUser!.uid;
      // Save the vaccine data to Firestore under the current user's document
      FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .collection('vaccine')
      .add({'Vaccine Name': _vaccineNameController.text, 'path': _picturePathController.text})
      .then((value) {
        print('Saved successfully!');
        Navigator.pop(context);
      }).catchError((error) {
         print('Failed to add vaccine: $error');
      });
      // Show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vaccine details saved successfully')),
      );
    } catch (e) {
      // Show an error message if there's an error saving the data
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to save vaccine details')),
      );
      print('Error saving vaccine details: $e');
    }
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade400,
        title: const Text('Add Vaccine Details'),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _vaccineNameController,
                  decoration: const InputDecoration(
                    hintText: 'Vaccine Name',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a vaccine name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _picturePathController,
                        decoration: const InputDecoration(
                          hintText: 'Add Picture',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please add a picture';
                          }
                          return null;
                        },
                      ),
                    ),
                    ElevatedButton(
                      onPressed: _capturePhoto,
                      child: const Text('Add'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _saveVaccineDetails,
                  child: const Text('Save'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
