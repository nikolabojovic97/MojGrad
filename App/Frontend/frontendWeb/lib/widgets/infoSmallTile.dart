import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontendWeb/commons/theme.dart';

class InfoSmallTile extends StatelessWidget {
  final String cardTitle;
  final IconData icon;
  final Color iconBgColor;
  final String information;
  final double mediaSize;
  final Color cardBgColor;

  const InfoSmallTile({
    Key key, 
    this.cardTitle,
    this.icon,
    this.iconBgColor,
    this.information,
    this.mediaSize,
    this.cardBgColor
  }) : super (key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: cardBgColor,
      elevation: 8.0,
      margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: Container(
        width: mediaSize,
        decoration: BoxDecoration(
          color: cardBgColor,
        ),
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          leading: Container(
            padding: EdgeInsets.only(right: 12.0),
            decoration: BoxDecoration(
              border: Border(
                right: BorderSide(
                  width: 1.0,
                  color: Colors.white,
                ),
              ),
            ),
            child: Icon(
              icon,
              color: iconBgColor,
            ),
          ),
          title: Text(
            information,
            style: infoCardInfoStyle,
          ),
          subtitle: Text(
            cardTitle,
            style: infoCardTitleStyle,
          ),
        ),
      ),
    );
  }
}