import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../const.dart';
import '../HomePage/homepage.dart';
import '../Services/chooseHospital.dart';
import 'appointmentDetails.dart';

class appointmentListing extends StatefulWidget {
  final String? name;
  final String? email;
  final String? phone;
  final String? mrn;
  final DateTime? selectedDate;
  final String? selectedOption;
  final String? locationGroup;
  final String? appointmentReason;
  final String? hospitalId;
  final String? hospitalName;
  final String? clinicName;
  final String? doctorName;
  final String? doctorImage;
  final Map? mapData;

  const appointmentListing({
    Key? key,
    required this.name,
    required this.email,
    required this.phone,
    required this.mrn,
    required this.selectedDate,
    required this.selectedOption,
    required this.appointmentReason,
    required this.locationGroup,
    required this.hospitalId,
    required this.hospitalName,
    required this.clinicName,
    required this.doctorName,
    required this.doctorImage,
    this.mapData,
  }) : super(key: key);

  @override
  State<appointmentListing> createState() => _appointmentListingState();
}

  class _appointmentListingState extends State<appointmentListing>{
    // Track the index of the selected button (null initially)
    // int? _selectedButtonIndex;

    var _width;
    var _height;

    bool _isGuestMode = false;

    List<String> membersname = [];
    var selectedUser;

    // Set the first button as selected by default
    int _selectedButtonIndex = 1;

    // Get the current year dynamically
    int currentYear = DateTime.now().year;

    // Sample list items to display when Button 1 is clicked
    final List<String> _listItems = [
      'Item 1',
      'Item 2',
      'Item 3',
      'Item 4',
      'Item 5',
    ];

    final List<String> _imagePaths = [
      'assets/images/specialist.png',
      'assets/images/dr-sani.jpg',
      'assets/images/dr-nazatul-profile.jpg',
      'assets/images/dr-kartini-profile.jpg',
      'assets/images/dr-ahmad-murad-profile.jpg',
    ];

    final List<String> _specialistName = [
      'Dato\' Dr Abdul Razak Rahman Hamzah',
      'Dato\' Dr Abdullah Sani Mohamed',
      'Dr Nazatul Sabariah Ahmad',
      'Dr Kartini Farah Rahim',
      'Dr Ahmad Murad Zainuddin',
    ];

    final List<String> _specialistService = [
      'Ear, Nose & Throat',
      'Ear, Nose & Throat',
      'Paediatric Dentistry',
      'Physician & Dermatology',
      'Obstetrician & Gynaecologist',
    ];

    final List<String> _appointmentDateSession = [
      '31/12/2025 | Morning',
      '06/01/2024 | Morning',
      '17/11/2025 | Afternoon',
      '16/10/2024 | Evening',
      '24/08/2024 | Morning',
    ];

    // Sample list items to display when Button 2 is clicked
    final List<String> _listActiveItems = [
      'Item 1',
      'Item 2',
    ];

    final List<String> _imagePathActive = [
      'assets/images/specialist.png',
      'assets/images/dr-sani.jpg',
    ];

    final List<String> _specialistNameActive = [
      'Dato\' Dr Abdul Razak Rahman Hamzah',
      'Dato\' Dr Abdullah Sani Mohamed',
    ];

    final List<String> _specialistServiceActive = [
      'Ear, Nose & Throat',
      'Ear, Nose & Throat',
    ];

    final List<String> _appointmentDateSessionActive = [
      '31/12/2025 | Morning',
      '06/01/2025 | Morning',
    ];

    // Sample list items to display when Button 3 is clicked
    final List<String> _listPastItems = [
      'Item 1',
      'Item 2',
      'Item 3',
    ];

    final List<String> _imagePathsPast = [
      'assets/images/dr-nazatul-profile.jpg',
      'assets/images/dr-kartini-profile.jpg',
      'assets/images/dr-ahmad-murad-profile.jpg',
    ];

    final List<String> _specialistNamePast = [
      'Dr Nazatul Sabariah Ahmad',
      'Dr Kartini Farah Rahim',
      'Dr Ahmad Murad Zainuddin',
    ];

    final List<String> _specialistServicePast = [
      'Paediatric Dentistry',
      'Physician & Dermatology',
      'Obstetrician & Gynaecologist',
    ];

    final List<String> _appointmentDateSessionPast = [
      '17/11/2025 | Afternoon',
      '16/10/2024 | Evening',
      '24/08/2024 | Morning',
    ];

    final List<String> _currentYearAppointmentDateSessionPast = [
      '17/11/2025 | Afternoon',
      // '16/10/2024 | Evening',
      // '24/08/2024 | Morning',
    ];

    Map<String, dynamic>? appointmentData;

    List<String> _filteredAppointments = [];

    var _selectedYear;

    // Function to handle button press and update the selected button index
    void _onButtonPressed(int index) {
      setState(() {
        _selectedButtonIndex = index;
      });
    }

    @override
    void initState() {
      super.initState();
      _filteredAppointments = List.from(_currentYearAppointmentDateSessionPast); // Initially show all
      _loadGuestMode();
    }

    _loadGuestMode() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        _isGuestMode = (prefs.getBool('isGuest') ?? false);
      });
    }

    void _filterAppointmentsByYear(String year) {
      setState(() {
        if (year == currentYear.toString()) {
          _filteredAppointments = List.from(_currentYearAppointmentDateSessionPast);
        } else {
          _filteredAppointments = _appointmentDateSessionPast
              .where((appointment) => appointment.contains(year))
              .toList();
        }
      });
    }

    Widget _buildYearFilter() {
      final years = ["2025", "2024", "2023"]; // Dynamically add years as needed

      return AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        width: 110,
        height: 48,
        padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        decoration: BoxDecoration(
          color: Constants.violet,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 2,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: Align(
          alignment: Alignment.center,
          child: SizedBox(
            width: 95, // Set the desired width for the dropdown
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedYear,
                dropdownColor: Constants.violet,
                iconEnabledColor: Constants.violet,
                borderRadius: BorderRadius.circular(15.0),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _selectedYear = newValue;
                      debugPrint("Selected year: $_selectedYear"); // Debug log
                      _filterAppointmentsByYear(newValue);
                    });
                  }
                },
                items: years.map<DropdownMenuItem<String>>((String year) {
                  return DropdownMenuItem<String>(
                    value: year,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(width: 8),
                        Text(
                          year,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontFamily: 'WorkSans',
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
                hint: Row(
                  children: [
                    Icon(Icons.filter_alt_outlined, color: Colors.white),
                    SizedBox(width: 8), // Spacing between icon and text
                    Text(
                      "$currentYear",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: 'WorkSans',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
      );
    }

    Widget _selectPatientName() {
      List<String> membersname = ['Nani', 'Ira', 'Alep', 'Piqachu'];

      return Container(
          child: Container(
            margin: EdgeInsets.all(20),
            padding: const EdgeInsets.only(
              left: 15.0,
              right: 15.0,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Constants.violet,
            ),
            child: Column(
              children: <Widget>[
                DropdownButton<String>(
                  iconEnabledColor: Colors.white,
                  icon: Icon(Icons.expand_more),
                  underline: SizedBox(),
                  dropdownColor: Constants.violet,
                  isExpanded: true,
                  value: selectedUser, // Null by default to show placeholder
                  borderRadius: BorderRadius.circular(15.0),
                  items: [
                    DropdownMenuItem<String>(
                      value: null,
                      child: Text(
                        "${widget.name}",
                        style: TextStyle(
                          // color: Colors.white70,
                            color: Colors.white,
                            fontSize: 16,
                            fontFamily: 'WorkSans'
                        ), // Placeholder style
                      ),
                    ),
                    ...membersname.map((member) {
                      return DropdownMenuItem<String>(
                        value: member,
                        child: Text(
                          member,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontFamily: 'WorkSans'
                          ),
                        ),
                      );
                    }).toList(),
                  ],
                  onChanged: (String? user) {
                    setState(() {
                      selectedUser = user; // Update selected user
                    });
                  },
                ),
              ],
            ),
          ));
    }

    Widget myAppointments(int index) {
      _height = MediaQuery.of(context).size.height;
      _width = MediaQuery.of(context).size.width;

      return Container(
        padding: EdgeInsets.only(top: _height * 0.004, right: 10, left: _width * 0.05),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: Image.asset(
                    _imagePaths[index],
                    height: 100,
                    width: 100,
                  ),
                ),
                SizedBox(
                  width: _width * 0.01,
                ),
                Expanded( // Ensures details fit within the available space
                  child: appointmentData == null
                      ? myAppointmentDetails(index)
                      : myAppointmentDetails(index),
                ),
              ],
            ),
            SizedBox(height: 11),
            myAppointmentsButtons(),
          ],
        ),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: Colors.white,
            boxShadow: const [
              BoxShadow(
                color: Colors.grey,
                offset: Offset(
                  4.0,
                  4.0,
                ),
                blurRadius: 10.0,
                spreadRadius: 2.0,
              )
            ]
        ),
        height: _height * 0.23,
        margin: EdgeInsets.only(
            left: _width * 0.047, right: _width * 0.047, top: _height / 35
        ),
      );
    }

    Widget myAppointmentDetails(int index) {
      return SizedBox(
        width: _width * 0.59,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              // "${appointmentData!["doctor_name"] ?? "${_specialistName[index]}"}",
              "${_specialistName[index]}",
              style: TextStyle(
                  color: Colors.blueGrey,
                  fontFamily: 'WorkSans',
                  fontWeight: FontWeight.bold,
                  fontSize: 18.5
              ),
              textAlign: TextAlign.start,
              maxLines: 5,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 5),
            Text(
              // "${appointmentData!["service"] ?? "${_specialistName[index]}"}",
              "${_specialistService[index]}",
              style: TextStyle(
                  color: Colors.grey,
                  fontFamily: 'WorkSans',
                  fontSize: 12
              ),
              textAlign: TextAlign.start,
              maxLines: 5,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 5),
            Text(
              // "${appointmentData!["appointmentDate"] ?? ""}, ${appointmentData!["session"] ?? "${_specialistName[index]}"}",
              "${_appointmentDateSession[index]}",
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'WorkSans',
                  fontSize: 13
              ),
              textAlign: TextAlign.start,
              maxLines: 5,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 5),
          ],
        ),
        // margin: EdgeInsets.only(left: 0, right: _width / 18),
      );
    }

    Widget myActiveAppointments(int index) {
      _height = MediaQuery.of(context).size.height;
      _width = MediaQuery.of(context).size.width;

      return Container(
        height: _height * 0.28,
        margin: EdgeInsets.only(left: _width * 0.047, right: _width * 0.047, top: _height / 35),
        padding: EdgeInsets.only(left: _height * 0.015, right: 10, top: _height * 0.015),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: Colors.white,
            boxShadow: const [
              BoxShadow(
                color: Colors.grey,
                offset: Offset(
                  4.0,
                  4.0,
                ),
                blurRadius: 10.0,
                spreadRadius: 2.0,
              )
            ]
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15.0),
                    child: Image.asset(
                      _imagePathActive[index],
                      height: MediaQuery.of(context).size.height * 0.17,
                      width: MediaQuery.of(context).size.width * 0.26,
                      fit: BoxFit.cover,
                    ),
                  ),
                SizedBox(
                  width: _width * 0.03,
                ),
                Expanded( // Ensures details fit within the available space
                  child: appointmentData == null
                      ? myActiveAppointmentDetails(index)
                      : myAppointmentDetails(index),
                ),
              ],
            ),
            Spacer(),
            myAppointmentsButtons(),
          ],
        ),
      );
    }

    Widget myActiveAppointmentDetails(int index) {
      return SizedBox(
        width: MediaQuery.of(context).size.width * 0.55,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              // "${appointmentData!["doctor_name"] ?? "${_specialistName[index]}"}",
              "${_specialistNameActive[index]}",
              style: TextStyle(
                  color: turquoise,
                  fontFamily: 'WorkSans',
                  fontWeight: FontWeight.bold,
                  fontSize: 18
              ),
              textAlign: TextAlign.start,
              maxLines: 5,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 5),
            Text(
              // "${appointmentData!["service"] ?? "${_specialistName[index]}"}",
              "${_specialistServiceActive[index]}",
              style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'WorkSans',
                  fontSize: 14
              ),
              textAlign: TextAlign.start,
              maxLines: 5,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 5),
            Text(
              // "${appointmentData!["appointmentDate"] ?? ""}, ${appointmentData!["session"] ?? "${_specialistName[index]}"}",
              "${_appointmentDateSessionActive[index]}",
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'WorkSans',
                  fontSize: 13
              ),
              textAlign: TextAlign.start,
              maxLines: 5,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 5),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6), // Padding inside the "button"
              decoration: BoxDecoration(
                color: Color(0xFF1fbeec),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
              "Pre-booking",
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
                fontFamily: 'WorkSans'
              ),
            ),
          )
          ],
        ),
        // margin: EdgeInsets.only(left: 0, right: _width / 18),
      );
    }

    Widget myPastAppointments(String appointment, int index) {
      _height = MediaQuery.of(context).size.height;
      _width = MediaQuery.of(context).size.width;

      return Container(
        padding: EdgeInsets.only(top: _height * 0.002, right: 10, left: _width * 0.05),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: Image.asset(
                    _imagePathsPast[index],
                    height: 100,
                    width: 100,
                  ),
                ),
                SizedBox(
                  width: _width * 0.01,
                ),
                Expanded(
                  child: appointmentData == null
                      ? myPastAppointmentDetails(index)
                      : myAppointmentDetails(index),
                ),
              ],
            ),
            SizedBox(height: 15),
            myPastAppointmentsButtons(),
          ],
        ),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: Colors.white,
            boxShadow: const [
              BoxShadow(
                color: Colors.grey,
                offset: Offset(
                  4.0,
                  4.0,
                ),
                blurRadius: 10.0,
                spreadRadius: 2.0,
              )
            ]
        ),
        height: _height * 0.23,
        margin: EdgeInsets.only(
            left: _width * 0.047, right: _width * 0.047, top: _height / 35
        ),
      );
    }

    Widget myPastAppointmentDetails(int index) {
      return SizedBox(
        width: _width * 0.59,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              // "${appointmentData!["doctor_name"] ?? "${_specialistName[index]}"}",
              "${_specialistNamePast[index]}",
              style: TextStyle(
                  color: turquoise,
                  fontFamily: 'WorkSans',
                  fontWeight: FontWeight.bold,
                  fontSize: 18.5
              ),
              textAlign: TextAlign.start,
              maxLines: 5,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 5),
            Text(
              // "${appointmentData!["service"] ?? "${_specialistName[index]}"}",
              "${_specialistServicePast[index]}",
              style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'WorkSans',
                  fontSize: 13
              ),
              textAlign: TextAlign.start,
              maxLines: 5,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 5),
            Text(
              // "${appointmentData!["appointmentDate"] ?? ""}, ${appointmentData!["session"] ?? "${_specialistName[index]}"}",
              "${_appointmentDateSessionPast[index]}",
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'WorkSans',
                  fontSize: 13
              ),
              textAlign: TextAlign.start,
              maxLines: 5,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 5),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6), // Padding inside the "button"
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                "Discharged",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    fontFamily: 'WorkSans'
                ),
              ),
            )
          ],
        ),
        // margin: EdgeInsets.only(left: 0, right: _width / 18),
      );
    }

    Widget myAppointmentsButtons() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: TextButton(
              onPressed: () async {},
              style: TextButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                primary: Colors.white,
                minimumSize: Size(0, MediaQuery.of(context).size.width * 0.0035),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: Text(
                'Reschedule'.tr,
                style: const TextStyle(
                  fontFamily: 'WorkSans',
                  fontSize: 15,
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 18, // Space between buttons
          ),
          Expanded(
            child: TextButton(
              onPressed: () async {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => appointmentDetails(
                      name: widget.name,
                      email: widget.email,
                      phone: widget.phone,
                      mrn: widget.mrn,
                      locationGroup: widget.locationGroup,
                      hospitalId: widget.hospitalId,
                      hospitalName: widget.hospitalName,
                      clinicName: widget.clinicName,
                      doctorName: widget.doctorName,
                      doctorImage: widget.doctorImage,
                      appointmentReason: widget.appointmentReason,
                      selectedOption: widget.selectedOption,
                      selectedDate: widget.selectedDate,
                      mapData: widget.mapData,
                    ),
                  ),
                      (Route<dynamic> route) => false,
                );
              },
              style: TextButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor, // Replaces FlatButton's `color`
                primary: Colors.white, // Replaces FlatButton's `textColor`
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8), // Adjust padding
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15), // Same as FlatButton's `shape`
                ),
                minimumSize: Size(0, MediaQuery.of(context).size.width * 0.0035),
              ),
              child: Text(
                'Details'.tr,
                style: const TextStyle(
                  fontFamily: 'WorkSans',
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ],
      );

    }

    Widget myPastAppointmentsButtons() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center, // Center the buttons horizontally
        children: <Widget>[
          SizedBox(
            width: 200, // Set the desired width
            child: TextButton(
              onPressed: () async {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => appointmentDetails(
                      name: widget.name,
                      email: widget.email,
                      phone: widget.phone,
                      mrn: widget.mrn,
                      locationGroup: widget.locationGroup,
                      hospitalId: widget.hospitalId,
                      hospitalName: widget.hospitalName,
                      clinicName: widget.clinicName,
                      doctorName: widget.doctorName,
                      doctorImage: widget.doctorImage,
                      appointmentReason: widget.appointmentReason,
                      selectedOption: widget.selectedOption,
                      selectedDate: widget.selectedDate,
                      mapData: widget.mapData,
                    ),
                  ),
                      (Route<dynamic> route) => false,
                );
              },
              style: TextButton.styleFrom(
                backgroundColor: Constants.violet,
                primary: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                minimumSize: Size(0, 35),
              ),
              child: Text(
                'Details'.tr,
                style: const TextStyle(
                  fontFamily: 'WorkSans',
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ],
      );
    }


    @override
    Widget build(BuildContext context) {

      _height = MediaQuery.of(context).size.height;
      _width = MediaQuery.of(context).size.width;

      return KeyboardDismisser(
        gestures: [
         GestureType.onTap,
         GestureType.onPanUpdateDownDirection
        ],
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: Constants.violet,
              title: Text(
                'My Appointments'.tr,
                style: TextStyle(
                    fontSize: _width * 0.05,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'WorkSans'
                ),
              ),
              centerTitle: true,
              leading: IconButton(
                onPressed: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage(
                    name: widget.name.toString(),
                    email: widget.email.toString(),
                    phone: widget.phone.toString(),
                    mrn: widget.mrn.toString(),
                  ),
                  ),
                ),
                icon: Icon(
                    Icons.arrow_back_rounded,
                    color: Colors.white,
                    size: _width * 0.06
                ),
              ),
              elevation: 10,
            ),
            backgroundColor: Colors.grey.shade200,
            body: Padding(
                padding: const EdgeInsets.all(6.0),
                child: Container(
                  height: _height * 1.50,
                  decoration: BoxDecoration(
                    color: Colors.white, // Background color of the container
                    borderRadius: BorderRadius.circular(20), // Circular border radius
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(20.0), // Add padding around the entire stack
                            child: Stack(
                              children: [
                                // Background Container for Buttons
                                Container(
                                  width: _width * 1.5,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                ),
                                // Sliding Indicator
                                AnimatedAlign(
                                  duration: Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                  alignment: _selectedButtonIndex == 1
                                      ? Alignment.centerLeft
                                      : Alignment.centerRight,
                                  child: Container(
                                    width: _width * 0.4,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: Constants.violet,
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                  ),
                                ),
                                // Active & Past Buttons
                                Positioned(
                                  // top: 10.0, // Adjust the top position
                                  left: 0.05, // Adjust the left position
                                  right: 190.0, // Adjust the right position if needed
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8.0), // Padding between buttons
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        SizedBox(
                                          width: _width / 4,
                                          height: 50,
                                          child: ElevatedButton(
                                            onPressed: () => _onButtonPressed(1),
                                            style: ElevatedButton.styleFrom(
                                              primary: Colors.transparent,
                                              shadowColor: Colors.transparent,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(20),
                                                side: BorderSide(color: Colors.transparent),
                                              ),
                                              padding: EdgeInsets.zero, // Remove default padding
                                            ),
                                            child: Text(
                                              'Active',
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontFamily: 'WorkSans',
                                                color: _selectedButtonIndex == 1
                                                    ? Colors.white
                                                    : Constants.violet,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Positioned(
                                  // top: 10.0, // Adjust the top position
                                  left: 190.0, // Adjust the left position
                                  right: 0.05, // Adjust the right position if needed
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8.0), // Padding between buttons
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        SizedBox(
                                          width: _width / 4,
                                          height: 50,
                                          child: ElevatedButton(
                                            onPressed: () => _onButtonPressed(2),
                                            style: ElevatedButton.styleFrom(
                                              primary: Colors.transparent,
                                              shadowColor: Colors.transparent,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(20),
                                                side: BorderSide(color: Colors.transparent),
                                              ),
                                            ),
                                            child: Text(
                                              'Past',
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontFamily: 'WorkSans',
                                                color: _selectedButtonIndex == 2
                                                    ? Colors.white
                                                    : Constants.violet,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        _isGuestMode == false ? _selectPatientName() : Container(),
                        if (_selectedButtonIndex == 2)
                        Align(
                            alignment: Alignment.centerRight, // Aligns the widget to the right side
                            child: Padding(
                              padding: const EdgeInsets.only(
                                left: 15.0,
                                right: 18.0,
                              ),
                              child: _buildYearFilter(),
                            )
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        if (_selectedButtonIndex == 1)
                          SingleChildScrollView(
                            child: Container(
                              height: _height * 0.80, // height for the ListView
                              child: Card(
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: _listActiveItems.length, // Number of items in the list
                                  itemBuilder: (context, index) {
                                    return myActiveAppointments(index);
                                  },
                                ),
                              ),
                            ),
                          )
                        else if (_selectedButtonIndex == 2)
                          SingleChildScrollView(
                            child: Container(
                              height: _height * 0.80, // Fixed height for the ListView
                              child: Card(
                                child: ListView.builder(
                                  shrinkWrap: true, // Ensures the ListView only takes as much height as it needs
                                  itemCount: _filteredAppointments.length, // Number of items in the list
                                  itemBuilder: (context, index) {
                                    final originalIndex = _appointmentDateSessionPast.indexOf(_filteredAppointments[index]);
                                    return myPastAppointments(_filteredAppointments[index], originalIndex);
                                  },
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                )
            ),
            bottomNavigationBar:
            Container(
              margin: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
              child:
              ElevatedButton(
                onPressed: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => ChooseHospital(name: widget.name, email: widget.email, phone: widget.phone, mrn: widget.mrn)
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Book Appointment'.tr,
                      style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'WorkSans'
                      ),
                    ),
                  ],
                ),
                style: ElevatedButton.styleFrom(
                  elevation: 5,
                  primary: Constants.violet,
                  padding: EdgeInsets.all(_width * 0.05),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            )
        ),
      );

    }

  }

