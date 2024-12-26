import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'dart:html' as html;

class UserProfilePage extends StatefulWidget {
  final String username;

  const UserProfilePage({super.key, required this.username, required id});

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class User {
  final int index;
  final String id;
  final String username;

  User({required this.id, required this.username, required this.index});
}

class _UserProfilePageState extends State<UserProfilePage> {
  List<User> users = [];
  TextEditingController? usernameController; // 用于表单输入控制

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    try {
      String url = 'http://localhost:80/get_users.php';
      Response response = await Dio().get(url);

      // 假设响应是一个用户对象的数组
      List<dynamic> responseData = response.data['data'];
      int index = 0;
      List<User> fetchedUsers = responseData
          .map((user) => User(
                id: user['id'].toString(),
                username: user['username'] as String,
                index: index++,
              ))
          .toList();

      setState(() {
        users = fetchedUsers;
      });
    } catch (e) {
      print(e.toString());
    }
  }

  void _editUser(User user) {
    usernameController = TextEditingController(text: user.username);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit User'),
        content: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: usernameController!,
                decoration: const InputDecoration(labelText: 'Username'),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              String newUsername = usernameController!.text;
              try {
                Response response =
                    await Dio().post('http://localhost:80/update_user.php',
                        data: FormData.fromMap({
                          'username': newUsername,
                          'id': user.id,
                        }));
                await _fetchUsers();
                if (response.data['success']) {
                  Navigator.of(context).pop();
                }
              } catch (e) {
                html.window.alert('Username $newUsername already exist.');
              }
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  void _deleteUser(String userId) async {
    await Dio().post('http://localhost:80/delete_user.php',
        data: FormData.fromMap({
          'id': userId,
        }));
    await _fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Welcome! User ${widget.username} ~powered by Li Hongyao(230345754)',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      ),
      body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: DataTable(
              columns: const [
                DataColumn(label: Text('Index')),
                DataColumn(label: Text('Username')),
                DataColumn(label: Text('Actions')),
              ],
              rows: users
                  .map((user) => DataRow(cells: [
                        DataCell(Text(user.index.toString())),
                        DataCell(Text(user.username)),
                        DataCell(Row(
                          children: [
                            IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () => _editUser(user)),
                            IconButton(
                                icon: const Icon(Icons.delete),
                                color: Colors.red,
                                onPressed: () => _deleteUser(user.id)),
                          ],
                        )),
                      ]))
                  .toList(),
            ),
          )),
    );
  }
}
