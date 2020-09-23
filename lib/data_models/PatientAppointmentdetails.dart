class PatientAppointmentdetails {
  String PatientCode;
  String PatientName;
  String DoctorCode;
  String DoctorName;
  String DoctorDesignation;
  DateTime ApptDate;
  String SlotName;
  String SlotNumber;
  String DoctorSlotFromTime;
  String DoctorSlotToTime;
  String SlotTimeLabel;
  String AppointmentType;

  PatientAppointmentdetails(
    this.PatientCode,
    this.PatientName,
    this.DoctorCode,
    this.DoctorName,
    this.DoctorDesignation,
    this.ApptDate,
    this.SlotName,
    this.SlotNumber,
    this.DoctorSlotFromTime,
    this.DoctorSlotToTime,
    this.SlotTimeLabel,
    this.AppointmentType,
  );
  // PatientAppointmentdetails.fromJson(Map<String, dynamic> json) {
  //   PatientCode = json["PatientCode"];
  //   PatientName = json["PatientName"];
  //   DoctorCode = json["DoctorCode"];
  //   DoctorName = json["DoctorName"];
  //   DoctorDesignation = json["DoctorDesignation"];
  //   ApptDate = json["ApptDate"];
  //   SlotName = json["SlotName"];
  //   SlotNumber = json["SlotNumber"];
  //   DoctorSlotFromTime = json["DoctorSlotFromTime"];
  //   DoctorSlotToTime = json["DoctorSlotToTime"];
  //   SlotTimeLabel = json["SlotTimeLabel"];
  //   AppointmentType = json["AppointmentType"];
  // }
}

class PatientAppointment {
  String SlotAvailable;
  String DoctorTimingSlotName;
  String DoctorSlotFromTime;
  String DoctorSlotToTime;
  String SlotTimeLabel;
  String AppointmentType;

  PatientAppointment(
      this.SlotAvailable,
      this.DoctorTimingSlotName,
      this.DoctorSlotFromTime,
      this.DoctorSlotToTime,
      this.SlotTimeLabel,
      this.AppointmentType);
  PatientAppointment.fromJson(Map<String, dynamic> json) {
    SlotAvailable = json["SlotAvailable"];
    DoctorTimingSlotName = json["DoctorTimingSlotName"];
    DoctorSlotFromTime = json["DoctorSlotFromTime"];
    DoctorSlotToTime = json["DoctorSlotToTime"];
    SlotTimeLabel = json["SlotTimeLabel"];
    AppointmentType = json["AppointmentType"];
  }
}
