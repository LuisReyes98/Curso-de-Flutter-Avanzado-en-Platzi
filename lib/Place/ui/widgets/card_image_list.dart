import 'package:flutter/material.dart';
import 'card_image.dart';

class CardImageList extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350.0,
      child: ListView(
        padding: EdgeInsets.all(25.0),
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          CardImageFabIcon(
            width: 350.0,
            height: 250.0,
            onPressedFabIcon: (){},
            iconData: Icons.favorite_border,
            marginLeft: 20.0,
            pathImage:"assets/img/beach_palm.jpeg"),
          CardImageFabIcon(
            width: 350.0,
            height: 250.0,
            onPressedFabIcon: (){},
            iconData: Icons.favorite_border,
            marginLeft: 20.0,
            pathImage:"assets/img/mountain.jpeg"),
          CardImageFabIcon(
            width: 350.0,
            height: 250.0,
            onPressedFabIcon: (){

            },
            iconData: Icons.favorite_border,
            marginLeft: 20.0,
            pathImage:"assets/img/mountain_stars.jpeg"),
          CardImageFabIcon(
            width: 350.0,
            height: 250.0,
            onPressedFabIcon: (){},
            iconData: Icons.favorite_border,
            marginLeft: 20.0,
            pathImage:"assets/img/river.jpeg"),
          CardImageFabIcon(
            width: 350.0,
            height: 250.0,
            onPressedFabIcon: (){},
            iconData: Icons.favorite_border,
            marginLeft: 20.0,
            pathImage:"assets/img/sunset.jpeg"),
        ],
      ),
    );
  }

}