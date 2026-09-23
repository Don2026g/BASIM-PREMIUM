#!/usr/bin/env bash
set -e

echo ""
echo " BASIM ONE IPTV - Android Integration"
echo ""

# 1. التأكد أننا داخل مشروع Flutter
if ! command -v flutter >/dev/null 2>&1; then
  echo "ERROR: Flutter SDK غير موجود."
  exit 1
fi

if [ ! -f "pubspec.yaml" ]; then
  echo "ERROR: pubspec.yaml غير موجود. هذا ليس جذر مشروع Flutter."
  exit 1
fi

# 2. إذا كان Android موجوداً مسبقاً لا نستبدله
if [ -d "android" ]; then
  echo "Android directory موجود مسبقاً."
else
  echo "Android directory غير موجود."
  echo "إنشاء البنية الرسمية من Flutter..."
  flutter create --platforms=android --project-name=basim_one_iptv .
  echo "تم إنشاء Android directory."
fi

# 3. تحقق إجباري من وجود ملفات Android الأساسية
REQUIRED_PATHS=(
  "android"
  "android/app"
  "android/gradle"
  "android/app/build.gradle"
  "android/settings.gradle"
  "android/gradle.properties"
  "android/gradlew"
  "android/gradle/wrapper"
  "android/gradle/wrapper/gradle-wrapper.properties"
)

for PATH_TO_CHECK in "${REQUIRED_PATHS[@]}"; do
  if [ ! -e "$PATH_TO_CHECK" ]; then
    echo "ERROR: الملف/المجلد مفقود:"
    echo " $PATH_TO_CHECK"
    exit 1
  fi
done

# 4. التأكد من أن Git لا يتجاهل Android
if [ -f ".gitignore" ]; then
  if grep -Eq '^[[:space:]]*/?android/?' .gitignore; then
    echo "ERROR: .gitignore يستبعد مجلد Android."
    echo "يجب إزالة قاعدة استبعاد android."
    exit 1
  fi
fi

# 5. تحقق نهائي
echo ""
echo " ANDROID DIRECTORY VERIFIED SUCCESSFULLY"
echo ""
exit 0
