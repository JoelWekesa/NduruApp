import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:forms_app/screens/maindrawer.dart';

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
  bool? priority = false;

  final _formKey = GlobalKey<FormState>();

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
              print(contact_name);
              print(contact_phone);
              print(contact_location);
              print(contact_relationship);
            }
          },
          icon: Icon(Icons.send),
          label: Text("Submit")),
    );
  }

  Widget buildForm() {
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
