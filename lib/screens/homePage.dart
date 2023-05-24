

import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covid_jan/screens/changePassword.dart';
import 'package:covid_jan/screens/login.dart';
import 'package:covid_jan/screens/maps.dart';
import 'package:covid_jan/screens/myaccount.dart';
import 'package:covid_jan/screens/vaccine.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
//import 'package:geolocator/geolocator.dart';
//import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}
final User? user = FirebaseAuth.instance.currentUser;

class _HomePageState extends State<HomePage> {
 bool _switchValue = false;
   void _onSwitchChanged(bool value) {
    setState(() {
      _switchValue = value;
      // Do something here based on the switch value
    });
  }

  int _selectedIndex = 0;

  

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  
  
  
 Widget _buildActivityTab() {
  return Scaffold(
    body: Center(
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => Mapps()),
            
          );
        },
        child: Text("View Maps"),
      ),
    ),
  );
}


static Widget _buildHomeTab() {
  List<Map<String, String>> cardsData = [
    {
      'id': 'card1',
      'title': 'Dukoral',
      'description': '2 doses, given 1-6 weeks \n apart (children aged 2-5 \n years need 3 doses given \n 1-6 weeks apart, \n Given by Mouth)',
      'registeredPeople': '8.0k people registered',
    },
    {
      'id': 'card2',
      'title': 'Margin',
      'description': '2 doses, given 1-6 weeks \n apart (children aged 2-5 \n years need 3 doses given \n 1-6 weeks apart, \n Given by Mouth)',
      'registeredPeople': '8.8k people registered',
    },
    {
      'id': 'card3',
      'title': 'cobort',
      'description': '2 doses, given 1-6 weeks \n apart (children aged 2-5 \n years need 3 doses given \n 1-6 weeks apart, \n Given by Mouth)',
      'registeredPeople': '2.4k people registered',
    },
    {
      'id': 'card4',
      'title': 'Tariq',
      'description': '2 doses, given 1-6 weeks \n apart (children aged 2-5 \n years need 3 doses given \n 1-6 weeks apart, \n Given by Mouth)',
      'registeredPeople': '10.0k people registered',
    },
    // Add more cards here if needed
  ];

  List<Map<String, String>> filteredCardsData = List.from(cardsData);

  void searchCards(String searchQuery) {
    if (searchQuery.isEmpty) {
      filteredCardsData = List.from(cardsData);
    } else {
      filteredCardsData = cardsData.where((card) {
        String title = card['title']!.toLowerCase();
        return title.contains(searchQuery.toLowerCase());
      }).toList();
    }
  }

  TextEditingController searchController = TextEditingController();

  return SingleChildScrollView(
    child: Column(
      children: [
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: 'Search',
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                String searchQuery = searchController.text;
                searchCards(searchQuery);
              },
            ),
          ],
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: filteredCardsData.length,
          itemBuilder: (context, index) {
            Map<String, String> cardData = filteredCardsData[index];
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 2,
                color: Colors.blue.shade100,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 120,
                      height: 100,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/bottle.jpeg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            cardData['title']!,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                            key: Key(cardData['id']!),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            cardData['description']!,
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              Icon(
                                Icons.group,
                                color: Colors.orange,
                              ),
                              SizedBox(width: 8),
                              Text(
                                cardData['registeredPeople']!,
                                style: TextStyle(
                                  color: Colors.orange,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (_) => Mapps()));
                            },
                            child: Text('View Nearby Center'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    ),
  );
}


 Widget _buildProfileTab(BuildContext context, ) {
  
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(user?.uid)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('Loading');
        }

        final data = snapshot.data!.data() as Map<String, dynamic>;
      final firstName = data['First name'] ?? '';
      final lastname = data ['Last Name'] ?? '';
      final fullName = '$firstName $lastname';

        return ListView(
          padding: const EdgeInsets.symmetric(vertical: 16),
          children: [
            
            ListTile(
              leading: const Icon(Icons.account_circle),
              iconColor: Colors.white,
              title: Text(
                fullName,
                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
              subtitle: Text(
                user?.email ?? '',
                style: const TextStyle(color: Colors.white),
              ),
              
              tileColor: const Color.fromARGB(255, 68, 151, 245),
            ),
            const Divider(),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MyAccount()),
                );
              },
              child: const ListTile(
                leading: Icon(Icons.account_balance),
                title: Text('My Account'),
              ),
            ),
      ListTile(
        leading: const Icon(Icons.fingerprint),
      title: const Text('FaceID/TouchID'),
      trailing: Switch(
        value: _switchValue,
        onChanged: _onSwitchChanged,
        activeColor: Colors.green,
        inactiveThumbColor: Colors.grey[200],
        inactiveTrackColor: Colors.grey[400],
      ),
      ),
      GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ChangePassword()));
        },
        child:ListTile(
        leading: const Icon(Icons.lock),
        title: const Text('Change Password'),
      ) ,
      ),
      
      ListTile(
        leading: const Icon(Icons.logout),
        title: const Text('Log out'),
        onTap: _signOut,
      ),
      const ListTile(
        title: Text('More'),
      ),
      const Divider(),
      ListTile(
        leading: const Icon(Icons.help),
        title: const Text('Help and Support'),
      ),
      ListTile(
        leading: const Icon(Icons.info),
        title: const Text('About App'),
      ),
    ],
  );
    });
    
}


  @override
  Widget build(BuildContext context) {
    String title = '';
    switch (_selectedIndex) {
      case 0:
        title = 'Hey ${FirebaseAuth.instance.currentUser!.displayName}';
        break;
      case 1:
        title = 'Activity Log';
        break;
      case 2:
        title = 'Profile';
        break;
    }
    List<Widget> _widgetOptions = <Widget>[    _buildHomeTab(),   _buildActivityTab(),    _buildProfileTab(context),  ];
    return Scaffold(
          appBar: AppBar(
            title: Center(child: Text(title)),
          ),
          body: _widgetOptions.elementAt(_selectedIndex),
          bottomNavigationBar: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
          BottomNavigationBarItem(
              icon: Icon(Icons.history),
              label: 'Activity',
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
          ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.blue,
          onTap: _onItemTapped,
          ),
          drawer: Drawer(
  child: ListView(
    padding: EdgeInsets.zero,
    children: <Widget>[
      DrawerHeader(
        child: Text('Vaccine App'),
        decoration: BoxDecoration(
          color: Colors.blue,
        ),
      ),
      ListTile(
        title: Text('Add Vaccine card'),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => AddVaccineCard()));
        },
      ),
     
    ],
  ),
),
          );
          }
          void _signOut() async {
  await FirebaseAuth.instance.signOut();
  Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => LoginScreen()),
    
    );
  }


}