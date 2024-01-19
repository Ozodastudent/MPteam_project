import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pinterestmobile/models/user_model.dart';
import 'package:pinterestmobile/services/pref_service.dart';

class DataService {

  //// ----- FireBase instance ----- ////

  static final instance = FirebaseFirestore.instance;

  //// ----- Folder ----- ////

  static const String userFolder = "users";

  //// ----- User store ----- ////

  static Future storeUser(Users user) async {
    user.uid = (await Prefs.load(StorageKeys.UID))!;
    return instance.collection(userFolder).doc(user.uid).set(user.toJson());
  }

  //// ----- User load ----- ////

  static Future<Users> loadUser() async {
    String uid = (await Prefs.load(StorageKeys.UID))!;
    var value = await instance.collection(userFolder).doc(uid).get();

    Users user = Users.fromJson(value.data()!);
    return user;
  }

  //// ----- Update User ----- ////

  static Future updateUser(Users user) async {
    String uid = (await Prefs.load(StorageKeys.UID))!;
    return instance.collection(userFolder).doc(uid).update(user.toJson());
  }
}