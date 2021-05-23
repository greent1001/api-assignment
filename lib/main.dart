import 'package:projectapi/api/api_call.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'model/topnews_model.dart';


void main() {
  runApp(TopNewsAssignment());
}

class TopNewsAssignment extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FirstPage(),
    );
  }
}

class FirstPage extends StatefulWidget {
  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  final news = ApiCallClass().getNews();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder<List<Article>>(
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text(snapshot.data.toString()));
            }
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) => ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(
                        snapshot.data[index].urlToImage == null
                            ? ""
                            : snapshot.data[index].urlToImage),
                  ),
                  title: Text(snapshot.data[index].title == null
                      ? ""
                      : snapshot.data[index].title),
                  subtitle: Text(snapshot.data[index].author == null
                      ? ""
                      : snapshot.data[index].author),
                  trailing: IconButton(
                    icon: Icon(Icons.launch),
                    onPressed: () async {
                      await canLaunch(snapshot.data[index].url)
                          ? launch(snapshot.data[index].url)
                          : throw "Can't launch ${snapshot.data[index].url}";
                    },
                  ),
                ),
              );
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          },
          future: news,
        ));
  }
}


class TopNews {
  String status;
  int totalResults;
  List<Articles> articles;

  TopNews({this.status, this.totalResults, this.articles});

  TopNews.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    totalResults = json['totalResults'];
    if (json['articles'] != null) {
      // ignore: deprecated_member_use
      articles = <Articles>[];
      json['articles'].forEach((v) {
        articles.add(new Articles.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['totalResults'] = this.totalResults;
    if (this.articles != null) {
      data['articles'] = this.articles.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Articles {
  Source source;
  String author;
  String title;
  String description;
  String url;
  String urlToImage;
  String publishedAt;
  String content;

  Articles(
      {this.source,
        this.author,
        this.title,
        this.description,
        this.url,
        this.urlToImage,
        this.publishedAt,
        this.content});

  Articles.fromJson(Map<String, dynamic> json) {
    source =
    json['source'] != null ? new Source.fromJson(json['source']) : null;
    author = json['author'];
    title = json['title'];
    description = json['description'];
    url = json['url'];
    urlToImage = json['urlToImage'];
    publishedAt = json['publishedAt'];
    content = json['content'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.source != null) {
      data['source'] = this.source.toJson();
    }
    data['author'] = this.author;
    data['title'] = this.title;
    data['description'] = this.description;
    data['url'] = this.url;
    data['urlToImage'] = this.urlToImage;
    data['publishedAt'] = this.publishedAt;
    data['content'] = this.content;
    return data;
  }
}

class Source {
  String id;
  String name;

  Source({this.id, this.name});

  Source.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}