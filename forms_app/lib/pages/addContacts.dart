import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:forms_app/screens/maindrawer.dart';
import 'package:forms_app/pages/login.dart';
import 'package:forms_app/services/user.dart';
import 'package:forms_app/services/contacts.dart';
import 'package:forms_app/pages/contacts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class AddContacts extends StatefulWidget {
  const AddContacts({Key? key}) : super(key: key);

  @override
  _AddContactsState createState() => _AddContactsState();
}

class _AddContactsState extends State<AddContacts> {
  String? contact_name;
  String? contact_phone;
  String? contact_location;
  String? contact_relationship;
  String? token;
  bool? priority = false;
  bool? loading = false;
  int? statusCode;
  int number = 0;
  Map? User;
  Map? data;

  final _formKey = GlobalKey<FormState>();

  void _showDialogSuccess() {
    String message = "You have successfully added a new contact buddy.";
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          backgroundColor: Colors.green[400],
          title: Text("Success!",
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
                      primary: Colors.cyan,
                    ),
                    onPressed: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  ContactsPage()),
                          );
                    },
                    icon: Icon(Icons.family_restroom),
                    label: Text("View Contacts")),

                SizedBox(width: 20),
                ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.green[200],
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: Icon(Icons.close),
                    label: Text("Close")),
              ],
            )
          ],
        );
      },
    );
  }

  void _showDialog() {
    String message = data!["message"];
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          backgroundColor: Colors.red[400],
          title: Text("Request Failed",
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
            ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  primary: Colors.red[200],
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(Icons.close),
                label: Text("Close"))
          ],
        );
      },
    );
  }

  Future<void> authCheck() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = await prefs.getString("access-token");

    getUser instance = await getUser(token: token as String);
    await instance.userDetails();
    statusCode = instance.statusCode;
    if (statusCode != 200) {
      Navigator.of(context).push(
          MaterialPageRoute(builder: (BuildContext context) => Login()),
          );
    }
    User = await instance.data;
  }

  Future<void> contactsCheck() async {
    setState(() {
      loading = true;
    });
    await authCheck();
    try {
      String id = User!["user"]["id"];
      getUserContacts instance =
          await getUserContacts(id: id, token: token as String);
      await instance.userContacts();

      setState(() {
        number = instance.number as int;
        loading = false;
      });
    } catch (e) {
      print(e);
    }
  }

  Future addBuddy() async {
    addUserContacts instance = await addUserContacts(
        contact_name: contact_name as String,
        contact_phone: contact_phone as String,
        contact_location: contact_location as String,
        contact_relationship: contact_relationship as String,
        token: token as String);
    await instance.addBuddies();
    data = instance.data;
    if (instance.statusCode == 200) {
      _showDialogSuccess();
    } else {
      _showDialog();
    }
  }

  Widget buildContactName() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 15, 20, 10),
      child: TextFormField(
        decoration: InputDecoration(
          icon: Icon(Icons.person, color: Colors.blue),
          labelText: "Contact name",
          labelStyle: TextStyle(fontSize: 16, color: Colors.black),
        ),
        validator: (value) {
          if (value == null || value.length < 1) {
            return "Please input contact name";
          }
        },
        onSaved: (value) {
          contact_name = value;
        },
      ),
    );
  }

  Widget buildContactPhone() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 15, 20, 10),
      child: TextFormField(
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        decoration: InputDecoration(
          icon: Icon(
            Icons.phone,
            color: Colors.green,
          ),
          labelText: "Contact phone number",
          labelStyle: TextStyle(fontSize: 16, color: Colors.black),
        ),
        validator: (value) {
          if (value == null || value.length != 10) {
            return "Please input contact phone number";
          }
        },
        onSaved: (value) {
          contact_phone = value;
        },
      ),
    );
  }

  Widget buildContactLocation() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 15, 20, 10),
      child: TextFormField(
        decoration: InputDecoration(
          icon: Icon(Icons.location_pin),
          labelText: "Contact location",
          labelStyle: TextStyle(fontSize: 16, color: Colors.black),
        ),
        validator: (value) {
          if (value == null || value.length < 1) {
            return "Please input contact name";
          }
        },
        onSaved: (value) {
          contact_location = value;
        },
      ),
    );
  }

  Widget buildContactRelationship() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 15, 20, 10),
      child: TextFormField(
        decoration: InputDecoration(
          icon: Icon(Icons.family_restroom, color: Colors.amber),
          labelText: "Contact relationship",
          labelStyle: TextStyle(fontSize: 16, color: Colors.black),
        ),
        validator: (value) {
          if (value == null || value.length < 1) {
            return "Please input contact relationship";
          }
        },
        onSaved: (value) {
          contact_relationship = value;
        },
      ),
    );
  }

  Widget buildSubmit() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 15, 20, 10),
      child: ElevatedButton.icon(
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              addBuddy();
            }
          },
          icon: Icon(Icons.send),
          label: Text("Submit")),
    );
  }

  Widget buildMaxDialog() {
    return Container(
      child: SizedBox(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                  "You cannot add more contacts because you have added maximum number of allowed contacts",
                  style: TextStyle(letterSpacing: 2, fontSize: 16)),
              SizedBox(height: 20),
              ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (BuildContext context) => ContactsPage()),
                        );
                  },
                  icon: Icon(Icons.family_restroom_outlined),
                  label: Text("View my contacts"))
            ],
          ),
        ),
      ),
    );
  }

  Widget buildLoading() {
    return SpinKitCircle(
      color: Colors.white,
      size: 50.0,
    );
  }

  Widget buildForm() {
    if (number >= 5) {
      return buildMaxDialog();
    } else if (loading == true) {
      return buildLoading();
    } else {
      return ListView.builder(
          itemCount: 1,
          itemBuilder: (BuildContext context, index) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildContactName(),
                  buildContactPhone(),
                  buildContactLocation(),
                  buildContactRelationship(),
                  buildSubmit(),
                ],
              ),
            );
          });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    contactsCheck();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(title: Text("Add Contacts"), centerTitle: true),
        drawer: MainDrawer(),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: Form(key: _formKey, child: buildForm()),
            ),
          ),
        ));
  }
}
