// country_model.dart

import 'package:qrpaypro/widgets/inputs/custom_country_drop_down.dart';

class Country implements DropdownModel {
  final int id;
  final String name;
  final String mobileCode;
  final String currencyName;
  final String currencyCode;
  final String iso2;
  final String flag;

  Country({
    required this.id,
    required this.name,
    required this.mobileCode,
    required this.currencyName,
    required this.currencyCode,
    required this_iso2,
    @override required this.flag,
  }) : iso2 =
           this_iso2; // Handle potential conflict with a variable named 'iso2'

  // Factory constructor to create a Country from a Map
  factory Country.fromMap(Map<String, dynamic> map) {
    return Country(
      id: map['id'] as int,
      name: map['name'] as String,
      mobileCode: map['mobile_code'] as String,
      currencyName: map['currency_name'] as String,
      currencyCode: map['currency_code'] as String,
      this_iso2:
          map['iso2'] as String, // Use a different name to avoid conflict
      flag: map['flag'] as String,
    );
  }

  @override
  String? get iso2Used => iso2;

  @override
  String get title => name;

  @override
  String get flagImg => flag;
}
