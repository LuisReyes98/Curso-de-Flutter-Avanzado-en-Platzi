import 'dart:io';

import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:platzi_trips_app/Place/ui/screens/add_place_screen.dart';
import 'package:platzi_trips_app/User/bloc/bloc_user.dart';
import 'circle_button.dart';

class ButtonsBar extends StatelessWidget {
  UserBloc userBloc;

  @override
  Widget build(BuildContext context) {
    userBloc = BlocProvider.of(context);

    return Padding(
        padding: EdgeInsets.symmetric(
            horizontal: 0.0,
            vertical: 10.0
        ),
        child: Row(
          children: <Widget>[
            //Change password
            CircleButton(
              mini: true,
              icon: Icons.vpn_key,
              iconSize: 20.0,
              color: Color.fromRGBO(255, 255, 255, 0.6),onPressed: () => {} ),
            // Add new place
            CircleButton(
              mini: false,
              icon: Icons.add,
              iconSize: 40.0,
              color: Color.fromRGBO(255, 255, 255,1),
              onPressed: () async {
                File image;
                image = await ImagePicker.pickImage(source: ImageSource.camera);

                Navigator.push(context,
                MaterialPageRoute(
                  builder: (BuildContext context) => AddPlaceScreen(
                    image: image,)));
              }),
            // Close sesion SignOut
            CircleButton(
              mini: true,
              icon: Icons.exit_to_app,
              iconSize: 20.0,
              color: Color.fromRGBO(255, 255, 255, 0.6),
              onPressed: () => {
                userBloc.signOut()
              }),
          ],
        )
    );
  }

}