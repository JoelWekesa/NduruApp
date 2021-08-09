import 'package:flutter/material.dart';
import 'package:forms_app/screens/maindrawer.dart';
import 'package:forms_app/services/passwordreset.dart';

class PasswordReset extends StatefulWidget {
  const PasswordReset({Key? key}) : super(key: key);

  @override
  _PasswordResetState createState() => _PasswordResetState();
}

class _PasswordResetState extends State<PasswordReset> {
  String? email;
  String? code;
  String? password;
  String? confirmPassword;
  Map? data;

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
                      Navigator.of(context).pushNamed("/login");
                    },
                    icon: Icon(Icons.login),
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

  Future<void> resetPassword() async {
    UserPasswordReset instance = UserPasswordReset(
        email: email as String,
        code: code as String,
        password: password as String);

    await instance.resetPass();
    data = instance.data;
    if (instance.statusCode != 200) {
      _showDialog();
    } else {
      _showDialogSuccess();
    }
  }

  Widget buildEmail() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 15, 20, 10),
      child: TextFormField(
          initialValue: email,
          decoration: InputDecoration(
            icon: Icon(Icons.mail),
            labelText: "Enter your email",
            labelStyle: TextStyle(fontSize: 16, color: Colors.black),
          ),
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
          }),
    );
  }

  Widget buildCode() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 15, 20, 10),
      child: TextFormField(
          decoration: InputDecoration(
              labelText: "Confirmation code", icon: Icon(Icons.security)),
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

  Widget buildPassword() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 15, 20, 10),
      child: TextFormField(
          decoration: InputDecoration(
            icon: Icon(Icons.lock),
            labelText: "Enter your password",
            labelStyle: TextStyle(fontSize: 16, color: Colors.black),
          ),
          obscureText: true,
          validator: (value) {
            if (value == null || value.length < 8) {
              return "Passwords must be at least 8 characters long";
            }
          },
          onChanged: (value) {
            password = value;
          },
          onSaved: (value) {
            password = value;
          }),
    );
  }

  Widget buildConfirmPassword() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 15, 20, 10),
      child: TextFormField(
          decoration: InputDecoration(
            icon: Icon(Icons.lock),
            labelText: "Confirm password",
            labelStyle: TextStyle(fontSize: 16, color: Colors.black),
          ),
          obscureText: true,
          validator: (value) {
            if (value != password) {
              return "Passwords did not match";
            }
          },
          onSaved: (value) {
            confirmPassword = value;
          }),
    );
  }

  Widget buildSumbit() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 15, 20, 10),
      child: ElevatedButton.icon(
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              await resetPassword();
            }
          },
          icon: Icon(Icons.send),
          label: Text("Send")),
    );
  }

  Widget buildPasswordReset() {
    return ListView.builder(
        itemCount: 1,
        itemBuilder: (BuildContext context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildEmail(),
                    buildCode(),
                    buildPassword(),
                    buildConfirmPassword(),
                    buildSumbit(),
                  ],
                ),
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    email = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      appBar: AppBar(title: Text("Password Reset"), centerTitle: true),
      drawer: MainDrawer(),
      body: Container(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(child: buildPasswordReset()),
      )),
    );
  }
}
