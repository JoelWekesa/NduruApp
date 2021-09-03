import 'package:flutter/material.dart';
import 'package:forms_app/pages/providers.dart';
import 'package:forms_app/screens/maindrawer.dart';

class ServicesPage extends StatefulWidget {
  const ServicesPage({Key? key}) : super(key: key);

  @override
  _ServicesPageState createState() => _ServicesPageState();
}

class _ServicesPageState extends State<ServicesPage> {
  Map? services;

  Widget buildServicesPage() {
    List available = services!["services"]["rows"];
    if (available.length < 1) {
      return Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("No services available",
                style: TextStyle(fontSize: 20, letterSpacing: 2)),
          ),
        ],
      ));
    }
    return ListView.builder(
        itemCount: available.length,
        itemBuilder: (BuildContext context, index) {
          return Card(
            elevation: 5,
            shadowColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(available[index]["name"],
                      style: TextStyle(
                          fontSize: 20,
                          letterSpacing: 2,
                          fontWeight: FontWeight.bold)),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(available[index]["description"],
                      style: TextStyle(
                        fontSize: 16,
                        letterSpacing: 2,
                      )),
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    services = ModalRoute.of(context)!.settings.arguments as Map;
    return Scaffold(
        appBar: AppBar(title: Text("Available Services"), centerTitle: true),
        drawer: MainDrawer(),
        body: buildServicesPage());
  }
}
