import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DropDown extends StatefulWidget {
  DropDown() : super();
 
  @override
  DropDownState createState() => DropDownState();
}
 
class Institution {
  int id;
  String name;
 
  Institution(this.id, this.name);
 
  static List<Institution> getInstitutions() {
    return <Institution>[
      Institution(1, 'Gradsko zelenilo'),
      Institution(2, 'JPKD'),
      Institution(3, 'Vodovod i kanalizacija'),
      Institution(4, 'Srbija šume'),
      Institution(5, 'Srbija vode'),
    ];
  }
}
 
class DropDownState extends State<DropDown> {
  List<Institution> _institutions = Institution.getInstitutions();
  List<DropdownMenuItem<Institution>> _dropdownMenuItems;
  Institution _selectedInstitution;
 
  @override
  void initState() {
    _dropdownMenuItems = buildDropdownMenuItems(_institutions);
    _selectedInstitution = _dropdownMenuItems[0].value;
    super.initState();
  }
 
  List<DropdownMenuItem<Institution>> buildDropdownMenuItems(List institutions) {
    List<DropdownMenuItem<Institution>> items = List();
    for (Institution institution in institutions) {
      items.add(
        DropdownMenuItem(
          value: institution,
          child: Text(institution.name, style: TextStyle(fontSize: 14),),
        ),
      );
    }
    return items;
  }
 
  onChangeDropdownItem(Institution selectedInstitution) {
    setState(() {
      _selectedInstitution = selectedInstitution;
    });
  }
 
  @override
  Widget build(BuildContext context) {
    return  DropdownButton(
      value: _selectedInstitution,
      items: _dropdownMenuItems,
      onChanged: onChangeDropdownItem,
      iconEnabledColor: Colors.lightGreen,
    );
  }
}
