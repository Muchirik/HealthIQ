import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _passwordCtrl = TextEditingController();
  bool _isLoading = false;
  String _lottieAnimation = 'assets/lottie/doctor.json';

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _signUp() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: _emailCtrl.text.trim(),
          password: _passwordCtrl.text.trim(),
        );

        await userCredential.user?.reload(); // Refresh user data
        setState(() {
          _lottieAnimation = 'assets/lottie/signup-success.json';
        });

        await Future.delayed(const Duration(seconds: 4));

        if (!mounted) return;
        Navigator.pushReplacementNamed(context, '/home');
      } on FirebaseAuthException catch (e) {
        print('Signup error: $e');
        setState(() {
          _lottieAnimation = 'assets/lottie/signup-failed.json';
        });

        await Future.delayed(const Duration(seconds: 4));

        if (!mounted) return;
        setState(() {
          _lottieAnimation = 'assets/lottie/doctor.json';
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message ?? 'Signup failed')),
        );
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  Future<void> _handleGoogleSignIn() async {
    try {
      setState(() => _isLoading = true);

      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        setState(() => _isLoading = false);
        return; // User cancelled
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await _auth.signInWithCredential(credential);

      await userCredential.user?.reload();

      setState(() {
        _lottieAnimation = 'assets/lottie/signup-success.json';
      });

      await Future.delayed(const Duration(seconds: 4));

      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      print("Google Sign-In error: $e");
      setState(() {
        _lottieAnimation = 'assets/lottie/signup-failed.json';
      });

      await Future.delayed(const Duration(seconds: 4));

      if (!mounted) return;
      setState(() {
        _lottieAnimation = 'assets/lottie/doctor.json';
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Google Sign-In failed')),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: SpinKitFadingCircle(color: Colors.teal))
          : SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 60),
            Lottie.asset(_lottieAnimation, height: 180),
            const SizedBox(height: 16),
            const Text(
              "Create Account",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _emailCtrl,
                    decoration: const InputDecoration(labelText: 'Email'),
                    validator: (value) => value!.contains('@') ? null : 'Enter a valid email',
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordCtrl,
                    decoration: const InputDecoration(labelText: "Password"),
                    obscureText: true,
                    validator: (value) => value!.length < 6 ? 'Minimum 6 characters' : null,
                  ),
                  const SizedBox(height: 42),
                  ElevatedButton(
                    onPressed: _signUp,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      minimumSize: const Size.fromHeight(48),
                    ),
                    child: const Text("Sign Up"),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: _handleGoogleSignIn,
                    icon: SvgPicture.asset(
                      'assets/icons/google.svg',
                      height: 24,
                      width: 24,
                    ),
                    label: const Text('Sign up with Google'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      minimumSize: const Size(double.infinity, 50),
                      side: BorderSide(color: Colors.grey.shade300),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      elevation: 2,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/signin');
                    },
                    child: const Text("Already have an account? Sign In"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
