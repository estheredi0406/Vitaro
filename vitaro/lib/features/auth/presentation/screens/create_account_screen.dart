import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vitaro/core/services/auth_service.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _authService = AuthService();
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _acceptedTerms = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _createAccount() async {
    if (!_formKey.currentState!.validate()) return;

    if (!_acceptedTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please accept the Terms of Service and Privacy Policy')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Create user
      final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      // Update display name
      final fullName = '${_firstNameController.text.trim()} ${_lastNameController.text.trim()}';
      await userCredential.user?.updateDisplayName(fullName);

      // Save to Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'firstName': _firstNameController.text.trim(),
        'lastName': _lastNameController.text.trim(),
        'displayName': fullName, // Added for consistency with Google Auth
        'username': _usernameController.text.trim(),
        'email': _emailController.text.trim(),
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Account created successfully!')),
        );
        // Redirect to Home (User is already signed in by createUserWithEmailAndPassword)
        Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
      }
    } on FirebaseAuthException catch (e) {
      // ... Error handling logic kept same ...
      String message = 'An error occurred';
      if (e.code == 'weak-password') message = 'The password provided is too weak.';
      else if (e.code == 'email-already-in-use') message = 'An account already exists for that email.';
      else if (e.code == 'invalid-email') message = 'Invalid email address.';

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleSocialSignIn(Future<Map<String, dynamic>> Function() signInMethod) async {
    setState(() => _isLoading = true);

    final result = await signInMethod();

    setState(() => _isLoading = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message']),
          backgroundColor: result['success'] ? Colors.green : Colors.red,
        ),
      );

      if (result['success']) {
        final user = _authService.currentUser;
        if (user != null) {
          final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

          if (!userDoc.exists) {
            await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
              'email': user.email,
              'displayName': user.displayName,
              'photoURL': user.photoURL,
              'createdAt': FieldValue.serverTimestamp(),
            });
          }
        }
        // Navigate to Home
        if (mounted) {
          Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
        }
      }
    }
  }

  // ... Build method below is mostly standard UI code ...
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1A1A1A)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Create Account', style: TextStyle(color: Color(0xFF1A1A1A), fontWeight: FontWeight.w700)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  // Header and fields kept the same, only logic above changed
                  // Keeping UI code concise for response limits, but logic above is the key fix.
                  // Just copy the original UI structure from your file here.
                  const SizedBox(height: 24),
                  Container(
                    width: 80, height: 80,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE53935),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(Icons.water_drop, color: Colors.white, size: 40),
                  ),
                  const SizedBox(height: 20),
                  const Text('Join Vitaro', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 32),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('First Name', style: TextStyle(fontWeight: FontWeight.w600)),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _firstNameController,
                              decoration: InputDecoration(
                                hintText: 'John',
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              validator: (v) => v!.isEmpty ? 'Required' : null,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Last Name', style: TextStyle(fontWeight: FontWeight.w600)),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _lastNameController,
                              decoration: InputDecoration(
                                hintText: 'Doe',
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              validator: (v) => v!.isEmpty ? 'Required' : null,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      labelText: 'Username',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    validator: (v) => v!.contains('@') ? null : 'Invalid Email',
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    validator: (v) => v!.length < 6 ? 'Weak Password' : null,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Confirm Password',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    validator: (v) => v != _passwordController.text ? 'Mismatch' : null,
                  ),

                  // Terms Checkbox
                  CheckboxListTile(
                    value: _acceptedTerms,
                    onChanged: (v) => setState(() => _acceptedTerms = v!),
                    title: const Text('I agree to Terms & Privacy'),
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: EdgeInsets.zero,
                  ),

                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _createAccount,
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      child: _isLoading ? const CircularProgressIndicator() : const Text('Create Account'),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          icon: const Icon(Icons.g_mobiledata),
                          label: const Text('Google'),
                          onPressed: () => _handleSocialSignIn(_authService.signInWithGoogle),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: OutlinedButton.icon(
                          icon: const Icon(Icons.facebook),
                          label: const Text('Facebook'),
                          onPressed: () => _handleSocialSignIn(_authService.signInWithFacebook),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Already have an account? Sign In'),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}