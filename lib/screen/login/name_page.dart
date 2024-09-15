import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:water_app_buyurtmachi_09_09_2024/screen/home/home_page.dart';
import 'dart:convert';

class NamePage extends StatefulWidget {
  @override
  _NamePageState createState() => _NamePageState();
}

class _NamePageState extends State<NamePage> {
  final TextEditingController _nameController = TextEditingController();
  final box = GetStorage();
  bool _isLoading = false; // Loading indicator

  Future<void> _register() async {
    final name = _nameController.text;
    final phone = box.read('phone'); // Phone number should be saved in GetStorage

    if (name.isEmpty || phone == null) {
      Get.snackbar(
        'Xato',
        'Ism yoki telefon raqami mavjud emas',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    setState(() {
      _isLoading = true; // Show loading indicator
    });

    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:8000/api/user/login/name'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'phone': phone, 'name': name}),
      );

      if (response.statusCode == 201) {
        final responseBody = json.decode(response.body);
        if (responseBody['status'] == 'token') {
          await box.write('token', responseBody['token']);
          Get.off(() => HomePage());
        } else {
          Get.snackbar(
            'Xato',
            'Noma\'lum status',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } else {
        // Handle other HTTP errors
        Get.snackbar(
          'Xato',
          'Server bilan aloqa o\'rnatilmadi: ${response.statusCode}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print('Xatolik: $e');
      Get.snackbar(
        'Xato',
        'Tarmoq xatosi: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      setState(() {
        _isLoading = false; // Always hide loading indicator
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Matching background color
      appBar: AppBar(
        backgroundColor: Colors.white, // Matching AppBar color
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade300,
                    blurRadius: 10,
                    offset: const Offset(0, 5), // Shadow for text field
                  ),
                ],
              ),
              child: TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Ismingizni kiriting',
                  labelStyle: const TextStyle(
                    color: Color(0xff00BDF7), // Light blue label color
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.all(16),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: Color(0xff00BDF7), // Border when focused
                      width: 2.0,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: Colors.grey.shade300, // Default border
                      width: 1.0,
                    ),
                  ),
                ),
                keyboardType: TextInputType.text,
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff00BDF7), // Light blue button
                  foregroundColor: Colors.white, // White text
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8), // Slight radius for button
                  ),
                  elevation: 5, // Button shadow
                ),
                onPressed: _isLoading ? null : _register,
                child: _isLoading
                    ? const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                )
                    : const Text(
                  'Ro\'yxatdan o\'tish',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
