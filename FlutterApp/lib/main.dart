import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String _username = '';
  String _password = '';
  String _response = '';

  String _formTitle = 'Login';
  String _switchTitle = 'To Sign Up';

  bool _isLogin = true;

  void _switch() {
    _isLogin = !_isLogin;
    setState(() {
      if (_isLogin) {
        _formTitle = 'Login';
        _switchTitle = 'To Sign Up';
      } else {
        _formTitle = 'Sign Up';
        _switchTitle = 'To Login';
      }
    });
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      String url = _isLogin ? 'login.php' : 'register.php';

      try {
        Response response = await Dio().post('http://localhost:80/$url',
            data: FormData.fromMap({
              'username': _username,
              'password': _password,
            }));

        setState(() {
          _response = response.data['message'];
        });

        // 根据响应数据做进一步处理，比如导航到另一个页面
      } catch (e) {
        if (e is DioError && e.type == DioErrorType.response) {
          String data = e.response?.data.toString() ?? '';
          Map<String, dynamic> dataMap = jsonDecode(data);
          setState(() {
            _response = 'Error: ${dataMap['message']}';
          });
        } else {
          setState(() {
            _response = 'Error: ${e.toString()}';
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'This web is powered by Li Hongyao(230345754)',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Text(
                _formTitle,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Username'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your username.';
                  }
                  return null;
                },
                onSaved: (value) {
                  _username = value!;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password.';
                  }
                  return null;
                },
                onSaved: (value) {
                  _password = value!;
                },
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: _switch,
                    child: Text(_switchTitle),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: _submit,
                    child: Text(_formTitle),
                    style: ButtonStyle(
                        backgroundColor:
                            WidgetStateProperty.all(Colors.blue[100])),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(_response),
            ],
          ),
        ),
      ),
    );
  }
}
