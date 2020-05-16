import 'dart:io';
import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

class ImageView extends StatefulWidget {
  final String imgUrl;
  final String photographer;
  final String photographerUrl;

  ImageView(
      {@required this.imgUrl,
      @required this.photographer,
      @required this.photographerUrl});
  @override
  _ImageViewState createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
  String home = "Home Screen",
      lock = "Lock Screen",
      both = "Both Screen",
      system = "System";

  Stream<String> progressString;
  String res;
  bool downloading = false;
  var result = "Waiting to set wallpaper";

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Hero(
            tag: widget.imgUrl,
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: CachedNetworkImage(
                  imageUrl: widget.imgUrl,
                  placeholder: (context, url) => Container(
                        color: Color(0xfff5f8fd),
                      ),
                  fit: BoxFit.cover),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                InkWell(
                  onTap: () {
                    _save();
                  },
                  child: Stack(
                    children: <Widget>[
                      Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width / 2,
//                        color: Color(0xFF1C1B1B).withOpacity(0.8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: Colors.white54,
                            width: 1,
                          ),
//                          color: Color(0xFF1C1B1B).withOpacity(0.8),
                          gradient: LinearGradient(
                            colors: [
                              Color(0xFF1C1B1B),
                              Color(0x001C1B1B),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 2,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.white54,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(30),
                          gradient: LinearGradient(
                            colors: [
                              Color(0x36FFFFFF),
                              Color(0x0FFFFFFF),
                            ],
                          ),
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                        child: Column(
                          children: <Widget>[
                            Text(
                              'Save Wallpaper',
                              style: TextStyle(
                                fontSize: 15.0,
                                color: Colors.white70,
                                fontFamily: 'Comfortaa',
                              ),
                            ),
                            SizedBox(
                              height: 3.0,
                            ),
                            Text(
                              'Image will be saved in gallery',
                              style: TextStyle(
                                color: Colors.white70,
                                fontFamily: 'Comfortaa',
                                fontSize: 10.0,
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 15.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Shot by ',
                      style: TextStyle(
                        color: Colors.black54,
                        fontFamily: 'Comfortaa',
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        _launchURL(widget.photographerUrl);
                      },
                      child: Text(
                        widget.photographer,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Comfortaa',
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 15.0,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Back',
                    style: TextStyle(
                      color: Colors.white70,
                      fontFamily: 'Comfortaa',
                    ),
                  ),
                ),
                SizedBox(
                  height: 50.0,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _save() async {
    if (Platform.isAndroid) {
      await _askPermission();
    }
    var response = await Dio().get(
      widget.imgUrl,
      options: Options(
        responseType: ResponseType.bytes,
      ),
    );
    final result =
        await ImageGallerySaver.saveImage(Uint8List.fromList(response.data));
    print(result);
    Navigator.pop(context);
  }

  _askPermission() async {
//      /* PermissionStatus permission = */ await PermissionHandler()
//          .checkPermissionStatus(PermissionGroup.storage);
    if (await Permission.storage.request().isGranted) {
      // Either the permission was already granted before or the user just granted it.
    }
    await Permission.storage.shouldShowRequestRationale;
  }
}
