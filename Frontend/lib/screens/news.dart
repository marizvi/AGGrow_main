import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hackathon_app/Widget/loaders/loading_screen.dart';
import 'package:hackathon_app/Widget/news_element.dart';
import 'package:hackathon_app/providers/news_provider.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';

class News extends StatelessWidget {
  int? length;
  Future<void> _fecthAndUpdate(BuildContext context) async {
    final prov = Provider.of<NewsProvider>(context, listen: false);
    await prov.fetchAndUpdate();
    await prov.fetchBreaking();
    length = prov.len;
    print("printing news content: ");
    // print(length);
    // print(news.breakingNews);
    // print(news_content);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _fecthAndUpdate(context),
        builder: (context, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? LoadingScreen()
            : RefreshIndicator(
                onRefresh: () => _fecthAndUpdate(context),
                child: Consumer<NewsProvider>(builder: (context, news, _) {
                  return SingleChildScrollView(
                    physics: ScrollPhysics(),
                    child: Column(
                      children: [
                        // if (news.breakingNews != null)
                        InkWell(
                          onTap: () {
                            Navigator.of(context).pushNamed('/news_web',
                                arguments: news.breakingNews['url']);
                          },
                          child: Card(
                            color: Colors.black87,
                            child: Stack(
                              children: [
                                Container(
                                  height: 210,
                                  width: double.infinity,
                                  child: FadeInImage(
                                    placeholder:
                                        AssetImage('assets/images/place.png'),
                                    image: NetworkImage(news.breakingNews !=
                                            null
                                        ? news.breakingNews['image']
                                        : 'https://www.slntechnologies.com/wp-content/uploads/2017/08/ef3-placeholder-image.jpg'),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  width: 400,
                                  child: Column(
                                    children: [
                                      Container(
                                        color: Colors.black54,
                                        padding: EdgeInsets.all(8),
                                        child: Text(
                                          news.breakingNews['title'],
                                          maxLines: 3,
                                          // softWrap: true,
                                          overflow: TextOverflow.fade,
                                          style: GoogleFonts.ebGaramond(
                                              color: Colors.white,
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Container(
                                        // top: 100,
                                        color: Colors.black54,
                                        padding: EdgeInsets.only(bottom: 5),
                                        alignment: Alignment.bottomRight,
                                        width: double.infinity,
                                        // color: Colors.amber,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Icon(
                                              Icons.bookmark,
                                              color: Colors.grey[100],
                                            ),
                                            Text(
                                              news.breakingNews['source'],
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.sansita(
                                                  color: Colors.grey[100],
                                                  fontSize: 14),
                                            ),
                                            Spacer(),
                                            Text(
                                              Jiffy(DateTime.parse(
                                                      news.breakingNews[
                                                          'created_at']))
                                                  .fromNow(),
                                              style: GoogleFonts.sansita(
                                                  color: Colors.grey[100],
                                                  fontSize: 14),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: length,
                            itemBuilder: (context, index) => NewsElements(
                                  news.newsMap[index]['title'],
                                  news.newsMap[index]['source'],
                                  news.newsMap[index]['created_at'],
                                  news.newsMap[index]['url'],
                                  news.newsMap[index]['image'],
                                ))
                      ],
                    ),
                  );
                }),
              ));
  }
}
