import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController userController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    userController.dispose();
    passController.dispose();
    super.dispose();
  }

  Future<void> login() async {
    if (userController.text.isEmpty || passController.text.isEmpty) {
      _showSnackBar('Username dan password wajib diisi', Colors.orange);
      return;
    }

    setState(() => _isLoading = true);

    // Simulasi loading
    await Future.delayed(const Duration(milliseconds: 800));

    if (userController.text == 'admin' && passController.text == '1234') {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLogin', true);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } else {
      setState(() => _isLoading = false);
      _showSnackBar('Username atau password salah', Colors.red);
    }
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF6C5CE7), Color(0xFFE8B4F7), Color(0xFFF5D4F7)],
            stops: [0.0, 0.6, 1.0],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo Section
                  _buildLogo(),

                  const SizedBox(height: 50),

                  // Login Form Card
                  _buildLoginCard(),

                  const SizedBox(height: 24),

                  // Info Text
                  _buildInfoText(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.lock_outline_rounded,
              size: 60,
              color: Color(0xFF6C5CE7),
            ),
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'SELAMAT DATANG',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Silakan login untuk melanjutkan',
          style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.9)),
        ),
      ],
    );
  }

  Widget _buildLoginCard() {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Login',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF6C5CE7),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Masukkan kredensial Anda',
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
          const SizedBox(height: 28),

          // Username Field
          _buildTextField(
            controller: userController,
            label: 'Username',
            icon: Icons.person_outline_rounded,
            obscureText: false,
          ),

          const SizedBox(height: 16),

          // Password Field
          _buildTextField(
            controller: passController,
            label: 'Password',
            icon: Icons.lock_outline_rounded,
            obscureText: _obscurePassword,
            isPassword: true,
          ),

          const SizedBox(height: 28),

          // Login Button
          _buildLoginButton(),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required bool obscureText,
    bool isPassword = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF5F6FA),
        borderRadius: BorderRadius.circular(16),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        style: const TextStyle(fontSize: 16),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.grey[600]),
          prefixIcon: Icon(icon, color: const Color(0xFF6C5CE7)),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    _obscurePassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: Colors.grey[600],
                  ),
                  onPressed: () {
                    setState(() => _obscurePassword = !_obscurePassword);
                  },
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: const Color(0xFFF5F6FA),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 18,
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _isLoading ? null : login,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF6C5CE7),
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          disabledBackgroundColor: Colors.grey[300],
        ),
        child: _isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : const Text(
                'Login',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
      ),
    );
  }

  Widget _buildInfoText() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.info_outline_rounded, color: Colors.white, size: 20),
          const SizedBox(width: 8),
          Text(
            'Username: admin | Password: 1234',
            style: TextStyle(
              color: Colors.white.withOpacity(0.95),
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

