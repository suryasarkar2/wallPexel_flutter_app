import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:wallpaperstore/model/wallpaper_model.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:wallpaperstore/views/image_view.dart';

const style = TextStyle(fontFamily: 'Comfortaa');
Widget brandName() {
//  return RichText(
//    text: TextSpan(
//      style: TextStyle(
//          fontSize: 16.0,
//          fontFamily: 'Comfortaa',
//          color: Colors.black87,
//          fontWeight: FontWeight.w500),
//      children: <TextSpan>[
//        TextSpan(
//          text: 'Wallpaper',
//          style: TextStyle(
//            fontFamily: 'Comfortaa',
//            color: Colors.black87,
//          ),
//        ),
//        TextSpan(
//          text: 'Store',
//          style: TextStyle(
//              fontFamily: 'Comfortaa',
//              color: Colors.pink,
//              fontWeight: FontWeight.bold),
//        ),
//      ],
//    ),
//  );
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Text(
        'Wall',
        style: TextStyle(
          fontFamily: 'Dawning',
          color: Colors.black87,
          fontWeight: FontWeight.w600,
          fontSize: 20.0,
        ),
      ),
      Text(
        'Pexel',
        style: TextStyle(
            fontFamily: 'Comfortaa',
            color: Colors.pink,
            fontSize: 18.0,
            fontWeight: FontWeight.bold),
      ),
    ],
  );
}

Widget wallpapersList({List<WallpaperModel> wallpapers, context}) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 16),
    child: StaggeredGridView.countBuilder(
      physics: ClampingScrollPhysics(),
      scrollDirection: Axis.vertical,
      crossAxisCount: 4,
      mainAxisSpacing: 8.0,
      crossAxisSpacing: 8.0,
      shrinkWrap: true,
//      children: wallpapers.map((wallpaper) {
//        String imgPath = wallpaper.src.portrait;
//        return Material(
//          elevation: 8.0,
//          borderRadius: new BorderRadius.all(new Radius.circular(8.0)),
//          child: InkWell(
//            child: Hero(
//              tag: imgPath,
//              child: Image(
//                image: NetworkImage(imgPath),
//                fit: BoxFit.cover,
//              ),
//            ),
//          ),
//        );
//      }).toList(),
      itemCount: wallpapers.length,
      itemBuilder: (context, i) {
        String imgPath = wallpapers[i].src.portrait;
        return new Material(
          elevation: 10.0,
          borderRadius: new BorderRadius.all(new Radius.circular(10.0)),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ImageView(
                      imgUrl: imgPath,
                      photographer: wallpapers[i].photographer,
                      photographerUrl: wallpapers[i].photographer_url,
                    ),
                  ));
            },
            child: Hero(
              tag: imgPath,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: CachedNetworkImage(
                    imageUrl: imgPath,
                    placeholder: (context, url) => Container(
                          color: Color(0xfff5f8fd),
                        ),
                    fit: BoxFit.cover),
              ),
            ),
          ),
        );
      },
      staggeredTileBuilder: (i) => StaggeredTile.count(2, i.isEven ? 2 : 3),
    ),
  );
}
