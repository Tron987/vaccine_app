

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covid_jan/screens/changePassword.dart';
import 'package:covid_jan/screens/login.dart';
import 'package:covid_jan/screens/myaccount.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
  

  static Widget _buildHomeTab() {
    return Column(
      children: [
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search',
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                ),
              ),
            ),
            Visibility(
              visible: true,
              maintainState: true,
              maintainSize: true,
              maintainAnimation: true,
              child: IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  // TODO: Implement search functionality
                },
              ),
            ),
          ],
        ),
        Expanded(
          child: Center(
            child: Text('Home'),
          ),
        ),
      ],
    );
  }

 Widget _buildProfileTab(BuildContext context) {
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
        title = 'Hey User Name';
        break;
      case 1:
        title = 'Activity Log';
        break;
      case 2:
        title = 'Profile';
        break;
    }
    List<Widget> _widgetOptions = <Widget>[    _buildHomeTab(),    Text('Activity'),    _buildProfileTab(context),  ];
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
          );
          }
          void _signOut() async {
  await FirebaseAuth.instance.signOut();
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (_) => LoginScreen()),
    (route) => false,
  );
}

          }