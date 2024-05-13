import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class DatabaseMethods {
  final String? uid;

  DatabaseMethods({this.uid});

  final CollectionReference patientCollection =
      FirebaseFirestore.instance.collection("testingData");

  Future deleteuser() {
    return patientCollection.doc(uid).delete();
  }

  Future<void> addUserInfo(id, userData) async {
    FirebaseFirestore.instance
        .collection("patient")
        .doc(id)
        .set(userData)
        .catchError((e) {
      print(e.toString());
    });
  }

  getUserSignin(String email) async {
    return FirebaseFirestore.instance
        .collection("patient")
        .where("email", isEqualTo: email)
        .get()
        .catchError((e) {
      print(e.toString());
    });
  }

  getUserInfo(String email) async {
    return FirebaseFirestore.instance
        .collection("patient")
        .where("email", isEqualTo: email)
        .get()
        .catchError((e) {
      print(e.toString());
    });
  }

  deleteUser(String email) async {
    return FirebaseFirestore.instance
        .collection("patient")
        .where("email", isEqualTo: email)
        .get()
        .catchError((e) {
      print(e.toString());
    });
  }

  updateUserInfoOnMain(id, mapData) async {
    FirebaseFirestore.instance.collection("patient").doc(id).update(mapData);
  }

  getUserInfobasedonId(String id) async {
    return FirebaseFirestore.instance
        .collection("patient")
        .where("id", isEqualTo: id)
        .get()
        .catchError((e) {
      print(e.toString());
    });
  }

  getUserInfobasedonIC(String icNo, String myic) async {
    return FirebaseFirestore.instance
        .collection("patient")
        .where("icNo", isEqualTo: icNo)
        // .where("icNo",isLessThan:myic)
        .limit(1)
        .get()
        .catchError((e) {
      print(e.toString());
    });
  }

  Future<void> addUserDetails(id, userData) async {
    FirebaseFirestore.instance
        .collection("patient_details")
        .doc(id)
        .set(userData)
        .catchError((e) {
      print(e.toString());
    });
  }

  // CareProvider
  getCareProvider() async {
    return FirebaseFirestore.instance
        .collection("careProvider")
        .where("cpCode")
        .get();
  }
  // updateUserInfo(id,mapData) async {
  //    FirebaseFirestore.instance
  //       .collection("patient_details")
  //       .doc(id)
  //       .update(mapData);
  // }

  updateUserLocation(id, mapData) async {
    FirebaseFirestore.instance.collection("patient").doc(id).update(mapData);
  }

  searchByName(String searchField) async {
    return FirebaseFirestore.instance
        .collection("patient")
        .where('userName', isEqualTo: searchField)
        .get();
  }

  Future<void> addChatRoom(chatRoom, chatRoomId) async {
    FirebaseFirestore.instance
        .collection("chatRoom")
        .doc(chatRoomId)
        .set(chatRoom)
        .catchError((e) {
      print(e);
    });
  }

  getChats(String chatRoomId) async {
    return FirebaseFirestore.instance
        .collection("chatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .orderBy('time')
        .snapshots(includeMetadataChanges: true);
  }

  getLastChats(String chatRoomId) async {
    return FirebaseFirestore.instance
        .collection("chatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .orderBy('time', descending: true)
        .limit(1)
        .snapshots();
  }

  getunreadchats(String chatRoomId, cpCode) async {
    return FirebaseFirestore.instance
        .collection("chatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .where('isRead', isEqualTo: false)
        .where('sendByUserId', isEqualTo: cpCode)
        .orderBy('sendBy', descending: true)
        .orderBy('time', descending: true)
        .snapshots();
  }

  getChatsDevicesToken(String? chatRoomId) async {
    return FirebaseFirestore.instance
        .collection("chatRoom")
        .where('chatRoomId', isEqualTo: chatRoomId)
        .get();
  }

  addMessage(String chatRoomId, chatMessageData) async {
    var result = await FirebaseFirestore.instance
        .collection("chatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .add(chatMessageData)
        .catchError((e) {
      print(e.toString());
    });
    return result;
  }

  readMessage(String chatRoomId, chatMessageData, cpCode) async {
    FirebaseFirestore.instance
        .collection("chatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .where('isRead', isEqualTo: false)
        .where('sendByUserId', isEqualTo: cpCode)
        .orderBy('sendBy', descending: true)
        .orderBy('time', descending: true)
        .get()
        .then((val) =>
            val.docs.forEach((doc) => {doc.reference.update(chatMessageData)}));
    // print('data update $chatMessageData');
  }

  removedChatRoom(String chatRoomId, mapData) async {
    FirebaseFirestore.instance
        .collection("chatRoom")
        .doc(chatRoomId)
        .update(mapData);
    print('data update $mapData');
  }

  getUserChats(String itIsMyId) async {
    return await FirebaseFirestore.instance
        .collection("chatRoom")
        .where('usersId', arrayContains: itIsMyId)
        // .where('deleteDateTime', isGreaterThanOrEqualTo:Timestamp.now())
        .where("isRemoved", isEqualTo: false)
        .orderBy("deleteDateTime", descending: true)
        .snapshots();
  }

  //
  getVideoRoomId(String a, String b) {
    return "$a\_$b";
  }

  // add videoRoom
  addVideoRoom(videoRoomId, videoRoomData) async {
    return FirebaseFirestore.instance
        .collection("videoRoom")
        .doc(videoRoomId)
        .set(videoRoomData)
        .catchError((e) {
      print(e);
    });
  }

  getVideoRoom(String itIsMyName, int channelid) async {
    return FirebaseFirestore.instance
        .collection("videoRoom")
        .where("users", arrayContains: itIsMyName)
        .where("channelId", isEqualTo: channelid)
        .get()
        .catchError((e) {
      print(e.toString());
    });
  }

  Future<bool> joinVideoRoom(
      String roomId, String itIsMyName, var expiredDate) {
    var now = new DateTime.now();
    FirebaseFirestore.instance
        .collection("videoRoom")
        .where('users', arrayContains: itIsMyName)
        .where('start_date', isGreaterThanOrEqualTo: now)
        .where('end_date', isLessThanOrEqualTo: expiredDate)
        .get()
        .catchError((e) {
      print(e);
    });
    throw '';
  }

  // ignore: missing_return
  Future<void> addSurvey(appointmentId, surveyData) async {
    FirebaseFirestore.instance
        .collection("appointment")
        .doc(appointmentId)
        .set(surveyData)
        .catchError((e) {
      print(e);
    });
  }

  Future<void> updateSurvey(appointmentId, surveyData) async {
    FirebaseFirestore.instance
        .collection("appointment")
        .doc(appointmentId)
        .update(surveyData)
        .catchError((e) {
      print(e);
    });
  }

  getTestLab(id) async {
    return FirebaseFirestore.instance
        .collection("labTest")
        .where("testId", isEqualTo: id)
        .get();
  }

  updateTestLab(testId, surveyData) async {
    var result = FirebaseFirestore.instance
        .collection("labTest")
        .doc(testId)
        .update(surveyData)
        .catchError((e) {
      print(e);
    });
    return result;
  }

  // Future<void> addSurveyData(surveyId, surveyData,transid) async{
  //   FirebaseFirestore.instance.collection("survey")
  //       .doc(surveyId)
  //       .collection("surveyForms")
  //       .doc(transid)
  //       .set(surveyData);
  //       // .add(surveyData);
  //     // .then((_data)  {
  //     //     print("doc written with ID: + ${_data}");
  //     // });
  //   // print("data ${newUID.uid}");
  //   // FirebaseFirestore.instance.collection("survey")
  //   //     .doc(surveyId)
  //   //     .collection("surveyForms")
  //   //     .add(surveyData).catchError((e){
  //   //       print(e.toString());
  //   // });
  // }

  gettransactionId() async {
    var result = FirebaseFirestore.instance
        .collection("appointment")
        .orderBy("appointmentId", descending: true)
        .limit(1)
        .get();
    return result;
  }

  getSurveyData(appointmentId) async {
    var result = FirebaseFirestore.instance
        .collection("appointment")
        .where("appointmentId", isEqualTo: appointmentId)
        .limit(1)
        .get();
    return result;
  }

  getOrderPrescriptionData(appointmentId) async {
    var result = FirebaseFirestore.instance
        .collection("order")
        .where("appointmentId", isEqualTo: appointmentId)
        .limit(1)
        .get();
    return result;
  }

  updateOrderPrescriptionData(orderId, surveyData) async {
    var result = FirebaseFirestore.instance
        .collection("order")
        .doc(orderId)
        .update(surveyData)
        .catchError((e) {
      print(e);
    });
    return result;
  }

  gettwolasttransaction(userId) async {
    var now = DateTime.now();
    var newnow = "${now.toLocal()}".split(' ')[0];
    var nowsubtract = now.subtract(Duration(minutes: 240));
    var nowsubtract2 = "$nowsubtract".split(".")[0];
    print("nowsubtract $nowsubtract $nowsubtract2");
    return FirebaseFirestore.instance
        .collection("appointment")
        .where("userId", isEqualTo: userId)
        .where("status", whereIn: ["Confirm", "Pending", "Completed"])
        .where("appointmentDate", isGreaterThanOrEqualTo: newnow)
        .orderBy("appointmentDate")
        .orderBy("appointmentTime")
        .limit(5)
        .snapshots();
  }

  checkforChanges(userId) async {
    var data;
    var now = DateTime.now();
    var newnow = "${now.toLocal()}".split(' ')[0];
    FirebaseFirestore.instance
        .collection("appointment")
        .where("userId", isEqualTo: userId)
        .where("status", whereIn: ["Confirm", "Pending", "Completed"])
        .where("appointmentDate", isGreaterThanOrEqualTo: newnow)
        .orderBy("appointmentDate")
        .orderBy("appointmentTime")
        .limit(5)
        .snapshots()
        .listen((querySnapshot) {
          querySnapshot.docChanges.forEach((change) {
            if (change.type == DocumentChangeType.added) {
              print("added");
            } else if (change.type == DocumentChangeType.modified) {
              print("modified");
            } else if (change.type == DocumentChangeType.removed) {
              print("removed");
            }
            data = change;
          });
        });
    return data;
  }

  checkforChangesAll(userId) async {
    var data;
    FirebaseFirestore.instance
        .collection("appointment")
        .where("userId", isEqualTo: userId)
        .orderBy("createdDate", descending: true)
        .orderBy("appointmentTime")
        .snapshots()
        .listen((querySnapshot) {
      querySnapshot.docChanges.forEach((change) {
        // Do something with change
        // print("change isss ${change.doc.data}");
        if (change.type == DocumentChangeType.added) {
          print("added");
        } else if (change.type == DocumentChangeType.modified) {
          print("modified");
        } else if (change.type == DocumentChangeType.removed) {
          print("removed");
        }
        data = change;
      });
    });
    return data;
  }

  getAlltransaction({String? userId, int? loadmore}) async {
    var now = DateTime.now();
    var nowsubtract = now.subtract(Duration(minutes: 120));
    var nowsubtract2 = "$nowsubtract".split(".")[0];
    var newnow = "${now.toLocal()}".split(' ')[0];
    return FirebaseFirestore.instance
        .collection("appointment")
        .where("userId", isEqualTo: userId)
        .where("status", whereIn: ["Confirm", "Pending"])
        .where("appointmentDate", isGreaterThanOrEqualTo: newnow)
        .orderBy("appointmentDate")
        .orderBy("appointmentTime")
        // .limit(loadmore)
        .snapshots();
  }

  getCompletetransaction2({String? userId, int? loadmore}) async {
    var now = DateTime.now();
    var newnow = "${now.toLocal()}".split(' ')[0];
    var nowsubtract = now.add(Duration(minutes: 120));
    var nowsubtract2 = "$nowsubtract".split(".")[0];
    print("nowsubtract2 now $nowsubtract2");
    return FirebaseFirestore.instance
        .collection("appointment")
        .where("userId", isEqualTo: userId)
        .where("status", whereIn: ["Completed"])
        // .where("appointmentDateTime",isLessThan:nowsubtract2)
        .orderBy("appointmentId", descending: true)
        .orderBy("appointmentDateTime", descending: true)
        .orderBy("appointmentDate")
        .orderBy("appointmentTime")
        // .limit(loadmore)
        // .orderBy("appointmentDate",descending: true)
        .snapshots();
  }

  getCancelledtransaction({String? userId, int? loadmore}) async {
    var now = DateTime.now();
    var newnow = "${now.toLocal()}".split(' ')[0];
    var nowsubtract = now.add(Duration(minutes: 120));
    var nowsubtract2 = "$nowsubtract".split(".")[0];
    print("nowsubtract2 now $nowsubtract2");
    return FirebaseFirestore.instance
        .collection("appointment")
        .where("userId", isEqualTo: userId)
        .where("status", whereIn: ["Cancelled"])
        // .where("appointmentDateTime",isLessThan:nowsubtract2)
        .orderBy("appointmentId", descending: true)
        .orderBy("appointmentDateTime", descending: true)
        .orderBy("appointmentDate")
        .orderBy("appointmentTime")
        // .limit(loadmore)
        // .orderBy("appointmentDate",descending: true)
        .snapshots();
  }

  Future<bool> getUserSurveyExist(id) async {
    QuerySnapshot result = await FirebaseFirestore.instance
        .collection('appointment')
        .where('userId', isEqualTo: id)
        .get();

    final List<DocumentSnapshot> docs = result.docs;

    //if user is registered then length of list > 0 or else less than 0
    return docs.length == 0 ? true : false;
  }

  //  specialist
  getAllSpecialist() async {
    return FirebaseFirestore.instance
        .collection("careProvider")
        .where("careType", isEqualTo: "Specialist")
        .where("isTeleconsult", isEqualTo: 1)
        .where("isActive", isEqualTo: 1)
        .orderBy("status", descending: true)
        .snapshots();
  }

  //  specialist
  getAllSpecialistDoc() async {
    return FirebaseFirestore.instance
        .collection("careProvider")
        .where("careType", isEqualTo: "Specialist")
        .where("isTeleconsult", isEqualTo: 1)
        .where("isActive", isEqualTo: 1)
        .orderBy("specialistType")
        .get();
  }

  //  specialist
  getSpecialistbyType(type) async {
    return FirebaseFirestore.instance
        .collection("careProvider")
        .where("careType", isEqualTo: "Specialist")
        .where("specialistType", isEqualTo: "$type")
        .where("isTeleconsult", isEqualTo: 1)
        .where("isActive", isEqualTo: 1)
        .orderBy("status", descending: true)
        .snapshots();
  }

  //  Dietician
  getAllDietitian() async {
    return FirebaseFirestore.instance
        .collection("careProvider")
        .where("careType", isEqualTo: "Dietician")
        .where("isTeleconsult", isEqualTo: 1)
        .where("isActive", isEqualTo: 1)
        .orderBy("status", descending: true)
        .snapshots();
  }

  getAllPsychologist() async {
    return FirebaseFirestore.instance
        .collection("careProvider")
        .where("careType", isEqualTo: "Psychologist")
        .where("isTeleconsult", isEqualTo: 1)
        .where("isActive", isEqualTo: 1)
        .orderBy("status", descending: true)
        .snapshots();
  }

  updateDeviceToken(id, mapData) async {
    FirebaseFirestore.instance.collection("patient").doc(id).update(mapData);
  }

  // family members
  Future<bool> checkUserfamilyExist(id) async {
    QuerySnapshot result = await FirebaseFirestore.instance
        .collection('patient_familymembers')
        .where('id', isEqualTo: id)
        .get();

    final List<DocumentSnapshot> docs = result.docs;
    print("docs lengt ${docs.length}");
    return docs.length == 0 ? true : false;
  }

  Future<void> addUserFamilymembers(id, userData) async {
    FirebaseFirestore.instance
        .collection("patient_familymembers")
        .doc(id)
        .set(userData);
  }

  Future<void> updateUserFamilymembers(id, memberid, familymember) async {
    FirebaseFirestore.instance
        .collection("patient_familymembers")
        .doc(id)
        .collection("members")
        .doc(memberid)
        .set(familymember);
  }

  getFamilyMembers(id) async {
    return FirebaseFirestore.instance
        .collection("patient_familymembers")
        .doc(id)
        .collection("members")
        .where("isDeleted", isEqualTo: false)
        .snapshots();
  }

  getFamilyMembersdocs(id) async {
    return FirebaseFirestore.instance
        .collection("patient_familymembers")
        .doc(id)
        .collection("members")
        .where("isDeleted", isEqualTo: false)
        .get();
  }

  Future checkUserfamilyId(id) async {
    return FirebaseFirestore.instance
        .collection('patient_familymembers')
        .doc(id)
        .collection("members")
        .get();

    // final List<docSnapshot> docs = result.docs;
    // print("docs lengt ${docs.length}");
    // return docs.length;
  }

  // sendrequestfmilymember
  Future sendRequestFamilyMember(id, mapData) async {
    return FirebaseFirestore.instance
        .collection('patient_familymembersRequest')
        .doc(id)
        .set(mapData);

    // final List<docSnapshot> docs = result.docs;
    // print("docs lengt ${docs.length}");
    // return docs.length;
  }

  Future getRequestFamilyMember(id) async {
    return FirebaseFirestore.instance
        .collection('patient_familymembersRequest')
        .where("toUserId", isEqualTo: id)
        .where("isReplied", isEqualTo: false)
        .snapshots();
  }

  Future updateRequestFamilyMember(id, mapData) async {
    return FirebaseFirestore.instance
        .collection('patient_familymembersRequest')
        .doc(id)
        .update(mapData);
  }

  removedFamilyMembers(patientid, memberid, mapData) async {
    FirebaseFirestore.instance
        .collection("patient_familymembers")
        .doc(patientid)
        .collection("members")
        .doc(memberid)
        .update(mapData);
    print('data update $mapData');
  }

  Future getpendingrequesttoFamilyMember(id) async {
    return FirebaseFirestore.instance
        .collection('patient_familymembersRequest')
        .where("fromUserid", isEqualTo: id)
        .where("isReplied", isEqualTo: false)
        .snapshots();
  }

  Future<bool> removemyrequest(id) async {
    try {
      await FirebaseFirestore.instance
          .collection("patient_familymembersRequest")
          .doc(id)
          .delete();
      await FirebaseFirestore.instance
          .collection("patient_familymembersRequest")
          .doc(id)
          .delete();
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  // endfmily member

  void setImageMsg(String url, chatMessageData, chatRoomId) async {
    await FirebaseFirestore.instance
        .collection("chatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .add(chatMessageData)
        .catchError((e) {
      print(e.toString());
    });
  }

  addCall(id, mapData) async {
    await FirebaseFirestore.instance
        .collection("call")
        .doc(id)
        .set(mapData)
        .catchError((e) {
      print(e.toString());
    });
  }

  // Stream<docSnapshot> getcallIncoming(id) {
  //   return FirebaseFirestore.instance
  //       .collection("call")
  //       .where("receiverId",isEqualTo:id)
  //       .where("isPickup",isEqualTo:false)
  //       .snapshots();
  // }

  Stream<QuerySnapshot> getcallIncoming({String? id}) {
    return FirebaseFirestore.instance
        .collection("call")
        .where("receiverId", isEqualTo: id)
        .where("isPickup", isEqualTo: false)
        .snapshots();
  }

  Future<bool> updatecallIncoming(id, mapData) async {
    try {
      FirebaseFirestore.instance.collection("call").doc(id).update(mapData);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> endCall({id}) async {
    var mapData = {
      "isHangup": true,
    };
    try {
      await FirebaseFirestore.instance.collection("call").doc(id).delete();
      await FirebaseFirestore.instance.collection("call").doc(id).delete();
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  // announcement
  getHomeBanner() async {
    return FirebaseFirestore.instance
        .collection("homePage")
        .where("type", isEqualTo: "homebanner")
        .get();
  }

  getNotificationImage() async {
    return FirebaseFirestore.instance
        .collection("notificationDrawer")
        .where("type", isEqualTo: "notificationMedia")
        .get();
  }

  // popup
  getPopup() async {
    var expiredDateTime = DateTime.now();
    print("expiredDateTime $expiredDateTime");
    return FirebaseFirestore.instance
        .collection("homePage")
        .where("type", isEqualTo: "homepopup")
        .where("expiredDateTime", isGreaterThan: expiredDateTime)
        .get();
  }

  // carousell
  getCarousell() async {
    return FirebaseFirestore.instance
        .collection("homePage")
        .where("type", isEqualTo: "carousell")
        .get();
  }

  // getPhysiotherpy
  getPhysio() async {
    return FirebaseFirestore.instance
        .collection("services")
        .where("type", isEqualTo: "physio")
        .get();
  }

  // getDoctor
  getDoctor() async {
    return FirebaseFirestore.instance
        .collection("services")
        .where("type", isEqualTo: "doctor")
        .get();
  }

  // // getBreasfeeding
  // getBreasfeeding() async {
  //   return FirebaseFirestore.instance
  //       .collection("services")
  //       .where("type", isEqualTo: "mombaby")
  //       .get();
  // }

  // getNurse
  getNurse() async {
    return FirebaseFirestore.instance
        .collection("services")
        .where("type", isEqualTo: "nurse")
        .get();
  }

  updateCareProvider(id, mapData) async {
    FirebaseFirestore.instance
        .collection("careProvider")
        .doc(id)
        .update(mapData);
  }

  updateCareprovidertobusy(id) async {
    var updateStatus = {
      "status": 2,
    };
    await updateCareProvider(id, updateStatus);
  }

  updateCareprovidertoonline(id) async {
    var updateStatus = {
      "status": 1,
    };
    await updateCareProvider(id, updateStatus);
  }

  //  allnotificitaion
  getAllNotification(userId) async {
    // var now2 = DateTime.now();
    return FirebaseFirestore.instance
        .collection("notificationDrawer")
        .where("userid", isEqualTo: userId)
        // .where("appointmentDate",isGreaterThanOrEqualTo:newnow)
        // .where("appointmentTime",isGreaterThanOrEqualTo:newnowtime2)
        .orderBy("timestamp") //,descending: true
        .snapshots();
  }

  // getHospital
  getHospital() async {
    return FirebaseFirestore.instance
        .collection("hospital")
        .orderBy("isEnable", descending: true)
        .orderBy("name")
        .snapshots();
  }

  getEscortService(id) async {
    return FirebaseFirestore.instance
        .collection("hospitalService")
        .where("hospitalId", arrayContains: id)
        .where("type", isEqualTo: "escort")
        .snapshots();
  }

  getHospitalDriver() async {
    return FirebaseFirestore.instance
        .collection("hospitalService")
        .where("type", isEqualTo: "driver")
        .snapshots();
  }

  getCovidService() async {
    return FirebaseFirestore.instance
        .collection("hospitalService")
        .where("type", isEqualTo: "covid")
        .where("isEnable", isEqualTo: true)
        .snapshots();
  }

  getQuarantineService() async {
    return FirebaseFirestore.instance
        .collection("hospitalService")
        .where("type", isEqualTo: "quarantine")
        .where("isEnable", isEqualTo: true)
        .snapshots();
  }

  getVaccineService() async {
    return FirebaseFirestore.instance
        .collection("hospitalService")
        .where("type", isEqualTo: "covid vaccine")
        .where("isEnable", isEqualTo: true)
        .snapshots();
  }

  getHospitalwithCovid(serviceid) async {
    return FirebaseFirestore.instance
        .collection("hospital")
        .where("serviceId", arrayContains: serviceid)
        .orderBy("isEnable", descending: true)
        .orderBy("name")
        .snapshots();
  }

  getHospitalwithDialysis(serviceid) async {
    return FirebaseFirestore.instance
        .collection("dialysisCentre")
        .where("serviceId", arrayContains: serviceid)
        .orderBy("isEnable", descending: true)
        .orderBy("name")
        .snapshots();
  }

  getDialysisService() async {
    return FirebaseFirestore.instance
        .collection("dialysisService")
        .where("type", isEqualTo: "dialysis")
        .where("isEnable", isEqualTo: true)
        .snapshots();
  }

  getPermanentSlot() async {
    return FirebaseFirestore.instance
        .collection("bookingDialysis")
        .where("type", isEqualTo: "permanent")
        .where("isEnable", isEqualTo: true)
        .snapshots();
  }

  getVisitingSlot() async {
    return FirebaseFirestore.instance
        .collection("bookingDialysis")
        .where("type", isEqualTo: "visiting")
        .where("isEnable", isEqualTo: true)
        .snapshots();
  }

  //getPostNatalCare
  getPostNatalCare() async {
    return FirebaseFirestore.instance
        .collection("momBaby")
        .where("type", isEqualTo: "postnatal")
        .where("isEnable", isEqualTo: true)
        .snapshots();
  }

  //getBreastFeedingCounselor
  getBreastFeedingCare() async {
    return FirebaseFirestore.instance
        .collection("momBaby")
        .where("type", isEqualTo: "bfcare")
        .where("isEnable", isEqualTo: true)
        .snapshots();
  }

  //getBreastFeedingCounselor
  getConfinementCare8() async {
    return FirebaseFirestore.instance
        .collection("momBaby")
        .where("type", isEqualTo: "confinement8")
        .where("isEnable", isEqualTo: true)
        .snapshots();
  }

  getConfinementCare4() async {
    return FirebaseFirestore.instance
        .collection("momBaby")
        .where("type", isEqualTo: "confinement4")
        .where("isEnable", isEqualTo: true)
        .snapshots();
  }

  getStayInPackage() async {
    return FirebaseFirestore.instance
        .collection("momBaby")
        .where("type", isEqualTo: "stayin")
        .where("isEnable", isEqualTo: true)
        .snapshots();
  }

  // getAskService() async {
  //   return FirebaseFirestore.instance
  //       .collection("dialysisService")
  //       .where("type", isEqualTo: "ask")
  //       .where("isEnable", isEqualTo: true)
  //       .snapshots();
  // }
  //

  getVoucherCode(vcode) async {
    return FirebaseFirestore.instance
        .collection("vouchercode")
        .where("name", isEqualTo: vcode)
        .get();
  }

  getReferralCode(vcode) async {
    return FirebaseFirestore.instance
        .collection("patient")
        .where("referralCode", isEqualTo: vcode)
        .get();
  }

  getAppointmentReferral(mycode) async {
    return FirebaseFirestore.instance
        .collection("appointment")
        .where("vouchercode", isEqualTo: mycode)
        .where("status", isEqualTo: "Completed")
        .get();
  }

  getRegisteredReferral(mycode) async {
    return FirebaseFirestore.instance
        .collection("patient")
        .where("referredBy", isEqualTo: mycode)
        .get();
  }

  updateVoucherCode(id, data) async {
    return FirebaseFirestore.instance
        .collection("vouchercode")
        .doc(id)
        .update(data);
  }

  getVoucherCodeAdmission(vcode) async {
    return FirebaseFirestore.instance
        .collection("vouchercodeadmission")
        .where("name", isEqualTo: vcode)
        .get();
  }

  updateVoucherCodeAdmission(id, data) async {
    return FirebaseFirestore.instance
        .collection("vouchercodeadmission")
        .doc(id)
        .update(data);
  }

  getPublicHolidays() async {
    return FirebaseFirestore.instance.collection("calender").limit(1).get();
  }

  getMaxnoofdays() async {
    return FirebaseFirestore.instance
        .collection("calender")
        .where("type", isEqualTo: "maxdays")
        .limit(1)
        .get();
  }

  getAllDoctors() async {
    return FirebaseFirestore.instance
        .collection("users")
        .orderBy("email")
        .get()
        .catchError((e) {
      print(e.toString());
    });
  }

  getAllDoctorsPagination(documentLimit) async {
    return await FirebaseFirestore.instance
        .collection("doctors")
        .orderBy("rank")
        .limit(documentLimit)
        .get()
        .catchError((e) {
      print(e.toString());
    });
  }

  getAllDoctorsPaginationStartAfter(documentLimit, lastDocument) async {
    return await FirebaseFirestore.instance
        .collection("doctors")
        .orderBy("rank")
        .startAfterDocument(lastDocument)
        .limit(documentLimit)
        .get()
        .catchError((e) {
      print(e.toString());
    });
  }

  getDoctorBySearch(String searchString) async {
    return await FirebaseFirestore.instance
        .collection("doctors")
        .where("lastName", isGreaterThanOrEqualTo: searchString)
        .where("lastName", isLessThanOrEqualTo: searchString + "z")
        .get()
        .catchError((e) {
      print(e.toString());
    });
  }

  getDoctorBySpecialty(String specialty) async {
    return await FirebaseFirestore.instance
        .collection("doctors")
        .where("specialty", isEqualTo: specialty)
        .get()
        .catchError((e) {
      print(e.toString());
    });
  }

  getAllSpecialties() async {
    return FirebaseFirestore.instance
        .collection("specialties")
        .get()
        .catchError((e) {
      print(e.toString());
    });
  }

  getSpecialty(String specialty) async {
    return FirebaseFirestore.instance
        .collection("specialties")
        .where("specialty", isEqualTo: specialty)
        .get()
        .catchError((e) {
      print(e.toString());
    });
  }

  getDoctorProfile(String lastName) async {
    return FirebaseFirestore.instance
        .collection("doctors")
        .where("lastName", isEqualTo: lastName)
        .get()
        .catchError((e) {
      print(e.toString());
    });
  }

  getDoctorOfficeGallery(String lastName) async {
    return FirebaseFirestore.instance
        .collection("officeGalleries")
        .where("lastName", isEqualTo: lastName)
        .get()
        .catchError((e) {
      print(e.toString());
    });
  }

  getUserProfile(String email) async {
    return FirebaseFirestore.instance
        .collection("users")
        .where("email", isEqualTo: email)
        .get()
        .catchError((e) {
      print(e.toString());
    });
  }
}
