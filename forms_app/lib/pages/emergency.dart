import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EmergencyPage extends StatefulWidget {
  const EmergencyPage({Key? key}) : super(key: key);

  @override
  _EmergencyPageState createState() => _EmergencyPageState();
}

class _EmergencyPageState extends State<EmergencyPage> {
  Map? emergency;
  DateTime? date;

  Widget buildEmergency() {
    date = DateTime.parse(emergency!["createdAt"]).add(Duration(hours: 3));
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
              itemCount: 1,
              itemBuilder: (BuildContext context, index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Row(
                              children: [
                                Text("Time: ",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)),
                                Text(
                                    DateFormat.yMMMd().format(DateTime.parse(
                                        emergency!["createdAt"])),
                                    style: TextStyle(fontSize: 16)),
                              ],
                            ),
                            SizedBox(width: 10),
                            Text(DateFormat.jms().format(date as DateTime),
                                style: TextStyle(fontSize: 16))
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Description: ",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                            Text(emergency!["description"],
                                style: TextStyle(fontSize: 16)),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Location: ",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                            Text(
                                emergency!["location"]
                                    .split(':')[1]
                                    .replaceAll("coordinates", ""),
                                style: TextStyle(fontSize: 16)),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    emergency = ModalRoute.of(context)!.settings.arguments as Map;
    return Scaffold(
      appBar: AppBar(title: Text("Reported Emergency"), centerTitle: true),
      body: buildEmergency(),
    );
  }
}
