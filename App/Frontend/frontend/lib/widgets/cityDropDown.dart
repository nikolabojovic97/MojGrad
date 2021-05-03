import 'package:Frontend/commons/theme.dart';
import 'package:flutter/material.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';

class CityDropDown extends StatefulWidget {
  String _selectedCity;

  CityDropDown(this._selectedCity, );

  @override
  _CityDropDownState createState() => _CityDropDownState();
}

class _CityDropDownState extends State<CityDropDown> {
  List<String> cities = ["Beograd", "Kragujevac", "Niš", "Novi Sad", "Subotica", "Čačak"];
  List<DropdownMenuItem<String>> _items = List<DropdownMenuItem<String>>();

  @override
  initState(){
    super.initState();

    for(var city in cities)
      _items.add(DropdownMenuItem<String>(
          value: city,
          child: Container(
            child: Text(city),
            ),
        )
      );
  }

  void setCity(String city){
    setState(() {
      widget._selectedCity = city;  
    });
  }

  @override
  Widget build(BuildContext context) {
    /*return SearchableDropdown.single(
              style: infoField,
              items: _items,
              //value: widget._selectedCity,
              onChanged: (value) {
                setState(() {
                  widget._selectedCity = value;
                });
              },
              hint: "Izaberite grad",
              isExpanded: true,
              dialogBox: false,
              menuConstraints: BoxConstraints.tight(Size.fromHeight(300)),
              iconSize: 30,
              iconEnabledColor: Colors.lightGreen,
              closeButton: "Zatvori",

    );*/

    return  ListTile(
         /* title: ListTile(
            title: Text(
              "Institucija",
              style: infoFieldBold,
            ),
          ),*/
          subtitle: SearchableDropdown.single(
            style: infoField,
            items: _items,
            value: widget._selectedCity,
            onChanged: (value) {
              setState(() {
                widget._selectedCity = value;
              });
            },
            hint: "Izaberite",
            isExpanded: true,
            dialogBox: false,
            menuConstraints: BoxConstraints.tight(Size.fromHeight(300)),
            iconSize: 30,
            iconEnabledColor: Colors.lightGreen,
            closeButton: "Zatvori",
          ),
        );
  }
}