import 'package:flutter/material.dart';
import 'package:forms_app/screens/maindrawer.dart';
import 'package:forms_app/pages/emergency.dart';

class MyEmergencies extends StatefulWidget {
  const MyEmergencies({Key? key}) : super(key: key);

  @override
  _MyEmergenciesState createState() => _MyEmergenciesState();
}

class _MyEmergenciesState extends State<MyEmergencies> {
  Map? data;
  List? emergencies;
  Map? emergency;

  Widget buildUserEmergencies() {
    try {
      emergencies = data!["emergencies"]["rows"];
      if (emergencies!.length < 1) {
        return Container(
          child: Center(
              child: Text("You have not made any distress calls",
                  style: TextStyle(fontSize: 20))),
        );
      }
      return ListView.builder(
          itemCount: emergencies!.length,
          itemBuilder: (BuildContext context, index) {
            return Card(
                elevation: 5,
                shadowColor: Colors.cyan,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: InkWell(
                  onTap: () {
                    emergency = emergencies![index];
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) => EmergencyPage(),
                        settings: RouteSettings(arguments: emergency)));
                  },
                  child: ListTile(
                      title: Text(emergencies![index]["description"],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          softWrap: false,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 2)),
                      subtitle: Text(emergencies![index]["location"]
                          .split(":")[1]
                          .replaceAll("coordinates", ""))),
                ));
          });
    } catch (e) {
      return Center(child: Text("No reports", style: TextStyle(fontSize: 16)));
    }
  }

  @override
  Widget build(BuildContext context) {
    data = ModalRoute.of(context)!.settings.arguments as Map;
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(title: Text("My Emergencies"), centerTitle: true),
      drawer: MainDrawer(),
      body: buildUserEmergencies(),
    );
  }
}
