import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class Carousel extends StatelessWidget {
  final List _source;
  Carousel(this._source);
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        color: Colors.white,
        height: 210,
        child: CarouselSlider(
          options: CarouselOptions(
              autoPlayCurve: Curves.fastOutSlowIn,
              height: 195,
              autoPlay: true,
              enlargeCenterPage: true),
          items: _source.map((i) {
            return Container(
              width: MediaQuery.of(context).size.width,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  i as String,
                  fit: BoxFit.cover,
                ),
              ),
            );
          }).toList(),
        ));
  }
}
