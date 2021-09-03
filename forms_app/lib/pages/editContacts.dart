import 'package:flutter/material.dart';
import 'package:forms_app/screens/maindrawer.dart';
import 'package:forms_app/services/contacts.dart';
import 'package:forms_app/pages/contacts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:forms_app/screens/loading.dart';

class EditContacts extends StatefulWidget {
  const EditContacts({
    Key? key,
  }) : super(key: key);

  @override
  _EditContactsState createState() => _EditContactsState();
}

class _EditContactsState extends State<EditContacts> {
  String? contact_name;
  String? contact_phone;
  String? contact_location;
  String? contact_relationship;
  String? id;
  String? token;
  Map? data;
  Map? contact;
  bool checked = false;
  bool? loading = false;

  final _formKey = GlobalKey<FormState>();

  void _showDialogSuccess() {
    String message = data!["message"];
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
                            builder: (BuildContext context) => ContactsPage()),
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

  checkPriority() {
    if (contact!["priority"] == false) {
      return "Make priority contact";
    } else {
      return "Remove from priority contacts";
    }
  }

  Future<void> editEmergencyContact() async {
    setState(() {
      loading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString("access-token");
    id = contact!["id"];
    editUserContacts instance = await editUserContacts(
        id: id as String,
        token: token as String,
        contact_name: contact_name as String,
        contact_phone: contact_phone as String,
        contact_location: contact_location as String,
        contact_relationship: contact_relationship as String,
        priority: checked == true && contact!["priority"] == true
            ? "false"
            : checked == true && contact!["priority"] == false
                ? "true"
                : "false");
    await instance.editBuddy();
    data = instance.data;
    setState(() {
      loading = false;
    });
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
        initialValue: contact!["contact_name"],
        decoration: InputDecoration(
          hintText: "Conatct Name",
          icon: Icon(Icons.person, color: Colors.blue),
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
        initialValue: contact!["contact_phone"],
        decoration: InputDecoration(
          hintText: "Contact Phone Number",
          icon: Icon(Icons.phone, color: Colors.green),
        ),
        validator: (value) {
          if (value == null || value.length != 10) {
            return "Please input a valid phone number.";
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
        initialValue: contact!["contact_location"],
        decoration: InputDecoration(
          hintText: "Conatact Location",
          icon: Icon(Icons.location_pin),
        ),
        validator: (value) {
          if (value == null || value.length < 1) {
            return "Please input contact location";
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
        initialValue: contact!["contact_relationship"],
        decoration: InputDecoration(
          hintText: "Contact Relationship",
          icon: Icon(Icons.family_restroom, color: Colors.amber),
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

  Widget buildPriority() {
    return Padding(
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 10),
        child: Row(
          children: [
            Checkbox(
              checkColor: Colors.white,
              value: checked,
              onChanged: (bool? value) {
                setState(() {
                  checked = value!;
                });
              },
            ),
            Text(
              checkPriority(),
              style: TextStyle(fontSize: 16),
            ),
          ],
        ));
  }

  Widget buildSubmit() {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 15, 20, 10),
          child: ElevatedButton.icon(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  editEmergencyContact();
                }
              },
              icon: Icon(Icons.send),
              label: Text("Submit")),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: LoadingCircle(loading: loading as bool),
        )
      ],
    );
  }

  Widget buildForm() {
    return ListView.builder(
        itemCount: 1,
        itemBuilder: (BuildContext context, index) {
          return Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildContactName(),
                buildContactPhone(),
                buildContactLocation(),
                buildContactRelationship(),
                buildPriority(),
                buildSubmit(),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    contact = ModalRoute.of(context)!.settings.arguments as Map;
    return Scaffold(
      appBar: AppBar(title: Text("Edit Contact"), centerTitle: true),
      drawer: MainDrawer(),
      body: Form(
          key: _formKey,
          child: Card(
              elevation: 5,
              shadowColor: Colors.cyan,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: buildForm())),
    );
  }
}
