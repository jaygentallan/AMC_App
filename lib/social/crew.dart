import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:amc/main.dart';
import 'package:amc/services/crud.dart';
import 'package:amc/singletons/userdata.dart';
import 'package:amc/profile/viewprofile.dart';

class CrewList extends StatefulWidget {
  @override
  _CrewListState createState() => _CrewListState();
}

class _CrewListState extends State<CrewList> {
  String picture;
  String firstName;
  String lastName;

  QuerySnapshot users;
  CrudMethods crud = CrudMethods();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget> [


        Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background.png'),
          fit: BoxFit.cover,
            ),
          ),
        ),

        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: PreferredSize(
          preferredSize: Size.fromHeight(40.0),
          child: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.black,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: Image.asset(
                    'assets/amc_logo.png',
                    width: 30.0,
                    height: 30.0,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    'Meet Your Crew',
                    style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 22
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      body: _crewList(),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).popUntil((route) => route.isFirst);
        },
        child: Icon(
          Icons.arrow_back,
        ),
        backgroundColor: const Color.fromRGBO(206, 38, 64, 1.0),
      ),
    ),
    ]
    );
  }

  Widget _crewList() {

    Future<void> _refresh() async
    {
      print('Refreshing');
      _crewList();
    }

    if (userData.users != null) {
      return RefreshIndicator(
        backgroundColor: const Color.fromRGBO(206, 38, 64, 1.0),
        color: Colors.white,
        onRefresh: _refresh,
          child: ListView.builder(
            itemCount: userData.users.documents.length,
            padding: const EdgeInsets.all(5.0),
            itemBuilder: (context, i) {
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                height: 55.0,
                alignment: FractionalOffset.center,
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromRGBO(132, 26, 42, 1.0),
                        offset: Offset(0.0,6.0),
                      ),
                    ],
                    color: const Color.fromRGBO(206, 38, 64, 1.0),
                    borderRadius: BorderRadius.all(const Radius.circular(32.0))),
                child: FlatButton(
                  onPressed: () {
                    userData.viewUser = userData.users.documents[i];
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ViewProfilePage()));
                    },
                  child: ListTile(
                    // USER PROFILE PIC
                    leading: CircleAvatar(
                      radius: 23,
                      backgroundImage: NetworkImage(
                          userData.users.documents[i].data['profilePic'],
                          ),
                        ),
                    // USER FULL NAME
                    title: Text(
                      "${userData.users.documents[i].data['firstName']} ${userData.users.documents[i].data['lastName']}",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  )
                ),
              );
          },
        ),
      );
    } else {
      return Text(
        'Loading...',
        style: TextStyle(
          color: Colors.white,
          fontSize: 15.0,
          fontWeight: FontWeight.w300,
        ),
      );
    }
  }
}