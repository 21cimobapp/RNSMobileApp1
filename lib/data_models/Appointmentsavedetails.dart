import 'dart:convert';

class Appointmentsavedetails {
  String Token;
  String PatientCode;
  String DoctorCode;
  String ApptDate;
  String SlotName;
  String SlotNumber;
  String DoctorSlotFromTime;
  String DoctorSlotToTime;
  String PaymentModeCode;
  String OrganizationCode;
  String AppointmentType;
  String SlotTimeLabel;

  Appointmentsavedetails(
      this.Token,
      this.PatientCode,
      this.DoctorCode,
      this.ApptDate,
      this.SlotName,
      this.SlotNumber,
      this.DoctorSlotFromTime,
      this.DoctorSlotToTime,
      this.PaymentModeCode,
      this.OrganizationCode,
      this.AppointmentType,
      this.SlotTimeLabel);

  Appointmentsavedetails.fromJson(Map<String, dynamic> json) {
    Token = json["Token"];
    PatientCode = json["PatientCode"];
    DoctorCode = json["DoctorCode"];
    ApptDate = json["ApptDate"];
    SlotName = json["SlotName"];
    SlotNumber = json["SlotNumber"];
    DoctorSlotFromTime = json["DoctorSlotFromTime"];
    DoctorSlotToTime = json["DoctorSlotToTime"];
    OrganizationCode = json["OrganizationCode"];
    PaymentModeCode = json["PaymentModeCode"];
    AppointmentType = json["AppointmentType"];
    SlotTimeLabel = json["SlotTimeLabel"];
  }
  String toJson(Appointmentsavedetails savedetail) {
    var mapData = new Map();
    mapData["Token"] = savedetail.Token;
    mapData["PatientCode"] = savedetail.PatientCode;
    mapData["DoctorCode"] = savedetail.DoctorCode;
    mapData["ApptDate"] = savedetail.ApptDate;
    mapData["SlotName"] = savedetail.SlotName;
    mapData["SlotNumber"] = savedetail.SlotNumber;
    mapData["DoctorSlotFromTime"] = savedetail.DoctorSlotFromTime;
    mapData["DoctorSlotToTime"] = savedetail.DoctorSlotToTime;
    mapData["OrganizationCode"] = savedetail.OrganizationCode;
    mapData["PaymentModeCode"] = savedetail.PaymentModeCode;
    mapData["AppointmentType"] = savedetail.AppointmentType;

    String json = jsonEncode(mapData); //JSON.encode(mapData);
    return json;
  }
}
