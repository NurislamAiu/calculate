import 'package:example/services/auth_service.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final _authService = AuthService();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLogin = true;
  bool _isLoading = false;
  String? _errorMessage;

  void _toggleAuthMode() {
    setState(() {
      _isLogin = !_isLogin;
      _errorMessage = null;
    });
  }

  Future<void> _submit() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      if (_isLogin) {
        await _authService.signInWithEmail(
          _emailController.text,
          _passwordController.text,
        );
      } else {
        await _authService.registerWithEmail(
          _emailController.text,
          _passwordController.text,
        );
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color mainBrown = Color(0xFF79573C);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    height: 180,
                    width: 180,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: mainBrown.withOpacity(0.1),
                          blurRadius: 40,
                          offset: const Offset(0, 20),
                          spreadRadius: 20,
                        )
                      ],
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/logo.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),

                Text(
                  _isLogin ? 'Welcome Back!' : 'Create Account',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    color: Colors.black87,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _isLogin
                      ? 'Sign in to enjoy delicious food'
                      : 'Sign up to get started',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16, color: Colors.grey, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 40),

                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    hintText: 'hello@example.com',
                    prefixIcon: Icon(Icons.email_rounded),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    hintText: '••••••••',
                    prefixIcon: Icon(Icons.lock_rounded),
                  ),
                ),
                const SizedBox(height: 24),

                if (_errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.red[200]!),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.error_outline, color: Colors.red),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _errorMessage!,
                              style: const TextStyle(color: Colors.red, fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                _isLoading
                    ? const Center(child: CircularProgressIndicator(color: mainBrown))
                    : Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: mainBrown.withOpacity(0.3),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: _submit,
                          child: Text(_isLogin ? 'Log In' : 'Register'),
                        ),
                      ),

                const SizedBox(height: 24),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _isLogin ? "Don't have an account? " : "Already have an account? ",
                      style: TextStyle(color: Colors.grey[600], fontSize: 15),
                    ),
                    GestureDetector(
                      onTap: _toggleAuthMode,
                      child: const Text(
                        "Register",
                        style: TextStyle(
                          color: mainBrown,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
