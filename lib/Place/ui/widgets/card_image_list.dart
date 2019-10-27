import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:platzi_trips_app/Place/model/place.dart';
import 'package:platzi_trips_app/User/bloc/bloc_user.dart';
import 'package:platzi_trips_app/User/model/user.dart';
import 'card_image.dart';

class CardImageList extends StatefulWidget {
  final User user;

  CardImageList(this.user);

  @override
  State<StatefulWidget> createState() {
    return _CardImageList();
  }

}

UserBloc userBloc;

class _CardImageList extends State<CardImageList> {

  @override
  Widget build(BuildContext context) {
    userBloc = BlocProvider.of<UserBloc>(context);

    return Container(
      height: 350.0,
      child: StreamBuilder(
        stream: userBloc.placesStream,
        builder: (context, AsyncSnapshot snapshot){
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            return CircularProgressIndicator();
            break;
          case ConnectionState.none:
            return CircularProgressIndicator();

            break;
          case ConnectionState.active:

            return listViewPlaces(userBloc.buildPlaces(
              snapshot.data.documents,
              widget.user
            ));
            break;
          case ConnectionState.done:

            return listViewPlaces(userBloc.buildPlaces(
              snapshot.data.documents,
              widget.user
            ));

            break;

          default:
            return CircularProgressIndicator();
            break;
          }
        },
      ),

    );
  }


  Widget listViewPlaces(List<Place> places){

    void setLiked(Place place){
      setState(() {
        place.liked = !place.liked;
        userBloc.likePlace(place, widget.user.uid);
        place.likes = place.liked?place.likes+1:place.likes-1;
        userBloc.placeSelectedSink.add(place);
      });
    }

    IconData iconDataLiked = Icons.favorite;
    IconData iconDataLike = Icons.favorite_border;

    return ListView(
      padding: EdgeInsets.all(25.0),
      scrollDirection: Axis.horizontal,
      children: places.map((place){
        return GestureDetector(
          onTap: (){
            print("CLICK PLACE: ${place.name}");
            userBloc.placeSelectedSink.add(place);
          },
          child:CardImageFabIcon(
            pathImage: place.urlImage,
            width: 300.0,
            height: 250.0,
            marginLeft: 20.0,
            iconData: place.liked ? iconDataLiked : iconDataLike,
            onPressedFabIcon: (){
              setLiked(place);
            },
            internet: true,
          ),
        );
      }).toList(),
    );
  }
}