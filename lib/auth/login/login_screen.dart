import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_todo_c9_mon/auth/register/register_screen.dart';
import 'package:flutter_app_todo_c9_mon/components/custom_text_form_field.dart';
import 'package:flutter_app_todo_c9_mon/dialog_utils.dart';
import 'package:flutter_app_todo_c9_mon/firebase_utils.dart';
import 'package:flutter_app_todo_c9_mon/home/home_screen.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = 'login';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var emailController = TextEditingController(text: 'amira@route.com');

  var passwordController = TextEditingController(text: '123456');

  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            'assets/images/main_background.png',
            width: double.infinity,
            fit: BoxFit.fill,
          ),
          Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.3,
                    ),
                    CustomTextFormField(
                      label: 'Email Address',
                      keyboardType: TextInputType.emailAddress,
                      controller: emailController,
                      validator: (text) {
                        if (text == null || text.trim().isEmpty) {
                          return 'Please enter email address';
                        }
                        bool emailValid = RegExp(
                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(text);
                        if (!emailValid) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    CustomTextFormField(
                      label: 'Password',
                      keyboardType: TextInputType.number,
                      controller: passwordController,
                      obscureText: true,
                      validator: (text) {
                        if (text == null || text.trim().isEmpty) {
                          return 'Please enter Password';
                        }
                        if (text.length < 6) {
                          return 'Password should be at least 6 chars.';
                        }
                        return null;
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 12)),
                          onPressed: () {
                            register();
                          },
                          child: Text(
                            'Login',
                            style: Theme.of(context).textTheme.titleLarge,
                          )),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.1,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account?",
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        TextButton(
                            onPressed: () {
                              /// navigate to register screen
                              Navigator.of(context)
                                  .pushNamed(RegisterScreen.routeName);
                            },
                            child: Text('SignUp',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(
                                        color: Theme.of(context).primaryColor)))
                      ],
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  void register() async {
    if (formKey.currentState?.validate() == true) {
      //todo: register with firebase auth
      DialogUtils.showLoading(context, 'Loading...');
      try {
        final credential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
                email: emailController.text, password: passwordController.text);

        var user = await FirebaseUtils.readUserFromFireStore(
            credential.user?.uid ?? '');
        if (user == null) {
          return;
        }
        var authProvider = Provider.of<AuthProvider>(context, listen: false);
        authProvider.updateUser(user);
        // todo: hide loading
        DialogUtils.hideLoading(context);
        // todo : show message
        DialogUtils.showMessage(context, 'Login Successfully',
            posActionName: 'Ok', title: 'Success', posAction: () {
          Navigator.pushReplacementNamed(context, HomeScreen.routeName);
        });
      } on FirebaseAuthException catch (e) {
        if (e.code == 'INVALID_LOGIN_CREDENTIALS') {
          // todo: hide loading
          DialogUtils.hideLoading(context);
          // todo : show message
          DialogUtils.showMessage(context,
              'No user found for that email or Wrong password provided for that user.',
              posActionName: 'Ok', title: 'Error');
        }
      } catch (e) {
        // todo: hide loading
        DialogUtils.hideLoading(context);
        // todo : show message
        DialogUtils.showMessage(context, e.toString(), posActionName: 'Ok');
      }
    }
  }
}
