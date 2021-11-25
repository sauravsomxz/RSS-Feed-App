import 'package:flutter/material.dart';
import 'package:webfeed/webfeed.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';

class RSSDemo extends StatefulWidget {
  const RSSDemo({Key? key}) : super(key: key);

  @override
  _RSSDemoState createState() => _RSSDemoState();
}

class _RSSDemoState extends State<RSSDemo> {

  /*
  Search Engine Journal - http://feeds.searchengineland.com/searchengineland =>Working
  Neil Patel - https://neilpatel.com/feed/   => Working
  Smart Blogger - https://smartblogger.com/blog/feed/   => Working
   */

  static const RSS_URl = "https://smartblogger.com/blog/feed/"; // Replace with the URL's blogs you need. URL above.
  static const String loadingFeedMsg = "LoadingFeed";
  static const String errorFeedMsg = "ErrorLoadingFeed";
  static const String errorFeedOpen = "ErrorLOpeningFeed";

  late GlobalKey<RefreshIndicatorState> _refreshKey;

  late RssFeed _feed;
  String? _title;

  updateTitle(title) {
    setState(() {
      _title = title;
    });
  }

  updateFeed(feed) {
    setState(() {
      _feed = feed;
    });
  }

  Future<void> openFeed(String url) async{
    if(await canLaunch(url)) {
      await launch(url, forceSafariVC: false, forceWebView: true);
      return;
    }
    updateTitle(errorFeedOpen);
  }

  load() async {
    updateTitle(loadingFeedMsg);
    loadFeed().then((result){
      if(null == result || result.toString().isEmpty) {
        updateTitle(errorFeedMsg);
        return;
      } else {
        updateFeed(result);
        updateTitle(_feed.title);
      }
    });
  }

  Future<RssFeed> loadFeed() async {
    try {
      final client = http.Client();
      final response = await client.get(Uri.parse(RSS_URl));

      return RssFeed.parse(response.body);
    }catch(e) {
      throw e.toString();
    }
  }

  title(title) {
    return Text(
      title,
    );
  }

  subTitle(subTitle) {
    return Text(
      subTitle,
    );
  }

  thumbnail(url) {
    return CachedNetworkImage(imageUrl: url);
  }

  rightIcon() {
    return const Icon(Icons.keyboard_arrow_right);
  }

  list() {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (BuildContext context, int index) {
        final item = _feed.items![index];
        return ListTile(
          title: title(item.title),
          subtitle: subTitle(item.description),
          trailing: rightIcon(),
          contentPadding: EdgeInsets.all(5.0),
          onTap: () => openFeed(item.link!),
        );
      },
    );
  }

  ifFeedEmpty() {
    return null == _feed.items;
  }

  body() {
    return ifFeedEmpty() ? const Center(child: CircularProgressIndicator(),
    ) : RefreshIndicator(child: list(), onRefresh: () => load(), key: _refreshKey,);
  }

  @override
  void initState() {
    super.initState();
    _refreshKey = GlobalKey<RefreshIndicatorState>();
    updateTitle(_title);
    load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(_title!),
      ),
      body: body(),
    );
  }
}
