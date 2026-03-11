name: Flutter Build

on:
  push:
    branches: [ "main" ]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Set up Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.19.0'
          channel: 'stable'

      - name: Rebuild Android mic_app
        run: |
          flutter create repair_temp --project-name mic_app --platforms android
          rm -rf android
          mv repair_temp/android .
          rm -rf repair_temp
          sed -i 's/minSdkVersion [0-9]\+/minSdkVersion 21/g' android/app/build.gradle
          echo "flutter.minSdkVersion=21" >> android/local.properties
          sed -i '/android {/a \    aaptOptions { noCompress "tflite" }' android/app/build.gradle
          cat <<EOF >> android/app/build.gradle
          dependencies {
              implementation "org.tensorflow:tensorflow-lite:2.14.0"
              implementation "org.tensorflow:tensorflow-lite-select-tf-ops:2.14.0"
          }
          EOF

      - name: Inject Permissions
        run: |
          sed -i '/<application/i \    <uses-permission android:name="android.permission.CAMERA"/>' android/app/src/main/AndroidManifest.xml
          sed -i '/<application/i \    <uses-permission android:name="android.permission.RECORD_AUDIO"/>' android/app/src/main/AndroidManifest.xml

      - name: Build APK
        run: |
          flutter pub get
          flutter build apk --release

      - name: Upload APK
        uses: actions/upload-artifact@v4
        with:
          name: mic_app_release
          path: build/app/outputs/flutter-apk/app-release.apk
