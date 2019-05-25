import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:amc/singletons/userdata.dart';

class ViewProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  'Profile',
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
      body: Stack(
        children: <Widget>[

          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background.png'),
                alignment: Alignment.bottomCenter,
                fit: BoxFit.cover,
              ),
            ),
          ),

          ListView(
            children: <Widget>[

              ProfilePic(),

              SizedBox(height: 5.0),

              UserInfo(),

              SizedBox(height: 20.0),

            ],
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: Icon(
          Icons.arrow_back,
        ),
        backgroundColor: const Color.fromRGBO(206, 38, 64, 1.0),
      ),
    );
  }
}

class ProfilePic extends StatefulWidget {
  @override
  _ProfilePicState createState() => _ProfilePicState();
}

class _ProfilePicState extends State<ProfilePic> {

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[

          Container(
            width: 190.0,
            height: 190.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                fit: BoxFit.cover,
                alignment: Alignment.center,
                image: NetworkImage(
                  userData.viewUser.data['profilePic'],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class UserInfo extends StatefulWidget {
  @override
  _UserInfoState createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  bool init = true;

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery
        .of(context)
        .size
        .width;
    //double _height = MediaQuery.of(context).size.height;

    return Column(
      children: <Widget>[

        // FULL NAME
        Container(
          width: _width / 1.25,
          height: 85.5,
          alignment: Alignment.center,
          child: Column(
            children: <Widget>[

              SizedBox(height: 10.0),

              Text(
                "${userData.viewUser.data['firstName']} ${userData.viewUser.data['lastName']}",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.3,
                ),
              ),

              Text(
                "AMC Employee",
                style: TextStyle(
                  color: Colors.white24,
                  fontSize: 15.0,
                  fontStyle: FontStyle.italic,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ),

        Container(
          width: 350.0,
          alignment: Alignment.center,
          child: Column(
            children: <Widget>[

              SizedBox(height: 30.0),

              Container(
                height: 3,
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(46, 5, 13, 1.0),
                  borderRadius: BorderRadius.all(const Radius.circular(30.0)),
                ),
              ),

              SizedBox(height: 10.0),

              // FAVORITE MOVIE
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[

                  Container(
                    child: Row(
                      children: <Widget>[

                        Icon(
                          IconData(0xe824, fontFamily: 'line_icons'),
                          color: const Color.fromRGBO(212, 175, 55, 1.0),
                          size: 28,
                        ),

                        SizedBox(width: 10.0),

                        Text(
                          "Favorite Movie",
                          style: TextStyle(
                            color: const Color.fromRGBO(212, 175, 55, 1.0),
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.3,
                          ),
                        ),

                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(height: 10.0),
              // FAVORITE MOVIE OUTPUT
              Container(
                alignment: Alignment.topLeft,
                margin: const EdgeInsets.only(left: 40.0),
                child: Text(
                  userData.viewUser.data['favMovie'] == '' || userData.viewUser.data['favMovie'] == null
                      ? 'None'
                      : '${userData.viewUser.data['favMovie']}',
                  style: TextStyle(
                    color: userData.viewUser.data['favMovie'] == '' || userData.viewUser.data['favMovie'] == null
                        ? Colors.white24
                        : Colors.white,
                    fontSize: 15.0,
                    fontStyle: FontStyle.italic,
                    letterSpacing: 0.3,
                  ),
                ),
              ),

              SizedBox(height: 20.0),

              Container(
                height: 3,
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(46, 5, 13, 1.0),
                  borderRadius: BorderRadius.all(const Radius.circular(30.0)),
                ),
              ),

              SizedBox(height: 10.0),

              // BIOGRAPHY
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[

                  Container(
                    child: Row(
                      children: <Widget>[

                        Icon(
                          IconData(0xe828, fontFamily: 'line_icons'),
                          color: const Color.fromRGBO(212, 175, 55, 1.0),
                          size: 25,
                        ),

                        SizedBox(width: 10.0),

                        Text(
                          'Biography',
                          style: TextStyle(
                            color: const Color.fromRGBO(212, 175, 55, 1.0),
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.3,
                          ),
                        ),

                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(height: 15.0),
              // BIOGRAPHY OUTPUT
              Container(
                alignment: Alignment.topLeft,
                margin: const EdgeInsets.only(left: 40.0),
                child: Text(
                  userData.viewUser.data['bio'] == '' || userData.viewUser.data['bio'] == null
                      ? 'None'
                      : '${userData.viewUser.data['bio']}',
                  style: TextStyle(
                    color: userData.viewUser.data['bio'] == '' || userData.viewUser.data['bio'] == null
                        ? Colors.white24
                        : Colors.white,
                    fontSize: 15.0,
                    fontStyle: FontStyle.italic,
                    letterSpacing: 0.3,
                  ),
                ),
              ),

              SizedBox(height: 20.0),

              Container(
                height: 3,
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(46, 5, 13, 1.0),
                  borderRadius: BorderRadius.all(const Radius.circular(30.0)),
                ),
              ),

              SizedBox(height: 20.0),
              // TROPHIES
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[

                  Container(
                    child: Row(
                      children: <Widget>[

                        Icon(
                          IconData(0xe822, fontFamily: 'line_icons'),
                          color: const Color.fromRGBO(212, 175, 55, 1.0),
                          size: 28,
                        ),

                        SizedBox(width: 10.0),

                        Text(
                          "Achievements",
                          style: TextStyle(
                            color: const Color.fromRGBO(212, 175, 55, 1.0),
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.3,
                          ),
                        ),

                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(height: 5.0),

              // FAVORITE MOVIE OUTPUT
              Container(
                alignment: Alignment.topLeft,
                margin: const EdgeInsets.only(left: 40.0),
                child: Text(
                  "",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15.0,
                    fontStyle: FontStyle.italic,
                    letterSpacing: 0.3,
                  ),
                ),
              ),

              SizedBox(height: 100.0),

              Container(
                height: 3,
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(46, 5, 13, 1.0),
                  borderRadius: BorderRadius.all(const Radius.circular(30.0)),
                ),
              ),

            ],
          ),
        ),
      ],
    );
  }
}