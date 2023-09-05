import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

enum AuthPageType { login, signup }

class AuthenticationPage extends StatefulWidget {
  const AuthenticationPage({super.key});

  @override
  State<AuthenticationPage> createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage> {
  AuthPageType currentAuthPageType = AuthPageType.signup;

  final _authenticationFormKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void togglePageType() {
    setState(() {
      if (currentAuthPageType == AuthPageType.signup) {
        currentAuthPageType = AuthPageType.login;
      } else {
        currentAuthPageType = AuthPageType.signup;
      }
    });
  }

  Future<void> signUp() async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text, password: _passwordController.text);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }

    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Account Created Successfully')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Form(
      key: _authenticationFormKey,
      child: Column(
        children: [
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Email',
            ),
          ),
          TextFormField(
            controller: _passwordController,
            obscureText: true,
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Password',
            ),
          ),
          ElevatedButton(
              onPressed: () {
                signUp();
              },
              child: Text((currentAuthPageType == AuthPageType.login)
                  ? "Sign in"
                  : "Sign Up")),
          TextButton(
              onPressed: () {
                togglePageType();
              },
              child: Text(currentAuthPageType == AuthPageType.login
                  ? "Don't already have an account"
                  : "Already have an account?"))
        ],
      ),
    ));
  }
}
