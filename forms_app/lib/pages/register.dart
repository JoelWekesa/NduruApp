import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:forms_app/screens/maindrawer.dart';
import 'package:forms_app/pages/home.dart';
import 'package:forms_app/services/user.dart';
import 'package:forms_app/services/parents.dart';
import 'package:forms_app/services/register.dart';
import 'package:forms_app/pages/activateAccount.dart';

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
  String? confirmPassword;
  bool? student = false;
  Map? parents;
  List? items;
  Map? data;
  var parentId = "";
  var studentID = "";
  var nationalID = "";
  final _formKey = GlobalKey<FormState>();

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

  Future<void> allParents() async {
    await checkAuth();
    Parents instance = Parents();
    await instance.getParents();
    parents = instance.parents;
    print(parents!["parents"]);
    items = parents!['parents'];
  }

  Future<void> addUser() async {
    userRegistration instance = await userRegistration(
      first_name: firstname as String,
      last_name: lastname as String,
      email: email as String,
      password: password as String,
      phone: phonenumber as String,
      student_id: studentID,
      national_id: nationalID,
      attached_to: parentId,
    );

    await instance.registerUser();
    data = instance.data;
    if (instance.statusCode != 200) {
      _showDialog();
    } else {
      _showDialogSuccess();
    }
  }

  void _showDialogSuccess() {
    String message = "You account was successfully registered!";
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
                          builder: (BuildContext context) => ActivateAccount(),
                          settings: RouteSettings(arguments: data)));
                    },
                    icon: Icon(Icons.send),
                    label: Text("Activate Account")),
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
            labelText: "Confirm password",
            labelStyle: TextStyle(fontSize: 16, color: Colors.black),
          ),
          obscureText: true,
          validator: (value) {
            if (value == null || value.length < 8 || value != password) {
              return "Passwords did not match";
            }
          },
          onSaved: (value) {
            confirmPassword = value;
          }),
    );
  }

  Widget buildIsStudent() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
      child: Row(
        children: [
          Checkbox(
            checkColor: Colors.white,
            value: student,
            onChanged: (bool? value) {
              setState(() {
                student = value!;
              });
            },
          ),
          Text(
            "I'm a student",
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget buildAffilition() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 15, 20, 20),
      child: DropdownButtonFormField(
        decoration: InputDecoration(
          labelText: "Select your institution",
          labelStyle: TextStyle(fontSize: 16, color: Colors.black),
        ),
        items: items?.map((parent) {
          return DropdownMenuItem(
              value: parent["name"], child: Text(parent["name"]));
        }).toList(),
        onChanged: (value) => setState(() {
          parentId = value as String;
        }),
      ),
    );
  }

  Widget buildNationalId() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 15, 20, 10),
      child: TextFormField(
          decoration: InputDecoration(
            labelText: "Enter your national ID",
            labelStyle: TextStyle(fontSize: 16, color: Colors.black),
          ),
          keyboardType: TextInputType.number,
          validator: (value) {
            if (student == false && (value == null || value.length < 1)) {
              return "Please input your national ID";
            }
          },
          onSaved: (value) {
            nationalID = value as String;
          }),
    );
  }

  Widget buildStudentId() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 15, 20, 10),
      child: TextFormField(
          decoration: InputDecoration(
            labelText: "Enter your student ID",
            labelStyle: TextStyle(fontSize: 16, color: Colors.black),
          ),
          validator: (value) {
            if (student == true && (value == null || value.length < 1)) {
              return "Please input your student ID";
            }
          },
          onSaved: (value) {
            studentID = value as String;
          }),
    );
  }

  Widget buildIdentiy() {
    if (student == false) {
      return buildNationalId();
    }

    return Column(
      children: [
        buildNationalId(),
        buildAffilition(),
        buildStudentId(),
      ],
    );
  }

  Widget buildSubmitButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 15, 20, 10),
      child: Row(
        children: [
          ElevatedButton.icon(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  await addUser();
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
                // buildUsername(),
                buildEmail(),
                buildPhonenumber(),
                buildIdentiy(),
                buildIsStudent(),
                buildPassword(),
                buildConfirmPassword(),
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
    allParents();
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
