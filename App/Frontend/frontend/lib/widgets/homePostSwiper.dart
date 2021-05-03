import 'package:Frontend/models/post.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

import 'map.dart';

class HomePostSwiper extends StatelessWidget {
  const HomePostSwiper({
    Key key,
    @required Post post,
    @required this.images,
  }) : _post = post, super(key: key);

  final Post _post;
  final List<String> images;

   Future<void> _showMap(context) async {
    List<Post> list = List<Post>();
    list.add(_post);
    await showModalBottomSheet<void>(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return Map(MapSize.small, list);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height * 0.40,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(8.0),
            bottomRight: Radius.circular(8.0),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey[300],
              blurRadius: 5.0,
            ),
          ],
        ),
        child: GestureDetector(
          onDoubleTap: () => print(_post.isLiked.toString()),
          onLongPress: () => _showMap(context),
          child: Swiper(
            itemCount: images == null ? 0 : images.length,
            itemBuilder: (ctx, i) {
              return Image.network(images[i], fit: BoxFit.cover);
            },
            pagination: SwiperPagination(
              builder: SwiperPagination.dots,
            ),
            control: null,
          ),
        ));
  }
}