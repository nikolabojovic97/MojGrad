import 'package:Frontend/commons/messages.dart';
import 'package:Frontend/commons/theme.dart';
import 'package:Frontend/config/config.dart';
import 'package:Frontend/models/post.dart';
import 'package:Frontend/models/user.dart';
import 'package:Frontend/services/mapServices.dart';
import 'package:Frontend/services/postServices.dart';
import 'package:Frontend/services/userServices.dart';
import 'package:Frontend/src/pages/prehome.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_map_location_picker/google_map_location_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';

class EditPost extends StatefulWidget {
  final Post _post;
  final List<User> _institutions;
  EditPost(this._post, this._institutions);

  @override
  _EditPostState createState() => _EditPostState(_post, _institutions);
}

class _EditPostState extends State<EditPost> {
  Post _post;
  User _user;
  List<User> institutions;
  final List<DropdownMenuItem> items = [];
  String _selectedInstitution;
  User previousInstitution;
  bool _isLoading;
  _EditPostState(this._post, this.institutions);

  LocationResult _pickedLocation;
  TextEditingController _description = TextEditingController();

  @override
  void initState() {
    _user = Provider.of<UserService>(context, listen: false).user;
    _description.text = _post.description;
    if (_post.institutionUserName != null && _post.institutionUserName != "") {
      print(_post.institutionUserName);
      previousInstitution = institutions.firstWhere(
          (element) => element.username == _post.institutionUserName);
    }

    for (var item in institutions) {
      print(item.username);
      items.add(DropdownMenuItem(
        child: ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(checkUserImgUrl(item.imgUrl)),
          ),
          title: Text(item.username),
          subtitle: Text(item.city),
        ),
        value: item.username,
      ));
    }

    _isLoading = false;
    super.initState();
  }

  void getLocationFromMap(context) async {
    var initLocation = await MapServices.getCityLatLng(_user.city);

    LocationResult result = await showLocationPicker(
      context,
      apiKey,
      myLocationButtonEnabled: true,
      layersButtonEnabled: true,
      initialCenter: initLocation,
    );

    if (result.address == null) result.address = "Adresa ne postoji";

    setState(() {
      _pickedLocation = result;
    });
  }

  void getLocationFromDevice() async {
    LatLng location = await MapServices.getDeviceLocation();
    var address = await MapServices.getAddress(location);

    if (address == null) address = "Adresa ne postoji";

    setState(() {
      _pickedLocation = LocationResult(latLng: location, address: address);
    });
  }

  Future<bool> updatePost() async {
    _post.description = _description.text;
    _post.lastTimeModify = DateTime.now();
    _post.latLng = (_pickedLocation != null)
        ? "${_pickedLocation.latLng.latitude},${_pickedLocation.latLng.longitude}"
        : _post.latLng;
    _post.address =
        (_pickedLocation != null) ? _pickedLocation.address : _post.address;
    _post.institutionUserName = (_selectedInstitution != null)
        ? _selectedInstitution
        : _post.institutionUserName;

    bool updated = await PostServices.updatePost(_post.id, _post, _user.token);
    if (updated) {
      return true;
    }

    return false;
  }

  Widget _descrtiption(context) {
    return ListTile(
      title: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25.0),
            topRight: Radius.circular(25.0),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey[300],
              blurRadius: 10.0,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            leading: CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(checkUserImgUrl(_user.imgUrl)),
            ),
            title: Text(
              _user.username,
              style: postUsername,
            ),
          ),
        ),
      ),
      trailing: Icon(
        Icons.edit,
        size: 30,
      ),
      subtitle: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(25.0),
            bottomRight: Radius.circular(25.0),
          ),
        ),
        child: ListTile(
          title: Text(
            "Opis objave",
            style: infoFieldBold,
          ),
          subtitle: TextField(
            controller: _description,
            decoration: new InputDecoration.collapsed(
                hintText: 'Unesite opis...', hintStyle: infoField),
            autofocus: false,
            maxLines: null,
            keyboardType: TextInputType.text,
          ),
        ),
      ),
    );
  }

  Widget _institutionsDropDown() {
    return ListTile(
      title: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(25.0),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey[300],
              blurRadius: 10.0,
            ),
          ],
        ),
        child: Column(
          children: <Widget>[
            (previousInstitution != null)
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      title: Text(
                        "Prethodno odabrana institucija",
                        style: infoFieldBold,
                      ),
                      subtitle: ListTile(
                        leading: CircleAvatar(
                          radius: 20,
                          backgroundImage: NetworkImage(
                              checkUserImgUrl(previousInstitution.imgUrl)),
                        ),
                        title: Text(previousInstitution.username),
                        subtitle: Text(previousInstitution.city),
                      ),
                    ),
                  )
                : SizedBox.shrink(),
            ListTile(
              title: ListTile(
                title: Text(
                  "Izaberite novu",
                  style: infoFieldBold,
                ),
              ),
              subtitle: SearchableDropdown.single(
                style: infoField,
                items: items,
                value: _selectedInstitution,
                onChanged: (value) {
                  setState(() {
                    _selectedInstitution = value;
                  });
                },
                hint: "Izaberite",
                isExpanded: true,
                dialogBox: false,
                menuConstraints: BoxConstraints.tight(Size.fromHeight(400)),
                iconSize: 30,
                iconEnabledColor: Colors.lightGreen,
                closeButton: "Zatvori",
              ),
            ),
          ],
        ),
      ),
      trailing: Icon(
        Icons.account_balance,
        size: 30,
      ),
    );
  }

  Widget _location() {
    return ListTile(
      title: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(25.0),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey[300],
              blurRadius: 10.0,
            ),
          ],
        ),
        child: ListTile(
          title: ListTile(
            title: Text(
              "Lokacija",
              style: infoFieldBold,
            ),
          ),
          subtitle: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      (!_post.isSolution)
                          ? RaisedButton(
                              color: Colors.lightGreen,
                              textColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                              child: Row(
                                children: <Widget>[
                                  Text("Mapa", style: locationOption),
                                  Icon(Icons.map, size: 33),
                                ],
                              ),
                              onPressed: () {
                                getLocationFromMap(context);
                              })
                          : SizedBox.shrink(),
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      (!_post.isSolution)
                          ? RaisedButton(
                              color: Colors.lightGreen,
                              textColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                              child: Row(
                                children: <Widget>[
                                  Text("Telefon", style: locationOption),
                                  Icon(Icons.location_searching, size: 33),
                                ],
                              ),
                              onPressed: () {
                                getLocationFromDevice();
                              })
                          : SizedBox.shrink(),
                    ],
                  ),
                ],
              ),
              ListTile(
                title: Text("Koordinate"),
                subtitle: Text(
                  (_pickedLocation != null)
                      ? _pickedLocation.latLng.toString()
                      : _post.latLng.toString(),
                ),
              ),
              ListTile(
                title: Text("Adresa"),
                subtitle: Text(
                  (_pickedLocation != null)
                      ? _pickedLocation.address.toString()
                      : _post.address,
                ),
              ),
            ],
          ),
        ),
      ),
      trailing: Icon(
        Icons.location_on,
        size: 30,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.0),
        child: AppBar(
          leading: BackButton(color: Colors.white),
          title: Text("Izmena objave", style: appBarTitle),
          shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.only(
                  bottomLeft: const Radius.elliptical(50, 50),
                  bottomRight: const Radius.elliptical(50, 50))),
          centerTitle: true,
          backgroundColor: Colors.lightGreen,
          elevation: 0,
          actions: <Widget>[
            Padding(
              padding: EdgeInsets.only(right: 8),
              child: IconButton(
                icon: Icon(
                  Icons.done,
                  color: Colors.white,
                ),
                onPressed: () async {
                  setState(() {
                    _isLoading = true;
                  });
                  bool updated = await updatePost();

                  if (updated) {
                    setState(() {
                      _isLoading = false;
                    });
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => HomePage()),
                        (route) => false);
                  }
                  else{
                    setState(() {
                    _isLoading = false;
                  });
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return SimpleDialog(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25)),
                          title: ListTile(
                            title: Text(
                              "Greska",
                              style: alertOption,
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(editPostFailed),
                            ),
                          ),
                          children: <Widget>[
                            SimpleDialogOption(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Row(children: <Widget>[
                                Icon(
                                  Icons.refresh,
                                  color: Colors.lightGreen,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("Pokušajte ponovo"),
                                ),
                              ]),
                            ),
                            SimpleDialogOption(
                              onPressed: () {
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => HomePage()),
                                    (route) => false);
                              },
                              child: Row(children: <Widget>[
                                Icon(
                                  Icons.home,
                                  color: Colors.lightGreen,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("Vratite se na početnu"),
                                ),
                              ]),
                            )
                          ],
                        );
                      });
                  }
                },
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            (_isLoading)
                    ? Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                        ),
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : SizedBox.shrink(),
            _descrtiption(context),
            _institutionsDropDown(),
            _location(),
          ],
        ),
      ),
    );
  }
}
