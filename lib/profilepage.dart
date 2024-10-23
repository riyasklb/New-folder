import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'dart:typed_data';


class ProfilePage extends StatefulWidget {
  final Map<dynamic, dynamic> datas;

  const ProfilePage({Key? key, required this.datas}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  @override
  void initState() {
    // GetResponse();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "My Activies",
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
      drawer: Container(
        width: 250, // Set the desired width for the drawer
        child: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              // Circular image with user details
              UserAccountsDrawerHeader(
                accountName: Text('${widget.datas?['firstname']+widget.datas?['lastname']}', style: const TextStyle(color: Colors.white,fontWeight: FontWeight.w600,fontSize: 20)),
                accountEmail: Text(widget.datas?['email'], style: const TextStyle(color: Colors.white,fontWeight: FontWeight.w400,fontSize: 15
                )),
                currentAccountPicture: CircleAvatar(
                  child: Image.asset('assets/profile/avatar.jpg',height: 50,),                ),
                decoration: BoxDecoration(color: Colors.blue),
              ),
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text('My Activity'),
                onTap: () {
                  Navigator.pop(context);
                  // Add navigation or functionality here
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
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Header
            Container(
              color: Colors.blue,
              padding: const EdgeInsets.all(16.0),
              child: UserAccountsDrawerHeader(
                accountName: Text(
                  '${widget.datas['firstname']} ${widget.datas['lastname']}',
                  style: const TextStyle(color: Colors.white, fontSize: 24),
                ),
                accountEmail: Text(
                  widget.datas['email'] ?? '',
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
                currentAccountPicture: CircleAvatar(
                  radius: 30,
                  child: Image.asset('assets/profile/avatar.jpg',height: 50,),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Summary Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Summary',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  _buildSummaryCard("Steps", widget.datas['walktime'] ?? "0", "Walking kilometers", Colors.redAccent),
                  _buildSummaryCard("Sleep", widget.datas['sleeptime'] ?? "0", "Hours slept", Colors.black),
                  _buildSummaryCard("Heart Rate", widget.datas['heartrate'] ?? "95", "bpm", Colors.red),
                  _buildSummaryCard("Water Intake", widget.datas['waterintake'] ?? "0", "Liters", Colors.blueAccent),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // More Sections (Optional)
            // Add more cards or sections as needed.
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          print("Starting Generating Pdf");
          await generatePdf();
        },
        label: Text('Download Report',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w300,color: Colors.white),),  // Use the 'extended' version for a text label
        icon: Icon(Icons.download,color:Colors.white),      // Add an icon next to the text
        backgroundColor: Color.fromRGBO(128, 11, 5, 1.0),    // You can customize the color
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

    );
  }


  Future<void> generatePdf() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Container(
          padding: pw.EdgeInsets.all(32),
          decoration: pw.BoxDecoration(
            border: pw.Border.all(color: PdfColors.grey),
            borderRadius: pw.BorderRadius.circular(10),
          ),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Patient Details',
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.blueGrey800,
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Text('Title : ${this.widget.datas?['title']}'),
              pw.SizedBox(height: 5),
              pw.Text('Name: ${this.widget.datas?['firstname']+this.widget.datas?['firstname']}'),
              pw.Text('Email: ${this.widget.datas?['email']}'),
              pw.Text('Mobile: ${this.widget.datas?['mobile']}'),
              pw.Text('NhS Number: ${this.widget.datas?['nhsnumber']}'),
              pw.Text('Food: ${this.widget.datas?['foodtake']}'),
              pw.SizedBox(height: 30),

              // Modern decorative section for monitor details
              pw.Container(
                padding: pw.EdgeInsets.all(20),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.blue),
                  borderRadius: pw.BorderRadius.circular(8),
                  gradient: pw.LinearGradient(
                    colors: [PdfColors.blue, PdfColors.lightBlueAccent],
                  ),
                ),
                child: pw.Column(
                  children: [
                    pw.Text(
                      'Monitor Details',
                      style: pw.TextStyle(
                        fontSize: 18,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.white,
                      ),
                    ),
                    pw.SizedBox(height: 10),
                    pw.Text('Medicine Contains: ${this.widget.datas?['drugordose']}', style: pw.TextStyle(color: PdfColors.white)),
                    pw.Text('Slept Time: ${this.widget.datas?['sleeptime']} Hours', style: pw.TextStyle(color: PdfColors.white)),
                    pw.Text('Water Taken: ${this.widget.datas?['waterintake']} Liters', style: pw.TextStyle(color: PdfColors.white)),
                    pw.Text('Walked :  ${this.widget.datas?['walktime']} kilometers', style: pw.TextStyle(color: PdfColors.white)),
                  ],
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Text('Generated on: ${DateTime.now()}'),
            ],
          ),
        ),
      ),
    );

    // Preview or save the generated PDF
    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
  }


  // Method to build a summary card
  Widget _buildSummaryCard(String title, String value, String unit, Color color) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  value,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            Text(
              unit,
              style: TextStyle(fontSize: 14, color: color),
            ),
          ],
        ),
      ),
    );
  }
}
