import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dashboard.dart';
import 'register-form.dart';

void main() {
  runApp(const Myapp());
}

class Myapp extends StatelessWidget {
  const Myapp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Index(),
    );
  }
}

class Index extends StatefulWidget {
  const Index({super.key});

  @override
  State<Index> createState() => _IndexState();
}

class _IndexState extends State<Index> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _animation;

  @override
  void initState() {
    super.initState();

    // Setup for the animation controller
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true); // Animates back and forth

    // Define a colorful gradient animation for loading
    _animation = ColorTween(
      begin: Colors.blueAccent,
      end: Colors.orangeAccent,
    ).animate(_controller);
  }

  @override
  void dispose() {
    // Clean up the animation controller when the widget is disposed
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool islargescreen = MediaQuery.of(context).size.width > 600;
    bool isloaded=false;
    return Scaffold(
      body: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {

          return Container(
            padding: const EdgeInsets.all(32),
            color: _animation.value, // Animated background color
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    child: Image.asset(
                      "assets/logo/index-logo.jpg",
                      fit: BoxFit.cover,
                      height: 500,
                      width: double.maxFinite,
                    ),
                    radius: 80,
                  ),
                  const SizedBox(height: 20),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "Welcome To Thrombosis",
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            color: Colors.white,
                            fontSize: islargescreen ? 30 : 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "For Outpatient Hospital Discharge",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: islargescreen ? 30 : 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                   SizedBox(height: 40),
               isloaded?Center(child: CircularProgressIndicator()):ElevatedButton(
                    onPressed: () async{
                      // Show a loading animation for 2 seconds
                      setState(() {
                        print("isloading activating");
                        isloaded =true;
                      });
                      // find the preferencefile

                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      if( prefs.getString("user_data")!=null) {
                        Future.delayed(const Duration(seconds: 2), () {
                          Navigator.pushReplacement(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (context, animation,
                                  secondaryAnimation) => const DashboardPage(),
                              transitionsBuilder: (context, animation,
                                  secondaryAnimation, child) {
                                var begin = 0.0;
                                var end = 1.0;
                                var curve = Curves.easeInOut;
                                var tween = Tween(begin: begin, end: end).chain(
                                    CurveTween(curve: curve));

                                return FadeTransition(
                                  opacity: animation.drive(tween),
                                  child: child,
                                );
                              },
                            ),
                          );
                        });
                      }
                      else
                        {
                          Future.delayed(const Duration(seconds: 2), () {
                            Navigator.pushReplacement(
                              context,
                              PageRouteBuilder(
                                pageBuilder: (context, animation,
                                    secondaryAnimation) => const RegisterPage(),
                                transitionsBuilder: (context, animation,
                                    secondaryAnimation, child) {
                                  var begin = 0.0;
                                  var end = 1.0;
                                  var curve = Curves.easeInOut;
                                  var tween = Tween(begin: begin, end: end).chain(
                                      CurveTween(curve: curve));

                                  return FadeTransition(
                                    opacity: animation.drive(tween),
                                    child: child,
                                  );
                                },
                              ),
                            );
                          });
                        }
                     },
                    child: Text(
                      "Let's get Started",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: islargescreen ? 30 : 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                      overlayColor: MaterialStateProperty.resolveWith<Color?>(
                            (Set<MaterialState> states) {
                          if (states.contains(MaterialState.hovered)) return Colors.blue.withOpacity(0.04);
                          if (states.contains(MaterialState.focused) || states.contains(MaterialState.pressed)) {
                            return Colors.blue.withOpacity(0.12);
                          }
                          return null; // Defer to the widget's default.
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
