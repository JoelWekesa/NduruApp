import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:forms_app/pages/addEmergency.dart';
import 'package:geocoding/geocoding.dart';
import 'package:forms_app/screens/maindrawer.dart';
import 'package:forms_app/services/location.dart';
import 'package:forms_app/pages/contacts.dart';
import 'package:forms_app/pages/providers.dart';
import 'package:forms_app/pages/userEmergencies.dart';
import 'package:forms_app/services/device.dart';
import 'package:forms_app/services/panic.dart';
import 'package:forms_app/services/providers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:forms_app/services/userEmergencies.dart';
import 'package:forms_app/services/user.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  const Loading({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        child: SizedBox(
            child: Card(child: LayoutBuilder(builder: (context, constraint) {
              return SpinKitCircle(
                  color: Colors.blue, size: constraint.maxWidth);
            })),
            height: 300),
      ),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Map? providers;
  String? token;
  Map? data;
  bool loading = false;

  Future<void> checkAuth() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = await prefs.getString("access-token");
    getUser instance = await getUser(token: token as String);
    await instance.userDetails();
    int statusCode = await instance.statusCode as int;
    if (statusCode != 200) {
      Navigator.of(context).pushNamed("/login");
    }
  }

  Future<void> goToContacts() async {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (BuildContext context) => ContactsPage()),
    );
  }

  Future getAllProviders() async {
    getProviders instance = getProviders();
    await instance.allProviders();
    providers = instance.providers;
    return providers;
  }

  Future<void> usrEmergencies() async {
    setState(() {
      loading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = await prefs.getString("access-token");
    UserEmergencies instance = await UserEmergencies(token: token as String);
    await instance.retrieveEmergencies();
    setState(() {
      loading = false;
    });
    data = instance.data as Map;
  }

  Widget buildEmergency() {
    return Expanded(
        child: InkWell(
      splashColor: Colors.red,
      customBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (BuildContext context) => AddEmergency()),
        );
      },
      child: Container(
        child: SizedBox(
            child: Card(
                elevation: 5,
                shadowColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: LayoutBuilder(builder: (context, constraint) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.warning_rounded,
                          size: constraint.maxWidth, color: Colors.red),
                      Text("Emergency", style: TextStyle(fontSize: 20))
                    ],
                  );
                })),
            height: 300),
      ),
    ));
  }

  Widget buildPhone() {
    return Expanded(
        child: InkWell(
      splashColor: Colors.green,
      customBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (BuildContext context) => ContactsPage()),
        );
      },
      child: Container(
        child: SizedBox(
            child: Card(
                elevation: 5,
                shadowColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: LayoutBuilder(builder: (context, constraint) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.phone_rounded,
                          size: constraint.maxWidth, color: Colors.green),
                      Text("Contacts", style: TextStyle(fontSize: 20))
                    ],
                  );
                })),
            height: 300),
      ),
    ));
  }

  Widget buildServices() {
    return Expanded(
        child: InkWell(
      splashColor: Colors.cyan,
      customBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      onTap: () async {
        await getAllProviders();
        Navigator.of(context).push(
          MaterialPageRoute(
              builder: (BuildContext context) => ProvidersList(),
              settings: RouteSettings(arguments: providers)),
        );
      },
      child: Container(
        child: SizedBox(
            child: Card(
                elevation: 5,
                shadowColor: Colors.cyan,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: LayoutBuilder(builder: (context, constraint) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.settings_rounded,
                          size: constraint.maxWidth, color: Colors.cyan),
                      Text("Services", style: TextStyle(fontSize: 20))
                    ],
                  );
                })),
            height: 300),
      ),
    ));
  }

  Widget buildInfo() {
    return Expanded(
        child: InkWell(
      splashColor: Colors.blue,
      customBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      onTap: () {},
      child: Container(
        child: SizedBox(
            child: Card(
                elevation: 5,
                shadowColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: LayoutBuilder(builder: (context, constraint) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.info_rounded,
                          size: constraint.maxWidth, color: Colors.blue),
                      Text("Information", style: TextStyle(fontSize: 20))
                    ],
                  );
                })),
            height: 300),
      ),
    ));
  }

  Widget buildReports() {
    if (loading == true) {
      return Loading();
    }
    return Expanded(
        child: InkWell(
      splashColor: Colors.amber,
      customBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      onTap: () async {
        await usrEmergencies();
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => MyEmergencies(),
            settings: RouteSettings(arguments: data)));
      },
      child: Container(
        child: SizedBox(
            child: Card(
                elevation: 5,
                shadowColor: Colors.amber,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: LayoutBuilder(builder: (context, constraint) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.file_copy_rounded,
                          size: constraint.maxWidth, color: Colors.amber),
                      Text("Reports", style: TextStyle(fontSize: 20))
                    ],
                  );
                })),
            height: 300),
      ),
    ));
  }

  Widget buildBlackSpots() {
    return Expanded(
        child: InkWell(
      splashColor: Colors.black,
      customBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      onTap: () {},
      child: Container(
        child: SizedBox(
            child: Card(
                elevation: 5,
                shadowColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: LayoutBuilder(builder: (context, constraint) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.cancel_rounded,
                          size: constraint.maxWidth, color: Colors.black),
                      Text("BlackSpots", style: TextStyle(fontSize: 20))
                    ],
                  );
                })),
            height: 300),
      ),
    ));
  }

  Widget builEmergencyAndPhone() {
    return Row(
      children: [
        buildEmergency(),
        buildPhone(),
      ],
    );
  }

  Widget buildServicesAndPhone() {
    return Row(
      children: [buildServices(), buildInfo()],
    );
  }

  Widget buildReportsAndSpots() {
    return Row(
      children: [
        buildReports(),
        buildBlackSpots(),
      ],
    );
  }

  Widget buildHomePage() {
    return ListView.builder(
        itemCount: 1,
        itemBuilder: (BuildContext context, index) {
          return Column(
            children: [
              builEmergencyAndPhone(),
              buildServicesAndPhone(),
              buildReportsAndSpots(),
            ],
          );
        });
  }

  Future myDevice() async {
    DeviceInfo instance = await DeviceInfo();
    await instance.userDevice();
    return json.encode(instance.deviceData);
  }

  Future currentUserLocation() async {
    getUserCoordinates instance = getUserCoordinates();
    await instance.getCurrentLocation();
    Placemark placeMark = instance.placemarks![0];
    return (json.encode(placeMark));
  }

  Future<void> panicEmergency() async {
    String location = await currentUserLocation();
    String device = await myDevice();
    PanicEmergency instance =
        await PanicEmergency(device: device, location: location);
    await instance.addPanicEmergency();

    if (instance.statusCode == 200) {
      HapticFeedback.vibrate();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Nduru"),
            SizedBox(
              width: 10,
            ),
            Icon(Icons.volume_up),
            SizedBox(
              width: 60,
            ),
          ],
        ),
        // centerTitle: true,
      ),
      drawer: MainDrawer(),
      body: buildHomePage(),
      floatingActionButton: Padding(
        padding: const EdgeInsets.fromLTRB(0, 2, 0, 0),
        child: FloatingActionButton(
          backgroundColor: Colors.red[900],
          onPressed: () {
            panicEmergency();
            // currentUserLocation();
            // Navigator.pushNamed(context, "/location");
          },
          child: Icon(Icons.warning, color: Colors.white),
        ),
      ),
    );
  }
}
