import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final settings = SettingsService();
  final languageCode = await settings.getLanguage();
  final isDarkMode = await settings.isDarkMode();

  runApp(
    FirstepApp(
      initialLanguageCode: languageCode,
      initialDarkMode: isDarkMode,
    ),
  );
}

class FirstepApp extends StatefulWidget {
  final String initialLanguageCode;
  final bool initialDarkMode;

  const FirstepApp({
    super.key,
    required this.initialLanguageCode,
    required this.initialDarkMode,
  });

  @override
  State<FirstepApp> createState() => _FirstepAppState();
}

class _FirstepAppState extends State<FirstepApp> {
  late Locale _locale;
  late ThemeMode _themeMode;

  @override
  void initState() {
    super.initState();

    _locale = Locale(widget.initialLanguageCode);
    _themeMode =
        widget.initialDarkMode ? ThemeMode.dark : ThemeMode.light;
  }

  void changeLanguage(String languageCode) {
    setState(() {
      _locale = Locale(languageCode);
    });

    SettingsService().setLanguage(languageCode);
  }

  void changeThemeMode(bool isDark) {
    setState(() {
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    });

    SettingsService().setDarkMode(isDark);
  }

 @override
Widget build(BuildContext context) {
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'FIRSTSTEP',

    // إعدادات اللغة
    locale: _locale,
    supportedLocales: const [
      Locale('fr'),
      Locale('ar'),
    ],
    localizationsDelegates: GlobalMaterialLocalizations.delegates,

    // إعدادات المظهر
    themeMode: _themeMode,
    theme: ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.blue,
      ),
    ),
    darkTheme: ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.blue,
        brightness: Brightness.dark,
      ),
    ),

   home: HomeScreen(
  onLanguageChanged: changeLanguage,
  onThemeChanged: changeThemeMode,
),
  );
}
}

class AppText {
  static String get(String languageCode, String key) {
    final Map<String, String> french = {
      'appTitle': 'FIRSTSTEP',
      'offers': 'Offres',
      'favorites': 'Favoris',
      'applications': 'Candidatures',
      'profile': 'Profil',
      'search': 'Rechercher un stage (domaine, ville)...',
      'noOffers': 'Aucune offre trouvée',
      'apply': 'Postuler',
      'submit': 'Envoyer la candidature',
      'fullName': 'Nom complet',
      'email': 'Email',
      'phone': 'Téléphone',
      'motivation': 'Message de motivation',
      'required': 'Ce champ est obligatoire',
      'invalidEmail': 'Email invalide',
      'applied': 'Candidature envoyée ! Réf : ',
      'alreadyApplied': 'Vous avez déjà postulé à cette offre',
      'closedOffer': 'Cette offre est fermée',
      'noFavorites': 'Aucun favori ajouté',
      'noApplications': 'Aucune candidature envoyée',
      'status': 'Statut',
      'language': 'Langue',
      'darkMode': 'Mode sombre',
      'company': 'Entreprise',
      'location': 'Lieu',
      'field': 'Domaine',
      'type': 'Type',
      'newest': 'Plus récentes',
      'oldest': 'Plus anciennes',
      'allFields': 'Tous les domaines',
      'allLocations': 'Toutes les wilayas',
      'error': 'Erreur',
    };

    final Map<String, String> arabic = {
      'appTitle': 'FIRSTSTEP',
      'offers': 'العروض',
      'favorites': 'المفضلة',
      'applications': 'طلباتي',
      'profile': 'الملف الشخصي',
      'search': 'ابحث عن تربص (المجال، الولاية)...',
      'noOffers': 'لا توجد عروض',
      'apply': 'التقديم',
      'submit': 'إرسال الطلب',
      'fullName': 'الاسم الكامل',
      'email': 'البريد الإلكتروني',
      'phone': 'الهاتف',
      'motivation': 'رسالة التحفيز',
      'required': 'هذا الحقل مطلوب',
      'invalidEmail': 'البريد الإلكتروني غير صالح',
      'applied': 'تم إرسال الطلب بنجاح! المرجع: ',
      'alreadyApplied': 'لقد تقدمت مسبقاً إلى هذا العرض',
      'closedOffer': 'هذا العرض مغلق',
      'noFavorites': 'لا توجد عناصر في المفضلة',
      'noApplications': 'لم تقدم على أي عرض بعد',
      'status': 'الحالة',
      'language': 'اللغة',
      'darkMode': 'الوضع الليلي',
      'company': 'الشركة',
      'location': 'الموقع',
      'field': 'المجال',
      'type': 'النوع',
      'newest': 'الأحدث أولاً',
      'oldest': 'الأقدم أولاً',
      'allFields': 'كل المجالات',
      'allLocations': 'كل الولايات',
      'error': 'خطأ',
    };

    return languageCode == 'ar'
        ? arabic[key] ?? key
        : french[key] ?? key;
  }
}

class SettingsService {
  static const String _languageKey = 'language';
  static const String _darkModeKey = 'dark_mode';
  static const String _lastFieldKey = 'last_field';
  static const String _lastWilayaKey = 'last_wilaya';

  Future<String> getLanguage() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getString(_languageKey) ?? 'fr';
  }

  Future<void> setLanguage(String languageCode) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_languageKey, languageCode);
  }

  Future<bool> isDarkMode() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getBool(_darkModeKey) ?? false;
  }

  Future<void> setDarkMode(bool value) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool(_darkModeKey, value);
  }

  Future<int?> getLastField() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getInt(_lastFieldKey);
  }

  Future<void> setLastField(int? value) async {
    final preferences = await SharedPreferences.getInstance();

    if (value == null) {
      await preferences.remove(_lastFieldKey);
    } else {
      await preferences.setInt(_lastFieldKey, value);
    }
  }

  Future<int?> getLastWilaya() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getInt(_lastWilayaKey);
  }

  Future<void> setLastWilaya(int? value) async {
    final preferences = await SharedPreferences.getInstance();

    if (value == null) {
      await preferences.remove(_lastWilayaKey);
    } else {
      await preferences.setInt(_lastWilayaKey, value);
    }
  }
}

class Internship {
  final int id;
  final String titleFr;
  final String titleAr;
  final String company;
  final String wilaya;
  final String field;
  final String type;
  final String status;
  final String createdAt;

  const Internship({
    required this.id,
    required this.titleFr,
    required this.titleAr,
    required this.company,
    required this.wilaya,
    required this.field,
    required this.type,
    required this.status,
    required this.createdAt,
  });

  factory Internship.fromMap(Map<String, Object?> map) {
    return Internship(
      id: map['id'] as int,
      titleFr: map['title_fr'] as String? ?? '',
      titleAr: map['title_ar'] as String? ?? '',
      company: map['company'] as String? ?? '',
      wilaya: map['wilaya'] as String? ?? '',
      field: map['field'] as String? ?? '',
      type: map['type'] as String? ?? '',
      status: map['status'] as String? ?? 'open',
      createdAt: map['created_at'] as String? ?? '',
    );
  }

  String title(String languageCode) {
    return languageCode == 'ar' ? titleAr : titleFr;
  }
}

class Application {
  final int id;
  final int internshipId;
  final String referenceCode;
  final String fullName;
  final String email;
  final String phone;
  final String motivation;
  final String status;
  final String createdAt;

  const Application({
    required this.id,
    required this.internshipId,
    required this.referenceCode,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.motivation,
    required this.status,
    required this.createdAt,
  });

  factory Application.fromMap(Map<String, Object?> map) {
    return Application(
      id: map['id'] as int,
      internshipId: map['internship_id'] as int,
      referenceCode: map['reference_code'] as String,
      fullName: map['full_name'] as String,
      email: map['email'] as String,
      phone: map['phone'] as String,
      motivation: map['motivation'] as String,
      status: map['status'] as String,
      createdAt: map['created_at'] as String,
    );
  }
}

class DatabaseHelper {
  DatabaseHelper._internal();

  static final DatabaseHelper instance = DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final databasePath = p.join(databasesPath, 'firstep.db');

    return openDatabase(
      databasePath,
      version: 1,
      onCreate: _createDatabase,
    );
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE companies (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL UNIQUE
      )
    ''');

    await db.execute('''
      CREATE TABLE wilayas (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL UNIQUE
      )
    ''');

    await db.execute('''
      CREATE TABLE fields (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name_fr TEXT NOT NULL,
        name_ar TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE skills (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL UNIQUE
      )
    ''');

    await db.execute('''
      CREATE TABLE internships (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        company_id INTEGER NOT NULL,
        wilaya_id INTEGER NOT NULL,
        field_id INTEGER NOT NULL,
        title_fr TEXT NOT NULL,
        title_ar TEXT NOT NULL,
        type TEXT NOT NULL,
        status TEXT NOT NULL DEFAULT 'open',
        created_at TEXT NOT NULL,
        FOREIGN KEY (company_id) REFERENCES companies(id),
        FOREIGN KEY (wilaya_id) REFERENCES wilayas(id),
        FOREIGN KEY (field_id) REFERENCES fields(id)
      )
    ''');

    await db.execute('''
      CREATE TABLE internship_skills (
        internship_id INTEGER NOT NULL,
        skill_id INTEGER NOT NULL,
        PRIMARY KEY (internship_id, skill_id),
        FOREIGN KEY (internship_id) REFERENCES internships(id),
        FOREIGN KEY (skill_id) REFERENCES skills(id)
      )
    ''');

    await db.execute('''
      CREATE TABLE favorites (
        internship_id INTEGER PRIMARY KEY,
        created_at TEXT NOT NULL,
        FOREIGN KEY (internship_id) REFERENCES internships(id)
      )
    ''');

    await db.execute('''
      CREATE TABLE applications (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        internship_id INTEGER NOT NULL,
        reference_code TEXT NOT NULL UNIQUE,
        full_name TEXT NOT NULL,
        email TEXT NOT NULL,
        phone TEXT NOT NULL,
        motivation TEXT NOT NULL,
        status TEXT NOT NULL DEFAULT 'submitted',
        created_at TEXT NOT NULL,
        FOREIGN KEY (internship_id) REFERENCES internships(id)
      )
    ''');

    await db.execute('''
      CREATE TABLE application_status_history (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        application_id INTEGER NOT NULL,
        old_status TEXT,
        new_status TEXT NOT NULL,
        changed_at TEXT NOT NULL,
        FOREIGN KEY (application_id) REFERENCES applications(id)
      )
    ''');

    await _seedData(db);
  }

  Future<void> _seedData(Database db) async {
    final result = await db.rawQuery(
      'SELECT COUNT(*) AS count FROM internships',
    );

    final count = result.first['count'] as int? ?? 0;

    if (count > 0) {
      return;
    }

    final companies = [
      'Tech Algerie',
      'DataSoft',
      'Netcom',
      'Djezzy',
      'Sonatrach',
    ];

    for (final company in companies) {
      await db.insert('companies', {'name': company});
    }

    final wilayas = [
      'Alger',
      'Oran',
      'Constantine',
      'Annaba',
      'Blida',
    ];

    for (final wilaya in wilayas) {
      await db.insert('wilayas', {'name': wilaya});
    }

    final fields = [
      {'name_fr': 'Informatique', 'name_ar': 'الإعلام الآلي'},
      {'name_fr': 'Data', 'name_ar': 'تحليل البيانات'},
      {'name_fr': 'Réseaux', 'name_ar': 'الشبكات'},
      {'name_fr': 'Marketing', 'name_ar': 'التسويق'},
      {'name_fr': 'Gestion', 'name_ar': 'التسيير'},
    ];

    final fieldIds = <int>[];

    for (final field in fields) {
      final id = await db.insert('fields', field);
      fieldIds.add(id);
    }

    final skills = [
      'Flutter',
      'Dart',
      'SQL',
      'Python',
      'Excel',
      'Communication',
    ];

    final skillIds = <int>[];

    for (final skill in skills) {
      final id = await db.insert('skills', {'name': skill});
      skillIds.add(id);
    }

    final types = [
      'Stage PFE',
      'Stage été',
      'Stage pratique',
    ];

    for (var i = 1; i <= 32; i++) {
      final companyId = (i % companies.length) + 1;
      final wilayaId = (i % wilayas.length) + 1;
      final fieldId = fieldIds[i % fieldIds.length];
      final type = types[i % types.length];
      final status = i % 10 == 0 ? 'closed' : 'open';

      final internshipId = await db.insert(
        'internships',
        {
          'company_id': companyId,
          'wilaya_id': wilayaId,
          'field_id': fieldId,
          'title_fr': 'Stage $type #$i',
          'title_ar': 'تربص $type رقم $i',
          'type': type,
          'status': status,
          'created_at': DateTime.now()
              .subtract(Duration(days: i))
              .toIso8601String(),
        },
      );

      await db.insert(
        'internship_skills',
        {
          'internship_id': internshipId,
          'skill_id': skillIds[i % skillIds.length],
        },
      );
    }
  }
}

class InternshipRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  Future<List<Internship>> getInternships({
    String query = '',
    int? fieldId,
    int? wilayaId,
    String sort = 'newest',
  }) async {
    final db = await _databaseHelper.database;

    final conditions = <String>[];
    final arguments = <Object?>[];

    if (query.trim().isNotEmpty) {
      conditions.add(
        '(i.title_fr LIKE ? OR i.title_ar LIKE ? OR c.name LIKE ? OR w.name LIKE ?)',
      );

      final search = '%$query%';
      arguments.addAll([search, search, search, search]);
    }

    if (fieldId != null) {
      conditions.add('i.field_id = ?');
      arguments.add(fieldId);
    }

    if (wilayaId != null) {
      conditions.add('i.wilaya_id = ?');
      arguments.add(wilayaId);
    }

    final whereClause = conditions.isEmpty
        ? ''
        : 'WHERE ${conditions.join(' AND ')}';

    final orderBy = sort == 'oldest'
        ? 'i.created_at ASC'
        : 'i.created_at DESC';

    final result = await db.rawQuery('''
      SELECT
        i.*,
        c.name AS company,
        w.name AS wilaya,
        f.name_fr AS field,
        f.name_ar AS field_ar
      FROM internships i
      INNER JOIN companies c ON c.id = i.company_id
      INNER JOIN wilayas w ON w.id = i.wilaya_id
      INNER JOIN fields f ON f.id = i.field_id
      $whereClause
      ORDER BY $orderBy
    ''', arguments);

    return result.map((row) {
      final map = Map<String, Object?>.from(row);
      map['field'] = map['field'] ?? map['field_ar'];
      return Internship.fromMap(map);
    }).toList();
  }

  Future<List<Map<String, Object?>>> getFields() async {
    final db = await _databaseHelper.database;
    return db.query('fields', orderBy: 'id');
  }

  Future<List<Map<String, Object?>>> getWilayas() async {
    final db = await _databaseHelper.database;
    return db.query('wilayas', orderBy: 'name');
  }

  Future<bool> isFavorite(int internshipId) async {
    final db = await _databaseHelper.database;

    final result = await db.query(
      'favorites',
      where: 'internship_id = ?',
      whereArgs: [internshipId],
    );

    return result.isNotEmpty;
  }

  Future<void> toggleFavorite(int internshipId) async {
    final db = await _databaseHelper.database;
    final isFavorite = await this.isFavorite(internshipId);

    if (isFavorite) {
      await db.delete(
        'favorites',
        where: 'internship_id = ?',
        whereArgs: [internshipId],
      );
    } else {
      await db.insert(
        'favorites',
        {
          'internship_id': internshipId,
          'created_at': DateTime.now().toIso8601String(),
        },
      );
    }
  }

  Future<List<Internship>> getFavorites() async {
    final db = await _databaseHelper.database;

    final result = await db.rawQuery('''
      SELECT
        i.*,
        c.name AS company,
        w.name AS wilaya,
        f.name_fr AS field,
        f.name_ar AS field_ar
      FROM favorites fav
      INNER JOIN internships i ON i.id = fav.internship_id
      INNER JOIN companies c ON c.id = i.company_id
      INNER JOIN wilayas w ON w.id = i.wilaya_id
      INNER JOIN fields f ON f.id = i.field_id
      ORDER BY fav.created_at DESC
    ''');

    return result.map((row) {
      final map = Map<String, Object?>.from(row);
      map['field'] = map['field'] ?? map['field_ar'];
      return Internship.fromMap(map);
    }).toList();
  }

  Future<bool> hasApplied(int internshipId) async {
    final db = await _databaseHelper.database;

    final result = await db.query(
      'applications',
      where: 'internship_id = ?',
      whereArgs: [internshipId],
    );

    return result.isNotEmpty;
  }

  Future<Application> submitApplication({
    required int internshipId,
    required String fullName,
    required String email,
    required String phone,
    required String motivation,
  }) async {
    final db = await _databaseHelper.database;

    final internshipResult = await db.query(
      'internships',
      where: 'id = ?',
      whereArgs: [internshipId],
    );

    if (internshipResult.isEmpty) {
      throw Exception('Internship not found');
    }

    final status = internshipResult.first['status'] as String;

    if (status == 'closed') {
      throw Exception('This offer is closed');
    }

    final alreadyApplied = await hasApplied(internshipId);

    if (alreadyApplied) {
      throw Exception('Already applied');
    }

    final referenceCode = _generateReferenceCode();
    final now = DateTime.now().toIso8601String();

    final applicationId = await db.insert(
      'applications',
      {
        'internship_id': internshipId,
        'reference_code': referenceCode,
        'full_name': fullName,
        'email': email,
        'phone': phone,
        'motivation': motivation,
        'status': 'submitted',
        'created_at': now,
      },
    );

    await db.insert(
      'application_status_history',
      {
        'application_id': applicationId,
        'old_status': null,
        'new_status': 'submitted',
        'changed_at': now,
      },
    );

    return Application(
      id: applicationId,
      internshipId: internshipId,
      referenceCode: referenceCode,
      fullName: fullName,
      email: email,
      phone: phone,
      motivation: motivation,
      status: 'submitted',
      createdAt: now,
    );
  }

  String _generateReferenceCode() {
    final year = DateTime.now().year;
    final randomPart = DateTime.now().microsecondsSinceEpoch % 10000;
    final paddedPart = randomPart.toString().padLeft(4, '0');

    return 'FS-$year-$paddedPart';
  }

  Future<List<Application>> getApplications() async {
    final db = await _databaseHelper.database;

    final result = await db.query(
      'applications',
      orderBy: 'created_at DESC',
    );

    return result.map(Application.fromMap).toList();
  }
}

class HomeScreen extends StatefulWidget {
  final ValueChanged<String> onLanguageChanged;
  final ValueChanged<bool> onThemeChanged;

  const HomeScreen({
    super.key,
    required this.onLanguageChanged,
    required this.onThemeChanged,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final InternshipRepository _repository = InternshipRepository();
  final SettingsService _settingsService = SettingsService();

  int _currentIndex = 0;

  String _searchQuery = '';
  int? _selectedFieldId;
  int? _selectedWilayaId;
  String _sort = 'newest';

  List<Internship> _offers = [];
  List<Internship> _favorites = [];
  List<Map<String, Object?>> _fields = [];
  List<Map<String, Object?>> _wilayas = [];

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    _selectedFieldId = await _settingsService.getLastField();
    _selectedWilayaId = await _settingsService.getLastWilaya();

    await _loadFilters();
    await _loadOffers();
    await _loadFavorites();
  }

  Future<void> _loadFilters() async {
    final fields = await _repository.getFields();
    final wilayas = await _repository.getWilayas();

    if (!mounted) return;

    setState(() {
      _fields = fields;
      _wilayas = wilayas;
    });
  }

  Future<void> _loadOffers() async {
    final offers = await _repository.getInternships(
      query: _searchQuery,
      fieldId: _selectedFieldId,
      wilayaId: _selectedWilayaId,
      sort: _sort,
    );

    if (!mounted) return;

    setState(() {
      _offers = offers;
    });
  }

  Future<void> _loadFavorites() async {
    final favorites = await _repository.getFavorites();

    if (!mounted) return;

    setState(() {
      _favorites = favorites;
    });
  }

  Future<void> _toggleFavorite(Internship internship) async {
    await _repository.toggleFavorite(internship.id);

    await _loadOffers();
    await _loadFavorites();
  }

  @override
  Widget build(BuildContext context) {
    final languageCode =
        Localizations.localeOf(context).languageCode;
    final isArabic = languageCode == 'ar';

    final screens = [
      _buildOffersTab(languageCode),
      _buildFavoritesTab(languageCode),
      _buildApplicationsTab(languageCode),
      _buildProfileTab(languageCode, isArabic),
    ];

    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppText.get(languageCode, 'appTitle')),
          actions: [
            IconButton(
              icon: const Icon(Icons.language),
              onPressed: () {
                widget.onLanguageChanged(isArabic ? 'fr' : 'ar');
                _loadOffers();
                _loadFavorites();
              },
            ),
          ],
        ),
        body: screens[_currentIndex],
        bottomNavigationBar: NavigationBar(
          selectedIndex: _currentIndex,
          onDestinationSelected: (index) {
            setState(() {
              _currentIndex = index;
            });

            if (index == 1) {
              _loadFavorites();
            }
          },
          destinations: [
            NavigationDestination(
              icon: const Icon(Icons.work_outline),
              selectedIcon: const Icon(Icons.work),
              label: AppText.get(languageCode, 'offers'),
            ),
            NavigationDestination(
              icon: const Icon(Icons.favorite_outline),
              selectedIcon: const Icon(Icons.favorite),
              label: AppText.get(languageCode, 'favorites'),
            ),
            NavigationDestination(
              icon: const Icon(Icons.assignment_outlined),
              selectedIcon: const Icon(Icons.assignment),
              label: AppText.get(languageCode, 'applications'),
            ),
            NavigationDestination(
              icon: const Icon(Icons.person_outline),
              selectedIcon: const Icon(Icons.person),
              label: AppText.get(languageCode, 'profile'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOffersTab(String languageCode) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: TextField(
            key: const Key('offers_search_field'),
            onChanged: (value) {
              _searchQuery = value;
              _loadOffers();
            },
            decoration: InputDecoration(
              hintText: AppText.get(languageCode, 'search'),
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<int?>(isExpanded: true,
                  initialValue: _selectedFieldId,
                  decoration: InputDecoration(
                    labelText:
                        AppText.get(languageCode, 'field'),
                    border: const OutlineInputBorder(),
                  ),
                  items: [
                    DropdownMenuItem<int?>(
                      value: null,
                      child: Text(
                        AppText.get(languageCode, 'allFields'),
                      ),
                    ),
                    ..._fields.map((field) {
                      return DropdownMenuItem<int?>(
                        value: field['id'] as int,
                        child: Text(
                          field['name_fr'].toString(),
                        ),
                      );
                    }),
                  ],
                  onChanged: (value) async {
                    setState(() {
                      _selectedFieldId = value;
                    });

                    await _settingsService.setLastField(value);
                    await _loadOffers();
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: DropdownButtonFormField<int?>(isExpanded: true,
                  initialValue: _selectedWilayaId,
                  decoration: InputDecoration(
                    labelText:
                        AppText.get(languageCode, 'location'),
                    border: const OutlineInputBorder(),
                  ),
                  items: [
                    DropdownMenuItem<int?>(
                      value: null,
                      child: Text(
                        AppText.get(languageCode, 'allLocations'),
                      ),
                    ),
                    ..._wilayas.map((wilaya) {
                      return DropdownMenuItem<int?>(
                        value: wilaya['id'] as int,
                        child: Text(
                          wilaya['name'].toString(),
                        ),
                      );
                    }),
                  ],
                  onChanged: (value) async {
                    setState(() {
                      _selectedWilayaId = value;
                    });

                    await _settingsService.setLastWilaya(value);
                    await _loadOffers();
                  },
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 8,
          ),
          child: SegmentedButton<String>(
            segments: [
              ButtonSegment<String>(
                value: 'newest',
                label: Text(
                  AppText.get(languageCode, 'newest'),
                ),
              ),
              ButtonSegment<String>(
                value: 'oldest',
                label: Text(
                  AppText.get(languageCode, 'oldest'),
                ),
              ),
            ],
            selected: {_sort},
            onSelectionChanged: (value) {
              setState(() {
                _sort = value.first;
              });

              _loadOffers();
            },
          ),
        ),
        Expanded(
          child: _offers.isEmpty
              ? Center(
                  child: Text(
                    AppText.get(languageCode, 'noOffers'),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: _offers.length,
                  itemBuilder: (context, index) {
                    final internship = _offers[index];

                    return FutureBuilder<bool>(
                      future:
                          _repository.isFavorite(internship.id),
                      builder: (context, snapshot) {
                        final isFavorite = snapshot.data ?? false;

                        return Card(
                          margin:
                              const EdgeInsets.only(bottom: 10),
                          child: ListTile(
                            title: Text(
                              internship.title(languageCode),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              '${internship.company} • '
                              '${internship.wilaya} • '
                              '${internship.field}',
                            ),
                            trailing: IconButton(
                              icon: Icon(
                                isFavorite
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: isFavorite
                                    ? Colors.red
                                    : null,
                              ),
                              onPressed: () =>
                                  _toggleFavorite(internship),
                            ),
                            onTap: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return InternshipDetailScreen(
                                      internship: internship,
                                      onFavoriteChanged:
                                          _toggleFavorite,
                                    );
                                  },
                                ),
                              );

                              await _loadOffers();
                              await _loadFavorites();
                            },
                          ),
                        );
                      },
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildFavoritesTab(String languageCode) {
    if (_favorites.isEmpty) {
      return Center(
        child: Text(
          AppText.get(languageCode, 'noFavorites'),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: _favorites.length,
      itemBuilder: (context, index) {
        final internship = _favorites[index];

        return Card(
          child: ListTile(
            title: Text(internship.title(languageCode)),
            subtitle: Text(
              '${internship.company} • '
              '${internship.wilaya}',
            ),
            trailing: IconButton(
              icon: const Icon(
                Icons.delete,
                color: Colors.red,
              ),
              onPressed: () => _toggleFavorite(internship),
            ),
          ),
        );
      },
    );
  }

  Widget _buildApplicationsTab(String languageCode) {
    return FutureBuilder<List<Application>>(
      future: _repository.getApplications(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final applications = snapshot.data ?? [];

        if (applications.isEmpty) {
          return Center(
            child: Text(
              AppText.get(languageCode, 'noApplications'),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: applications.length,
          itemBuilder: (context, index) {
            final application = applications[index];

            return Card(
              child: ListTile(
                title: Text(application.referenceCode),
                subtitle: Text(
                  '${AppText.get(languageCode, 'status')}: '
                  '${application.status}',
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildProfileTab(
    String languageCode,
    bool isArabic,
  ) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        SwitchListTile(
          title: Text(
            AppText.get(languageCode, 'darkMode'),
          ),
          value: isDark,
          onChanged: widget.onThemeChanged,
        ),
        ListTile(
          title: Text(
            AppText.get(languageCode, 'language'),
          ),
          subtitle: Text(isArabic ? 'العربية' : 'Français'),
          trailing: const Icon(Icons.language),
          onTap: () {
            widget.onLanguageChanged(isArabic ? 'fr' : 'ar');
          },
        ),
      ],
    );
  }
}

class InternshipDetailScreen extends StatelessWidget {
  final Internship internship;
  final Future<void> Function(Internship) onFavoriteChanged;

  const InternshipDetailScreen({
    super.key,
    required this.internship,
    required this.onFavoriteChanged,
  });

  @override
  Widget build(BuildContext context) {
    final languageCode =
        Localizations.localeOf(context).languageCode;

    return Scaffold(
      appBar: AppBar(
        title: Text(internship.title(languageCode)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              internship.title(languageCode),
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              '${AppText.get(languageCode, 'company')}: '
              '${internship.company}',
            ),
            const SizedBox(height: 6),
            Text(
              '${AppText.get(languageCode, 'location')}: '
              '${internship.wilaya}',
            ),
            const SizedBox(height: 6),
            Text(
              '${AppText.get(languageCode, 'field')}: '
              '${internship.field}',
            ),
            const SizedBox(height: 6),
            Text(
              '${AppText.get(languageCode, 'type')}: '
              '${internship.type}',
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: internship.status == 'closed'
                    ? null
                    : () async {
                        final repository = InternshipRepository();
                        final alreadyApplied =
                            await repository.hasApplied(
                          internship.id,
                        );

                        if (!context.mounted) return;

                        if (alreadyApplied) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                AppText.get(
                                  languageCode,
                                  'alreadyApplied',
                                ),
                              ),
                            ),
                          );

                          return;
                        }

                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return ApplyFormScreen(
                                internship: internship,
                              );
                            },
                          ),
                        );
                      },
                child: Text(
                  AppText.get(languageCode, 'apply'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ApplyFormScreen extends StatefulWidget {
  final Internship internship;

  const ApplyFormScreen({
    super.key,
    required this.internship,
  });

  @override
  State<ApplyFormScreen> createState() => _ApplyFormScreenState();
}

class _ApplyFormScreenState extends State<ApplyFormScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController =
      TextEditingController();
  final TextEditingController _emailController =
      TextEditingController();
  final TextEditingController _phoneController =
      TextEditingController();
  final TextEditingController _motivationController =
      TextEditingController();

  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _motivationController.dispose();

    super.dispose();
  }

  Future<void> _submitApplication() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final application = await InternshipRepository()
          .submitApplication(
        internshipId: widget.internship.id,
        fullName: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        motivation: _motivationController.text.trim(),
      );

      if (!mounted) return;

      final languageCode =
          Localizations.localeOf(context).languageCode;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${AppText.get(languageCode, 'applied')}'
            '${application.referenceCode}',
          ),
        ),
      );

      Navigator.pop(context, true);
    } catch (error) {
      if (!mounted) return;

      final languageCode =
          Localizations.localeOf(context).languageCode;

      String message = AppText.get(languageCode, 'error');

      if (error.toString().contains('Already applied')) {
        message = AppText.get(languageCode, 'alreadyApplied');
      } else if (error.toString().contains('closed')) {
        message = AppText.get(languageCode, 'closedOffer');
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final languageCode =
        Localizations.localeOf(context).languageCode;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppText.get(languageCode, 'apply'),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText:
                    AppText.get(languageCode, 'fullName'),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return AppText.get(languageCode, 'required');
                }

                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: AppText.get(languageCode, 'email'),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return AppText.get(languageCode, 'required');
                }

                final emailRegex =
                    RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

                if (!emailRegex.hasMatch(value.trim())) {
                  return AppText.get(
                    languageCode,
                    'invalidEmail',
                  );
                }

                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: AppText.get(languageCode, 'phone'),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return AppText.get(languageCode, 'required');
                }

                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _motivationController,
              maxLines: 4,
              decoration: InputDecoration(
                labelText:
                    AppText.get(languageCode, 'motivation'),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return AppText.get(languageCode, 'required');
                }

                return null;
              },
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed:
                  _isSubmitting ? null : _submitApplication,
              child: _isSubmitting
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    )
                  : Text(
                      AppText.get(languageCode, 'submit'),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}