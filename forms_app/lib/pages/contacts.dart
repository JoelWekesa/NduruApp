import 'package:flutter/material.dart';
import 'package:forms_app/screens/maindrawer.dart';
import 'package:forms_app/services/user.dart';
import 'package:forms_app/services/contacts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:forms_app/pages/login.dart';
import 'package:forms_app/pages/addContacts.dart';
import 'package:forms_app/pages/editContacts.dart';
import 'package:forms_app/screens/loading.dart';

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
  bool delLoading = false;
  String? contact_id = "";
  Map? contact;

  void _showDialogDelete(id) {
    String message =
        "Are you sure you want to delete this contact? This action is not reversible.";
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          backgroundColor: Colors.red,
          title: Text("Delete Contact",
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
            Row(
              children: [
                ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.red[800],
                    ),
                    onPressed: () async {
                      await deleteContact(id);
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (BuildContext context) => super.widget),
                      );
                    },
                    icon: Icon(Icons.delete),
                    label: Text("Delete")),

                SizedBox(
                  width: 10,
                ), //

                ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.green[400],
                    ),
                    onPressed: () async {
                      Navigator.of(context).pop();
                    },
                    icon: Icon(Icons.close),
                    label: Text("Cancel")),

                SizedBox(
                  width: 10,
                ), //

                LoadingCircle(loading: delLoading)
              ],
            )
          ],
        );
      },
    );
  }

  Future getUserID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = await prefs.getString("access-token");
    getUser user = getUser(token: token as String);
    await user.userDetails();
    statusCode = user.statusCode;
    if (statusCode == 200) {
      User = user.data;
      return User!["user"]["id"];
    } else {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (BuildContext context) => Login()),
      );
    }
  }

  Future<void> usrContacts() async {
    try {
      setState(() {
        loading = true;
      });

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

  Future<void> selectContact(id) async {
    setState(() {
      contact_id = id;
    });
  }

  Future<void> deleteContact(id) async {
    setState(() {
      delLoading = true;
    });
    await selectContact(id);
    deleteUserContact instance = await deleteUserContact(
        id: contact_id as String, token: token as String);

    await instance.deleteBuddy();

    setState(() {
      delLoading = false;
    });
  }

  Widget buildNoContact() {
    return Card(
      elevation: 5,
      shadowColor: Colors.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("You are yet to add any emergency contact buddies.",
                style: TextStyle(letterSpacing: 2, fontSize: 18)),
            SizedBox(height: 10),
            ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (BuildContext context) => AddContacts()),
                  );
                },
                icon: Icon(Icons.add),
                label: Text("Add new contact."))
          ],
        ),
      ),
    );
  }

  Widget buildAddContacts() {
    return ElevatedButton.icon(
        onPressed: () {}, icon: Icon(Icons.add), label: Text("Add Contact"));
  }

  Widget buildContacts() {
    if (loading == true) {
      return Center(child: LoadingCircle(loading: loading as bool));
    } else if (details.length == 0) {
      return buildNoContact();
    } else {
      return ListView.builder(
          itemCount: details.length,
          itemBuilder: (BuildContext context, index) {
            return Card(
                elevation: 5,
                shadowColor: Colors.cyan,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Column(
                  children: <Widget>[
                    ListTile(
                      leading: Icon(
                        Icons.person,
                        color: Colors.blue,
                      ),
                      title: Text(details[index]["contact_name"],
                          style: TextStyle(
                              color: Colors.blue,
                              letterSpacing: 2,
                              fontSize: 18)),
                    ),
                    ListTile(
                      leading: Icon(Icons.phone, color: Colors.green),
                      title: Text(details[index]["contact_phone"],
                          style: TextStyle(
                              color: Colors.green,
                              letterSpacing: 2,
                              fontSize: 18)),
                    ),
                    ListTile(
                      leading: Icon(Icons.family_restroom, color: Colors.amber),
                      title: Text(details[index]["contact_relationship"],
                          style: TextStyle(
                              color: Colors.amber,
                              letterSpacing: 2,
                              fontSize: 18)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: <Widget>[
                          ElevatedButton.icon(
                              onPressed: () {
                                _showDialogDelete(details[index]["id"]);
                              },
                              icon: Icon(Icons.delete),
                              label: Text("delete")),
                          SizedBox(width: 20),
                          ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.cyan),
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        EditContacts(),
                                    settings: RouteSettings(
                                      arguments: details[index],
                                    ),
                                  ),
                                );
                              },
                              icon: Icon(Icons.edit),
                              label: Text("Edit"))
                        ],
                      ),
                    ),
                  ],
                ));
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
      body: Container(child: buildContacts()),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () {
          Navigator.pushNamed(context, "/addcontacts");
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
