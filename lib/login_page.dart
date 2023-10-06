import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:git_practice/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<void> _saveToken(String tokenValue) async {
    final SharedPreferences prefs = await _prefs;

    setState(() {
      prefs.setString('token', tokenValue).then((bool success) {
        return success;
      });
    });
  }

  Future<String?> _getToken() async {
    final SharedPreferences prefs = await _prefs;
    String? abc;

    setState(() {
      abc = prefs.getString('token');
    });
    print(abc);
    return abc;
  }

  final _formKey = GlobalKey<FormState>();

  TextEditingController tokenKey = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: Center(
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    border: Border.all(color: Colors.blueGrey),
                  ),
                  // child: Image.asset('assets/logo.svg'),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Form(
                    key: _formKey,
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: TextFormField(
                          controller: tokenKey,
                          validator: MultiValidator([
                            RequiredValidator(errorText: 'Enter token'),
                          ]),
                          decoration: InputDecoration(
                            hintText: 'Token',
                            labelText: 'Token',
                            prefixIcon: Icon(
                              Icons.email,
                              //color: Colors.green,
                            ),
                            errorStyle: TextStyle(fontSize: 18.0),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red),
                              borderRadius: BorderRadius.all(
                                Radius.circular(9.0),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(28.0),
                        child: Container(
                          child: ElevatedButton(
                            child: Text(
                              'Login',
                              style: TextStyle(color: Colors.white, fontSize: 22),
                            ),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _saveToken(tokenKey.text).then((value) => Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => HomePage(),
                                    )));
                                _getToken();
                              }
                            },
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                          ),
                          width: MediaQuery.of(context).size.width,
                          height: 50,
                        ),
                      ),
                      Center(
                        child: Container(
                          padding: EdgeInsets.only(top: 50),
                          child: Text(
                            'SIGN UP!',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Colors.lightBlue,
                            ),
                          ),
                        ),
                      )
                    ]),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
