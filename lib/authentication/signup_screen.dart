import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:beer_like/authentication/login_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  SignUpScreenState createState() => SignUpScreenState();
}

class SignUpScreenState extends State<SignUpScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> signUp(BuildContext context) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      // Add additional user information to Firestore
      await FirebaseFirestore.instance.collection('users').doc(userCredential.user?.uid).set({
        'name': _nameController.text,
        'email': _emailController.text,
        // Додайте інші дані, які ви хочете зберегти
      });

      // Handle successful signup
      print("User signed up: ${userCredential.user?.uid}");

      // Navigate to the login screen after successful signup
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    } catch (e) {
      // Handle errors, you can show an error message to the user.
      print("Error during signup: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/background_splash.png'), fit: BoxFit.cover),
      ),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black, size: 36,),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Container(
              padding: const EdgeInsets.only(left: 30, top: 10),
              child: const Text(
                "Create\nAccount",
                style: TextStyle(color: Colors.black, fontSize: 38, fontWeight: FontWeight.bold),
              ),
            ),
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                    right: 35,
                    left: 35,
                    top: MediaQuery.of(context).size.height * 0.16),
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.person,
                          color: Color(0xff323f4b),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.black),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.black),
                        ),
                        hintText: 'Name',
                        hintStyle: const TextStyle(color: Colors.black),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.email_outlined,
                          color: Color(0xff323f4b),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.black),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.black),
                        ),
                        hintText: 'Email',
                        hintStyle: const TextStyle(color: Colors.black),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.lock_outline,
                          color: Color(0xff323f4b),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.black),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.black),
                        ),
                        hintText: 'Password',
                        hintStyle: const TextStyle(color: Colors.black),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Sign Up',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 33,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.black, width: 1.0),
                          ),
                          child: CircleAvatar(
                            radius: 33,
                            backgroundColor: Colors.white60,
                            child: IconButton(
                              color: Colors.black,
                              onPressed: () => signUp(context),
                              icon: const Icon(Icons.arrow_forward),
                              iconSize: 30,
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}