import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wallpaperstore/data/data.dart';
import 'package:http/http.dart' as http;
import 'package:wallpaperstore/model/wallpaper_model.dart';
import 'package:wallpaperstore/widget/widget.dart';

class Category extends StatefulWidget {
  final String categoryName;
  Category({this.categoryName});

  @override
  _CategoryState createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  List<WallpaperModel> wallpapers = List();
  ScrollController _scrollController = new ScrollController();
  int pageNumber = 1;
  int noOfImageToLoad = 30;
  @override
  void initState() {
    super.initState();
    getSearchWallpapers(widget.categoryName);

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        noOfImageToLoad = noOfImageToLoad + 30;
        pageNumber += 1;
        getSearchWallpapers(widget.categoryName);
      }
    });
  }

  getSearchWallpapers(String query) async {
    String url =
        "https://api.pexels.com/v1/search?query=$query&per_page=$noOfImageToLoad&page=$pageNumber";
    var response = await http.get(url, headers: {"Authorization": API_KEY});
    Map<String, dynamic> jsonData = jsonDecode(response.body);
    jsonData['photos'].forEach((element) {
      WallpaperModel wallpaperModel = new WallpaperModel();
      wallpaperModel = WallpaperModel.fromMap(element);
      wallpapers.add(wallpaperModel);
    });

    setState(() {});
  }

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
        appBar: AppBar(
          title: brandName(),
          centerTitle: true,
          elevation: 0.0,
        ),
        body: SingleChildScrollView(
          controller: _scrollController,
          child: Container(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 24,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Photos provided By ",
                      style: TextStyle(
                          color: Colors.black54,
                          fontSize: 12,
                          fontFamily: 'Comfortaa'),
                    ),
                    GestureDetector(
                      onTap: () {
                        _launchURL("https://www.pexels.com/");
                      },
                      child: Container(
                        child: Text(
                          "Pexels",
                          style: TextStyle(
                              color: Colors.pink,
                              fontSize: 12,
                              fontFamily: 'Comfortaa'),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 24,
                ),
                wallpapersList(wallpapers: wallpapers, context: context),
              ],
            ),
          ),
        ));
  }
}
