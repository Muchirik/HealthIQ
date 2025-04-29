import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lottie/lottie.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'success_page.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _passwordCtrl = TextEditingController();
  bool _isLoading = false;

  Future<void> _signIn() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailCtrl.text.trim(),
          password: _passwordCtrl.text.trim(),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const SuccessPage()),
        );
      } on FirebaseAuthException catch (e) {
        Fluttertoast.showToast(
          msg: e.message ?? "Authentication failed",
          gravity: ToastGravity.BOTTOM,
        );
      } catch (e) {
        Fluttertoast.showToast(
          msg: "Something went wrong. Try again later.",
          gravity: ToastGravity.BOTTOM,
        );
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _handleGoogleSignIn() async {
    setState(() => _isLoading = true);
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        setState(() => _isLoading = false);
        Fluttertoast.showToast(msg: "Google Sign-In cancelled");
        return;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const SuccessPage()),
      );
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(
        msg: e.message ?? "Google Authentication failed",
        gravity: ToastGravity.BOTTOM,
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Google Sign-In failed. Try again.",
        gravity: ToastGravity.BOTTOM,
      );
    } finally {
      setState(() => _isLoading = false);
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
          children: [
            const SizedBox(height: 60),
            Lottie.asset('assets/lottie/doctor.json', height: 180),
            const Text(
              "Welcome Back!",
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
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) =>
                    value!.contains('@') ? null : 'Enter a valid email',
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordCtrl,
                    decoration: const InputDecoration(labelText: 'Password'),
                    obscureText: true,
                    validator: (value) =>
                    value!.length < 6 ? 'Minimum 6 characters' : null,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _signIn,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      minimumSize: const Size.fromHeight(48),
                    ),
                    child: const Text("Sign In"),
                  ),
                  const SizedBox(height: 12),
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
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/signup');
                    },
                    child: const Text("Don't have an account? Sign Up"),
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
