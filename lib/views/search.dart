import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wallpaperstore/data/data.dart';
import 'package:wallpaperstore/model/categories_model.dart';
import 'package:wallpaperstore/model/wallpaper_model.dart';
import 'package:wallpaperstore/widget/widget.dart';
import 'package:http/http.dart' as http;

class Search extends StatefulWidget {
  final String searchQuery;
  Search({this.searchQuery});

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  int pageNumber = 1;
  int noOfImageToLoad = 30;
  List<CategoriesModel> categories = List();

  List<WallpaperModel> wallpapers = List();

  TextEditingController searchController1 = new TextEditingController();

  ScrollController _scrollController = new ScrollController();

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
  void initState() {
    super.initState();
    getSearchWallpapers(widget.searchQuery);
    searchController1.text = widget.searchQuery;

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        noOfImageToLoad = noOfImageToLoad + 30;
        pageNumber += 1;
        getSearchWallpapers(searchController1.text);
      }
    });
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
              Container(
                decoration: BoxDecoration(
                  color: Color(0xFFF5F8FD),
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                margin: EdgeInsets.symmetric(horizontal: 24.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: searchController1,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "search wallpapers",
                          hintStyle: TextStyle(fontFamily: 'Comfortaa'),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        getSearchWallpapers(searchController1.text);
//                        initState();
//                        (context as Element).reassemble();
                      },
                      child: Container(
                        child: Icon(Icons.search),
                      ),
                    ),
                  ],
                ),
              ),
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
      ),
    );
  }
}
