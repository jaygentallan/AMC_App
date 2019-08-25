import 'dart:ui';

import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[

        // BACKGROUND
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/background.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Text(
              '',
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
          ),
        ),

        ListView(
          children: <Widget>[

            // BACKGROUND
            Container(
              height: 175.0,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/amc_newark.jpg'),
                  fit: BoxFit.cover,
                  alignment: Alignment(0.0,-0.5)
                ),
              ),
            ),

            SizedBox(height: 20.0),

            // AMC location text
            Container(
              alignment: AlignmentDirectional.center,
              child: Text(
                'AMC NewPark 12',
                style: TextStyle(
                  color: const Color.fromRGBO(250,205,85, 0.75),
                  fontSize: 17.0,
                  fontWeight: FontWeight.w300,
                  letterSpacing: 0.75,
                ),
              ),
            ),

            // Used as padding
            SizedBox(height: 20.0),

            RecentPosts(),

            // Used as padding
            SizedBox(height: 10.0),

            RecentNews(),

            // Used as padding
            SizedBox(height: 10.0),

            RecentCrew(),

            SizedBox(height: 1000.0),

          ],
        )

      ],
    );
  }
}


class RecentPosts extends StatefulWidget {
  @override
  _RecentPostsState createState() => _RecentPostsState();
}

class _RecentPostsState extends State<RecentPosts> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: FractionalOffset.center,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: const Color.fromRGBO(132, 26, 42, 1.0),
            width: 1.0,
          ),
        ),
        color: const Color.fromRGBO(206, 38, 64, 1.0),
      ),
      child: Column(
        children: <Widget>[

          // Used as padding
          SizedBox(height: 5.0),

          Text(
            "Recent Posts",
            style: TextStyle(
              color: Colors.white,
              fontSize: 15.0,
              fontWeight: FontWeight.w300,
              letterSpacing: 0.75,
            ),
          ),

          // Used as padding
          SizedBox(height: 15.0),

        ],
      ),
    );
  }
}

class RecentNews extends StatefulWidget {
  @override
  _RecentNewsState createState() => _RecentNewsState();
}

class _RecentNewsState extends State<RecentNews> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: FractionalOffset.center,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: const Color.fromRGBO(132, 26, 42, 1.0),
            width: 1.0,
          ),
        ),
        color: const Color.fromRGBO(206, 38, 64, 1.0),
      ),
      child: Column(
        children: <Widget>[

          // Used as padding
          SizedBox(height: 5.0),

          Text(
            "Recent News",
            style: TextStyle(
              color: Colors.white,
              fontSize: 15.0,
              fontWeight: FontWeight.w300,
              letterSpacing: 0.75,
            ),
          ),

          // Used as padding
          SizedBox(height: 15.0),

        ],
      ),
    );
  }
}

class RecentCrew extends StatefulWidget {
  @override
  _RecentCrewState createState() => _RecentCrewState();
}

class _RecentCrewState extends State<RecentCrew> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: FractionalOffset.center,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: const Color.fromRGBO(132, 26, 42, 1.0),
            width: 1.0,
          ),
        ),
        color: const Color.fromRGBO(206, 38, 64, 1.0),
      ),
      child: Column(
        children: <Widget>[

          // Used as padding
          SizedBox(height: 5.0),

          Text(
            "Recent Crew",
            style: TextStyle(
              color: Colors.white,
              fontSize: 15.0,
              fontWeight: FontWeight.w300,
              letterSpacing: 0.75,
            ),
          ),

          // Used as padding
          SizedBox(height: 15.0),

        ],
      ),
    );
  }
}