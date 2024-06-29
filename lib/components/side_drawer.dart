import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:runningapp/pages/logged_in/providers/user_info_provider.dart';

class SideDrawer extends ConsumerWidget {
  final Function(int) onTap;

  const SideDrawer({required this.onTap, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userInfo = ref.watch(userInformationProvider).asData?.value;

    final name = userInfo?['name'] as String?;
    final points = userInfo?['points'] as int?;

    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            accountName:
                name != null ? Text(name) : const CircularProgressIndicator(),
            accountEmail: Text('$points pts'),
            currentAccountPicture: CircleAvatar(
              child: ClipOval(
                child: Image.network(
                    'https://images.unsplash.com/photo-1633332755192-727a05c4013d?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8dXNlcnxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=900&q=60'),
              ),
            ),
            decoration: const BoxDecoration(
              color: Colors.red,
            ),
          ),
          ListTile(
            title: const Text('Story'),
            leading: const Icon(Icons.book),
            onTap: () {
              onTap(4);
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Training'),
            leading: const Icon(Icons.run_circle),
            onTap: () {
              onTap(5);
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('My Stats'),
            leading: const Icon(FontAwesomeIcons.trophy),
            onTap: () {
              onTap(6);
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Leaderboards'),
            leading: const Icon(FontAwesomeIcons.rankingStar),
            onTap: () {
              onTap(7);
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Settings'),
            leading: const Icon(Icons.settings),
            onTap: () {
              onTap(8);
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Routes'),
            leading: const Icon(Icons.map_outlined),
            onTap: () {
              onTap(9);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
