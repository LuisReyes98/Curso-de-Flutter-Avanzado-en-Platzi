import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:platzi_trips_app/User/bloc/bloc_user.dart';
import 'package:platzi_trips_app/User/model/user.dart';
import 'package:platzi_trips_app/platzi_trips_cupertino.dart';
import 'package:platzi_trips_app/widgets/gradient_back.dart';
import 'package:platzi_trips_app/widgets/button_green.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignInScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _SignInScreen();
  }
}

class _SignInScreen extends State<SignInScreen> {
  UserBloc userBloc;
  double screenWidth;
  bool isLoading = false;


  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;//ancho de la pantalla
    userBloc = BlocProvider.of(context);

    return _handleCurrentSesion();
  }

  Widget _handleCurrentSesion(){
    return StreamBuilder(
      stream: userBloc.authStatus,
      builder: (BuildContext context, AsyncSnapshot snapshot){
        //snapshot - data - Object User
        if(!snapshot.hasData || snapshot.hasError){
          return signInGoogleUI();
        }else{
          return PlatziTripsCupertino();
        }
      },
    );
  }

  Widget _loadingView() {
    return new Center(
      child: new CircularProgressIndicator(),
    );
  }

  Widget signInGoogleUI(){    
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          GradientBack(
            height: null,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Flexible(
                child: Container(
                  width: screenWidth,
                  child: Text(
                    "Welcome \n This is your travel App",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 37.0,
                      fontFamily: "Lato",
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              ButtonGreen(
                text: "Login with Gmail",
                onPressed: (){
                  isLoading = true;
                  userBloc.signOut();
                  userBloc.signIn().then((FirebaseUser user) {

                    userBloc.updateUserData(User(
                      uid: user.uid,
                      name: user.displayName,
                      email: user.email,
                      photoURL: user.photoUrl,
                    ));
                    isLoading = false;
                  });
                  // isLoading = false;

                },
                width: 300.0,
                height: 50.0,
              )
            ],
          ),
          Center(
            child: isLoading ? CircularProgressIndicator(
              strokeWidth: 8.0,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blueGrey)
            ) : Container(),
          )
        ],
      ),
    );
  }

}

