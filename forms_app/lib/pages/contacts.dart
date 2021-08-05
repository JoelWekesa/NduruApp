import 'package:flutter/material.dart';
import 'package:forms_app/screens/maindrawer.dart';
import 'package:forms_app/services/user.dart';
import 'package:forms_app/services/contacts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:forms_app/pages/login.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ContactsPage extends StatefulWidget {
  const ContactsPage({Key? key}) : super(key: key);

  @override
  _ContactsPageState createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  String? token;
  String? id;
  Map? User;
  Map? contacts;
  List details = [];
  int? statusCode;
  bool? loading = false;

  Future getUserID() async {
    setState(() {
      loading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = await prefs.getString("access-token");
    getUser user = getUser(token: token as String);
    await user.userDetails();
    statusCode = user.statusCode;
    loading = false;
    if (statusCode == 200) {
      User = user.data;
      return User!["user"]["id"];
    } else {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => Login()),
          (route) => false);
    }
  }

  Future<void> usrContacts() async {
    try {
      id = await getUserID();
      getUserContacts instance =
          await getUserContacts(id: id as String, token: token as String);
      await instance.userContacts();
      contacts = instance.contacts;

      setState(() {
        details = contacts!["contacts"];
        loading = false;
      });
    } catch (e) {
      print(e);
    }
  }

  Widget buildAddContacts() {
    return ElevatedButton.icon(
        onPressed: () {}, icon: Icon(Icons.add), label: Text("Add Contact"));
  }

  Widget buildContacts() {
    if(loading == true) {
      return Center(
        child: SpinKitRotatingCircle(
          color: Colors.white,
          size: 50.0,
        ),
      );
    }
    else if (details.length == 0) {
      return Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Card(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("You don't have any emergency contacts.",
                style: TextStyle(letterSpacing: 2, fontSize: 16)),
          )),
          ElevatedButton.icon(
              onPressed: () {},
              icon: Icon(Icons.add),
              label: Text("Add new contact."))
        ],
      ));
    } else {
      return ListView.builder(
          itemCount: details.length,
          itemBuilder: (BuildContext context, index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                  child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      leading: Icon(
                        Icons.person,
                        color: Colors.blue,
                      ),
                      title: Text(details[index]["contact_name"],
                          style: TextStyle(color: Colors.blue)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      leading: Icon(Icons.phone, color: Colors.green),
                      title: Text(details[index]["contact_phone"],
                          style: TextStyle(color: Colors.green)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      leading: Icon(Icons.family_restroom, color: Colors.amber),
                      title: Text(details[index]["contact_relationship"],
                          style: TextStyle(color: Colors.amber)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: <Widget>[
                        ElevatedButton.icon(
                            onPressed: () {},
                            icon: Icon(Icons.delete),
                            label: Text("delete")),
                        SizedBox(width: 20),
                        ElevatedButton.icon(
                            style:
                                ElevatedButton.styleFrom(primary: Colors.cyan),
                            onPressed: () {},
                            icon: Icon(Icons.edit),
                            label: Text("Edit"))
                      ],
                    ),
                  ),
                ],
              )),
            );
          });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    usrContacts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My contacts"),
        centerTitle: true,
      ),
      drawer: MainDrawer(),
      body: Container(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: buildContacts(),
      )),
    );
  }
}
