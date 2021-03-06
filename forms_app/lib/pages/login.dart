import 'package:flutter/material.dart';
import 'package:forms_app/services/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:forms_app/screens/maindrawer.dart';
import 'package:forms_app/screens/loading.dart';
import 'package:forms_app/pages/home.dart';
import 'package:forms_app/services/user.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String? email;
  String? password;
  int? statusCode;
  Map? data;
  bool loading = false;

  final _formKey = GlobalKey<FormState>();

  void startLogin(email, password) async {
    setState(() {
      loading = true;
    });
    authLogin instance = authLogin(email: email, password: password);
    await instance.userLogin();
    setState(() {
      loading = false;
    });
    statusCode = instance.statusCode;
    data = instance.data;

    if (statusCode == 200) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (BuildContext context) => Home()),
      );
    } else {
      _showDialog();
    }
  }

  Future<void> checkAuth() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = await prefs.getString("access-token") as String;
    getUser instance = await getUser(token: token);
    await instance.userDetails();
    int statusCode = await instance.statusCode as int;
    if (statusCode == 200) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (BuildContext context) => Home()),
      );
    }
  }

  void _showDialog() {
    String message = data!["message"];
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Text("Login Failed"),
          content: Text("$message"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            ElevatedButton.icon(
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
            if (value == null || value.length < 5) {
              return "Passwords must be at least 8 characters long";
            }
          },
          onSaved: (value) {
            password = value;
          }),
    );
  }

  Widget buildSubmitButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 15, 0, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ElevatedButton.icon(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      startLogin(email, password);
                    }
                  },
                  icon: Icon(Icons.send),
                  label: Text("Login")),
              SizedBox(width: 10),
              TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, "/register");
                  },
                  child: Text("Or register")),
              SizedBox(width: 10),
              LoadingCircle(loading: loading),
            ],
          ),
          SizedBox(height: 10),
          TextButton(
              onPressed: () {
                Navigator.pushNamed(context, "/resetcodes");
              },
              child: Text("Forgot password?"))
        ],
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkAuth();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(title: Text("Login to your account.."), centerTitle: true),
      drawer: MainDrawer(),
      body: Center(
        child: Card(
          elevation: 5,
          shadowColor: Colors.cyan,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [buildEmail(), buildPassword(), buildSubmitButton()],
              )),
        ),
      ),
      // floatingActionButton: Padding(
      //   padding: const EdgeInsets.all(8.0),
      //   child: FloatingActionButton(
      //     backgroundColor: Colors.red[900],
      //     onPressed: () {
      //       // Navigator.pushNamed(context, "/location");
      //     },
      //     child: Icon(Icons.warning, color: Colors.red),
      //   ),
      // ),
    );
  }
}
