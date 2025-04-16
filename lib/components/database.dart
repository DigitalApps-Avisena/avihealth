import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class DatabaseMethods {
  final String? uid;

  DatabaseMethods({this.uid});


  // ignore: missing_return
  Future<void> addAppointment() async {
    FirebaseFirestore.instance
        .collection("appointment")
        .doc("5")
        .set({
        'appointmentId' : '5',
        'appointmentDate' : '2024-12-31',
        'service' : 'Ear, Nose & Throat',
        'session' :'Morning',
        'appointment_type' : 'Consultation without procedure',
        'appointment_reason' : 'test test',
        'doctor_name' : 'Dato Dr. Abdul Razak Rahman Hamzah',
        'hospital_address' : 'Avisena Women & Children Specialist Hospital',
        }).catchError((e) {
      print(e);
    });
  }

}
