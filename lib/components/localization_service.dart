import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LocalizationService extends Translations {
  static final LocalizationService instance = LocalizationService();

  static final langs = [
    'English',
    'Malay',
  ];

  static final locales = [
    const Locale('en', 'US'),
    const Locale('ms', 'MY'),
  ];

  @override
  Map<String, Map<String, String>> get keys => {
    'en_US': {
      "Add Dependent" : "Add Dependent",
      "Add Dependent Instruction" : "to bring IC/myKid/myKad/birth certificate/passport for validation and approval process.",
      "Add Dependent Instruction Mandatory" : "MANDATORY ",
      "Add Dependent Warning" : "Please register new Dependent at Avisena Healthcare registration counter.",
      "Admission & Discharge Department Contact Information" : "Admission & Discharge Department Contact Information",
      "Add New" : "Add New",
      "Appointment" : "Appointment",
      "Book an Appointment" : "Book an Appointment",
      "Choose Hospital" : "Choose Hospital",
      "Services" : "Services",
      "Specialists" : "Specialists",
      "Contact Us" : "Contact Us",
      "Details" : "Details",
      "Dependents" : "Dependents",
      "Discover More" : "Discover More",
      "Doctors" : "Doctors",
      "Fertility Services" : "Fertility Services",
      "Language" : "Language",
      "Language Changed" : "Language Changed",
      "More" : "More",
      "My Account" : "My Account",
      "My Appointments" : "My Appointments",
      "My Dependents" : "My Dependents",
      "Need Help" : "Need Help",
      "Next" : "Next",
      "Number Not Register" : "Number Not Register",
      "Okay" : "Okay",
      "Patient & Family Rights": "Patient & Family Rights",
      "Paediatric Suction Recovery Package" : "Paediatric Suction Recovery Package",
      "Personal Verification List" : "Please Enter IC Number",
      "Profile" : "Profile",
      "Reschedule" : "Reschedule",
      "Save" : "Save",
      "Services" : "Services",
      "Submit" : "Submit",
      "View Room Rates" : "View Room Rates"
    },
    'ms_MY': {
      "Add Dependent" : "Tambah Tanggungan",
      "Add Dependent Instruction" : "untuk bawa IC/myKid/MyKad/sijil lahir/passport untuk proses pengesahan dan kelulusan.",
      "Add Dependent Instruction Mandatory" : "WAJIB ",
      "Add Dependent Warning" : "Sila daftar tanggungan baru di kaunter pendaftaran Avisena Healthcare.",
      "Admission & Discharge Department Contact Information" : "Maklumat Perhubungan Jabatan Kemasukan & Pelepasan",
      "Add New" : "Tambah Baru",
      "Appointment" : "Temu Janji",
      "Book an Appointment" : "Tempah Temu Janji",
      "Choose Hospital" : "Pilih Hospital",
      "Services" : "Servis",
      "Specialists" : "Pakar",
      "Contact Us" : "Hubungi Kami",
      "Details" : "Lanjut",
      "Dependents" : "Tanggungan",
      "Discover More" : "Lebih Lanjut",
      "Doctors" : "Doktor",
      "Fertility Services" : "Servis Kesuburan",
      "Language" : "Bahasa",
      "Language Changed" : "Bahasa Ditukar",
      "More" : "Lagi",
      "My Account" : "Akaun Saya",
      "My Appointments" : "Temu Janji Saya",
      "My Dependents" : "Tanggungan Saya",
      "Need Help" : "Perlukan Pertolongan",
      "Next" : "Seterusnya",
      "Number Not Register" : "Nombor Belum Didaftar",
      "Okay" : "Okey",
      "Patient & Family Rights": "Hak Pesakit & Keluarga",
      "Paediatric Suction Recovery Package" : "Pakej Pemulihan Sedutan Pediatrik",
      "Personal Verification List" : "Sila Masukkan Nombor IC",
      "Profile" : "Profil",
      "Reschedule" : "Jadual Semula",
      "Save" : "Simpan",
      "Services" : "Servis",
      "Submit" : "Hantar",
      "View Room Rates" : "Lihar Harga Bilik"
    },
  };

  void changeLocale(String lang) {
    final locale = getLocaleFromLanguage(lang);
    print('chinca $locale');
    Get.updateLocale(locale);
  }

  Locale getLocaleFromLanguage(String lang) {
    // for (int i = 0; i < langs.length; i++) {
    //   if (lang == langs[i]) return locales[i];
    // }
    // return Get.locale!;
    for (int i = 0; i < langs.length; i++) {
      if (lang == langs[i]) return locales[i];
    }
    return Get.locale ?? locales[0];
  }
}
