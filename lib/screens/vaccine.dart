import 'package:covid_jan/screens/addVaccine.dart';
import 'package:covid_jan/screens/homePage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';

class AddVaccineCard extends StatefulWidget {
  const AddVaccineCard({Key? key});

  @override
  State<AddVaccineCard> createState() => _AddVaccineCardState();
}

class _AddVaccineCardState extends State<AddVaccineCard> {
  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(user?.uid)
          .collection('vaccine')
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading");
        }

        final vaccineCards = snapshot.data!.docs;

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black),
              onPressed: ()  => Navigator.of(context).pop(),
            ),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Text(
                          'Recent Vaccination ID Card',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: TextButton.icon(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (_) => AddVaccine()),
                            (route) => false,
                          );
                        },
                        icon: Icon(Icons.add, color: Colors.black),
                        label: Text(
                          'Scan Barcode',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: vaccineCards.length,
                  itemBuilder: (BuildContext context, int index) {
                    final DocumentSnapshot document = vaccineCards[index];
                    final Map<String, dynamic> data =
                        document.data() as Map<String, dynamic>;
                    final vaccineName = data['Vaccine Name'];
                    final photoPath = data['pathss'];

                    return GestureDetector(
                      onTap: () {
                        if (photoPath != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => FullScreenImage(photoPath),
                            ),
                          );
                        }
                      },
                      child: Card(
                        child: ListTile(
                          title: Text(vaccineName ?? ''),
                          leading: FutureBuilder<String?>(
                            future: photoPath != null
                                ? FirebaseStorage.instance.ref(photoPath).getDownloadURL()
                                : null,
                            builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return CircularProgressIndicator();
                              } else if (snapshot.hasError) {
                                return Icon(Icons.error);
                              } else if (snapshot.hasData && snapshot.data != null) {
                                final imageUrl = snapshot.data!;
                                return CachedNetworkImage(
                                  imageUrl: imageUrl,
                                  placeholder: (context, url) => CircularProgressIndicator(),
                                  errorWidget: (context, url, error) => Icon(Icons.error),
                                  fit: BoxFit.cover,
                                  width: 50,
                                  height: 50,
                                );
                              } else {
                                return Icon(Icons.image);
                              }
                            },
                          ),

                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class FullScreenImage extends StatelessWidget {
  final String photoPath;

  const FullScreenImage(this.photoPath);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: CachedNetworkImage(
          imageUrl: photoPath,
          placeholder: (context, url) => CircularProgressIndicator(),
          errorWidget: (context, url, error) => Icon(Icons.error),
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
