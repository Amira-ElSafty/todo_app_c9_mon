import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_todo_c9_mon/auth/login/login_screen.dart';
import 'package:flutter_app_todo_c9_mon/components/custom_text_form_field.dart';
import 'package:flutter_app_todo_c9_mon/dialog_utils.dart';
import 'package:flutter_app_todo_c9_mon/firebase_utils.dart';
import 'package:flutter_app_todo_c9_mon/home/home_screen.dart';
import 'package:flutter_app_todo_c9_mon/model/my_user.dart';
import 'package:flutter_app_todo_c9_mon/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  static const String routeName = 'register';

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  var nameController = TextEditingController(text: 'Amira');

  var emailController = TextEditingController(text: 'amira@route.com');

  var passwordController = TextEditingController(text: '123456');

  var confirmPasswordController = TextEditingController(text: '123456');

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
                      label: 'User Name',
                      controller: nameController,
                      validator: (text) {
                        if (text == null || text.trim().isEmpty) {
                          return 'Please enter User Name';
                        }
                        return null;
                      },
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
                    CustomTextFormField(
                      label: 'Confirm Password',
                      keyboardType: TextInputType.number,
                      controller: confirmPasswordController,
                      obscureText: true,
                      validator: (text) {
                        if (text == null || text.trim().isEmpty) {
                          return 'Please enter Confirm Password';
                        }
                        if (text != passwordController.text) {
                          return "Password doesn't match.";
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
                            'Register',
                            style: Theme.of(context).textTheme.titleLarge,
                          )),
                    ),
                    TextButton(
                        onPressed: () {
                          /// navigate to login screen
                          Navigator.of(context)
                              .pushNamed(LoginScreen.routeName);
                        },
                        child: Text(
                          'Already hava an account',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(color: Theme.of(context).primaryColor),
                        )),
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
      // todo: show loading
      DialogUtils.showLoading(context, 'Loading...');
      try {
        final credential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
        MyUser myUser = MyUser(
            id: credential.user?.uid ?? '',
            name: nameController.text,
            email: emailController.text);
        var authProvider = Provider.of<AuthProvider>(context, listen: false);
        authProvider.updateUser(myUser);
        FirebaseUtils.addUserToFireStore(myUser).then((value) {
        });
        // todo: hide loading
        DialogUtils.hideLoading(context);
        // todo : show message
        DialogUtils.showMessage(context, 'Register Successfully',
            posActionName: 'Ok', title: 'Success', posAction: () {
          Navigator.pushReplacementNamed(context, HomeScreen.routeName);
        });
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          // todo: hide loading
          DialogUtils.hideLoading(context);
          // todo : show message
          DialogUtils.showMessage(context, 'The password provided is too weak.',
              posActionName: 'Ok');
        } else if (e.code == 'email-already-in-use') {
          // todo: hide loading
          DialogUtils.hideLoading(context);
          // todo : show message
          DialogUtils.showMessage(
              context, 'The account already exists for that email',
              posActionName: 'Ok');
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
