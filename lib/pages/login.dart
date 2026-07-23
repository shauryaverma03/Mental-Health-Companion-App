import 'package:flutter/material.dart';
import 'package:saathi/components/my_button.dart';
import 'package:saathi/components/my_textfield.dart';
import 'package:saathi/services/auth_service.dart';
import 'package:saathi/themes/app_theme.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();

  final AuthService _authService = AuthService();
  bool isLogin = true;
  bool isLoading = false;

  void showErrorMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _submit() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final name = nameController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      showErrorMessage('Email and password cannot be empty.');
      return;
    }

    if (!isLogin && name.isEmpty) {
      showErrorMessage('Name cannot be empty.');
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      if (isLogin) {
        await _authService.signInWithEmailPassword(email, password);
      } else {
        await _authService.signUpWithEmailPassword(email, password, name);
      }
      // Success is handled by StreamBuilder in SplashAuthGate, but we need to pop this page
      if (mounted) {
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    } catch (e) {
      showErrorMessage(e.toString().replaceAll('Exception: ', ''));
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void _googleSignIn() async {
    setState(() {
      isLoading = true;
    });

    try {
      await _authService.signInWithGoogle();
      // Success is handled by StreamBuilder in SplashAuthGate, but we need to pop this page
      if (mounted) {
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    } catch (e) {
      showErrorMessage(e.toString().replaceAll('Exception: ', ''));
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.backgroundGradient,
        ),
        child: SafeArea(
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
                        height: 150, width: 150, fit: BoxFit.cover),
                  ),

                  const SizedBox(height: 30),
                  Text(
                    isLogin ? 'Welcome back, Saathi!' : 'Create an Account',
                    style: AppTheme.heading1,
                  ),
                  const SizedBox(height: 25),

                  if (!isLogin) ...[
                    MyTextField(
                      controller: nameController,
                      hintText: 'Name',
                      obscureText: false,
                    ),
                    const SizedBox(height: 15),
                  ],

                  MyTextField(
                    controller: emailController,
                    hintText: 'Email',
                    obscureText: false,
                  ),
                  const SizedBox(height: 15),

                  MyTextField(
                    controller: passwordController,
                    hintText: 'Password',
                    obscureText: true,
                  ),
                  const SizedBox(height: 25),

                  isLoading
                      ? const CircularProgressIndicator()
                      : MyButton(
                          onTap: _submit,
                          text: isLogin ? 'Sign In' : 'Sign Up',
                        ),

                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isLogin = !isLogin;
                      });
                    },
                    child: Text(
                      isLogin ? 'Don\'t have an account? Sign up' : 'Already have an account? Sign in',
                      style: AppTheme.body.copyWith(
                        color: AppTheme.primaryDark,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Google sign-in
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Divider(
                            thickness: 0.5,
                            color: AppTheme.textSecondary.withOpacity(0.3),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text(
                            'Or continue with',
                            style: AppTheme.bodySmall,
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            thickness: 0.5,
                            color: AppTheme.textSecondary.withOpacity(0.3),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  GestureDetector(
                    onTap: _googleSignIn,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppTheme.surface,
                        borderRadius: BorderRadius.circular(AppTheme.radiusCard),
                        boxShadow: AppTheme.cardShadow,
                      ),
                      child: Image.asset(
                        'assets/images/google.png',
                        height: 40,
                      ),
                    ),
                  ),

                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}