import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:water_app_buyurtmachi_09_09_2024/screen/login/verification_page.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PhoneNumberPage extends StatefulWidget {
  @override
  _PhoneNumberPageState createState() => _PhoneNumberPageState();
}

class _PhoneNumberPageState extends State<PhoneNumberPage> {
  final TextEditingController _phoneController = TextEditingController();
  final maskFormatter = MaskTextInputFormatter(
    mask: '## ### ####', // Format: 90 883 0450
    filter: {"#": RegExp(r'[0-9]')}, // Only allows digits
  );
  bool _isLoading = false;
  Future<void> _submitPhoneNumber() async {
    final phoneNumber = _phoneController.text.replaceAll(' ', ''); // Remove spaces
    if (phoneNumber.isEmpty) {
      Get.snackbar(
        'Xato',
        'Telefon raqam kiritilmagan',
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
        Uri.parse('http://10.0.2.2:8000/api/user/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'phone': phoneNumber}),
      );
      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        if (responseBody['status'] == true) {
          final box = GetStorage();
          box.write('phone', responseBody['phone']);
          box.write('code', responseBody['code']);
          box.write('message', responseBody['message']);
          print(box.read('code'));
          Get.to(() => VerificationPage());
        } else {
          String errorMessage;
          switch (response.statusCode) {
            case 400:
              errorMessage = 'Ma\'lumotlar noto\'g\'ri.';
              break;
            case 401:
              errorMessage = 'Akkountga kirish ruxsat berilmagan.';
              break;
            case 403:
              errorMessage = 'Ruxsat etilmagan.';
              break;
            case 404:
              errorMessage = 'Manzil topilmadi.';
              break;
            case 500:
              errorMessage = 'Server xatosi.';
              break;
            default:
              errorMessage = 'Noma\'lum xato: ${response.statusCode}';
          }
          Get.snackbar(
            'Xatolik',
            errorMessage,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } else {
        String errorMessage;
        switch (response.statusCode) {
          case 701:
            errorMessage = 'Telefon raqam kiritilmagan.';
            break;
          default:
            errorMessage = 'Noma\'lum xato: ${response.statusCode}';
        }
        Get.snackbar(
          'Xatolik',
          errorMessage,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print('Xatolik: $e'); // Console ga xatolikni chiqarish
      Get.snackbar(
        'Xato',
        'Tarmoq xatosi: ${e.toString()}', // e.toString() ni ishlatish
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
      body: Container(
        color: Colors.white, // Background color matching the logo
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('assets/logo.png'), // Company logo
            const SizedBox(height: 30),
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
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: 'Telefon raqami',
                  labelStyle: const TextStyle(
                    color: Color(0xff00BDF7), // Light blue label color
                  ),
                  prefixText: '+998 ',
                  prefixStyle: const TextStyle(
                    color: Colors.black, // Prefix text color
                    fontWeight: FontWeight.bold, // Make it bold
                  ),
                  border: const OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.all(16),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xff00BDF7), // Border when focused
                      width: 2.0,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey.shade300, // Default border
                      width: 1.0,
                    ),
                  ),
                ),
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  maskFormatter, // Phone number format
                ],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity, // Match the width of the input field
              height: 50, // Button height
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff00BDF7), // Light blue button
                  foregroundColor: Colors.white, // White text
                  shape: RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(8), // Slight radius for button
                  ),
                  elevation: 5, // Button shadow
                ),
                onPressed: _isLoading ? null : _submitPhoneNumber,
                child: _isLoading
                    ? const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                )
                    : const Text(
                  'Kirish',
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
