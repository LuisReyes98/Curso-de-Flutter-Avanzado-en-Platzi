import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:platzi_trips_app/Place/model/place.dart';
import 'package:platzi_trips_app/Place/ui/screens/title_input_location.dart';
import 'package:platzi_trips_app/Place/ui/widgets/card_image.dart';
import 'package:platzi_trips_app/User/bloc/bloc_user.dart';
import 'package:platzi_trips_app/widgets/button_purple.dart';
import 'package:platzi_trips_app/widgets/gradient_back.dart';
import 'package:platzi_trips_app/widgets/text_input.dart';
import 'package:platzi_trips_app/widgets/title_header.dart';


class AddPlaceScreen extends StatefulWidget {
  File image;
  bool isLoading = false;
  String dummyImagePath = "assets/img/mountain_stars.jpeg";

  AddPlaceScreen({
    Key key,
    this.image,
  });

  @override
  State<StatefulWidget> createState() {
    return _AddPlaceScreen();
  }
}

class _AddPlaceScreen extends State<AddPlaceScreen> {


  @override
  Widget build(BuildContext context) {

    UserBloc userBloc = BlocProvider.of<UserBloc>(context);

    final _controllerTitlePlace = TextEditingController();
    final _controllerDescriptionPlace = TextEditingController();
    final _controllerLocationPlace = TextEditingController();

    void upload() {
      //ID del usuario logeado actualmente
        userBloc.currentUser.then((FirebaseUser user){
          if (user != null) {
            String uid = user.uid;
            String path = "$uid/${DateTime.now().toString()}.jpg";
            //1. Firebase Storage
            //url
            userBloc.uploadFile(path, widget.image)
              .then((StorageUploadTask storageUploadTask){
                storageUploadTask.onComplete.then((StorageTaskSnapshot  snapshot){
                  snapshot.ref.getDownloadURL().then((urlImage){
                    print("URL_IMAGE: $urlImage");

                    //2. Cloud Firestore
                    // Place - title, description, url, userOwner, likes

                    userBloc.updatePlaceData(Place(
                      name: _controllerTitlePlace.text,
                      description: _controllerDescriptionPlace.text,
                      likes: 0,
                      urlImage: urlImage,
                    )).whenComplete((){
                      print("Termino");
                      Navigator.pop(context);
                    });
                });
              });
            });
          }  // fin if user
        });

    }

    GradientBack gradient = GradientBack(
            height: 300.0,);

    Row header = Row(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only( top: 25.0, left: 5.0),
                child: SizedBox(
                  height: 45.0,
                  width: 45.0,
                  child: IconButton(
                    icon: Icon(
                      Icons.keyboard_arrow_left,
                      color: Colors.white,
                      size: 45,
                      ),
                    onPressed: (){
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),
              Flexible(
                child: Container(
                  padding: EdgeInsets.only(top:  45.0, left: 20.0, right: 10.0 ),
                  child: TitleHeader(title: "Add a new Place"),
                ),
              )
              ],
            );
    Center loaderUI = Center(
              child: widget.isLoading ? CircularProgressIndicator() : Container(),
            );

    Container form = Container(
              margin: EdgeInsets.only(top: 120.0, bottom: 20.0),
              child: ListView(
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(bottom: 20.0),
                    child: CardImageFabIcon(
                      internet: false,
                      width: 300.0,
                      height: 250.0,
                      marginLeft: 0.0,
                      pathImage: widget.image == null ? widget.dummyImagePath : widget.image.path,
                      iconData: Icons.camera_alt,
                      onPressedFabIcon: () async {

                        File _image;
                        _image = await ImagePicker.pickImage(source: ImageSource.camera);
                        setState(() {
                          widget.image = _image;
                        });
                      },

                    ),
                  ),//Foto
                  Container(
                    margin: EdgeInsets.only(bottom: 20.0),
                    child: TextInput(
                      hintText: "Title",
                      inputType: null,
                      maxLines: 1,
                      controller: _controllerTitlePlace,
                    ),
                  ),
                  TextInput(
                    hintText: "Description",
                    inputType: TextInputType.multiline,
                    maxLines: 4,
                    controller: _controllerDescriptionPlace,
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20.0),
                    child: TextInputLocation(
                      hintText: "Add Location",
                      iconData: Icons.location_on,
                      controller: _controllerLocationPlace,
                    ),
                  ),
                  Container(
                    width: 70.0,
                    child: ButtonPurple(
                      buttonText: "Add Place",
                      onPressed: (){
                        // FocusScope.of(context).requestFocus(new FocusNode());
                        print("Click boton subir");
                        if (!widget.isLoading) {
                          print("Subiendo");
                          upload();
                          setState(() {
                            widget.isLoading = true;
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
            );

    return Scaffold(
      body: Stack(
        children: <Widget>[
          gradient,
          header,
          form,
          loaderUI
        ],
      ),
    );
  }
  
}