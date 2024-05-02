import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:summail/ex/service.dart';
import 'package:summail/ex/user.dart';

import '../Mail_screens/drawer/drawer.dart';

class JsonParse extends StatefulWidget {
  const JsonParse({Key? key}) : super(key: key);

  @override
  State<JsonParse> createState() => _JsonParseState();
}

class _JsonParseState extends State<JsonParse> {
  List<User> _user = <User>[];
  bool loading = false;

  void navigateToPage(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Services.getInfo().then((value) {
      setState(() {
        _user = value;
        loading = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(loading ? '썸메일' : 'Loading...'),
      ),
      drawer: const CustomDrawer(),
      body: ListView.builder(
        itemCount: _user.length,
        itemBuilder: (context, index) {
          User user = _user[index];
          return ListTile(
            leading: const Icon(
              Icons.account_circle_rounded,
              color: Colors.blue,
            ),
            trailing: IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text(user.name),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(user.phone),
                          TextButton(
                            onPressed: (){
                              Navigator.pop(context);
                            },
                            child: const Text('Close'),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              icon: const Icon(
                Icons.phone_android_outlined,
                color: Colors.red,
              ),
            ),
            title: Text(user.name),
            subtitle: Text(user.email),
          );
        },
      ),
    );
  }
}