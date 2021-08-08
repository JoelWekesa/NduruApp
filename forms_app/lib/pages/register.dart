import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:forms_app/screens/maindrawer.dart';
import 'package:forms_app/pages/home.dart';
import 'package:forms_app/services/user.dart';
import 'package:forms_app/services/parents.dart';

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
  bool? student = false;
  Map? parents;
  List? items;
  String? parentId;
  String? studentID;
  String? nationalID;
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
              value: parent["id"], child: Text(parent["name"]));
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
          validator: (value) {
            if (student == false && (value == null || value.length < 1)) {
              return "Please input your national ID";
            }
          },
          onSaved: (value) {
            nationalID = value;
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
            studentID = value;
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
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  print(firstname);
                  print(lastname);
                  print(username);
                  print(email);
                  print(phonenumber);
                  print(password);
                  print(studentID);
                  print(nationalID);
                  print(parentId);
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
                buildIdentiy(),
                buildIsStudent(),
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
