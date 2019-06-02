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

              SizedBox(height: 25.0),

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
      child: Stack(
        children: <Widget>[

          // Golden line decoration behind profile picture
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 25.0),
            height: 190.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget> [

                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 65.0),
                  height: 10.0,
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(250,205,85, 0.75),
                    borderRadius: BorderRadius.vertical(top: const Radius.circular(40.0)),
                  ),
                ),

                SizedBox(height: 5.0),

                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 35.0),
                  height: 10.0,
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(250,205,85, 0.75),
                    borderRadius: BorderRadius.vertical(top: const Radius.circular(40.0)),
                  ),
                ),

                SizedBox(height: 5.0),

                Container(
                  height: 20.0,
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(250,205,85, 0.75),
                    borderRadius: BorderRadius.all(const Radius.circular(40.0)),
                  ),
                ),

                SizedBox(height: 5.0),

                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 35.0),
                  height: 10.0,
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(250,205,85, 0.75),
                    borderRadius: BorderRadius.vertical(bottom: const Radius.circular(40.0)),
                  ),
                ),

                SizedBox(height: 5.0),

                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 65.0),
                  height: 10.0,
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(250,205,85, 0.75),
                    borderRadius: BorderRadius.vertical(bottom: const Radius.circular(40.0)),
                  ),
                ),

              ],
            ),
          ),

          Align(
            child: Container(
              width: 190.0,
              height: 190.0,
              decoration: BoxDecoration(
                color: const Color.fromRGBO(250,205,85, 1.0),
                shape: BoxShape.circle,
                border: Border.all(
                  width: 5.0,
                  color: const Color.fromRGBO(250,205,85, 0.75),
                ),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                  image: NetworkImage(
                    userData.viewUser.data['profilePic']
                  ),
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

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget> [

                  // Golden line decoration
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10.0),
                    width: 50.0,
                    height: 10.0,
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(250,205,85, 0.75),
                      borderRadius: BorderRadius.only(bottomLeft: const Radius.circular(40.0)),
                    ),
                  ),

                  Text(
                    "AMC Employee",
                    style: TextStyle(
                      color: const Color.fromRGBO(250,205,85, 1.0),
                      fontSize: 15.0,
                      fontStyle: FontStyle.italic,
                      letterSpacing: 0.3,
                    ),
                  ),

                  // Golden line decoration
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10.0),
                    width: 50.0,
                    height: 10.0,
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(250,205,85, 0.75),
                      borderRadius: BorderRadius.only(bottomRight: const Radius.circular(40.0)),
                    ),
                  ),

                ],
              ),

            ],
          ),
        ),

        SizedBox(height: 20.0),

        Container(
          margin: const EdgeInsets.symmetric(horizontal: 25.0),
          alignment: FractionalOffset.center,
          decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: const Color.fromRGBO(132, 26, 42, 1.0),
                  offset: Offset(0.0, 5.0),
                ),
              ],
              color: const Color.fromRGBO(206, 38, 64, 1.0),
              borderRadius: BorderRadius.all(const Radius.circular(10.0))),
          child: Column(
            children: <Widget>[

              SizedBox(height: 20.0),

              // FAVORITE MOVIE
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[

                  // Used as padding
                  SizedBox(width: 30.0),

                  // Container for the Favorite Movie label
                  Container(
                    child: Row(
                      children: <Widget> [

                        Icon(
                          IconData(0xe824,fontFamily: 'line_icons'),
                          color: const Color.fromRGBO(250,205,85, 1.0),
                          size: 28,
                        ),

                        SizedBox(width: 10.0),

                        Text(
                          "Favorite Movie",
                          style: TextStyle(
                            color: const Color.fromRGBO(250,205,85, 1.0),
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

              // FAVORITE MOVIE OUTPUT
              Container(
                alignment: Alignment.topLeft,
                margin: const EdgeInsets.only(left: 67.0,right: 20.0),
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

              // Used as padding
              SizedBox(height: 20.0),

              // Border to separate section
              Container(
                height: 2.5,
                alignment: FractionalOffset.center,
                color: Color.fromRGBO(193, 34, 59, 1.0),
              ),

              // Used as padding
              SizedBox(height: 10.0),

              // BIOGRAPHY
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[

                  // Used as padding
                  SizedBox(width: 30.0),

                  // Container for Biography label
                  Container(
                    child: Row(
                      children: <Widget> [

                        Icon(
                          IconData(0xe828,fontFamily: 'line_icons'),
                          color: const Color.fromRGBO(250,205,85, 1.0),
                          size: 25,
                        ),

                        SizedBox(width: 10.0),

                        Text(
                          'Biography',
                          style: TextStyle(
                            color: const Color.fromRGBO(250,205,85, 1.0),
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
              // BIOGRAPHY OUTPUT
              Container(
                alignment: Alignment.topLeft,
                margin: const EdgeInsets.only(left: 67.0,right: 20.0),
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

              // Used as padding
              SizedBox(height: 20.0),

              // Border to separate section
              Container(
                height: 2.5,
                alignment: FractionalOffset.center,
                color: Color.fromRGBO(193, 34, 59, 1.0),
              ),

              // Used as padding
              SizedBox(height: 20.0),

              // ACHIEVEMENTS
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget> [

                  // Used as padding
                  SizedBox(width: 30.0),

                  // Container for Achievements
                  Container(
                    child: Row(
                      children: <Widget> [

                        Icon(
                          IconData(0xe822,fontFamily: 'line_icons'),
                          color: const Color.fromRGBO(250,205,85, 1.0),
                          size: 28,
                        ),

                        SizedBox(width: 10.0),

                        Text(
                          "Achievements",
                          style: TextStyle(
                            color: const Color.fromRGBO(250,205,85, 1.0),
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

              // ACHIEVEMENT OUTPUT
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

            ],
          ),
        ),
      ],
    );
  }
}