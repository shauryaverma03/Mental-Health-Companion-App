import 'package:flutter/material.dart';
import 'package:genai/components/my_button.dart';
import 'package:genai/components/my_textfield.dart';
import 'package:genai/pages/type.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // This controller is now for the user's name
  final nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),

                // logo
                Container(
                  alignment: Alignment.center,
                  child: Image.asset("assets/images/otter-swim.gif",
                      height: 240, width: 250, fit: BoxFit.cover),
                ),

                const SizedBox(height: 50),
                Text(
                  'What should we call you?',
                  style: TextStyle(
                    fontSize: 22,
                  ),
                ),

                const SizedBox(height: 25),

                // username textfield
                MyTextField(
                  controller: nameController, // Was emailController
                  hintText: 'captain',
                  obscureText: false,
                ),

                const SizedBox(height: 10),

                // "Pick a cool name!" text
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Pick a cool name!',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                // sign in button
                MyButton(
                  onTap: () {
                    // Simply navigate to the next page
                    // You could pass the nameController.text to the 'Type' page if needed
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Type()),
                    );
                  },
                  text: 'Continue',
                ),

                const SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }
}