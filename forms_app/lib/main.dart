import 'package:flutter/material.dart';
import 'package:forms_app/pages/contacts.dart';
import 'package:forms_app/pages/home.dart';
import 'package:forms_app/pages/register.dart';
import 'package:forms_app/pages/login.dart';
import 'package:forms_app/pages/location.dart';
import 'package:forms_app/pages/addEmergency.dart';
import 'package:forms_app/pages/addContacts.dart';
import 'package:forms_app/pages/services.dart';

void main() {
  runApp(MaterialApp(
    initialRoute: "/",
    routes: {
      "/": (context) => Home(),
      "/register": (context) => Register(),
      "/login": (context) => Login(),
      "/location": (context) => HomePage(),
      "/mycontacts": (context) => ContactsPage(),
      "/addemergency": (context) => AddEmergency(),
      "/addcontacts": (context) => AddContacts(),
      "/services": (context) => ServicesPage(),
      // "/editcontacts": (context) => EditContacts(contact: ,),
    },
    theme: ThemeData(primarySwatch: Colors.red),
  ));
}
