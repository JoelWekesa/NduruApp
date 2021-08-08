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

  Widget buildEmergency() {
    return Expanded(
        child: InkWell(
      onTap: () {
        Navigator.of(context).push(
            MaterialPageRoute(
                builder: (BuildContext context) => AddEmergency()),
            );
      },
      child: Container(
        child: SizedBox(
            child: Card(child: LayoutBuilder(builder: (context, constraint) {
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
      onTap: () {
        Navigator.of(context).push(
            MaterialPageRoute(
                builder: (BuildContext context) => ContactsPage()),
            );
      },
      child: Container(
        child: SizedBox(
            child: Card(child: LayoutBuilder(builder: (context, constraint) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.phone_rounded,
                      size: constraint.maxWidth, color: Colors.green),
                  Text("Phone", style: TextStyle(fontSize: 20))
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
            child: Card(child: LayoutBuilder(builder: (context, constraint) {
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
      onTap: () {},
      child: Container(
        child: SizedBox(
            child: Card(child: LayoutBuilder(builder: (context, constraint) {
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
    return Expanded(
        child: InkWell(
      onTap: () {},
      child: Container(
        child: SizedBox(
            child: Card(child: LayoutBuilder(builder: (context, constraint) {
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
      onTap: () {},
      child: Container(
        child: SizedBox(
            child: Card(child: LayoutBuilder(builder: (context, constraint) {
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: buildHomePage(),
      ),
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
