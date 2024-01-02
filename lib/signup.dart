import 'package:csci410_project2/signin.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class SignupForm extends StatefulWidget {
  @override
  _SignupFormState createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final _formKey = GlobalKey<FormState>();
  String _username = '';
  String _password = '';
  String _email = '';
  String _fullName = '';
  String _registrationMessage = '';

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width * 0.8;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Sign Up',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.teal, // Use the same color as the sign-in page
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: width, // Set the desired width based on a percentage
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Username',
                      prefixIcon: Icon(Icons.person, color: Colors.teal),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a username';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _username = value!;
                    },
                  ),
                ),
                SizedBox(height: 16),
                Container(
                  width: width, // Set the desired width based on a percentage
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: Icon(Icons.lock, color: Colors.teal),
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a password';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _password = value!;
                    },
                  ),
                ),
                SizedBox(height: 16),
                Container(
                  width: width, // Set the desired width based on a percentage
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email, color: Colors.teal),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an email';
                      }
                      // You can add more complex email validation logic here
                      return null;
                    },
                    onSaved: (value) {
                      _email = value!;
                    },
                  ),
                ),
                SizedBox(height: 16),
                Container(
                  width: width, // Set the desired width based on a percentage
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Full Name',
                      prefixIcon:
                          Icon(Icons.person_outline, color: Colors.teal),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your full name';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _fullName = value!;
                    },
                  ),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    _submitForm();
                  },
                  child: Text(
                    'Submit',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.teal,
                  ),
                ),
                // Display registration message
                SizedBox(height: 16),
                Text(
                  _registrationMessage,
                  style: TextStyle(color: Colors.green),
                ),
                // Already have an account? Sign in
                TextButton(
                  onPressed: () {
                    // Navigate to the sign-in page
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => SignInPage()),
                    );
                  },
                  child: Text(
                    "Already have an account? Sign in",
                    style: TextStyle(color: Colors.teal),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _submitForm() async {
    print('Submitting form');

    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final response = await http.post(
        Uri.parse('https://skypulse.000webhostapp.com/signup.php'),
        body: {
          'username': _username,
          'password_hash': _password,
          'email': _email,
          'full_name': _fullName,
        },
      );

      print('Response: ${response.body}');

      if (response.statusCode == 200) {
        // Registration successful
        print('Registration successful: ${response.body}');
        setState(() {
          _registrationMessage = 'Registration successful!';
        });
      } else {
        // Registration failed
        print('Registration failed: ${response.statusCode}');
        setState(() {
          _registrationMessage = 'Registration failed. Please try again.';
        });
      }
    }
  }
}
