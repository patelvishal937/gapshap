import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gapshap_4/pages/chatPage.dart';
import 'package:gapshap_4/pages/profilePage.dart';
import 'package:gapshap_4/services/auth/authService.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  // instance for firebase
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Signout Function

  void signOut() {
    // get auth service
    final authService = Provider.of<AuthService>(context, listen: false);
    authService.SignOut();
  }

  @override
  bool _isSearching = false;

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        leading: IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Profilepage()));
            },
            icon: Icon(CupertinoIcons.home)),
        title: _isSearching
            ? TextField(
                decoration: const InputDecoration(
                    border: InputBorder.none, hintText: 'Name, Email, ...'),
                autofocus: true,
                style: const TextStyle(fontSize: 17, letterSpacing: 0.5),
                //when search text changes then updated search list
                onChanged: (val) {
                  //search logic
                })
            : const Text('We Chat'),
        actions: [
          //search user button
          IconButton(
              onPressed: () {
                setState(() {
                  _isSearching = !_isSearching;
                });
              },
              icon: Icon(_isSearching
                  ? CupertinoIcons.clear_circled_solid
                  : Icons.search)),

          //more features button
          IconButton(
            onPressed: signOut,
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      body: _buildUserlist(),
    );
  }

  // build the list of users expect for the current logged in user

  Widget _buildUserlist() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text("error");
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator().centered();
        }
        return ListView(
          children: snapshot.data!.docs
              .map<Widget>((doc) => _buildUserlistitem(doc))
              .toList(),
        );
      },
    );
  }

  // build a user card indivisually

  Widget _buildUserlistitem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
    // display all the users expect current user
    if (_auth.currentUser?.email != data['email']) {
      return SafeArea(
        child: Card(
          color: Colors.deepPurple,
          child: ListTile(
            textColor: Colors.white,
            iconColor: Colors.white,

            // title for email

            title: Text(data['email'] ?? "-").p8(),

            // leading icon
            leading: Icon(Icons.person),

            //
            // Navigate to another page

            onTap: () {
              // pass the clicked user's Uid to chat screen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatPage(
                    reciverUserEmail: data['email'],
                    reciverUserId: data['uid'],
                  ),
                ),
              );
            },
          ),
        ).p4(),
      );
    } else {
      // return empty container
      return Container();
    }
  }
}
