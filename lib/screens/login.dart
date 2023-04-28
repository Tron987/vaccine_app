import 'package:covid_jan/screens/homePage.dart';
import 'package:covid_jan/screens/registerpage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  User? user;
  bool isloading = false;

  @override
  void initState() {
    super.initState();
    
    bool isloading = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView( 
      child: SafeArea(
        child: Column(
          
          children: [
            SizedBox(height: 100,),
            Text(
              "Let's Sign You In",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.left,
            ),
            SizedBox(height: 10),
            Text(
              "Welcome Back, \n You Have Been Missed",
              style: TextStyle(
                fontSize: 18,
              ),
              textAlign: TextAlign.left,
            ),
            SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                children: [
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      hintText: "Email or Phone Number",
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
                    ),
                    validator: (value) {
                      // Add necessary validation here
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: "Password",
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
                  SizedBox(height: 20,),
                  Container(
                    width:  double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        signInWithEmailAndPassword();
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Color.fromARGB(255, 15, 118, 236)
                      ), child: const Text('Sign In',
                      style: TextStyle(
                        fontSize: 20.0
                      ),),
                    ),
                  ),
                  
                  TextButton(onPressed: () {},
                   child: const Text(
                      'Forgot Password',
                       style: TextStyle(
                        color: Colors.black,
                        fontSize: 16.0,
                        
                        
                       ), 
                       textAlign: TextAlign.right,
                   )
                   ),
                  
                  SizedBox(height: 20),
                  Text(
                    "Or",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Icon(Icons.g_translate),
                      Icon(Icons.facebook),
                      Icon(Icons.apple),
                    ],
                  ),
                  SizedBox(height: 30,),
                  const Text('Do not have an account?'),
                  SizedBox(height: 2,),
                  TextButton(onPressed: () {
                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => RegisterPage()), (route) => false);
                  },
                   child: Text('Sign Up',
                   style: TextStyle(
                    
                    color: Colors.blue
                   ),))
                  
                ],
              ),
            ),
          ],
        ),
      ),
      )
    );
    
  }
  void signInWithEmailAndPassword() async {
    setState(() {
    isloading = true;
  });
  try {
    final UserCredential userCredential =
        await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );
    user = userCredential.user;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('User registered successfully')),
    );
    
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => HomePage()),
        (route) => false);
  } catch (e) {
    setState(() {
      isloading = false;
    });
    // Show an error toast message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: ${e.toString()}')),
    );
  }
}
  
}
