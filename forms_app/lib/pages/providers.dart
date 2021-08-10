import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:forms_app/screens/maindrawer.dart';
import 'package:forms_app/services/device.dart';
import 'package:forms_app/services/location.dart';
import 'package:forms_app/services/panic.dart';
import 'package:forms_app/pages/services.dart';
import 'package:forms_app/services/services.dart';

class ProvidersList extends StatefulWidget {
  const ProvidersList({Key? key}) : super(key: key);

  @override
  _ProvidersListState createState() => _ProvidersListState();
}

class _ProvidersListState extends State<ProvidersList> {
  Map? providers;
  List? providersList;
  Map? services;

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

  Future<void> getCompanyServices(id) async {
    providerServices instance = providerServices(id: id);
    await instance.getServices();
    services = instance.data;
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
                  onTap: () async {
                    await getCompanyServices(providersList![index]["id"]);
                    Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (BuildContext context) => ServicesPage(), settings: RouteSettings(arguments: services)),
                        );
                  },
                ),
              ));
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
        child: Icon(Icons.warning, color: Colors.white),
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
