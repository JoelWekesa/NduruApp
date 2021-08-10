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
  Map? data = {};
  String name = "";
  String email = "";
  int statusCode = 401;

  Future<void> userInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = await prefs.getString("access-token") as String;
    getUser instance = await getUser(token: token);
    await instance.userDetails();
    data = instance.data;
    statusCode = instance.statusCode as int;
    try {
      setState(() {
        name = data!["user"]["first_name"] + " " + data!["user"]["last_name"];
        email = data!["user"]["email"];
      });
    } catch (e) {
      print(e);
    }
  }

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
    if (statusCode != 200) {
      return SizedBox();
    }
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
    if (statusCode != 200) {
      return SizedBox();
    }
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
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
                  Widget>[
                Text(name, style: TextStyle(color: Colors.white, fontSize: 20)),
                Text(email, style: TextStyle(color: Colors.white, fontSize: 10))
              ]),
              SizedBox(
                width: 18,
              ),
              CircleAvatar(
                  backgroundColor: Colors.teal[800], child: Icon(Icons.edit)),
              buildDivider(),
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

  Widget buildAuth(context) {
    if (statusCode == 200) {
      return buildLogout();
    } else {
      return Column(
        children: [buildRegister(context), buildLogin(context)],
      );
    }
  }

  Widget buildDivider() {
    return Divider(color: Colors.white, thickness: 2);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userInfo();
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
                      buildHome(),
                      buildDivider(),
                      buildAuth(context),
                      buildDivider(),
                      buildAddContacts(),
                    ],
                  );
                })));
  }
}
