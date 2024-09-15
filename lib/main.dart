import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:water_app_buyurtmachi_09_09_2024/screen/home/home_page.dart';
import 'package:water_app_buyurtmachi_09_09_2024/screen/login/name_page.dart';
import 'package:water_app_buyurtmachi_09_09_2024/screen/login/phone_number_page.dart';
import 'package:water_app_buyurtmachi_09_09_2024/screen/login/verification_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Retrieve token from storage
    final box = GetStorage();
    final token = box.read('token');

    // Delay for splash screen effect
    Future.delayed(const Duration(seconds: 3), () {
      if (token != null) {
        // Token exists, navigate to HomePage
        Get.off(() => HomePage());
      } else {
        // No token, navigate to PhoneNumberPage
        Get.off(() => PhoneNumberPage());
      }
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('assets/logo.png'), // Your logo image
            const SizedBox(height: 20),
            const Text(
              'Yuklanmoqda...',
              style: TextStyle(
                fontSize: 18,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
