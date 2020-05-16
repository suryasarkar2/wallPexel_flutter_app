import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wallpaperstore/data/data.dart';
import 'package:wallpaperstore/model/categories_model.dart';
import 'package:wallpaperstore/model/wallpaper_model.dart';
import 'package:wallpaperstore/views/category.dart';
import 'package:wallpaperstore/views/image_view.dart';
import 'package:wallpaperstore/views/search.dart';
import 'package:wallpaperstore/widget/widget.dart';
import 'package:wallpaperstore/data/data.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int noOfImageToLoad = 50;

  int pageNumber = 1;
  List<CategoriesModel> categories = List();

  List<WallpaperModel> wallpapers = List();

  TextEditingController searchController = new TextEditingController();

  ScrollController _scrollController = new ScrollController();

  getTrendingWallpapers() async {
//    wallpapers.toSet().toSet();
    String url =
        "https://api.pexels.com/v1/curated?per_page=$noOfImageToLoad&page=$pageNumber";

    var response = await http.get(url, headers: {"Authorization": API_KEY});
    Map<String, dynamic> jsonData = jsonDecode(response.body);
//    print(response.body.toString());
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
    categories = getCategories();
    getTrendingWallpapers();
    pageNumber = 1;

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        noOfImageToLoad = noOfImageToLoad + 30;
        pageNumber += 1;
        getTrendingWallpapers();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: brandName(),
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
//        physics: ClampingScrollPhysics(),
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
                        controller: searchController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "search wallpapers",
                          hintStyle: TextStyle(fontFamily: 'Comfortaa'),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => Search(
                                searchQuery: searchController.text,
                              ),
                            ));
                      },
                      child: Container(
                        child: Icon(Icons.search),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Made with ❤️ by ',
                    style: TextStyle(
                      fontFamily: 'Comfortaa',
                      color: Colors.black87,
                      fontSize: 12.0,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      _launchURL('https://www.linkedin.com/in/surya-sarkar/');
                    },
                    child: Text(
                      'Surya Sarkar',
                      style: TextStyle(
                        fontFamily: 'Comfortaa',
                        color: Colors.pink,
                        fontWeight: FontWeight.bold,
                        fontSize: 12.0,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 15.0,
              ),
              Container(
                height: 80.0,
                child: ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    itemCount: categories.length,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, i) {
                      return CategoriesTile(
                        title: categories[i].categorieName,
                        imgUrl: categories[i].imgUrl,
                      );
                    }),
              ),
              SizedBox(
                height: 15.0,
              ),
              wallpapersList(wallpapers: wallpapers, context: context),
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
                    )),
                  ),
                  SizedBox(
                    height: 24,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CategoriesTile extends StatelessWidget {
  CategoriesTile({@required this.title, @required this.imgUrl});
  final String imgUrl, title;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) => Category(
                categoryName: title.toLowerCase(),
              ),
            ));
      },
      child: Container(
        margin: EdgeInsets.only(right: 6.0),
        child: Stack(
          children: <Widget>[
            ClipRRect(
              child: Image.network(
                imgUrl,
                height: 50,
                width: 100,
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                color: Colors.black26,
                height: 50,
                width: 100,
                alignment: Alignment.center,
                child: Text(
                  title,
                  style: style.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 15.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
