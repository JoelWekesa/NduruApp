import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:forms_app/screens/maindrawer.dart';
import 'package:forms_app/services/device.dart';
import 'package:forms_app/services/location.dart';
import 'package:forms_app/services/panic.dart';

class ProvidersList extends StatefulWidget {
  const ProvidersList({Key? key}) : super(key: key);

  @override
  _ProvidersListState createState() => _ProvidersListState();
}

class _ProvidersListState extends State<ProvidersList> {
  Map? providers;
  List? providersList;

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

  Widget buildProvidersPage() {
    providersList = providers!["providers"]["rows"];
    return ListView.builder(
        itemCount: providersList!.length,
        itemBuilder: (BuildContext context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              color: Colors.grey[200],
              child: ListTile(
                title: Text(providersList![index]["name"],
                    style: TextStyle(fontSize: 18, letterSpacing: 2)),
                onTap: () {},
              ),
            ),
          );
        });
  }

  Widget buildEmergencyButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 2, 0, 0),
      child: FloatingActionButton(
        backgroundColor: Colors.red[900],
        onPressed: () {
          panicEmergency();
        },
        child: Icon(Icons.warning, color: Colors.red),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    providers = ModalRoute.of(context)!.settings.arguments as Map;
    return Scaffold(
      appBar: AppBar(title: Text("Service Providers"), centerTitle: true),
      drawer: MainDrawer(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(child: buildProvidersPage()),
        ),
      ),
      floatingActionButton: buildEmergencyButton(),
    );
  }
}
