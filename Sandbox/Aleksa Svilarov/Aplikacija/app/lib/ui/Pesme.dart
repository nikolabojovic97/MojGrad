import 'package:Aplikacija/models/RHCP.dart';
import 'package:Aplikacija/models/api.services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

class Pesme extends StatefulWidget {
  Pesme({Key key}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _PesmeState();
  }
}

class _PesmeState extends State<Pesme> {
  List<RHCP> pesme;

  getPesme() {
    APIServices.fetchUser().then(
      (response) {
        Iterable list = json.decode(response.body);
        List<RHCP> userList = List<RHCP>();
        userList = list.map((model) => RHCP.fromObject(model)).toList();
        setState(
          () {
            pesme = userList;
          },
        );
      },
    );
  }
  
  @override
  Widget build(BuildContext context) {
    getPesme();
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: SafeArea(
        child: Container(
          height: 150.0,
          child: ListView.builder(
            itemCount: pesme.length,
            itemBuilder: (context, index) {
              return Card(
                color: Colors.white,
                elevation: 4.0,
                child: ListTile(
                  title: ListTile(
                    title: Text(pesme[index].naziv),
                    onTap: null,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}