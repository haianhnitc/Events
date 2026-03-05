class EventModel {
  final int id;
  final String img;
  final String category;
  final String name;
  final String address;
  final String hours;
  final String date;
  final String organization;
  final int memberRegister;
  final int slots;
  final String price;
  final String certificate;
  final String format; // e.g., Workshop, Talkshow, Training
  final String target; // e.g., Students, Developers, Public
  final bool
      hasStudent5Certificate; // whether event grants 'chứng chỉ sinh viên 5 tốt'
  // Richer fields
  final String? description;
  final List<Map<String, String>>?
      speakers; // [{"name":"...","title":"...","avatar":"asset/path"}]
  final List<Map<String, String>>?
      schedule; // [{"time":"09:00","title":"Opening"}]
  final String? venueName;
  final double? latitude;
  final double? longitude;
  final String contactEmail;
  final String contactPhone;
  final String registrationUrl;
  final List<String> tags;

  EventModel({
    required this.id,
    required this.img,
    required this.category,
    required this.name,
    required this.address,
    required this.hours,
    required this.date,
    required this.organization,
    required this.memberRegister,
    required this.slots,
    required this.price,
    required this.certificate,
    required this.format,
    required this.target,
    required this.hasStudent5Certificate,
    this.description,
    this.speakers,
    this.schedule,
    this.venueName,
    this.latitude,
    this.longitude,
    this.contactEmail = '',
    this.contactPhone = '',
    this.registrationUrl = '',
    this.tags = const [],
  });

  factory EventModel.fromMap(Map<String, dynamic> m) => EventModel(
        id: m['id'] as int,
        img: m['img'] as String,
        category: m['category'] as String,
        name: m['name'] as String,
        address: m['address'] as String,
        hours: m['hours'] as String,
        date: m['date'] as String,
        organization: m['organization'] as String,
        memberRegister: (m['memberResgiter'] as num).toInt(),
        slots: (m['slots'] as num).toInt(),
        price: m['price'].toString(),
        certificate: m['certificate'].toString(),
        format: m['format']?.toString() ?? m['certificate']?.toString() ?? '',
        target: m['target']?.toString() ?? '',
        hasStudent5Certificate: (m['hasStudent5'] is bool)
            ? m['hasStudent5'] as bool
            : (m['hasStudent5']?.toString().toLowerCase() == 'true'),
        description: m['description']?.toString(),
        speakers: (m['speakers'] is List)
            ? (m['speakers'] as List)
                .map((e) => Map<String, String>.from(e as Map))
                .toList()
            : null,
        schedule: (m['schedule'] is List)
            ? (m['schedule'] as List)
                .map((e) => Map<String, String>.from(e as Map))
                .toList()
            : null,
        venueName: m['venueName']?.toString(),
        latitude:
            (m['latitude'] is num) ? (m['latitude'] as num).toDouble() : null,
        longitude:
            (m['longitude'] is num) ? (m['longitude'] as num).toDouble() : null,
        contactEmail: m['contactEmail']?.toString() ?? '',
        contactPhone: m['contactPhone']?.toString() ?? '',
        registrationUrl: m['registrationUrl']?.toString() ?? '',
        tags: (m['tags'] is List)
            ? (m['tags'] as List).map((e) => e.toString()).toList()
            : const [],
      );
}
