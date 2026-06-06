import 'package:kalivra/model/association/association_link_request_draft.dart';

class AssociationMemberProfile {
  const AssociationMemberProfile({
    required this.personal,
    this.membershipStatusPercent = 0,
    this.paymentCommitmentPercent = 0,
    this.paymentYears = const [],
    this.financialSummary = const AssociationFinancialSummary(),
    this.installments = const [],
    this.otherPayments = const [],
    this.notifications = const [],
    this.events = const [],
    this.measurements = const [],
    this.attachments = const [],
  });

  final AssociationMemberPersonal personal;
  final double membershipStatusPercent;
  final double paymentCommitmentPercent;
  final List<int> paymentYears;
  final AssociationFinancialSummary financialSummary;
  final List<AssociationInstallment> installments;
  final List<AssociationOtherPayment> otherPayments;
  final List<AssociationMemberNotification> notifications;
  final List<AssociationMemberEvent> events;
  final List<AssociationMeasurement> measurements;
  final List<AssociationMemberAttachment> attachments;

  factory AssociationMemberProfile.fromJson(Map<String, dynamic> json) {
    return AssociationMemberProfile(
      personal: AssociationMemberPersonal.fromJson(
        Map<String, dynamic>.from(json['personal'] as Map? ?? json),
      ),
      membershipStatusPercent: _toPercent(json['membership_status_percent']),
      paymentCommitmentPercent: _toPercent(json['payment_commitment_percent']),
      paymentYears: _parseYears(json['payment_years']),
      financialSummary: AssociationFinancialSummary.fromJson(
        Map<String, dynamic>.from(json['financial_summary'] as Map? ?? {}),
      ),
      installments: _parseList(
        json['installments'],
        AssociationInstallment.fromJson,
      ),
      otherPayments: _parseList(
        json['other_payments'],
        AssociationOtherPayment.fromJson,
      ),
      notifications: _parseList(
        json['notifications'],
        AssociationMemberNotification.fromJson,
      ),
      events: _parseList(json['events'], AssociationMemberEvent.fromJson),
      measurements: _parseList(
        json['measurements'],
        AssociationMeasurement.fromJson,
      ),
      attachments: _parseList(
        json['attachments'],
        AssociationMemberAttachment.fromJson,
      ),
    );
  }

  factory AssociationMemberProfile.fromLinkRequest(
    AssociationLinkRequestDraft draft,
  ) {
    final currentAddress = [
      draft.governorate,
      draft.city,
      draft.town,
      draft.municipality,
      draft.street,
      draft.building,
    ].where((part) => part.trim().isNotEmpty).join(' - ');

    return AssociationMemberProfile(
      personal: AssociationMemberPersonal(
        fullName: [
          draft.firstName,
          draft.kunya,
          draft.fatherName,
        ].where((part) => part.trim().isNotEmpty).join(' '),
        membershipNumber: draft.membershipNumber,
        priorityNumber: draft.priorityNumber,
        mobile: draft.mobile,
        whatsApp: draft.whatsApp,
        email: draft.email,
        currentAddress: currentAddress,
        permanentAddress: draft.permanentAddress,
        governorate: draft.governorate,
        city: draft.city,
        town: draft.town,
        village: draft.municipality,
        street: draft.street,
        building: draft.building,
        projectName: draft.projectName,
        housingUnit: draft.housingUnit,
      ),
      financialSummary: AssociationFinancialSummary(
        totalAmount: _parseAmount(draft.totalPayments),
      ),
    );
  }

  static double _toPercent(dynamic raw) {
    if (raw == null) return 0;
    if (raw is num) return (raw / (raw > 1 ? 100 : 1)).clamp(0.0, 1.0);
    final parsed = double.tryParse(raw.toString());
    if (parsed == null) return 0;
    return (parsed > 1 ? parsed / 100 : parsed).clamp(0.0, 1.0);
  }

  static double _parseAmount(String raw) {
    final normalized = raw.replaceAll(RegExp(r'[^\d.]'), '');
    return double.tryParse(normalized) ?? 0;
  }

  static List<int> _parseYears(dynamic raw) {
    if (raw is! List) return const [];
    return raw
        .map((e) => int.tryParse(e.toString()))
        .whereType<int>()
        .toList();
  }

  static List<T> _parseList<T>(
    dynamic raw,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    if (raw is! List) return const [];
    return raw
        .whereType<Map>()
        .map((e) => fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }
}

class AssociationMemberPersonal {
  const AssociationMemberPersonal({
    this.fullName = '',
    this.membershipNumber = '',
    this.priorityNumber = '',
    this.mobile = '',
    this.whatsApp = '',
    this.email = '',
    this.currentAddress = '',
    this.permanentAddress = '',
    this.governorate = '',
    this.city = '',
    this.town = '',
    this.village = '',
    this.street = '',
    this.building = '',
    this.projectName = '',
    this.housingUnit = '',
  });

  final String fullName;
  final String membershipNumber;
  final String priorityNumber;
  final String mobile;
  final String whatsApp;
  final String email;
  final String currentAddress;
  final String permanentAddress;
  final String governorate;
  final String city;
  final String town;
  final String village;
  final String street;
  final String building;
  final String projectName;
  final String housingUnit;

  factory AssociationMemberPersonal.fromJson(Map<String, dynamic> json) {
    return AssociationMemberPersonal(
      fullName: json['full_name']?.toString() ?? json['name']?.toString() ?? '',
      membershipNumber: json['membership_number']?.toString() ?? '',
      priorityNumber: json['priority_number']?.toString() ?? '',
      mobile: json['mobile']?.toString() ?? '',
      whatsApp: json['whatsapp']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      currentAddress: json['current_address']?.toString() ?? '',
      permanentAddress: json['permanent_address']?.toString() ?? '',
      governorate: json['governorate']?.toString() ?? '',
      city: json['city']?.toString() ?? '',
      town: json['town']?.toString() ?? '',
      village: json['village']?.toString() ?? json['municipality']?.toString() ?? '',
      street: json['street']?.toString() ?? '',
      building: json['building']?.toString() ?? '',
      projectName: json['project_name']?.toString() ?? '',
      housingUnit: json['housing_unit']?.toString() ?? '',
    );
  }
}

class AssociationFinancialSummary {
  const AssociationFinancialSummary({
    this.totalAmount = 0,
    this.paidAmount = 0,
    this.remainingInstallments = 0,
  });

  final double totalAmount;
  final double paidAmount;
  final int remainingInstallments;

  factory AssociationFinancialSummary.fromJson(Map<String, dynamic> json) {
    return AssociationFinancialSummary(
      totalAmount: _amount(json['total_amount']),
      paidAmount: _amount(json['paid_amount']),
      remainingInstallments:
          (json['remaining_installments'] as num?)?.toInt() ?? 0,
    );
  }

  static double _amount(dynamic raw) {
    if (raw == null) return 0;
    if (raw is num) return raw.toDouble();
    return double.tryParse(raw.toString().replaceAll(',', '')) ?? 0;
  }
}

class AssociationInstallment {
  const AssociationInstallment({
    this.label = '',
    this.amount = 0,
    this.date = '',
    this.status = '',
    this.notes = '',
    this.year,
  });

  final String label;
  final double amount;
  final String date;
  final String status;
  final String notes;
  final int? year;

  factory AssociationInstallment.fromJson(Map<String, dynamic> json) {
    return AssociationInstallment(
      label: json['label']?.toString() ?? json['payment']?.toString() ?? '',
      amount: AssociationFinancialSummary._amount(json['amount']),
      date: json['date']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      notes: json['notes']?.toString() ?? '',
      year: (json['year'] as num?)?.toInt(),
    );
  }
}

class AssociationOtherPayment {
  const AssociationOtherPayment({
    this.amount = 0,
    this.date = '',
    this.method = '',
    this.bank = '',
    this.receipt = '',
    this.notes = '',
    this.year,
  });

  final double amount;
  final String date;
  final String method;
  final String bank;
  final String receipt;
  final String notes;
  final int? year;

  factory AssociationOtherPayment.fromJson(Map<String, dynamic> json) {
    return AssociationOtherPayment(
      amount: AssociationFinancialSummary._amount(json['amount']),
      date: json['date']?.toString() ?? '',
      method: json['method']?.toString() ?? '',
      bank: json['bank']?.toString() ?? '',
      receipt: json['receipt']?.toString() ?? '',
      notes: json['notes']?.toString() ?? '',
      year: (json['year'] as num?)?.toInt(),
    );
  }
}

class AssociationMemberNotification {
  const AssociationMemberNotification({
    this.date = '',
    this.type = '',
    this.title = '',
    this.isRead = false,
  });

  final String date;
  final String type;
  final String title;
  final bool isRead;

  factory AssociationMemberNotification.fromJson(Map<String, dynamic> json) {
    return AssociationMemberNotification(
      date: json['date']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      isRead: json['is_read'] == true || json['read'] == true,
    );
  }
}

class AssociationMemberEvent {
  const AssociationMemberEvent({
    this.date = '',
    this.title = '',
    this.location = '',
    this.status = '',
  });

  final String date;
  final String title;
  final String location;
  final String status;

  factory AssociationMemberEvent.fromJson(Map<String, dynamic> json) {
    return AssociationMemberEvent(
      date: json['date']?.toString() ?? '',
      title: json['title']?.toString() ?? json['event']?.toString() ?? '',
      location: json['location']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
    );
  }
}

class AssociationMeasurement {
  const AssociationMeasurement({
    this.date = '',
    this.value = '',
    this.notes = '',
  });

  final String date;
  final String value;
  final String notes;

  factory AssociationMeasurement.fromJson(Map<String, dynamic> json) {
    return AssociationMeasurement(
      date: json['date']?.toString() ?? '',
      value: json['value']?.toString() ?? '',
      notes: json['notes']?.toString() ?? '',
    );
  }
}

class AssociationMemberAttachment {
  const AssociationMemberAttachment({
    this.name = '',
    this.type = '',
    this.url = '',
  });

  final String name;
  final String type;
  final String url;

  factory AssociationMemberAttachment.fromJson(Map<String, dynamic> json) {
    return AssociationMemberAttachment(
      name: json['name']?.toString() ?? json['title']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      url: json['url']?.toString() ?? '',
    );
  }
}
