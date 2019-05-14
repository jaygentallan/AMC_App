import 'package:flutter/material.dart';

import 'home.dart';
import 'shifts.dart';
import 'profile.dart';

void main() => { runApp(App()) };

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Main(),
    );
  }
}

class Main extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          child: Header(),
          preferredSize: Size(0,50),),
      body: Body(),
      endDrawer: SideDrawer(),
      bottomNavigationBar: Footer(),
    );
  }
}

class Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                'assets/images/amc_logo.png',
                width: 40.0,
                height: 40.0,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Employee'),
            ),
          ]
      ),
      backgroundColor: Colors.black87,
    );
  }
}

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(child: Text('Home'),),
    );
  }
}

class Footer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: IconButton(
              icon: Icon(Icons.home),
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => Home())
                );
              },
              color: Colors.white,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: IconButton(
              icon: Icon(Icons.schedule),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Shifts())
                );
              },
              color: Colors.white,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: IconButton(
              icon: Icon(Icons.person),
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => Profile())
                );
              },
              color: Colors.white,
            ),
          ),
        ]
      ),
      color: Colors.black87,

      );
  }
}

class SideDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300.0,
      color: Colors.red,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ListTile(
              leading: Icon(
                Icons.cloud_done,
                color: Colors.white,
              ),
              title: Text(
                'Drawer is cool',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              trailing: Icon(
                Icons.expand_more,
                color: Colors.white,
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.image,
                color: Colors.white,
              ),
              title: Text(
                'Flutter is awesome',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              trailing: Icon(
                Icons.expand_more,
                color: Colors.white,
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.graphic_eq,
                color: Colors.white,
              ),
              title: Text(
                'Drawer initialization',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              trailing: Icon(
                Icons.expand_more,
                color: Colors.white,
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.child_care,
                color: Colors.white,
              ),
              title: Text(
                'See you soon!',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              trailing: Icon(
                Icons.expand_more,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}