import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:forms_app/screens/maindrawer.dart';
import 'package:forms_app/services/location.dart';
import 'package:forms_app/services/addEmergency.dart';
import 'package:forms_app/services/user.dart';
import 'package:forms_app/pages/login.dart';
import 'package:forms_app/pages/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:forms_app/screens/loading.dart';
import 'dart:convert';

class AddEmergency extends StatefulWidget {
  const AddEmergency({Key? key}) : super(key: key);

  @override
  _AddEmergencyState createState() => _AddEmergencyState();
}

class _AddEmergencyState extends State<AddEmergency> {
  final _formKey = GlobalKey<FormState>();
  String? description;
  String? location;
  String? token;
  double? longitude;
  double? latitude;
  int? statusCodeUser;
  int? stausCodeEmergency;
  Map? data;
  bool loading = false;

  Future currentUserLocation() async {
    getUserCoordinates instance = getUserCoordinates();
    await instance.getCurrentLocation();
    Placemark placeMark = instance.placemarks![0];
    String locality = placeMark.locality as String;
    String street = placeMark.street as String;
    longitude = instance.longitude;
    latitude = instance.latitude;
    return "location: $street, $locality coordinates: ($latitude, $longitude)";
  }

  Future<void> authCheck() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = await prefs.getString("access-token");
    getUser instance = await getUser(token: token as String);
    await instance.userDetails();
    statusCodeUser = instance.statusCode;
    if (statusCodeUser != 200) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (BuildContext context) => Login()),
      );
    }
  }

  void _showDialog() {
    String message =
        "There was an error in sending your report. Please ensure you have internet connection and your location service is turned on.";
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          backgroundColor: Colors.red[800],
          title: Text("Report Not Sent",
              style: TextStyle(
                  letterSpacing: 2,
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                  color: Colors.white)),
          content: Text("$message",
              style: TextStyle(
                  letterSpacing: 2, fontSize: 18, color: Colors.white)),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  primary: Colors.red[200],
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(Icons.close),
                label: Text("Close"))
          ],
        );
      },
    );
  }

  void _showDialogSuccess() {
    String message = "We received your report. We'll be there shortly.";
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          backgroundColor: Colors.green[400],
          title: Text("Report Sent",
              style: TextStyle(
                  letterSpacing: 2,
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                  color: Colors.white)),
          content: Text("$message",
              style: TextStyle(
                  letterSpacing: 2, fontSize: 18, color: Colors.white)),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  primary: Colors.green[200],
                ),
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                        builder: (BuildContext context) => AddEmergency()),
                  );
                },
                icon: Icon(Icons.close),
                label: Text("Close"))
          ],
        );
      },
    );
  }

  Future<void> userEmergency() async {
    setState(() {
      loading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = await prefs.getString("access-token");
    location = await currentUserLocation();
    newEmergency instance = await newEmergency(
        token: token as String,
        location: location as String,
        description: description as String);

    await instance.reportEmergency();
    data = await instance.data;

    stausCodeEmergency = await instance.statusCode;
    setState(() {
      loading = false;
    });

    if (stausCodeEmergency == 200) {
      _showDialogSuccess();
    } else {
      _showDialog();
    }
  }

  Widget buildSubmit() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          ElevatedButton.icon(
              style: ElevatedButton.styleFrom(primary: Colors.green[600]),
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  await userEmergency();
                }
              },
              icon: Icon(Icons.send),
              label: Text(
                "Send",
                style: TextStyle(letterSpacing: 2, fontSize: 16),
              )),
          SizedBox(width: 10),
          ElevatedButton.icon(
              onPressed: () async {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (BuildContext context) => Home()),
                );
              },
              icon: Icon(Icons.cancel),
              label: Text(
                "Cancel",
                style: TextStyle(letterSpacing: 2, fontSize: 16),
              )),
          SizedBox(width: 10),
          LoadingCircle(loading: loading)
        ],
      ),
    );
  }

  Widget buildDescriptions() {
    return Card(
      elevation: 5,
      shadowColor: Colors.cyan,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: TextFormField(
                maxLines: null,
                decoration:
                    InputDecoration(labelText: "Describe your emergency", labelStyle: TextStyle(fontSize: 18, letterSpacing: 2)),
                validator: (value) {
                  if (value == null || value.length < 1) {
                    return "Please Describe your emergency";
                  }
                },
                onSaved: (value) {
                  description = value;
                },
              ),
            ),
            buildSubmit()
          ],
        ),
      ),
    );
  }

  Widget buildEmergency() {
    return buildDescriptions();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    authCheck();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: Text("Report an emergency"),
        centerTitle: true,
      ),
      drawer: MainDrawer(),
      body: Form(key: _formKey, child: buildEmergency()),
    );
  }
}
