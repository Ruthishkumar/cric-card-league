import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_database/firebase_ui_database.dart';

class GridView1 extends StatefulWidget {
  const GridView1({Key? key}) : super(key: key);

  @override
  State<GridView1> createState() => _GridView1State();
}

class _GridView1State extends State<GridView1> {
  final usersQuery =
      FirebaseDatabase.instance.ref('playerStats').orderByChild('batAvg');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FirebaseDatabaseQueryBuilder(
        query: usersQuery,
        builder: (context, snapshot, _) {
          return GridView.builder(
            shrinkWrap: true,
            itemCount: snapshot.docs.length,
            itemBuilder: (context, index) {
              if (snapshot.hasMore && index + 1 == snapshot.docs.length) {
                snapshot.fetchMore();
              }
              final user = snapshot.docs[index].value as Map<dynamic, dynamic>;
              var gridList = [
                {'statsHeader': 'Bat Avg :', 'Value': '${user['batAvg']}'},
                {'statsHeader': 'Bowl Avg :', 'Value': '${user['batAvg']}'},
              ];
              log(user['batAvg'].toString());
              log('Total Runs');
              Map data = gridList[index];
              return Container(
                padding: const EdgeInsets.all(8),
                color: Colors.teal[100],
                child: Row(
                  children: [
                    Text(data['statsHeader']),
                    Text(data['Value']),
                  ],
                ),
              );
            },
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, mainAxisSpacing: 10, crossAxisSpacing: 10),
          );
        },
      ),
    );
  }
}
