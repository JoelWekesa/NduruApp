import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:forms_app/pages/addEmergency.dart';
import 'package:geocoding/geocoding.dart';
import 'package:forms_app/screens/maindrawer.dart';
import 'package:forms_app/services/location.dart';
import 'package:forms_app/pages/contacts.dart';
import 'package:forms_app/pages/providers.dart';
import 'package:forms_app/services/device.dart';
import 'package:forms_app/services/panic.dart';
import 'package:forms_app/services/providers.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Map? providers;
  Future<void> goToContacts() async {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (BuildContext context) => ContactsPage()),
        (route) => false);
  }

  Future getAllProviders() async {
    getProviders instance = getProviders();
    await instance.allProviders();
    providers = instance.providers;
    return providers;
  }

  Widget buildEmergencyAndPhone() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 3, 0, 3),
      child: Row(
        children: [
          Container(
            width: 192.0,
            height: 210.0,
            color: Color.fromARGB(255, 235, 237, 237),
            child: InkWell(
              onTap: () {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (BuildContext context) => AddEmergency()),
                    (route) => false);
              },
              child: Card(
                child: FractionallySizedBox(
                    widthFactor: 0.5,
                    child: LayoutBuilder(builder: (context, constraint) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.warning_rounded,
                              size: constraint.maxWidth, color: Colors.red),
                          Text("Emergency")
                        ],
                      );
                    })),
              ),
            ),
          ),
          Container(
            width: 192.0,
            height: 210.0,
            color: Color.fromARGB(255, 235, 237, 237),
            child: InkWell(
              onTap: () {
                goToContacts();
              },
              child: Card(
                child: FractionallySizedBox(
                    widthFactor: 0.5,
                    child: LayoutBuilder(builder: (context, constraint) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.contact_phone,
                              size: constraint.maxWidth, color: Colors.green),
                          Text("Contacts")
                        ],
                      );
                    })),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildInfoAndServices() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 3, 0, 3),
      child: Row(
        children: [
          Container(
            width: 192.0,
            height: 210.0,
            color: Color.fromARGB(255, 235, 237, 237),
            child: InkWell(
              onTap: () async {
                await getAllProviders();
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (BuildContext context) => ProvidersList(),
                        settings: RouteSettings(arguments: providers)),
                    (route) => false);
              },
              child: Card(
                child: FractionallySizedBox(
                    widthFactor: 0.5,
                    child: LayoutBuilder(builder: (context, constraint) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.settings_rounded,
                              size: constraint.maxWidth, color: Colors.cyan),
                          Text("Services")
                        ],
                      );
                    })),
              ),
            ),
          ),
          Container(
            width: 192.0,
            height: 210.0,
            color: Color.fromARGB(255, 235, 237, 237),
            child: InkWell(
              onTap: () {},
              child: Card(
                child: FractionallySizedBox(
                    widthFactor: 0.5,
                    child: LayoutBuilder(builder: (context, constraint) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.info_outlined,
                              size: constraint.maxWidth, color: Colors.blue),
                          Text("Information")
                        ],
                      );
                    })),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildReportsAndHotspots() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 3, 0, 3),
      child: Row(
        children: [
          Container(
            width: 192.0,
            height: 210.0,
            color: Color.fromARGB(255, 235, 237, 237),
            child: InkWell(
              onTap: () {},
              child: Card(
                child: FractionallySizedBox(
                    widthFactor: 0.5,
                    child: LayoutBuilder(builder: (context, constraint) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.file_present_rounded,
                              size: constraint.maxWidth, color: Colors.amber),
                          Text("Reports")
                        ],
                      );
                    })),
              ),
            ),
          ),
          Container(
            width: 192.0,
            height: 210.0,
            color: Color.fromARGB(255, 235, 237, 237),
            child: InkWell(
              onTap: () {},
              child: Card(
                child: FractionallySizedBox(
                    widthFactor: 0.5,
                    child: LayoutBuilder(builder: (context, constraint) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.dangerous_rounded,
                              size: constraint.maxWidth, color: Colors.black),
                          Text("Hotspots")
                        ],
                      );
                    })),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildHomePage() {
    return ListView.builder(
        itemCount: 1,
        itemBuilder: (BuildContext context, index) {
          return Column(
            children: [
              buildEmergencyAndPhone(),
              buildInfoAndServices(),
              buildReportsAndHotspots(),
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
      body: Container(child: buildHomePage()),
      floatingActionButton: Padding(
        padding: const EdgeInsets.fromLTRB(0, 2, 0, 0),
        child: FloatingActionButton(
          backgroundColor: Colors.red[900],
          onPressed: () {
            panicEmergency();
            // currentUserLocation();
            // Navigator.pushNamed(context, "/location");
          },
          child: Icon(Icons.warning, color: Colors.red),
        ),
      ),
    );
  }
}
