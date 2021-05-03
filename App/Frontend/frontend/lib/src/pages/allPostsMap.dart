import 'package:Frontend/commons/theme.dart';
import 'package:Frontend/config/config.dart';
import 'package:Frontend/services/mapServices.dart';
import 'package:Frontend/services/userServices.dart';
import 'package:Frontend/models/post.dart';
import 'package:Frontend/models/user.dart';
import 'package:Frontend/services/postServices.dart';
import 'package:Frontend/src/pages/camera.dart';
import 'package:Frontend/src/pages/gallery.dart';
import 'package:Frontend/src/pages/prehome.dart';
import 'package:Frontend/src/pages/profilePage.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class AllPostsMap extends StatefulWidget {
  @override
  _AllPostsMapState createState() => _AllPostsMapState();
}

class _AllPostsMapState extends State<AllPostsMap> {
  List<Post> _posts;
  Map<int, List<Image>> _images = Map<int, List<Image>>();
  LatLng _coords;
  List<Marker> _markers = List<Marker>();
  User _user;
  GlobalKey _bottomNavigationKey = GlobalKey();

  void loadImages(context) {
    if (_posts != null) {
      for (var post in _posts) {
        List<Image> images = List<Image>();
        for (var imgUrl in post.imgUrl)
          images.add(Image.network(
            postImageURL + imgUrl,
            fit: BoxFit.cover,
          ));
        _images[post.id] = images;
      }
    }
  }

  Future<void> init(User user) async {
    var response = await PostServices.getPosts(_user.token);
    var coords = await MapServices.getCityLatLng(user.city);

    for (var post in response) {
      var marker = Marker(
          markerId: MarkerId(post.id.toString()),
          position: MapServices.getLatLng(post.latLng),
          infoWindow: InfoWindow(
            title: post.description,
          ),
          onTap: () {
            _showSelectedPost(post, context);
          });

      _markers.add(marker);
    }

    setState(() {
      _posts = response;
      _coords = coords;
    });

    loadImages(context);
  }

  @override
  void initState() {
    super.initState();
    _user = Provider.of<UserService>(context, listen: false).user;
    init(_user);
  }

  void _showSelectedPost(Post post, BuildContext context) async {
    await showModalBottomSheet<void>(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return Container(
            margin: EdgeInsets.all(15),
            width: MediaQuery.of(context).size.width * 0.65,
            height: MediaQuery.of(context).size.height * 0.35,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: GestureDetector(
                child: Swiper(
                  itemCount: post == null ? 0 : _images[post.id].length,
                  itemBuilder: (ctx, i) {
                    return _images[post.id][i];
                  },
                  pagination:
                      new SwiperPagination(builder: SwiperPagination.dots),
                  control: null,
                ),
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: _customNavBar(),      
      body: _posts == null
          ? Center(child: CircularProgressIndicator())
          : GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: CameraPosition(
                target: _coords,
                zoom: 12,
              ),
              markers: Set<Marker>.of(_markers),
              mapToolbarEnabled: true,
              compassEnabled: true,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
            ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          "Mapa objava",
          style: appBarTitle,
        ),
        shape: RoundedRectangleBorder(
        borderRadius: new BorderRadius.only(
        bottomLeft:  const  Radius.elliptical(50, 50),
        bottomRight: const  Radius.elliptical(50, 50))
      ),
      ),
      /*floatingActionButton: FloatingActionButton(
        onPressed: () => _showBottomSheet(context),
        child: Icon(
          Icons.photo_library,
          color: Colors.white,
        ),
      ),*/
    );
  }

  Alert _alert(){
    return Alert(
      context: context,
      style: AlertStyle(
        titleStyle: alertTitle,
        isCloseButton: false,
      ),
      title: "Dodajte fotografiju",
      buttons: [
        DialogButton(
          height: 140.0,
          child: Icon(
            Icons.camera_alt,
            size: 100.0,
            color: Colors.lightGreen,
          ),
          color: Colors.white,
          onPressed: () => Navigator.push(
            context, MaterialPageRoute(builder: (context) => Camera(PostType.POST))),
          width: 120,
        ),
        DialogButton(
          height: 140.0,
          child: Icon(
            Icons.insert_drive_file,
            size: 100.0,
            color: Colors.lightGreen,
          ),
          color: Colors.white,
          onPressed: () => Navigator.push(
            context, MaterialPageRoute(builder: (context) => Gallery(PostType.POST))),
          width: 120,
        )
      ],
    );
  }

  Widget _customNavBar(){
    Alert alert = _alert();
    return CurvedNavigationBar(
      key: _bottomNavigationKey,
      backgroundColor: Colors.lightGreen,
      index: 2,
      height: 50.0,
      items: <Widget>[
        Icon(Icons.home, size: 30),
        Icon(Icons.camera, size: 30),
        Icon(Icons.map, size: 30),
        Icon(Icons.person, size: 30)
        ],
        buttonBackgroundColor: Colors.white,
        animationCurve: Curves.easeInOut,
        animationDuration: Duration(milliseconds: 600),
      onTap: (index) {
        if(index == 0){
          Navigator.push(context,
            MaterialPageRoute(builder: (context) => HomePage()));
        }
        else if(index == 1){
          alert.show();
        }
        else if(index == 2) {
          Navigator.push(context,
            MaterialPageRoute(builder: (context) => AllPostsMap()));
        }
        else {
          Navigator.push(context,
            MaterialPageRoute(builder: (context) => ProfilePage(username: _user.username,)));
        }
      },
    );
  }
}
