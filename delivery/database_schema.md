# مخطط قاعدة البيانات — FIRSTSTEP

## نظرة عامة

تستخدم FIRSTSTEP قاعدة بيانات SQLite محلية للعمل بدون إنترنت.  
تخزن قاعدة البيانات الشركات، الولايات، المجالات، المهارات، عروض التربص، المفضلة، الطلبات، وسجل تغيّر حالة الطلبات.

## إصدار قاعدة البيانات

- الإصدار الحالي: v2
- يتم إنشاء الجداول عند أول تشغيل عبر `onCreate`
- يتم تنفيذ الترحيل عند التحديث عبر `onUpgrade`

## جدول الشركات

```sql
CREATE TABLE companies (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL UNIQUE
);
```

## جدول الولايات

```sql
CREATE TABLE wilayas (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL UNIQUE
);
```

## جدول المجالات

```sql
CREATE TABLE fields (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name_fr TEXT NOT NULL,
  name_ar TEXT NOT NULL
);
```

## جدول المهارات

```sql
CREATE TABLE skills (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL UNIQUE
);
```

## جدول عروض التربص

```sql
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
);
```

## جدول مهارات العروض

```sql
CREATE TABLE internship_skills (
  internship_id INTEGER NOT NULL,
  skill_id INTEGER NOT NULL,
  PRIMARY KEY (internship_id, skill_id),
  FOREIGN KEY (internship_id) REFERENCES internships(id),
  FOREIGN KEY (skill_id) REFERENCES skills(id)
);
```

## جدول المفضلة

```sql
CREATE TABLE favorites (
  internship_id INTEGER PRIMARY KEY,
  created_at TEXT NOT NULL,
  FOREIGN KEY (internship_id) REFERENCES internships(id)
);
```

## جدول الطلبات

```sql
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
);
```

## جدول سجل حالة الطلب

```sql
CREATE TABLE application_status_history (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  application_id INTEGER NOT NULL,
  old_status TEXT,
  new_status TEXT NOT NULL,
  changed_at TEXT NOT NULL,
  FOREIGN KEY (application_id) REFERENCES applications(id)
);
```

## العلاقات بين الجداول

- كل عرض تربص مرتبط بشركة، ولاية، ومجال.
- كل عرض يمكن أن يرتبط بعدة مهارات عبر جدول `internship_skills`.
- كل مفضلة مرتبطة بعرض تربص واحد.
- كل طلب مرتبط بعرض تربص واحد.
- كل طلب يمكن أن يكون له سجل تغيّر حالة في `application_status_history`.

## ملاحظات الأمان

- يتم تخزين الحد الأدنى من البيانات الشخصية فقط: الاسم، البريد، الهاتف، والدافع.
- لا يتم تخزين كلمات مرور أو رموز OTP.
- لا يتم تخزين سيرة ذاتية كاملة أو صور شخصية.
- يتم استخدام استعلامات معاملات لمنع SQL Injection.
- يتم منع النسخ الاحتياطي التلقائي للبيانات الحساسة.