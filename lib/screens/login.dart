// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/signin_service.dart';
import '../widgets/theme_button.dart';
import 'upload_pdf.dart'; // Ensure to import your UploadPdFScreen file

class LoginScreen extends StatefulWidget {
  bool isLogin;

  LoginScreen({Key? key, required this.isLogin}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isObscure = true;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final signInService = Provider.of<SignInService>(context, listen: false);
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Container(
          color: Colors.black,
          child: Stack(
            children: [
              Positioned.fill(
                child: Opacity(
                  opacity: 0.3,
                  child: Image.asset(
                    'assets/imgs/angel.jpeg',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: ClipOval(
                        child: Container(
                          width: 180,
                          height: 180,
                          color: Colors.white,
                          alignment: Alignment.center,
                          child: Image.asset(
                            'assets/imgs/church.png',
                            height: 150,
                            width: 150,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      widget.isLogin ? 'Login' : 'Register',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 40),
                    buildInputForm('Email', false, _emailController),
                    buildInputForm('Password', true, _passwordController),
                    const SizedBox(height: 40),
                    ThemeButton(
                      label: widget.isLogin ? 'LOGIN' : 'REGISTER',
                      highlight: Colors.green[900],
                      color: Colors.amber,
                      onClick: () async {
                        final form = _formKey.currentState;
                        if (form!.validate()) {
                          FocusScope.of(context).unfocus();
                          form.save();

                          setState(() {
                            _isLoading = true;
                          });

                          bool success = (widget.isLogin
                              ? await signInService.signInWithEmailPassword(
                                  _emailController.text,
                                  _passwordController.text,
                                )
                              : await signInService.createAccount(
                                  _emailController.text,
                                  _passwordController.text,
                                )) as bool;

                          if (success) {
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                return const AlertDialog(
                                  content: SizedBox(
                                    width: 150,
                                    height: 150,
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          CircularProgressIndicator(
                                            strokeWidth: 10,
                                            color: Colors.white,
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                              Colors.white,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            'Login in ...',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );

                            await Future.delayed(
                              const Duration(seconds: 5),
                            );

                            setState(() {
                              _isLoading = false;
                            });

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UploadPdfScreen(),
                              ),
                            );
                          } else {
                            setState(() {
                              _isLoading = false;
                            });
                            // Handle failure or show error message
                          }
                        }
                      },
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          child: const Text(
                            'Don\'t have an account? Register instead',
                            style: TextStyle(
                              color: Colors.white54,
                              fontWeight: FontWeight.w900,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              widget.isLogin = !widget.isLogin;
                            });
                          },
                        ),
                      ],
                    ),
                    if (_isLoading)
                      const Center(
                        child: CircularProgressIndicator(),
                      ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Padding buildInputForm(
      String label, bool pass, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 30),
      child: TextFormField(
        style: const TextStyle(
          color: Colors.white,
        ),
        keyboardType: label == 'Email'
            ? TextInputType.emailAddress
            : label == 'phone'
                ? TextInputType.phone
                : TextInputType.text,
        obscureText: pass ? _isObscure : false,
        controller: controller,
        validator: (value) {
          return value!.isEmpty ? '$label is required' : null;
        },
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(
            color: Colors.white,
          ),
          border: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          suffixIcon: pass
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      _isObscure = !_isObscure;
                    });
                  },
                  icon: _isObscure
                      ? const Icon(
                          Icons.visibility_off,
                          color: Colors.grey,
                        )
                      : const Icon(
                          Icons.visibility,
                          color: Colors.grey,
                        ),
                )
              : null,
        ),
      ),
    );
  }
}
