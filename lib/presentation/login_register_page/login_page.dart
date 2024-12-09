import 'package:acl_application/core/utils/size_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../routes/app_routes.dart';
import '../../theme/custom_button_style.dart';
import '../../theme/custom_text_style.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_text_from_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void signUserIn() async {
    if (_validateInputs()) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      try {
        // Sign in the user
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );

        Navigator.pop(context); // Close the loading dialog
        Navigator.pushNamed(context, AppRoutes.homePage); // Navigate to profile page
      } on FirebaseAuthException catch (e) {
        Navigator.pop(context); // Close the loading dialog
        _showErrorSnackBar(e.message ?? 'An error occurred');
      } catch (e) {
        Navigator.pop(context); // Close the loading dialog
        _showErrorSnackBar('An unexpected error occurred.');
      }
    }
  }

  Future<void> resetPassword(BuildContext context) async {
    TextEditingController forgotPasswordEmailController = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text('Reset Password'),
          content: TextField(
            controller: forgotPasswordEmailController,
            decoration: const InputDecoration(hintText: "Enter your email"),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                final email = forgotPasswordEmailController.text.trim();
                if (email.isEmpty) {
                  Navigator.pop(context);
                  _showErrorSnackBar('Please enter an email address.');
                  return;
                }

                try {
                  await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
                  Navigator.pop(context);
                  _showErrorSnackBar('Password reset email sent.');
                } catch (e) {
                  Navigator.pop(context);
                  _showErrorSnackBar('Error: ${e.toString()}');
                }
              },
              child: const Text('Submit'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  bool _validateInputs() {
    if (emailController.text.trim().isEmpty || passwordController.text.trim().isEmpty) {
      _showErrorSnackBar('Please fill in all fields.');
      return false;
    }

    if (!_isValidEmail(emailController.text.trim())) {
      _showErrorSnackBar('Please enter a valid email address.');
      return false;
    }

    return true;
  }

  bool _isValidEmail(String email) {
    final emailRegEx = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    return emailRegEx.hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 22.h, vertical: 72.h),
          child: Column(
            children: [_buildLoginForm(context)],
          ),
        ),
      ),
    );
  }

  Widget _buildLoginForm(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          CustomTextFormField(
            controller: emailController,
            hintText: "Email",
            textInputType: TextInputType.emailAddress,
            contentPadding: EdgeInsets.symmetric(horizontal: 18.h, vertical: 12.h),
          ),
          SizedBox(height: 14.h),
          CustomTextFormField(
            controller: passwordController,
            hintText: "Password",
            textInputType: TextInputType.visiblePassword,
            obscureText: true,
            textInputAction: TextInputAction.done,
            contentPadding: EdgeInsets.symmetric(horizontal: 18.h, vertical: 12.h),
          ),
          SizedBox(height: 14.h),
          GestureDetector(
            onTap: () => resetPassword(context),
            child: Text(
              "Forgot Password?",
              style: CustomTextStyles.labelLargePrimary,
            ),
          ),
          SizedBox(height: 40.h),
          CustomElevatedButton(
            height: 44.h,
            text: "Login",
            buttonStyle: CustomButtonStyles.fillPrimary,
            buttonTextStyle: CustomTextStyles.titleSmallBold,
            onPressed: signUserIn,
          ),
        ],
      ),
    );
  }
}