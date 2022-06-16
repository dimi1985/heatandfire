import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider_tutorial/models/user.dart';
import '../providers/info_provider.dart';
import '../util/http_service.dart';
import 'package:easy_localization/easy_localization.dart';

class AdminPanelUsers extends StatefulWidget {
  final AsyncSnapshot<User> snapshot;
  const AdminPanelUsers(this.snapshot, {Key? key}) : super(key: key);

  @override
  State<AdminPanelUsers> createState() => _AdminUserScreenState();
}

class _AdminUserScreenState extends State<AdminPanelUsers> {
  late final List<User> _users = [];
  late Future<User> _futureUser;

  @override
  void initState() {
    _futureUser = HttpService.getAllUsers(_users);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<InfoProvider>(builder: (context, infoProvider, child) {
      return Scaffold(
        appBar: AppBar(
          
        ),
        body: FutureBuilder(
        future: _futureUser,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: _users.length,
                itemBuilder: (context, index) {
                  var user = _users[index];
                  return SizedBox(
                    width: MediaQuery.of(context).size.width /2,
                    child: ListTile(
                      leading: Image.network(
                          'http://10.0.2.2:3000/${(user.userImage).replaceAll(r'\', '/')}'),
                      title: Row(
                        children: [
                          const Text('Username').tr(),
                          Text(': ${user.username}')
                        ],
                      ),
                      subtitle: Text(user.id),
                      trailing: IconButton(
                        icon: const Icon(
                          Icons.info_outline_rounded,
                          size: 30,
                          color: Colors.blueGrey,
                        ),
                        onPressed: () {},
                      ),
                    ),
                  );
                });
          }

          return const CircularProgressIndicator();
        },
      ),
      );
    });
  }
}
