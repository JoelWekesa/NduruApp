import 'package:flutter/material.dart';
import 'package:forms_app/screens/maindrawer.dart';
import 'package:forms_app/services/activateAccount.dart';
import 'package:forms_app/pages/login.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ActivateAccount extends StatefulWidget {
  const ActivateAccount({Key? key}) : super(key: key);

  @override
  _ActivateAccountState createState() => _ActivateAccountState();
}

class _ActivateAccountState extends State<ActivateAccount> {
  Map? data;
  String? email;
  String? code;
  bool? loading = false;
  final _formKey = GlobalKey<FormState>();

  void _showDialogSuccess() {
    String message = "Your account has been activated!";
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
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) => Login(),
                      ));
                    },
                    icon: Icon(Icons.send),
                    label: Text("Login")),
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

  Future<void> finalActivation(email, code) async {
    setState(() {
      loading = true;
    });
    activateAccount instance = await activateAccount(code: code, email: email);
    await instance.accountActivation();
    data = instance.data;

    if (instance.statusCode != 200) {
      setState(() {
        loading = false;
      });
      _showDialog();
    } else {
      setState(() {
        loading = false;
      });
      _showDialogSuccess();
    }
  }

  Widget buildEmail() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 15, 20, 10),
      child: TextFormField(
        initialValue: data!["user"]["email"],
        decoration: InputDecoration(labelText: "Email"),
        validator: (value) {
          bool emailValid = RegExp(
                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
              .hasMatch("$value");

          if (!emailValid) {
            return "Please input your email";
          }
        },
        onSaved: (value) {
          email = value;
        },
      ),
    );
  }

  Widget buildCode() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 15, 20, 10),
      child: TextFormField(
          decoration: InputDecoration(labelText: "Confirmation code"),
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please input your code";
            }
          },
          onSaved: (value) {
            code = value;
          }),
    );
  }

  Widget buildSubmit() {
    if (loading == true) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 10),
        child: Row(
          children: [
            ElevatedButton.icon(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    await finalActivation(email, code);
                  }
                },
                icon: Icon(Icons.send),
                label: Text("Submit")),
            SpinKitRotatingCircle(
              color: Colors.white,
              size: 50.0,
            )
          ],
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 15, 20, 10),
      child: ElevatedButton.icon(
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              await finalActivation(email, code);
            }
          },
          icon: Icon(Icons.send),
          label: Text("Submit")),
    );
  }

  Widget buildAccountActivate() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildEmail(),
              buildCode(),
              buildSubmit(),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    data = ModalRoute.of(context)!.settings.arguments as Map;
    return Scaffold(
      appBar: AppBar(title: Text("Account confirmation"), centerTitle: true),
      drawer: MainDrawer(),
      body: buildAccountActivate(),
    );
  }
}
