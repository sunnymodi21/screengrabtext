import 'package:flutter/material.dart';

import 'package:screengrabtext/history_screen.dart';

class DrawerItem {
  String title;
  IconData icon;
  DrawerItem(this.title, this.icon);
}

class HomeDrawer extends StatefulWidget {
  final drawerItems = [
    new DrawerItem("History", Icons.history)
  ];

  @override
  State<StatefulWidget> createState() {
    return new _HomeDrawerState();
  }
}

class _HomeDrawerState extends State<HomeDrawer> {
  
  _onSelectItem(int index) {
    switch (index) {
      case 0:
        Navigator.of(context).pop();
        break;
    } // close the drawer
  }

  @override
  Widget build(BuildContext context) {
    var drawerOptions = <Widget>[];
    for (var i = 0; i < widget.drawerItems.length; i++) {
      var d = widget.drawerItems[i];
      drawerOptions.add(
        new ListTile(
          leading: new Icon(d.icon),
          title: new Text(d.title),
          selected: i == 0,
          onTap: () => _onSelectItem(i),
        )
      );
    }

    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.drawerItems[0].title),
      ),
      drawer: new Drawer(
        child: new Column(
          children: <Widget>[
            new UserAccountsDrawerHeader(
                accountName: new Text("User"), 
                accountEmail: null,),
            new Column(children: drawerOptions)
          ],
        ),
      ),
      body: new HistoryScreen(),
    );
  }
}
