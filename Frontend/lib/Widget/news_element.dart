import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';

class NewsElements extends StatelessWidget {
  String news_title;
  String website_url;
  String image_url;
  String date;
  String source;

  NewsElements(
    this.news_title,
    this.source,
    this.date,
    this.website_url,
    this.image_url,
  );
  @override
  Widget build(BuildContext context) {
    var dateString = DateFormat.MMMMEEEEd().format(DateTime.parse(date));
    var fromNow = Jiffy(DateTime.parse(date)).fromNow();
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed('/news_web', arguments: website_url);
      },
      child: Card(
        child: Row(children: [
          Container(
            margin: EdgeInsets.all(8),
            height: 120,
            width: 130,
            // color: Colors.amber,

            child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: FadeInImage(
                  placeholder: AssetImage('assets/images/place.png'),
                  image: NetworkImage(
                    image_url,
                  ),
                  fit: BoxFit.cover,
                )),
          ),
          SizedBox(
            width: 5,
          ),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 100,
                  width: 200,
                  child: Text(
                    news_title,
                    maxLines: 3,
                    // softWrap: true,
                    overflow: TextOverflow.fade,
                    style: GoogleFonts.ebGaramond(
                        fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  // top: 100,
                  alignment: Alignment.bottomRight,
                  width: double.infinity,
                  // color: Colors.amber,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Icons.bookmark),
                      Text(
                        source,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.sansita(
                            color: Colors.grey, fontSize: 12),
                      ),
                      Spacer(),
                      Icon(
                        Icons.timelapse_rounded,
                        color: Colors.grey,
                        size: 15,
                      ),
                      Flexible(
                        child: Text(
                          fromNow,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.sansita(
                              color: Colors.grey, fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
