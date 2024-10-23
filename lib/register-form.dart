import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dashboard.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const Register(),
    );
  }
}

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  // Declaring controllers at the class level
  late final TextEditingController titleController;
  late final TextEditingController firstnameController;
  late final TextEditingController lastnameController;
  late final TextEditingController nhsnumberController;
  late final TextEditingController emailController;
  late final TextEditingController mobileController;
  late final TextEditingController sleeptimeController;
  late final TextEditingController waterIntakeController;
  late final TextEditingController walktimeController;

  String? drugOrDose;
  String? foodAte;

  @override
  void initState() {
    super.initState();
    // Initialize controllers in initState to avoid creating new instances on each build
    titleController = TextEditingController();
    firstnameController = TextEditingController();
    lastnameController = TextEditingController();
    nhsnumberController = TextEditingController();
    emailController = TextEditingController();
    mobileController = TextEditingController();
    sleeptimeController = TextEditingController();
    waterIntakeController = TextEditingController();
    walktimeController = TextEditingController();
  }

  @override
  void dispose() {
    // Dispose controllers to free memory
    titleController.dispose();
    firstnameController.dispose();
    lastnameController.dispose();
    nhsnumberController.dispose();
    emailController.dispose();
    mobileController.dispose();
    sleeptimeController.dispose();
    waterIntakeController.dispose();
    walktimeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            "Register Page",
            style: TextStyle(fontSize: 40, fontWeight: FontWeight.w500, color: Colors.white),
          ),
        ),
        backgroundColor: Colors.black26,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.90),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                 RichText(
                  text: TextSpan(
                    text: "Hey User!",
                    style: TextStyle(color: Colors.black, fontSize: 30, fontStyle: FontStyle.italic),
                    children: <TextSpan>[
                      TextSpan(
                        text: "\nPlease fill out this form",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400, color: Colors.green),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Title
                _buildTextField(controller: titleController, labelText: 'Title', hintText: 'Enter title', icon: Icons.category),

                const SizedBox(height: 10),

                // First Name
                _buildTextField(controller: firstnameController, labelText: 'Firstname', hintText: 'Enter firstname', icon: Icons.person),

                const SizedBox(height: 10),

                // Last Name
                _buildTextField(controller: lastnameController, labelText: 'Lastname', hintText: 'Enter lastname', icon: Icons.drive_file_rename_outline),

                const SizedBox(height: 10),

                // NHS Number
                _buildTextField(controller: nhsnumberController, labelText: 'Enter NHS Number', hintText: 'NHS Number', icon: Icons.verified, inputType: TextInputType.number),

                const SizedBox(height: 10),

                // Email
                _buildTextField(controller: emailController, labelText: 'Enter email', hintText: 'email', icon: Icons.email),

                const SizedBox(height: 10),

                // Mobile Number
                _buildTextField(controller: mobileController, labelText: 'Enter Mobile Number', hintText: 'Number', icon: Icons.phone, inputType: TextInputType.number),

                const SizedBox(height: 10),

                // Drug/Dose Dropdown
                _buildDropdown(
                  value: drugOrDose,
                  label: 'Medicine contains Drug/Dose',
                  icon: Icons.local_hospital,
                  items: ['Drug', 'Dose'],
                  onChanged: (value) => setState(() => drugOrDose = value),
                ),

                const SizedBox(height: 10),

                // Walk Time
                _buildTextField(controller: walktimeController, labelText: 'How many kilometers do you walk per day?', hintText: 'Kilometers?', icon: Icons.directions_walk, inputType: TextInputType.number),

                const SizedBox(height: 10),

                // Sleep Time
                _buildTextField(controller: sleeptimeController, labelText: 'How long do you sleep per day?', hintText: 'Hours?', icon: Icons.airline_seat_legroom_extra_sharp, inputType: TextInputType.number),

                const SizedBox(height: 10),

                // Water Intake
                _buildTextField(controller: waterIntakeController, labelText: 'How many liters do you consume per day?', hintText: 'Liters?', icon: Icons.water_drop_sharp, inputType: TextInputType.number),

                const SizedBox(height: 10),

                // Food Intake Dropdown
                _buildDropdown(
                  value: foodAte,
                  label: 'Food Intake',
                  icon: Icons.restaurant_menu,
                  items: ['Breakfast', 'Lunch', 'Dinner', 'Snack Time'],
                  onChanged: (value) => setState(() => foodAte = value),
                ),

                const SizedBox(height: 20),

                // Submit Button
                FloatingActionButton(
                  onPressed: () async {
                    // Example of validation
                    if (firstnameController.text.isNotEmpty && drugOrDose != null && foodAte != null) {
                      // Handle form submission
                      print("Form Constraint Passed");

                      /*
                       titleController.dispose();
    firstnameController.dispose();
    lastnameController.dispose();
    nhsnumberController.dispose();
    emailController.dispose();
    mobileController.dispose();
    sleeptimeController.dispose();
    waterIntakeController.dispose();
    walktimeController.dispose();
                       */
                      SharedPreferences prefs = await SharedPreferences.getInstance();

                      if (prefs.getString("user_data") == null) {
                        // Prepare the data in a map
                        Map<String, dynamic> datas = {
                          "title": titleController.text.trim(),
                          "firstname": firstnameController.text.trim(),
                          "lastname": lastnameController.text.trim(),
                          "drugordose": drugOrDose,
                          "foodtake": foodAte,
                          "nhsnumber": nhsnumberController.text.trim(),
                          "email": emailController.text.trim(),
                          "mobile": mobileController.text.trim(),
                          "sleeptime": sleeptimeController.text.trim(),
                          "waterintake": waterIntakeController.text.trim(),
                          "walktime": walktimeController.text.trim(),
                        };

                        // Encode the map to a JSON string
                        String jsondatas = jsonEncode(datas);

                        // Save the JSON string in SharedPreferences
                        await prefs.setString("user_data", jsondatas);

                        print("Data saved successfully!");

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
                          Map<String,dynamic> datas = {

                            "title":titleController.text.trim(),
                            "firstname":firstnameController.text.trim(),
                            "lastname":lastnameController.text.trim(),
                            "drugordose": drugOrDose,
                            "foodtake" : foodAte,
                            "nhsnumber":nhsnumberController.text.trim(),
                            "email":emailController.text.trim(),
                            "mobile":mobileController.text.trim(),
                            "sleeptime":sleeptimeController.text.trim(),
                            "waterintake":waterIntakeController.text.trim(),
                            "walktime":walktimeController.text.trim(),

                          };
                          String jsondatas = jsonEncode(datas.toString());

                          prefs.setString("user_data", jsondatas);

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

                    } else {
                      print("Please fill in all fields");
                    }
                  },
                  child: Text("Submit"),
                  backgroundColor: Colors.blue, // Customize the background color
                  splashColor: Colors.white, // Splash effect color
                  elevation: 8.0, // Adds a nice shadow
                  tooltip: 'Next', // Tooltip for better UX (shows when long-pressed)
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0), // Make it slightly rounded
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper method to build TextFields
  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required String hintText,
    required IconData icon,
    TextInputType inputType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Colors.grey[200],
        prefixIcon: Icon(icon),
      ),
      keyboardType: inputType,
    );
  }

  // Helper method to build DropdownButtonFormFields
  Widget _buildDropdown({
    required String? value,
    required String label,
    required IconData icon,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      icon: Icon(icon),
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Colors.grey[200],
      ),
      items: items.map((item) => DropdownMenuItem<String>(value: item, child: Text(item))).toList(),
      onChanged: onChanged,
    );
  }
}
