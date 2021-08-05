import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:forms_app/screens/maindrawer.dart';
import 'package:forms_app/pages/home.dart';
import 'package:forms_app/services/user.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  String? username;
  String? firstname;
  String? lastname;
  String? email;
  String? phonenumber;
  String? password;
  final _formKey = GlobalKey<FormState>();

  Future<void> checkAuth() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = await prefs.getString("access-token") as String;
    getUser instance = await getUser(token: token);
    await instance.userDetails();
    int statusCode = await instance.statusCode as int;
    if (statusCode == 200) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => Home()),
          (route) => false);
    }
  }

  Widget buildFirstname() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 15, 20, 10),
      child: TextFormField(
          decoration: InputDecoration(
            labelText: "Enter your firstname",
            labelStyle: TextStyle(fontSize: 16, color: Colors.black),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please input your firstname";
            }
          },
          onSaved: (value) {
            firstname = value;
          }),
    );
  }

  Widget buildLastname() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 15, 20, 10),
      child: TextFormField(
          decoration: InputDecoration(
            labelText: "Enter your lastname",
            labelStyle: TextStyle(fontSize: 16, color: Colors.black),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please input your lastname";
            }
          },
          onSaved: (value) {
            lastname = value;
          }),
    );
  }

  Widget buildUsername() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 15, 20, 10),
      child: TextFormField(
          decoration: InputDecoration(
            labelText: "Enter your username",
            labelStyle: TextStyle(fontSize: 16, color: Colors.black),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please input your username";
            }
          },
          onSaved: (value) {
            username = value;
          }),
    );
  }

  Widget buildEmail() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 15, 20, 10),
      child: TextFormField(
          decoration: InputDecoration(
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

  Widget buildPhonenumber() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 15, 20, 10),
      child: TextFormField(
          decoration: InputDecoration(
            labelText: "Enter your phonenumber",
            labelStyle: TextStyle(fontSize: 16, color: Colors.black),
          ),
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please input your phonenumber";
            }
          },
          onSaved: (value) {
            phonenumber = value;
          }),
    );
  }

  Widget buildPassword() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 15, 20, 10),
      child: TextFormField(
          decoration: InputDecoration(
            labelText: "Enter your password",
            labelStyle: TextStyle(fontSize: 16, color: Colors.black),
          ),
          obscureText: true,
          validator: (value) {
            if (value == null || value.length < 8) {
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
      padding: const EdgeInsets.fromLTRB(20, 15, 20, 10),
      child: Row(
        children: [
          ElevatedButton.icon(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  print(firstname);
                  print(lastname);
                  print(username);
                  print(email);
                  print(phonenumber);
                  print(password);
                }
              },
              icon: Icon(Icons.send),
              label: Text("Register")),
          SizedBox(width: 20),
          TextButton(
              onPressed: () {
                Navigator.pushNamed(context, "/login");
              },
              child: Text("Or login"))
        ],
      ),
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
                buildFirstname(),
                buildLastname(),
                buildUsername(),
                buildEmail(),
                buildPhonenumber(),
                buildPassword(),
                buildSubmitButton(),
              ],
            ),
          );
        });
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
        appBar: AppBar(
          title: Text("Become a member"),
          centerTitle: true,
        ),
        drawer: MainDrawer(),
        body: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: Form(
                  key: _formKey,
                  child: buildForm(),
                ),
              ),
            )));
  }
}
