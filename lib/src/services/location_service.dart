import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationService {
  static const Map<String, Map<String, String>> _countryCurrencies = {
    'Uganda': {'code': 'UGX', 'name': 'Ugandan Shilling'},
    'Kenya': {'code': 'KES', 'name': 'Kenyan Shilling'},
    'Tanzania': {'code': 'TZS', 'name': 'Tanzanian Shilling'},
    'Rwanda': {'code': 'RWF', 'name': 'Rwandan Franc'},
    'Burundi': {'code': 'BIF', 'name': 'Burundian Franc'},
    'South Sudan': {'code': 'SSP', 'name': 'South Sudanese Pound'},
    'Democratic Republic of the Congo': {'code': 'CDF', 'name': 'Congolese Franc'},
    'Ethiopia': {'code': 'ETB', 'name': 'Ethiopian Birr'},
    'Somalia': {'code': 'SOS', 'name': 'Somali Shilling'},
    'South Africa': {'code': 'ZAR', 'name': 'South African Rand'},
    'Nigeria': {'code': 'NGN', 'name': 'Nigerian Naira'},
    'Ghana': {'code': 'GHS', 'name': 'Ghanaian Cedi'},
    'Egypt': {'code': 'EGP', 'name': 'Egyptian Pound'},
    'Morocco': {'code': 'MAD', 'name': 'Moroccan Dirham'},
    'Algeria': {'code': 'DZD', 'name': 'Algerian Dinar'},
    'Tunisia': {'code': 'TND', 'name': 'Tunisian Dinar'},
    'Libya': {'code': 'LYD', 'name': 'Libyan Dinar'},
    'Botswana': {'code': 'BWP', 'name': 'Botswana Pula'},
    'Namibia': {'code': 'NAD', 'name': 'Namibian Dollar'},
    'Zimbabwe': {'code': 'ZWL', 'name': 'Zimbabwean Dollar'},
    'Zambia': {'code': 'ZMW', 'name': 'Zambian Kwacha'},
    'Malawi': {'code': 'MWK', 'name': 'Malawian Kwacha'},
    'Mozambique': {'code': 'MZN', 'name': 'Mozambican Metical'},
    'Angola': {'code': 'AOA', 'name': 'Angolan Kwanza'},
    'Cameroon': {'code': 'XAF', 'name': 'Central African CFA Franc'},
    'Chad': {'code': 'XAF', 'name': 'Central African CFA Franc'},
    'Central African Republic': {'code': 'XAF', 'name': 'Central African CFA Franc'},
    'Equatorial Guinea': {'code': 'XAF', 'name': 'Central African CFA Franc'},
    'Gabon': {'code': 'XAF', 'name': 'Central African CFA Franc'},
    'Republic of the Congo': {'code': 'XAF', 'name': 'Central African CFA Franc'},
    'Senegal': {'code': 'XOF', 'name': 'West African CFA Franc'},
    'Mali': {'code': 'XOF', 'name': 'West African CFA Franc'},
    'Burkina Faso': {'code': 'XOF', 'name': 'West African CFA Franc'},
    'Niger': {'code': 'XOF', 'name': 'West African CFA Franc'},
    'Ivory Coast': {'code': 'XOF', 'name': 'West African CFA Franc'},
    'Guinea-Bissau': {'code': 'XOF', 'name': 'West African CFA Franc'},
    'Togo': {'code': 'XOF', 'name': 'West African CFA Franc'},
    'Benin': {'code': 'XOF', 'name': 'West African CFA Franc'},
    'United States': {'code': 'USD', 'name': 'US Dollar'},
    'Canada': {'code': 'CAD', 'name': 'Canadian Dollar'},
    'United Kingdom': {'code': 'GBP', 'name': 'British Pound'},
    'Germany': {'code': 'EUR', 'name': 'Euro'},
    'France': {'code': 'EUR', 'name': 'Euro'},
    'Spain': {'code': 'EUR', 'name': 'Euro'},
    'Italy': {'code': 'EUR', 'name': 'Euro'},
    'Netherlands': {'code': 'EUR', 'name': 'Euro'},
    'Belgium': {'code': 'EUR', 'name': 'Euro'},
    'Austria': {'code': 'EUR', 'name': 'Euro'},
    'Portugal': {'code': 'EUR', 'name': 'Euro'},
    'Ireland': {'code': 'EUR', 'name': 'Euro'},
    'Finland': {'code': 'EUR', 'name': 'Euro'},
    'Greece': {'code': 'EUR', 'name': 'Euro'},
    'Luxembourg': {'code': 'EUR', 'name': 'Euro'},
    'Malta': {'code': 'EUR', 'name': 'Euro'},
    'Cyprus': {'code': 'EUR', 'name': 'Euro'},
    'Slovakia': {'code': 'EUR', 'name': 'Euro'},
    'Slovenia': {'code': 'EUR', 'name': 'Euro'},
    'Estonia': {'code': 'EUR', 'name': 'Euro'},
    'Latvia': {'code': 'EUR', 'name': 'Euro'},
    'Lithuania': {'code': 'EUR', 'name': 'Euro'},
    'Switzerland': {'code': 'CHF', 'name': 'Swiss Franc'},
    'Norway': {'code': 'NOK', 'name': 'Norwegian Krone'},
    'Sweden': {'code': 'SEK', 'name': 'Swedish Krona'},
    'Denmark': {'code': 'DKK', 'name': 'Danish Krone'},
    'Poland': {'code': 'PLN', 'name': 'Polish Zloty'},
    'Czech Republic': {'code': 'CZK', 'name': 'Czech Koruna'},
    'Hungary': {'code': 'HUF', 'name': 'Hungarian Forint'},
    'Romania': {'code': 'RON', 'name': 'Romanian Leu'},
    'Bulgaria': {'code': 'BGN', 'name': 'Bulgarian Lev'},
    'Croatia': {'code': 'HRK', 'name': 'Croatian Kuna'},
    'Serbia': {'code': 'RSD', 'name': 'Serbian Dinar'},
    'Bosnia and Herzegovina': {'code': 'BAM', 'name': 'Bosnia and Herzegovina Convertible Mark'},
    'North Macedonia': {'code': 'MKD', 'name': 'Macedonian Denar'},
    'Albania': {'code': 'ALL', 'name': 'Albanian Lek'},
    'Montenegro': {'code': 'EUR', 'name': 'Euro'},
    'Kosovo': {'code': 'EUR', 'name': 'Euro'},
    'Russia': {'code': 'RUB', 'name': 'Russian Ruble'},
    'Ukraine': {'code': 'UAH', 'name': 'Ukrainian Hryvnia'},
    'Belarus': {'code': 'BYN', 'name': 'Belarusian Ruble'},
    'Moldova': {'code': 'MDL', 'name': 'Moldovan Leu'},
    'Georgia': {'code': 'GEL', 'name': 'Georgian Lari'},
    'Armenia': {'code': 'AMD', 'name': 'Armenian Dram'},
    'Azerbaijan': {'code': 'AZN', 'name': 'Azerbaijani Manat'},
    'Turkey': {'code': 'TRY', 'name': 'Turkish Lira'},
    'Israel': {'code': 'ILS', 'name': 'Israeli Shekel'},
    'Jordan': {'code': 'JOD', 'name': 'Jordanian Dinar'},
    'Lebanon': {'code': 'LBP', 'name': 'Lebanese Pound'},
    'Syria': {'code': 'SYP', 'name': 'Syrian Pound'},
    'Iraq': {'code': 'IQD', 'name': 'Iraqi Dinar'},
    'Iran': {'code': 'IRR', 'name': 'Iranian Rial'},
    'Saudi Arabia': {'code': 'SAR', 'name': 'Saudi Riyal'},
    'United Arab Emirates': {'code': 'AED', 'name': 'UAE Dirham'},
    'Qatar': {'code': 'QAR', 'name': 'Qatari Riyal'},
    'Kuwait': {'code': 'KWD', 'name': 'Kuwaiti Dinar'},
    'Bahrain': {'code': 'BHD', 'name': 'Bahraini Dinar'},
    'Oman': {'code': 'OMR', 'name': 'Omani Rial'},
    'Yemen': {'code': 'YER', 'name': 'Yemeni Rial'},
    'Afghanistan': {'code': 'AFN', 'name': 'Afghan Afghani'},
    'Pakistan': {'code': 'PKR', 'name': 'Pakistani Rupee'},
    'India': {'code': 'INR', 'name': 'Indian Rupee'},
    'Bangladesh': {'code': 'BDT', 'name': 'Bangladeshi Taka'},
    'Sri Lanka': {'code': 'LKR', 'name': 'Sri Lankan Rupee'},
    'Nepal': {'code': 'NPR', 'name': 'Nepalese Rupee'},
    'Bhutan': {'code': 'BTN', 'name': 'Bhutanese Ngultrum'},
    'Maldives': {'code': 'MVR', 'name': 'Maldivian Rufiyaa'},
    'China': {'code': 'CNY', 'name': 'Chinese Yuan'},
    'Japan': {'code': 'JPY', 'name': 'Japanese Yen'},
    'South Korea': {'code': 'KRW', 'name': 'South Korean Won'},
    'North Korea': {'code': 'KPW', 'name': 'North Korean Won'},
    'Mongolia': {'code': 'MNT', 'name': 'Mongolian Tugrik'},
    'Kazakhstan': {'code': 'KZT', 'name': 'Kazakhstani Tenge'},
    'Kyrgyzstan': {'code': 'KGS', 'name': 'Kyrgyzstani Som'},
    'Tajikistan': {'code': 'TJS', 'name': 'Tajikistani Somoni'},
    'Turkmenistan': {'code': 'TMT', 'name': 'Turkmenistani Manat'},
    'Uzbekistan': {'code': 'UZS', 'name': 'Uzbekistani Som'},
    'Thailand': {'code': 'THB', 'name': 'Thai Baht'},
    'Vietnam': {'code': 'VND', 'name': 'Vietnamese Dong'},
    'Laos': {'code': 'LAK', 'name': 'Lao Kip'},
    'Cambodia': {'code': 'KHR', 'name': 'Cambodian Riel'},
    'Myanmar': {'code': 'MMK', 'name': 'Myanmar Kyat'},
    'Malaysia': {'code': 'MYR', 'name': 'Malaysian Ringgit'},
    'Singapore': {'code': 'SGD', 'name': 'Singapore Dollar'},
    'Indonesia': {'code': 'IDR', 'name': 'Indonesian Rupiah'},
    'Brunei': {'code': 'BND', 'name': 'Brunei Dollar'},
    'Philippines': {'code': 'PHP', 'name': 'Philippine Peso'},
    'Taiwan': {'code': 'TWD', 'name': 'Taiwan Dollar'},
    'Hong Kong': {'code': 'HKD', 'name': 'Hong Kong Dollar'},
    'Macau': {'code': 'MOP', 'name': 'Macanese Pataca'},
    'Australia': {'code': 'AUD', 'name': 'Australian Dollar'},
    'New Zealand': {'code': 'NZD', 'name': 'New Zealand Dollar'},
    'Papua New Guinea': {'code': 'PGK', 'name': 'Papua New Guinean Kina'},
    'Fiji': {'code': 'FJD', 'name': 'Fijian Dollar'},
    'Solomon Islands': {'code': 'SBD', 'name': 'Solomon Islands Dollar'},
    'Vanuatu': {'code': 'VUV', 'name': 'Vanuatu Vatu'},
    'New Caledonia': {'code': 'XPF', 'name': 'CFP Franc'},
    'French Polynesia': {'code': 'XPF', 'name': 'CFP Franc'},
    'Samoa': {'code': 'WST', 'name': 'Samoan Tala'},
    'Tonga': {'code': 'TOP', 'name': 'Tongan Pa\'anga'},
    'Brazil': {'code': 'BRL', 'name': 'Brazilian Real'},
    'Argentina': {'code': 'ARS', 'name': 'Argentine Peso'},
    'Chile': {'code': 'CLP', 'name': 'Chilean Peso'},
    'Colombia': {'code': 'COP', 'name': 'Colombian Peso'},
    'Peru': {'code': 'PEN', 'name': 'Peruvian Sol'},
    'Ecuador': {'code': 'USD', 'name': 'US Dollar'},
    'Bolivia': {'code': 'BOB', 'name': 'Bolivian Boliviano'},
    'Paraguay': {'code': 'PYG', 'name': 'Paraguayan Guaraní'},
    'Uruguay': {'code': 'UYU', 'name': 'Uruguayan Peso'},
    'Venezuela': {'code': 'VES', 'name': 'Venezuelan Bolívar'},
    'Guyana': {'code': 'GYD', 'name': 'Guyanese Dollar'},
    'Suriname': {'code': 'SRD', 'name': 'Surinamese Dollar'},
    'French Guiana': {'code': 'EUR', 'name': 'Euro'},
    'Mexico': {'code': 'MXN', 'name': 'Mexican Peso'},
    'Guatemala': {'code': 'GTQ', 'name': 'Guatemalan Quetzal'},
    'Belize': {'code': 'BZD', 'name': 'Belize Dollar'},
    'El Salvador': {'code': 'USD', 'name': 'US Dollar'},
    'Honduras': {'code': 'HNL', 'name': 'Honduran Lempira'},
    'Nicaragua': {'code': 'NIO', 'name': 'Nicaraguan Córdoba'},
    'Costa Rica': {'code': 'CRC', 'name': 'Costa Rican Colón'},
    'Panama': {'code': 'PAB', 'name': 'Panamanian Balboa'},
    'Cuba': {'code': 'CUP', 'name': 'Cuban Peso'},
    'Jamaica': {'code': 'JMD', 'name': 'Jamaican Dollar'},
    'Haiti': {'code': 'HTG', 'name': 'Haitian Gourde'},
    'Dominican Republic': {'code': 'DOP', 'name': 'Dominican Peso'},
    'Puerto Rico': {'code': 'USD', 'name': 'US Dollar'},
    'Trinidad and Tobago': {'code': 'TTD', 'name': 'Trinidad and Tobago Dollar'},
    'Barbados': {'code': 'BBD', 'name': 'Barbadian Dollar'},
    'Bahamas': {'code': 'BSD', 'name': 'Bahamian Dollar'},
  };

  static Future<bool> _handleLocationPermission() async {
    try {
      bool serviceEnabled;
      LocationPermission permission;

      // Check if location services are enabled
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        print('Location services are disabled.');
        return false;
      }

      // Check current permission status
      permission = await Geolocator.checkPermission();
      print('Current location permission: $permission');

      if (permission == LocationPermission.denied) {
        // Request permission
        permission = await Geolocator.requestPermission();
        print('Requested location permission: $permission');
        
        if (permission == LocationPermission.denied) {
          print('Location permissions are denied');
          return false;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        print('Location permissions are permanently denied, cannot request permissions.');
        return false;
      }

      print('Location permissions granted: $permission');
      return true;
    } catch (e) {
      print('Error handling location permission: $e');
      return false;
    }
  }

  static Future<Map<String, String>?> detectCountryAndCurrency() async {
    try {
      print('Starting location detection...');
      
      final hasPermission = await _handleLocationPermission();
      if (!hasPermission) {
        print('Location permission denied, cannot detect location');
        return null;
      }

      print('Location permission granted, getting position...');
      
      Position? position;
      
      // Try different accuracy levels
      final accuracyLevels = [
        LocationAccuracy.medium,
        LocationAccuracy.low,
        LocationAccuracy.lowest,
      ];
      
      for (final accuracy in accuracyLevels) {
        try {
          print('Trying location accuracy: $accuracy');
          position = await Geolocator.getCurrentPosition(
            locationSettings: LocationSettings(
              accuracy: accuracy,
              timeLimit: const Duration(seconds: 15),
            ),
          );
          print('Successfully got position with $accuracy accuracy');
          break;
        } catch (e) {
          print('Failed to get position with $accuracy accuracy: $e');
          if (accuracy == accuracyLevels.last) {
            rethrow; // If all accuracy levels fail, throw the last error
          }
        }
      }
      
      if (position == null) {
        print('Failed to get position with all accuracy levels');
        return null;
      }

      print('Got position: ${position.latitude}, ${position.longitude}');

      print('Getting placemark information...');
      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      print('Found ${placemarks.length} placemarks');

      if (placemarks.isNotEmpty) {
        final placemark = placemarks.first;
        final country = placemark.country ?? 'Unknown';
        final locality = placemark.locality ?? '';
        final administrativeArea = placemark.administrativeArea ?? '';
        
        print('Placemark details:');
        print('  Country: $country');
        print('  Locality: $locality');
        print('  Administrative Area: $administrativeArea');
        print('  ISO Country Code: ${placemark.isoCountryCode}');
        
        final currencyInfo = _countryCurrencies[country];
        if (currencyInfo != null) {
          print('Found currency mapping for $country: ${currencyInfo['code']}');
          return {
            'country': country,
            'currencyCode': currencyInfo['code']!,
            'currencyName': currencyInfo['name']!,
          };
        } else {
          print('No currency mapping found for $country, using USD as fallback');
          // Default to USD if country not found in our mapping
          return {
            'country': country,
            'currencyCode': 'USD',
            'currencyName': 'US Dollar',
          };
        }
      }

      print('No placemarks found');
      return null;
    } catch (e) {
      print('Error detecting location: $e');
      return null;
    }
  }

  static Map<String, String>? getCurrencyForCountry(String country) {
    final currencyInfo = _countryCurrencies[country];
    if (currencyInfo != null) {
      return {
        'country': country,
        'currencyCode': currencyInfo['code']!,
        'currencyName': currencyInfo['name']!,
      };
    }
    return null;
  }

  // Debug function to test location detection manually
  static Future<void> testLocationDetection() async {
    print('=== TESTING LOCATION DETECTION ===');
    final result = await detectCountryAndCurrency();
    if (result != null) {
      print('SUCCESS: ${result['country']} -> ${result['currencyCode']} (${result['currencyName']})');
    } else {
      print('FAILED: Location detection returned null');
    }
    print('=== END TEST ===');
  }
}