import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:voice_assistant_app/auth/signup.dart';

import '../Screens/homescreen.dart';
import '../provider/utilities/utilities.dart';


class SquareTile extends StatelessWidget {
  final String imagePath;
  const SquareTile({
    super.key,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white),
        borderRadius: BorderRadius.circular(16),
        color: Colors.grey[200],
      ),
      child: Image.asset(
        imagePath,
        height: 40,
      ),
    );
  }
}

class MyButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final bool loading;

  const MyButton(
      {Key? key,
      required this.title,
      required this.onTap,
      this.loading = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(25),
        margin: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Center(
          child: loading? const CircularProgressIndicator(strokeWidth: 3, color: Colors.white,) :const Text(
            "Sign In",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool loading = false;
  final _formField = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  void login(){
    setState(() {
      loading = true;
    });
    _auth.signInWithEmailAndPassword(
      email: emailController.text, 
      password: passwordController.text.toString()).then((value){
        Utils().toastMessage(value.user!.email.toString());
        Navigator.push(context,
        MaterialPageRoute(builder: (context) => ChatScreen())
        );
        setState(() {
          loading = false;
        });

    }).onError((error, stackTrace){
      debugPrint(error.toString());
      Utils().toastMessage(error.toString());
      setState(() {
          loading = false;
        });
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
        SystemNavigator.pop();return true;
      },
      child: Scaffold(
          backgroundColor: Colors.grey[300],
          body: SingleChildScrollView(
              child: SafeArea(
                  child: Center(
            child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
    
                children: [
                  const SizedBox(height: 50),
    
                  // logo
                  Icon(
                    Icons.lock,
                    size: 100,
                    color: Colors.grey[800],
                  ),
    
                  const SizedBox(height: 50),
    
                  // welcome back, you've been missed!
                  Text(
                    'Start where you left off!',
                    style: TextStyle(
                      color: Colors.grey[800],
                      fontSize: 16,
                    ),
                  ),
    
                  const SizedBox(height: 25),
    
                  Form(
                    key: _formField,
                    child: Column(children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: TextFormField(
                          controller: emailController,
                          obscureText: false,
                          // hintText: 'Email',
    
                          decoration: InputDecoration(
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white10),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey.shade800),
                              ),
                              fillColor: Colors.grey.shade800,
                              filled: true,
                              hintText: 'Email',
                              hintStyle: const TextStyle(color: Colors.white)),
    
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Enter email';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: TextFormField(
                          controller: passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white10),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey.shade800),
                              ),
                              fillColor: Colors.grey.shade800,
                              filled: true,
                              hintText: 'Password',
                              hintStyle: const TextStyle(color: Colors.white)),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Enter Password';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
    
                      MyButton(onTap: () {
                        if(_formField.currentState!.validate()){
                          login();
                        }
                      }, title: 'Login',
                      loading: loading ,),
    
                      // forgot password?
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              'Forgot Password?',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      ),
    
                      const SizedBox(height: 25),
    
                      // or continue with
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Divider(
                                thickness: 1,
                                color: Colors.grey[400],
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Text(
                                'Or continue with',
                                style: TextStyle(color: Colors.grey[700]),
                              ),
                            ),
                            Expanded(
                              child: Divider(
                                thickness: 1,
                                color: Colors.grey[400],
                              ),
                            ),
                          ],
                        ),
                      ),
    
                      const SizedBox(height: 30),
    
                      // google + apple sign in buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          // google button
                          SquareTile(imagePath: 'lib/images/google.png'),
    
                          SizedBox(width: 20),
    
                          // apple button
                          SquareTile(imagePath: 'lib/images/apple.png')
                        ],
                      ),
    
                      const SizedBox(height: 50),
    
                      // not a member? register now
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center, 
                        children: [
                        Text(
                          'Not a member?',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                        const SizedBox(width: 4),
                        
                        TextButton(onPressed: () {
                          Navigator.push(context,
                          MaterialPageRoute(builder: (context) => const SignupScreen())
                          );
                        }, child: const Text('Register Now'))
                      ]),
                    ]),
                  )
                ]),
          )))),
    );
  }
}
