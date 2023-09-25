import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:roam_mate/screens/pages/friend_map.dart';
import 'package:roam_mate/screens/pages/friend_request_list.dart';
import 'package:roam_mate/screens/pages/user_search.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  int currentPageIndex = 1;

  void signOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
            'Roammate',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: false,
          actions: <Widget>[
            TextButton(
                onPressed: () {
                  signOut();
                },
                child: const Text("Sign out")),
          ]),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: Theme.of(context).colorScheme.inversePrimary,
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
              selectedIcon: Icon(Icons.search),
              icon: Icon(Icons.search_outlined),
              label: 'Friends'),
          NavigationDestination(
              selectedIcon: Icon(Icons.explore),
              icon: Icon(Icons.explore_outlined),
              label: 'Friend Map'),
          NavigationDestination(
              selectedIcon: Icon(Icons.person_3),
              icon: Icon(Icons.person_3_outlined),
              label: 'Invitations'),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: <Widget>[
            const UserSearch(),
            const FriendMap(),
            const FriendRequestList(),
          ][currentPageIndex],
        ),
      ),
    );
  }
}
