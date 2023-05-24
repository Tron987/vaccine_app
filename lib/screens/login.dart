import 'package:covid_jan/screens/homePage.dart';
import 'package:covid_jan/screens/passwordReset.dart';
import 'package:covid_jan/screens/registerpage.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

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
   bool _obscureText = true;

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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 100,),
            Text(
              "     Let's Sign You In",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.left,
            ),
            SizedBox(height: 10),
            Text(
              "       Welcome Back, \n       You Have Been Missed",
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
                         if (value!.isEmpty) {
                            return 'Please enter your email address';
                          } else if (!EmailValidator.validate(value)) {
                            return 'Please enter a valid email address';
                          }
                          return null;
                        },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscureText,
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
                      suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                          child: Icon(
                            _obscureText ? Icons.visibility_off : Icons.visibility,
                          ),
                      )
                    ),
                    validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your password';
                    } else if (value.length < 8) {
                      return 'Password should be at least 8 characters long';
                    } else if (!RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$').hasMatch(value)) {
                      return 'Password should contain at least one uppercase letter, one lowercase letter, one number, and one special character';
                    }
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
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => PasswordReset()), (route) => false);
                      },
                      child: const Text(
                        'Forgot Password',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
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
                      GestureDetector(
                        onTap: () async{
                           signInWithGoogle();
                           
                          
                        },
                        child: Image.asset(
                          'assets/icons/google.png',
                          height: 30,
                          width: 30,
                          semanticLabel: 'Google icon created by Freepik - Flaticon',
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          //signInWithFacebook();
                        },
                        child: Image.asset(
                          'assets/icons/facebook.png',
                          height: 30,
                          width: 30,
                          semanticLabel: 'Facebook icon created by Freepik - Flaticon',
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          // Add your acti
                        },
                        child: Image.asset(
                          'assets/icons/apple.png',
                          height: 30,
                          width: 30,
                          semanticLabel: 'Apple icon created by Freepik - Flaticon',
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 30,),
                  const Text('Do not have an account?',
                  style: TextStyle(
                    fontSize: 16
                  ),),
                  SizedBox(height: 0,),
                  TextButton(onPressed: () {
                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => RegisterPage()), (route) => false);
                  },
                   child: const Text('Register Now',
                   style: TextStyle(
                    fontSize: 16,
                    decoration: TextDecoration.underline,
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

 final GoogleSignIn _googleSignIn = GoogleSignIn();
 final _auth = FirebaseAuth.instance;

 signInWithGoogle() async {
  try {
    final GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
    if( googleSignInAccount != null){
      final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
      final AuthCredential authCredential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken
      );
      await _auth.signInWithCredential(authCredential);
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => HomePage()), (route) => false);
    } 
  } on FirebaseAuthException catch (e){
    print(e.message);
    throw e;
  }
  }
}

/*
 Future<void> signInWithFacebook() async {
  try {
    // Initialize Firebase if it hasn't been initialized yet
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp();
    }

    // Configure the Facebook provider
    final FacebookAuthProvider facebookProvider = FacebookAuthProvider();

    // Use the Facebook SDK to obtain an access token
    final LoginResult loginResult = await FacebookAuth.instance.login();

    // Create a Facebook credential from the access token
    final OAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(loginResult.accessToken!.token);

    // Sign in with the Facebook credential
    final UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);

    // Check if the user is new or returning
    if (userCredential.additionalUserInfo!.isNewUser) {
      // The user is new, so navigate to the registration page
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => RegisterPage()),
      );
    } else {
      // The user is returning, so navigate to the home page
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    }
  } catch (e) {
    // Handle errors that occur during sign-in
    print('Failed to sign in with Facebook: $e');
  }
}


}
*/