const Map<String, Map<String, Map<String, List<String>>>> _syrianLocationCatalog = {
  'دمشق': {
    'دمشق': {
      'المزة': ['المزة السكانية', 'المزة فيلات'],
      'برزة': ['برزة البلد', 'مساكن برزة'],
    },
    'كفرسوسة': {
      'كفرسوسة': ['المنطقة الشرقية', 'المنطقة الغربية'],
    },
  },
  'ريف دمشق': {
    'دوما': {
      'دوما': ['وسط المدينة', 'المنطقة الصناعية'],
      'حرستا': ['حرستا البلد', 'مساكن حرستا'],
    },
    'القطيفة': {
      'القطيفة': ['القطيفة', 'عسال الورد'],
    },
  },
  'حلب': {
    'حلب': {
      'الشهباء': ['الشهباء', 'الجميلية'],
      'العزيزية': ['العزيزية', 'السليمانية'],
    },
    'منبج': {
      'منبج': ['منبج', 'الحمرة'],
    },
  },
  'حمص': {
    'حمص': {
      'الوعر': ['الوعر', 'الإنشاءات'],
      'المدينة': ['المدينة القديمة', 'الغوطة'],
    },
    'تدمر': {
      'تدمر': ['تدمر', 'البوكمال'],
    },
  },
  'حماة': {
    'حماة': {
      'المدينة': ['المدينة', 'الحاضر'],
    },
    'مصياف': {
      'مصياف': ['مصياف', 'وادي العيون'],
    },
  },
  'اللاذقية': {
    'اللاذقية': {
      'المدينة': ['المدينة', 'الرمل الفلسطيني'],
    },
    'جبلة': {
      'جبلة': ['جبلة', 'القرداحة'],
    },
  },
  'طرطوس': {
    'طرطوس': {
      'المدينة': ['المدينة', 'الحامدية'],
    },
    'بانياس': {
      'بانياس': ['بانياس', 'القدموس'],
    },
  },
  'إدلب': {
    'إدلب': {
      'المدينة': ['المدينة', 'الضبيط'],
    },
    'معرة النعمان': {
      'معرة النعمان': ['معرة النعمان', 'كفرنبل'],
    },
  },
  'دير الزور': {
    'دير الزور': {
      'المدينة': ['المدينة', 'القصور'],
    },
    'البوكمال': {
      'البوكمال': ['البوكمال', 'العشارة'],
    },
  },
  'الحسكة': {
    'الحسكة': {
      'المدينة': ['المدينة', 'النشوة'],
    },
    'القامشلي': {
      'القامشلي': ['القامشلي', 'الواسطي'],
    },
  },
  'الرقة': {
    'الرقة': {
      'المدينة': ['المدينة', 'الرميلة'],
    },
    'الثورة': {
      'الثورة': ['الثورة', 'المنصورة'],
    },
  },
  'السويداء': {
    'السويداء': {
      'المدينة': ['المدينة', 'الكرك'],
    },
    'شهبا': {
      'شهبا': ['شهبا', 'صلخد'],
    },
  },
  'درعا': {
    'درعا': {
      'المدينة': ['المدينة', 'الصنمين'],
    },
    'إزرع': {
      'إزرع': ['إزرع', 'طفس'],
    },
  },
  'القنيطرة': {
    'القنيطرة': {
      'المدينة': ['المدينة', 'خان أرنبة'],
    },
    'فيق': {
      'فيق': ['فيق', 'بقعاثا'],
    },
  },
};

abstract class SyrianLocationCatalog {
  static List<String> governorates() {
    return _syrianLocationCatalog.keys.toList()..sort();
  }

  static List<String> cities(String? governorate) {
    if (governorate == null || governorate.isEmpty) return const [];
    return _syrianLocationCatalog[governorate]?.keys.toList() ?? const [];
  }

  static List<String> towns(String? governorate, String? city) {
    if (governorate == null ||
        governorate.isEmpty ||
        city == null ||
        city.isEmpty) {
      return const [];
    }
    return _syrianLocationCatalog[governorate]?[city]?.keys.toList() ??
        const [];
  }

  static List<String> villages(
    String? governorate,
    String? city,
    String? town,
  ) {
    if (governorate == null ||
        governorate.isEmpty ||
        city == null ||
        city.isEmpty ||
        town == null ||
        town.isEmpty) {
      return const [];
    }
    return List<String>.from(
      _syrianLocationCatalog[governorate]?[city]?[town] ?? const [],
    );
  }

  static List<String> withSavedValue(List<String> items, String? savedValue) {
    if (savedValue == null || savedValue.isEmpty || items.contains(savedValue)) {
      return items;
    }
    return [...items, savedValue];
  }
}
