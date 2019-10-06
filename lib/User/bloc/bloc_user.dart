import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:platzi_trips_app/Place/model/place.dart';
import 'package:platzi_trips_app/Place/repository/firebase_storage_repository.dart';
import 'package:platzi_trips_app/User/model/user.dart';
import 'package:platzi_trips_app/User/repository/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:platzi_trips_app/User/repository/cloud_firestore_api.dart';
import 'package:platzi_trips_app/User/repository/cloud_firestore_repository.dart';
import 'package:platzi_trips_app/User/ui/widgets/profile_place.dart';

class UserBloc implements Bloc {
  final _authRepository = AuthRepository();
  //Flujo de datos - Streams
  //Stream - Firebase
  //StreamController
  Stream<FirebaseUser> streamFirebase = FirebaseAuth.instance.onAuthStateChanged;
  //Auth Status Stream
  Stream<FirebaseUser> get authStatus => streamFirebase;

  Future<FirebaseUser> get currentUser => FirebaseAuth.instance.currentUser();

  //Casos de Uso
  //1. SignIn a la aplicacion Google
  Future<FirebaseUser> signIn() => _authRepository.signInFirebase();

  //2.Registrar usuario en base de datos
  final _cloudFirestoreRepository = CloudFirestoreRepository();
  void updateUserData(User user) => _cloudFirestoreRepository.updateUserDataFirestore(user);
  Future<void> updatePlaceData(Place place) => _cloudFirestoreRepository.updatePlaceData(place);

  // stream para subir places
  Stream<QuerySnapshot> placesListStream = Firestore.instance.collection(CloudFirestoreAPI().PLACES).snapshots();

  Stream<QuerySnapshot> get placesStream => placesListStream;

  List<ProfilePlace> buildMyPlaces(List<DocumentSnapshot> placesListSnapshot) => _cloudFirestoreRepository.buildMyPlaces(placesListSnapshot);

  Stream<QuerySnapshot> myPlacesListStream(String uid) => Firestore.instance.collection(CloudFirestoreAPI().PLACES)
  .where("userOwner", isEqualTo: Firestore.instance.document("${CloudFirestoreAPI().USERS}/$uid"))
  .snapshots()
  ;

  //3
  final _firebaseStorageRepository = FirebaseStorageRepository();
  Future<StorageUploadTask> uploadFile(String path, File image) => _firebaseStorageRepository.uploadFile(path, image);

  signOut(){
    _authRepository.signOut();
  }

  @override
  void dispose() {
    // TODO: implement dispose
  }
}