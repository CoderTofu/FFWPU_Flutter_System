import 'package:ffwpu_flutter_view/components/button.dart';
import 'package:ffwpu_flutter_view/pages/members_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(1, 118, 178, 1),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                     Text(
                        "Admin Login", 
                        style: GoogleFonts.roboto(
                        fontWeight: FontWeight.bold,
                        color: const Color.fromRGBO(1, 118, 178, 1),
                        fontSize: 24,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                        width: double.infinity,
                        constraints: const BoxConstraints(maxWidth: 400),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          TextField(
                            controller: _usernameController,
                            decoration: InputDecoration(
                              labelText: 'Username',
                              hintText: "Enter your username...",
                              border: OutlineInputBorder(),
                                labelStyle: const TextStyle(fontSize: 14),
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextField(
                            controller: _passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              hintText: "Enter your password...",
                              border: OutlineInputBorder(),
                                labelStyle: const TextStyle(fontSize: 14),
                            ),
                          ),
                          const SizedBox(height: 20),
                          // ElevatedButton(
                          //   onPressed: () {
                          //     Navigator.pushNamed(context, '/members');
                          //     final username = _usernameController.text;
                          //     final password = _passwordController.text;
                          //     showDialog(
                          //     context: context,
                          //     builder: (context) => AlertDialog(
                          //       title: const Text("Login Details"),
                          //       content: Text("Username: $username \nPassword: $password"),
                          //       actions: [
                          //       TextButton(
                          //         onPressed: () => Navigator.of(context).pop(),
                          //         child: const Text("OK"),
                          //       ),
                          //       ],
                          //     ),
                          //     );
                          //   },
                          //   child: const Text("Test"),
                          // ),
                          Button(
                            onPressed: () {
                              Navigator.push(context, // Navigate to MembersPage
                                MaterialPageRoute(
                                  builder: (context) => const MembersPage(),
                                ),
                              );
                            }, 
                            isFullWidth: true, 
                            buttonText: "Login",),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}