import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hackathon_app/providers/category_policy.dart';
import 'package:provider/provider.dart';

class SchemeDetail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final routes =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    var id = routes['id'];
    var cid = routes['cid'];
    final content = Provider.of<Policies>(context)
        .findContent(id.toString(), cid.toString());
    return Scaffold(
      appBar: AppBar(
        elevation: 0.8,
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: Text('Policies'),
      ),
      body: Container(
        margin: EdgeInsets.all(8),
        padding: EdgeInsets.all(8),
        child: Column(
          children: [
            Text(
              content['title'].toString(),
              textAlign: TextAlign.center,
              style: GoogleFonts.gideonRoman(
                  color: Colors.black,
                  fontSize: 22,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(8)),
              child: Text(
                content['desc'].toString(),
                style: GoogleFonts.dmSans(fontSize: 18),
              ),
            ),
            SizedBox(
              height: 18,
            ),
            if (content['url'] != '')
              TextButton.icon(
                onPressed: () {
                  Navigator.of(context)
                      .pushNamed('/news_web', arguments: content['url']);
                },
                icon: Icon(Icons.info_rounded),
                label: Text('Click for more Details'),
              )
          ],
        ),
      ),
    );
  }
}
