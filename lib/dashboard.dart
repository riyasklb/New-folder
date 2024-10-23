import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thrombosis/CachesHelper.dart';
import 'package:thrombosis/main.dart';

import 'profilepage.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  bool getresponse = false;
  Map? datas;
  int _selectedIndex = 2; // To track bottom navigation bar item selection

  @override
  void initState() {
    GetResponse();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Health Data",
          style: TextStyle(
            fontSize: 30,
            color: Colors.pink,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: const [
          Icon(Icons.notifications_on_sharp, color: Colors.red),
          SizedBox(width: 15),
        ],
      ),

      // Drawer for menu bar
      drawer: getresponse?Container(
        width: 250, // Set the desired width for the drawer
        child: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[

              // Circular image with user details
              UserAccountsDrawerHeader(
                accountName: Text('${datas?['firstname']+datas?['lastname']}', style: const TextStyle(color: Colors.white,fontWeight: FontWeight.w600,fontSize: 20)),
                accountEmail: Text(datas?['email'], style: const TextStyle(color: Colors.white,fontWeight: FontWeight.w400,fontSize: 15
                )),
                currentAccountPicture: CircleAvatar(
                  child: Image.asset('assets/profile/avatar.jpg',height: 50,),                ),
                decoration: BoxDecoration(color: Colors.blue),
              ),
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text('My Activity'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfilePage(datas: datas!),
                    ),
                  );                  // Add navigation or functionality here
                },
              ),
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('Settings'),
                onTap: () {
                  Navigator.pop(context);
                  // Add navigation or functionality here
                },
              ),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Logout'),
                onTap: ()async {
SharedPreferences prefs = await SharedPreferences.getInstance();
prefs.remove("user_data");

Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) =>Myapp()));
                },
              ),
            ],
          ),
        ),
      ):CircularProgressIndicator(),
      body: getresponse
          ? Container(
        padding: const EdgeInsets.all(16.0), // Adjusted padding for better layout
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildCalendar(),
              const SizedBox(height: 20),
              GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 12.0,
                childAspectRatio: 1.2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildDataCard("Steps", datas?['walktime'] ?? "", "walking kilometer", Colors.redAccent,
                      Icons.directions_walk),
                  _buildDataCard("Sleep", datas?['sleeptime'] ?? "", "Sleeped Hours", Colors.black,
                      Icons.airline_seat_legroom_extra_outlined),
                  _buildDataCard("Heart Rate", "95", "bpm", Colors.red, Icons.favorite),
                  _buildDataCard("WaterIntake", datas?['waterintake'] ?? "", "Water Drinked", Colors.blueAccent,
                      Icons.water_drop_sharp),
                ],
              ),
              const SizedBox(height: 20),
              const Text("Days Logged", style: TextStyle(fontSize: 20)),
              SizedBox(height: 200, child: _buildDaysLoggedChart()),
              const SizedBox(height: 20),
              const Text("Food Intake", style: TextStyle(fontSize: 20)),
              SizedBox(height: 200, child: _buildFoodIntakeChart()),
            ],
          ),
        ),
      )
          : const Center(child: CircularProgressIndicator()),

      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped, // Handle tap on items
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.emoji_events,color:Colors.red),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.video_call,color:Colors.blueAccent),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bolt,color: Colors.green,),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star,color: Colors.yellow,),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_hospital,color: Colors.red,),
            label: '',
          ),
        ],
      ),
    );
  }

  // Method to handle bottom navigation item taps
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Navigate to different pages based on the selected index
    // You can implement navigation logic here
  }

  // Method to build each data card
  Widget _buildDataCard(String title, String value, String unit, Color color, IconData icon) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 30),
            const SizedBox(height: 10),
            Text(
              value,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(unit, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Future<bool> GetResponse() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? datas = prefs.getString("user_data");

    if (datas != null && datas.isNotEmpty) {
      try {
        datas = datas.replaceAll("'", '"');

        try {
          Map<String, dynamic> jsonData = jsonDecode(datas);
          Cacheshelper chaches = Cacheshelper(myuserdatas: jsonData);
          this.datas = chaches.getjsonresponse();

          setState(() {
            getresponse = this.datas != null;
          });
        } catch (e) {
          print("Error decoding JSON: $e");
          setState(() {
            getresponse = false;
          });
        }
      } catch (e) {
        print("Error decoding JSON: $e");
      }
    } else {
      setState(() {
        getresponse = false;
      });
    }

    return getresponse;
  }

  Widget _buildCalendar() {
    DateTime now = DateTime.now();
    int currentDay = now.day;
    int currentMonth = now.month;

    return SizedBox(
      height: 60,
      child: FutureBuilder<int>(
        future: daysInMonth(now),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Text('Error loading days');
          } else {
            int daysInCurrentMonth = snapshot.data ?? 30;
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: daysInCurrentMonth,
              itemBuilder: (context, index) {
                int day = index + 1;
                bool isToday = day == currentDay;

                return Container(
                  width: 50,
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: isToday ? Colors.pinkAccent : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"][(index + DateTime(now.year, currentMonth, 1).weekday - 1) % 7],
                        style: TextStyle(
                          color: isToday ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        day.toString(),
                        style: TextStyle(
                          color: isToday ? Colors.white : Colors.black,
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  Future<int> daysInMonth(DateTime date) async {
    var nextMonth = (date.month < 12) ? DateTime(date.year, date.month + 1, 1) : DateTime(date.year + 1, 1, 1);
    var lastDayOfCurrentMonth = nextMonth.subtract(const Duration(days: 1));
    return lastDayOfCurrentMonth.day;
  }

  Widget _buildDaysLoggedChart() {
    return LineChart(
      LineChartData(
        lineBarsData: [
          LineChartBarData(
            isCurved: true,
            spots: const [
              FlSpot(0, 1),
              FlSpot(1, 3),
              FlSpot(2, 2),
              FlSpot(3, 5),
              FlSpot(4, 3),
              FlSpot(5, 4),
              FlSpot(6, 5),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFoodIntakeChart() {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceBetween,
        barGroups: [
          BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 2)]),
          BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: 4)]),
          BarChartGroupData(x: 3, barRods: [BarChartRodData(toY: 3)]),
          BarChartGroupData(x: 4, barRods: [BarChartRodData(toY: 5)]),
          BarChartGroupData(x: 5, barRods: [BarChartRodData(toY: 4)]),
        ],
      ),
    );
  }
}
