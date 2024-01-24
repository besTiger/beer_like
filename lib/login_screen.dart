import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
              child: Column(
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image(
                          height: 50,
                          width: 50,
                          image: AssetImage('assets/logo_splash.png')),
                      SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Beer",
                            style: TextStyle(
                                fontSize: 30,
                                fontFamily: 'Rubik Medium',
                                color: Color(0xff203142)),
                          ),
                          Text(
                            "Like",
                            style: TextStyle(
                                fontSize: 30,
                                fontFamily: 'Rubik Medium',
                                color: Color.fromARGB(255, 32, 181, 250)),
                          ),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  const Center(
                    child: Text(
                      "Log In",
                      style: TextStyle(
                          fontSize: 24,
                          fontFamily: 'Rubik Medium',
                          color: Color(0xff203142)),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Center(
                    child: Text(
                      "Like beer , drink beer!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'Rubik Regular',
                          color: Color(0xff4c5980)),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    child: TextFormField(
                        decoration: InputDecoration(
                            hintText: 'Email',
                            fillColor: Color(0xfffbf9fa),
                            filled: true,
                            prefixIcon: const Icon(
                              Icons.email,
                              color: Color(0xff323f4b),
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Color(0xffe4e7eb)),
                                borderRadius: BorderRadius.circular(10)),
                            enabledBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Color(0xffe4e7eb)),
                                borderRadius: BorderRadius.circular(10)))),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextFormField(
                        decoration: InputDecoration(
                            hintText: 'Password',
                            fillColor: const Color(0xfffbf9fa),
                            filled: true,
                            prefixIcon: const Icon(
                              Icons.lock_open,
                              color: Color(0xff323f4b),
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Color(0xffe4e7eb)),
                                borderRadius: BorderRadius.circular(10)),
                            enabledBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Color(0xffe4e7eb)),
                                borderRadius: BorderRadius.circular(10)))),
                  ),
                  const SizedBox(
                    height: 100,
                  ),
                  Container(
                    height: 50,
                    width: 300,
                    decoration: BoxDecoration(
                      color: const Color(0xff20b4fa),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Center(
                      child: Text(
                        "Log In",
                        style: TextStyle(
                            fontSize: 18,
                            fontFamily: 'Rubik Regular',
                            color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account?  ",
                        style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Rubik Regular',
                            color: Color(0xff203142)),
                      ),
                      Text(
                        "Sign Up",
                        style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Rubik Medium',
                            color: Color(0xff20b4fa)),
                      ),
                    ],
                  )
                ],
              ),
            )));
  }
}
