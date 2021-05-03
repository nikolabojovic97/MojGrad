import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/login.dart';
import 'package:frontend/models/band.dart';
import 'package:frontend/models/bandMember.dart';
import 'package:frontend/models/bandMemberServices.dart';

import 'addMemberPage.dart';

class HomePage extends StatefulWidget {
  final Band band;
  HomePage(this.band);

  @override
  State<StatefulWidget> createState() {
    return _HomePageState(band);
  }
}

class _HomePageState extends State<HomePage> {
  Band band;
  List<BandMember> members;
  int countMembers = 0;

  _HomePageState(this.band);

  void fetchMembers() async {
    members = await BandMemberServices.getMembersByBandID(band.id);
  }

  @override
  void initState() {
    fetchMembers();
    super.initState();
  }

  void updateHomePage() async {
    List<BandMember> replacement;

    replacement = await BandMemberServices.getMembersByBandID(band.id);

    setState(() {
      members = replacement;
      countMembers = members.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (members == null) {
      members = new List<BandMember>();
      updateHomePage();
    }

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: AppBar(
          automaticallyImplyLeading: false,
          actions: <Widget>[
            Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () {
                    navigateToAddMemberPage(band);
                  },
                  child: Icon(
                    Icons.person_add,
                    size: 26.0,
                  ),
                )),
            Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () {
                    navigateToLoginPage();
                  },
                  child: Icon(
                    Icons.exit_to_app,
                    size: 26.0,
                  ),
                )),
          ],
          title: Text(band.name),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[Colors.teal, Colors.cyan, Colors.indigo],
              ),
            ),
          ),
        ),
      ),
      body: makeBody(),
    );
  }

  Widget makeBody() {
    return Container(
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: countMembers,
        itemBuilder: (BuildContext context, int index) {
          return makeCard(members[index]);
        },
      ),
    );
  }

  Card makeCard(BandMember member) => Card(
        elevation: 8.0,
        margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
        child: Container(
          decoration: BoxDecoration(color: Colors.indigo),
          child: makeListTile(member),
        ),
      );

  ListTile makeListTile(BandMember member) => ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        leading: Container(
          padding: EdgeInsets.only(right: 12.0),
          decoration: new BoxDecoration(
              border: new Border(
                  right: new BorderSide(width: 1.0, color: Colors.white24))),
          child: Icon(Icons.person_outline, color: Colors.white),
        ),
        title: Text(
          member.firstName + " " + member.lastName,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        subtitle: Row(
          children: <Widget>[
            Expanded(
              flex: 4,
              child: Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child:
                      Text(band.name, style: TextStyle(color: Colors.white))),
            )
          ],
        ),
        trailing: Icon(Icons.delete, color: Colors.white, size: 30.0),
        onTap: () async {
          var deleted = await BandMemberServices.deleteBandMember(member.id);
          if (deleted != false) {
            updateHomePage();
          }
        },
      );

  void navigateToAddMemberPage(Band band) async {
    await Navigator.push(
        context, MaterialPageRoute(builder: (context) => AddMemberPage(band)));
  }

  void navigateToLoginPage() async {
    await Navigator.push(
        context, MaterialPageRoute(builder: (context) => LoginPage()));
  }
}
