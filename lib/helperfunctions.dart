import 'package:shared_preferences/shared_preferences.dart';

class HelperFunctions {
  static bool defaultEnterIsSend = false;
  static bool? enterIsSend;
  static String sharedPreferenceUserLoggedInKey = "ISLOGGEDIN";
  static String sharedPreferenceUserId = "USERID";
  static String sharedPreferenceUserNameKey = "USERNAMEKEY";
  static String sharedPreferenceNameKey = "NAMEKEY";
  static String sharedPreferenceUserEmailKey = "USEREMAILKEY";
  static String sharedPreferenceUserImageKey = "USERIMAGEKEY";
  static String sharedPreferenceUserDeviceToken = "DEVICETOKEN";

  // userprofile
  static String sharedPreferenceUserPhoneNo = "USERPHONEKEY";
  static String sharedPreferenceUserIcNo = "USERICKEY";
  static String sharedPreferenceFullNameKey = "USERFULLNAMEKEY";
  static String sharedPreferenceBirthdayKey = "USERBIRTHDAYKEY";
  static String sharedPreferenceBillingAddressKey = "USERBILLINGADDRESSKEY";
  static String sharedPreferenceWeightKey = "USERWEIGHTKEY";
  static String sharedPreferenceOccupationKey = "USEROCCUPATIONKEY";

  static String sharedPreferenceMRNKey = "USERMRNNOKEY";
  static String sharedPreferenceGenderKey = "USERGENDERKEY";

  static String sharedPreferenceReferralCode = "USERREFERRALCODE";

  static String sharedPreferenceNotifications = "NOTIFICATIONSKEY";

  /// saving data to sharedpreference
  static Future<bool> saveUserLoggedInSharedPreference(
      bool isUserLoggedIn) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setBool(
        sharedPreferenceUserLoggedInKey, isUserLoggedIn);
  }

  // user ID
  static Future<bool> saveUserIdSharedPreference(id) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(sharedPreferenceUserId, id);
  }

  static Future<bool> saveUserNameSharedPreference(String userName) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(sharedPreferenceUserNameKey, userName);
  }

  static Future<bool> saveNameSharedPreference(String userFullName) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(sharedPreferenceNameKey, userFullName);
  }

  static Future<bool> saveUserEmailSharedPreference(String userEmail) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(sharedPreferenceUserEmailKey, userEmail);
  }

  static Future<bool> saveUserMRNSharedPreference(String mrn) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(sharedPreferenceMRNKey, mrn);
  }

  static Future<bool> saveImageSharedPreference(String userImage) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(sharedPreferenceUserImageKey, userImage);
  }

  static Future<bool> saveUserDeviceTokenPreference(
      String userDeviceToken) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(
        sharedPreferenceUserDeviceToken, userDeviceToken);
  }

  static Future<bool> saveUserPhoneNoPreference(String userPhoneNo) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(
        sharedPreferenceUserPhoneNo, userPhoneNo);
  }

  static Future<bool> saveUserIcNoPreference(String userIc) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(sharedPreferenceUserIcNo, userIc);
  }

  static Future<bool> saveUserFullNamePreference(String fullname) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(sharedPreferenceFullNameKey, fullname);
  }

  static Future<bool> saveUserbirthdayPreference(String birthday) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(sharedPreferenceBirthdayKey, birthday);
  }

  static Future<bool> saveUserbillingAddressPreference(
      String billingaddress) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(
        sharedPreferenceBillingAddressKey, billingaddress);
  }

  /// fetching data from sharedpreference

  static Future<String?> getUserIdSharedPreference() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(sharedPreferenceUserId);
  }

  static Future<bool?> getUserLoggedInSharedPreference() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getBool(sharedPreferenceUserLoggedInKey);
  }

  static Future<String?> getUserNameSharedPreference() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(sharedPreferenceUserNameKey);
  }

  static Future<String?> getUserEmailSharedPreference() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(sharedPreferenceUserEmailKey);
  }

  static Future<String?> getNameSharedPreference() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(sharedPreferenceNameKey);
  }

  static Future<String?> getImageSharedPreference() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(sharedPreferenceUserImageKey);
  }

  static Future<String?> getUserDeviceTokenPreference() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(sharedPreferenceUserDeviceToken);
  }

  static Future<String?> getUserPhoneNoPreference() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(sharedPreferenceUserPhoneNo);
  }

  static Future<String?> getUserIcNoPreference() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(sharedPreferenceUserIcNo);
  }

  static Future<String?> getUserFullNamePreference() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(sharedPreferenceFullNameKey);
  }

  static Future<String?> getUserBirthdayPreference() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(sharedPreferenceBirthdayKey);
  }

  static Future<String?> getUserBillingAddressPreference() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(sharedPreferenceBillingAddressKey);
  }

  // start saveUserWeightPreference
  static Future<bool> saveUserWeightPreference(String weight) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(sharedPreferenceWeightKey, weight);
  }

  static Future<String?> getUserWeightSharedPreference() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(sharedPreferenceWeightKey);
  }
  // end saveUserWeightPreference

  // saveUserOccupationPreference
  static Future<bool> saveUserOccupationPreference(String occupation) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(
        sharedPreferenceOccupationKey, occupation);
  }

  static Future<String?> getUserOccupationSharedPreference() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(sharedPreferenceOccupationKey);
  }
  // saveUserOccupationPreference

  // saveUserMRNNoPreference
  // static Future<bool> saveUserMRNNoPreference(String rnno) async {
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //   return await preferences.setString(sharedPreferenceMRNKey, rnno);
  // }
  //
  // static Future<String?> getUserMRNNoSharedPreference() async {
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //   return preferences.getString(sharedPreferenceMRNKey);
  // }
  // MRNNO
  // Gender

  static Future<bool> saveUserGenderPreference(String gender) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(sharedPreferenceGenderKey, gender);
  }

  static Future<String?> getUserGenderPreference() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(sharedPreferenceGenderKey);
  }
  // gender

  // Referral Code
  static Future<bool> saveUserReferralCodePreference(
      String referralCode) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(
        sharedPreferenceReferralCode, referralCode);
  }

  static Future<String?> getUserReferralCodePreference() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(sharedPreferenceReferralCode);
  }

  // Referral Code

  // Referral Code
  static Future<bool> saveUserNotifications(dynamic data) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setStringList(sharedPreferenceNotifications, data);
  }

  static Future<List<String>?> getUserNotifications() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getStringList(sharedPreferenceNotifications);
  }
}
