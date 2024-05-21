class UnbordingContent {
  String title;
  String description;
  String lottie;

  UnbordingContent(
      {required this.lottie, required this.title, required this.description});
}

List<UnbordingContent> contents = [
  UnbordingContent(
      title: 'Online Appointment',
      lottie: 'assets/images/onboard_online_appointment_new.json',
      description:
          "View, manage and book an appointment whenever you need from the "
          "convenience of your mobile device. With real-time scheduling, "
          "your booking will be directly saved into our Hospital Information System (HIS). "),
  UnbordingContent(
      title: 'Auto Reminders',
      lottie: 'assets/images/onboard_auto_reminders.json',
      description:
          "Get instant reminders for every appointment you book, cancel or reschedule. "
          "Say goodbye to missed appointments. "),
  UnbordingContent(
      title: 'Live Queue',
      lottie: 'assets/images/onboard_live_queue.json',
      description:
          "Get your queue number and position without the need to wait in the clinic. "
          "Take control of your own waiting time. "),
  UnbordingContent(
      title: 'Health Record',
      lottie: 'assets/images/onboard_health_record.json',
      description:
          "Offering a convenient method for accessing your health record. "),
  UnbordingContent(
      title: 'Welcome',
      lottie: 'assets/images/onboard_doctor_welcoming.json',
      description: "With Us, It’s Always Personal. "),
];
