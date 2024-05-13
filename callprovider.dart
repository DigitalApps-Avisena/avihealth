import 'package:flutter/widgets.dart';
import 'package:flutter_avisena/Helperfunctions.dart';
import 'package:flutter_avisena/const.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';

class CallProvider with ChangeNotifier {
  playRingtone() {
    FlutterRingtonePlayer.playRingtone(
      asAlarm: true,
      looping: false,
      volume: 1.0,
    );
  }

  String _status = "idle";
  String get status => _status;

  void setToRinging() {
    playRingtone();
    _status = "ringing";
    // print("_status $_status");
    notifyListeners();
  }

  void setToIdle() {
    FlutterRingtonePlayer.stop();
    _status = "idle";
    // print("_status $_status");
    notifyListeners();
  }

  var _user;
  var _id;
  get getUser => _user;
  get getId => _id;

  Future<void> getUserId() async {
    Constants.myId = (await HelperFunctions.getUserIdSharedPreference())!;
    _id = Constants.myId;
    print("id getUserId $_id");
    notifyListeners();
  }
}
