# uGrabv1

## App Description:

uGrab is an a delivery service mobile app targetted at NTU students, and provides a platform for students to post item purchase and delivery jobs, or accept such jobs from other students.

uGrab aims to solve the problem of students needing to buy something urgently but cannot do so themselves due to inconvenience or other reasons, and allows students to put their job up for other students to purchase and deliver the items to them.

## Tools and Frameworks:

This app is developed in flutter, with firebase database integration.

## How to run:

## Getting Started:
Have the latest version of Flutter SDK and Android Studio installed. For more setup instructions, refer to this [link](https://www.liquidweb.com/kb/how-to-install-and-configure-flutter-sdk-windows-10/).

Clone repository into desired file location.

For projects with Firestore integration, you must first run the following commands to ensure the project compiles:

```
flutter pub get
flutter packages pub run build_runner build --delete-conflicting-outputs
```

This command creates the generated files that parse each Record from Firestore into a schema object.

Have an emulator device open in Android Studio. For setup details, refer to this [link](https://developer.android.com/studio/run/managing-avds)

Connect to emulator device on IDE. (If using Visual Studio Code, click on "chrome" on the bottom right hand corner and select emulator device)

run the following command to run the app in emulator:

```
flutter run
```

Note: main source code is in lib/ directory.
