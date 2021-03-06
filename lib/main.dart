import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:web_scraper/web_scraper.dart';

void main() => runApp(WebScraperApp());

class WebScraperApp extends StatefulWidget {
  @override
  _WebScraperAppState createState() => _WebScraperAppState();
}

class _WebScraperAppState extends State<WebScraperApp> {
  // initialize WebScraper by passing base url of website
  final webScraper = WebScraper('https://webscraper.io');

  // Response of getElement is always List<Map<String, dynamic>>
  List<Map<String, dynamic>>? productNames;
  List<Map<String, dynamic>>? productPrices;
  List<Map<String, dynamic>>? productImages;
  late List<Map<String, dynamic>> productDescriptions;

  void fetchProducts() async {

    // Loads web page and downloads into local state of library
    if (await webScraper
        .loadWebPage('/test-sites/e-commerce/allinone/computers/laptops')) {
      setState(() {
        // getElement takes the address of html tag/element and attributes you want to scrap from website
        // it will return the attributes in the same order passed
        productNames = webScraper.getElement(
            'div.thumbnail > div.caption > h4 > a.title', ['href', 'title']);
        productPrices = webScraper.getElement(
            'div.thumbnail > div.caption >h4',  ['href', 'title']);
        productImages = webScraper.getElement('div.thumbnail > img ',['src','src']);
        productDescriptions = webScraper.getElement(
            'div.thumbnail > div.caption > p.description', ['class']);
      });
      print("${productImages![0]['attributes']['src']}");
    }
  }

  @override
  void initState() {
    super.initState();
    // Requesting to fetch before UI drawing starts
    fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fetch Data Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
          appBar: AppBar(
            title: Text('Product Catalog'),
          ),
          body: SafeArea(
              child: productNames == null
                  ? Center(
                child:
                CircularProgressIndicator(), // Loads Circular Loading Animation
              )
                  : ListView.builder(
                  itemCount: productNames!.length,
                  itemBuilder: (BuildContext context, int index) {
                    // Attributes are in the form of List<Map<String, dynamic>>.
                    Map<String, dynamic> attributes =
                    productNames![index]['attributes'];
                    return ExpansionTile(
                      title: Text("${attributes['title']}Price:: ${productPrices![index]['title']}"),
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            children: <Widget>[
                              Container(
                                child: Text(
                                    "${productDescriptions[index]['title']} "),
                                margin: EdgeInsets.only(bottom: 10.0),
                              ),
                                Image.network("https://webscraper.io${productImages![index]['attributes']['src']}"),
                              InkWell(
                                onTap: () {
                                  // uses UI Launcher to launch in web browser & minor tweaks to generate url
                                  launch(webScraper.baseUrl! +
                                      attributes['href']);
                                },
                                child: Text(
                                  'View Product',
                                  style: TextStyle(color: Colors.blue),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    );
                  }))),
    );
  }
}