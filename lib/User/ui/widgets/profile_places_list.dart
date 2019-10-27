import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:platzi_trips_app/User/bloc/bloc_user.dart';
import 'package:platzi_trips_app/User/model/user.dart';

class ProfilePlacesList extends StatelessWidget {
  UserBloc userBloc;
  User user;

  ProfilePlacesList( this.user);

  @override
  Widget build(BuildContext context) {
    userBloc = BlocProvider.of<UserBloc>(context);
    
    return Container(
      margin: EdgeInsets.only(
          top: 10.0,
          left: 20.0,
          right: 20.0,
          bottom: 10.0
      ),
      child: StreamBuilder(
        stream: userBloc.myPlacesListStream(user.uid),
        builder: (context, AsyncSnapshot snapshot){
          switch(snapshot.connectionState){
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator(),) ;
            case ConnectionState.done:
              return Column(
                  children: userBloc.buildMyPlaces(snapshot.data.documents),
              );

            case ConnectionState.active:
              return Column(
                  children: userBloc.buildMyPlaces(snapshot.data.documents),
              );

            case ConnectionState.none:
              return Center(child: CircularProgressIndicator(),) ;

            default:
              return Column(
                  children: userBloc.buildMyPlaces(snapshot.data.documents),
              );


          }
        }
      ),
      // child: Column(
      //   children: <Widget>[
      //     ProfilePlace(place),
      //     ProfilePlace(place2),
      //   ],
      // ),
    );
  }

}