import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kalivra/core/app_theme.dart';
import '../../widgets/drawer/drawer_screen_app_bar.dart';

/// Privacy policy: scrollable text.
class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  static const String _policyText = '''
سياسة الخصوصية

آخر تحديث: يناير 2024

نحن في كليفرة نحترم خصوصيتك ونلتزم بحماية بياناتك الشخصية. توضح هذه السياسة كيفية جمع واستخدام ومشاركة معلوماتك عند استخدام تطبيقنا.

1. المعلومات التي نجمعها
نجمع المعلومات التي تقدمها عند التسجيل أو الطلب، مثل الاسم، البريد الإلكتروني، رقم الجوال، والعنوان. كما نجمع تلقائياً بعض البيانات التقنية لتحسين أداء التطبيق.

2. استخدام المعلومات
نستخدم معلوماتك لمعالجة الطلبات، التواصل معك، تحسين خدماتنا، وإرسال عروض قد تهمك (بموافقتك).

3. حماية البيانات
نطبق إجراءات أمنية مناسبة لحماية بياناتك من الوصول غير المصرح به أو التسريب.

4. مشاركة المعلومات
لا نبيع بياناتك الشخصية. قد نشارك معلومات مع شركاء الخدمة (مثل الشحن والدفع) فقط بما يلزم لتنفيذ طلبك.

5. حقوقك
يمكنك طلب الوصول أو التصحيح أو الحذف لبياناتك عبر التواصل معنا.

لأي استفسار: support@kalivra.com
''';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: const DrawerScreenAppBar(title: 'سياسة الخصوصية'),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
          child: Padding(
            padding: EdgeInsets.all(20.w),
            child: Text(
              _policyText,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: isDark ? AppColors.offWhite : AppColors.black,
                height: 1.6,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
