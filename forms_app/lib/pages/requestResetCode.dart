import 'package:flutter/material.dart';
import 'package:forms_app/screens/maindrawer.dart';
import 'package:forms_app/pages/passwordreset.dart';
import 'package:forms_app/services/requestresetcode.dart';

class RequestResetCode extends StatefulWidget {
  const RequestResetCode({Key? key}) : super(key: key);

  @override
  _RequestResetCodeState createState() => _RequestResetCodeState();
}

class _RequestResetCodeState extends State<RequestResetCode> {
  String? email;
  final _formKey = GlobalKey<FormState>();

  Future<void> passResetCode() async {
    RequestReset instance = RequestReset(email: email as String);
    await instance.requestCode();
  }

  Widget buildEmail() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 15, 20, 10),
      child: TextFormField(
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

  Widget buildSumbit() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 15, 20, 10),
      child: ElevatedButton.icon(
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              await passResetCode();
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => PasswordReset(),
                  settings: RouteSettings(arguments: email)));
            }
          },
          icon: Icon(Icons.send),
          label: Text("Send")),
    );
  }

  Widget buildResetCode() {
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
                buildSumbit(),
              ],
            )),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Request password reset"), centerTitle: true),
      drawer: MainDrawer(),
      body: buildResetCode(),
    );
  }
}
