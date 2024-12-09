import 'package:acl_application/core/utils/size_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../routes/app_routes.dart';
import '../../theme/custom_button_style.dart';
import '../../theme/custom_text_style.dart';
import '../../widgets/custom_checkbox_button.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_text_from_field.dart';

class RegisterpagePage extends StatefulWidget {
  const RegisterpagePage({super.key});

  @override
  RegisterpagePageState createState() => RegisterpagePageState();
}

class RegisterpagePageState extends State<RegisterpagePage>
    with AutomaticKeepAliveClientMixin<RegisterpagePage> {
  TextEditingController nameFieldController = TextEditingController();
  TextEditingController surnameFieldController = TextEditingController();
  TextEditingController phoneNumberFieldController = TextEditingController();
  TextEditingController emailFieldController = TextEditingController();
  TextEditingController passwordFieldController = TextEditingController();
  TextEditingController repeatPasswordFieldController = TextEditingController();
  bool termsAndConditionsCheckbox = false;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: SingleChildScrollView(
            child: Container(
              width: double.maxFinite,
              margin: EdgeInsets.symmetric(horizontal: 22.h, vertical: 26.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildNameField(context),
                  SizedBox(height: 14.h),
                  _buildEmailField(context),
                  SizedBox(height: 14.h),
                  _buildPasswordField(context),
                  SizedBox(height: 14.h),
                  _buildRepeatPasswordField(context),
                  SizedBox(height: 14.h),
                  _buildTermsAndConditionsCheckbox(context),
                  SizedBox(height: 20.h),
                  _buildRegisterButton(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNameField(BuildContext context) {
    return CustomTextFormField(
      controller: nameFieldController,
      hintText: "Name",
      contentPadding: EdgeInsets.symmetric(
        horizontal: 20.h,
        vertical: 10.h,
      ),
    );
  }

  Widget _buildEmailField(BuildContext context) {
    return CustomTextFormField(
      controller: emailFieldController,
      hintText: "Email",
      textInputType: TextInputType.emailAddress,
      contentPadding: EdgeInsets.symmetric(
        horizontal: 20.h,
        vertical: 10.h,
      ),
    );
  }

  Widget _buildPasswordField(BuildContext context) {
    return CustomTextFormField(
      controller: passwordFieldController,
      hintText: "Password",
      textInputType: TextInputType.visiblePassword,
      obscureText: true,
      textInputAction: TextInputAction.done,
      contentPadding: EdgeInsets.symmetric(
        horizontal: 20.h,
        vertical: 10.h,
      ),
    );
  }

  Widget _buildRepeatPasswordField(BuildContext context) {
    return CustomTextFormField(
      controller: repeatPasswordFieldController,
      hintText: "Repeat password",
      textInputType: TextInputType.visiblePassword,
      obscureText: true,
      textInputAction: TextInputAction.done,
      contentPadding: EdgeInsets.symmetric(
        horizontal: 20.h,
        vertical: 10.h,
      ),
    );
  }

  Widget _buildTermsAndConditionsCheckbox(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 8.h),
      child: CustomCheckboxButton(
        text: "I accept the terms and conditions...",
        value: termsAndConditionsCheckbox,
        onChange: (value) {
          setState(() {
            termsAndConditionsCheckbox = value;
          });
        },
      ),
    );
  }

  Widget _buildRegisterButton(BuildContext context) {
    return CustomElevatedButton(
      height: 44.h,
      text: "Register",
      buttonStyle: CustomButtonStyles.fillPrimary,
      buttonTextStyle: CustomTextStyles.titleSmallBold,
      onPressed: () {
        if (!termsAndConditionsCheckbox) {
          _showAlertDialog('Terms and Conditions', 'You must accept the terms and conditions to register.');
          return;
        }
        registerUser();
      },
    );
  }

  void registerUser() async {
    if (passwordFieldController.text.trim() != repeatPasswordFieldController.text.trim()) {
      _showAlertDialog('Password Mismatch', 'Passwords do not match.');
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return const Center(child: CircularProgressIndicator());
      },
    );

    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailFieldController.text.trim(),
        password: passwordFieldController.text.trim(),
      );

      User? user = userCredential.user;

      if (user != null) {
        await _saveUserDataToFirestore(user.uid);
      }

      Navigator.pop(context);
      Navigator.pushReplacementNamed(context, AppRoutes.profilepagePage);
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      _handleFirebaseAuthException(e);
    } catch (e) {
      Navigator.pop(context);
      _showAlertDialog('Error', 'Something went wrong. Please try again.');
    }
  }

  Future<void> _saveUserDataToFirestore(String userId) async {
    final firestore = FirebaseFirestore.instance;
    final userDoc = firestore.collection('usersData').doc(userId);

    print("Checking if user document exists in Firestore...");

    try {
      // Sprawdzanie, czy dokument istnieje
      final docSnapshot = await userDoc.get();

      if (docSnapshot.exists) {
        print("Document for user $userId already exists. Updating data...");
      } else {
        print("Document for user $userId does not exist. Creating new document...");
      }

      // Zapisywanie lub aktualizowanie danych użytkownika
      await userDoc.set({
        'name': nameFieldController.text.trim(),
        'surname': surnameFieldController.text.trim(),
        'phone': phoneNumberFieldController.text.trim(),
        'email': emailFieldController.text.trim(),
        'acceptedTerms': termsAndConditionsCheckbox,
      }, SetOptions(merge: true)) // Ustawienie merge na true, aby aktualizować bez usuwania istniejących pól
          .then((_) => print("Data saved successfully"))
          .catchError((error) => print("Failed to save data: $error"));

    } catch (e) {
      print("Error while saving user data: $e");
    }
  }

  void _handleFirebaseAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        _showAlertDialog('Email Already In Use', 'The email address is already in use by another account.');
        break;
      case 'invalid-email':
        _showAlertDialog('Invalid Email', 'The email address format is invalid.');
        break;
      case 'weak-password':
        _showAlertDialog('Weak Password', 'The password must be at least 6 characters long.');
        break;
      default:
        _showAlertDialog('Unknown Error', e.message ?? 'An unknown error occurred.');
    }
  }

  void _showAlertDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }
}
