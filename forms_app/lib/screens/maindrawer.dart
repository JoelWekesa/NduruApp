import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:forms_app/services/user.dart';
import 'package:forms_app/pages/login.dart';
import 'package:forms_app/pages/home.dart';
import 'package:forms_app/pages/addContacts.dart';

class MainDrawer extends StatefulWidget {
  const MainDrawer({Key? key}) : super(key: key);

  @override
  _MainDrawerState createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  Future<void> userLogout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("access-token", "");
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (BuildContext context) => Login()),
        (route) => false);
  }

  Future<void> goHome() async {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (BuildContext context) => Home()),
        (route) => false);
  }

  Widget buildHome() {
    return ListTile(
      leading: Icon(Icons.home, color: Colors.white),
      title: Text("Nduru", style: TextStyle(color: Colors.white)),
      onTap: () {
        goHome();
      },
    );
  }

  Widget buildAddContacts() {
    return ListTile(
      leading: Icon(Icons.add, color: Colors.white),
      title:
          Text("Add Emergency Contact", style: TextStyle(color: Colors.white)),
      onTap: () {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (BuildContext context) => AddContacts()),
            (route) => false);
      },
    );
  }

  Widget buildProfile(context) {
    return InkWell(
        onTap: () {
          Navigator.pushNamed(context, "/register");
        },
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 20, 0, 20),
          child: Row(
            children: <Widget>[
              CircleAvatar(
                backgroundImage: AssetImage("\assets/avatar.jpeg"),
              ),
              SizedBox(
                width: 18,
              ),
              Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("Joel Wekesa",
                        style: TextStyle(color: Colors.white, fontSize: 20)),
                    Text("joelwekesa.jw@gmail.com",
                        style: TextStyle(color: Colors.white, fontSize: 10))
                  ]),
              SizedBox(
                width: 18,
              ),
              CircleAvatar(
                  backgroundColor: Colors.teal[800], child: Icon(Icons.edit))
            ],
          ),
        ));
  }

  Widget buildLogin(context) {
    return ListTile(
      hoverColor: Colors.amber,
      focusColor: Colors.amber,
      leading: Icon(Icons.login, color: Colors.white),
      title: Text("Login", style: TextStyle(color: Colors.white)),
      onTap: () {
        Navigator.pushNamed(context, "/login");
      },
    );
  }

  Widget buildRegister(context) {
    return ListTile(
      leading: Icon(Icons.app_registration_outlined, color: Colors.white),
      title: Text("Register", style: TextStyle(color: Colors.white)),
      onTap: () {
        Navigator.of(context).pop();
        Navigator.pushNamed(context, "/register");
      },
    );
  }

  Widget buildLogout() {
    return ListTile(
      leading: Icon(Icons.logout, color: Colors.white),
      title: Text("Logout", style: TextStyle(color: Colors.white)),
      onTap: () {
        userLogout();
      },
    );
  }

  Widget buildPanic() {
    return ListTile(
      leading: Icon(Icons.warning, color: Colors.white),
      title: Text("Emergency", style: TextStyle(color: Colors.white)),
      onTap: () {},
    );
  }

  Widget buildDivider() {
    return Divider(color: Colors.white);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Material(
            color: Colors.red,
            child: ListView.builder(
                itemCount: 1,
                itemBuilder: (context, index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      buildProfile(context),
                      buildDivider(),
                      buildHome(),
                      buildLogin(context),
                      buildRegister(context),
                      buildDivider(),
                      buildAddContacts(),
                      buildLogout(),
                      buildDivider(),
                      buildPanic(),
                    ],
                  );
                })));
  }
}
