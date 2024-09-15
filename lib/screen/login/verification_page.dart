import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:water_app_buyurtmachi_09_09_2024/screen/home/home_page.dart';
import 'dart:convert';
import 'name_page.dart';  // NamePage import

class VerificationPage extends StatefulWidget {
  @override
  _VerificationPageState createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  final box = GetStorage();
  final List<TextEditingController> _controllers =
  List.generate(5, (_) => TextEditingController());
  Timer? _timer;
  int _remainingTime = 10; // Time in seconds
  bool _isLoading = false; // Loading indicator

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingTime > 0) {
          _remainingTime--;
        } else {
          _timer?.cancel();
        }
      });
    });
  }

  void _resendCode() async {
    final phone = box.read('phone'); // Retrieve phone number from GetStorage

    if (phone == null) {
      Get.snackbar(
        'Xato',
        'Telefon raqami mavjud emas',
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
        body: json.encode({'phone': phone}),
      );

      if (response.statusCode == 200) {
        // Successfully resent the code
        final responseBody = json.decode(response.body);
        box.write('message', responseBody['message']);
        print(responseBody['code']);
        setState(() {
          _remainingTime = 120; // Reset the timer
          _startTimer(); // Start the timer again
        });
        Get.snackbar(
          'Muvaffaqiyatli',
          'Kod qayta yuborildi',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        // Handle HTTP errors
        String errorMessage;
        switch (response.statusCode) {
          case 400:
            errorMessage = 'Xato talab qilindi.';
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
  void dispose() {
    _timer?.cancel();
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _handleTextChange(String value, int index) {
    if (value.length == 1) {
      if (index < 4) {
        FocusScope.of(context).nextFocus();
      }
    } else if (value.isEmpty) {
      if (index > 0) {
        FocusScope.of(context).previousFocus();
      }
    }
  }

  Future<void> _verifyCode() async {
    final code = _controllers.map((controller) => controller.text).join();
    final phone = box.read('phone'); // Phone number should be saved in GetStorage

    if (code.isEmpty || phone == null) {
      Get.snackbar(
        'Xato',
        'Kod yoki telefon raqami mavjud emas',
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
        Uri.parse('http://10.0.2.2:8000/api/user/login/code'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'phone': phone, 'code': code}),
      );

      if (response.statusCode == 200) {
        Get.off(() => NamePage());
      } else if (response.statusCode == 201) {
        final responseBody = json.decode(response.body);
        await box.write('token', responseBody['token']);
        Get.off(() => HomePage());
      } else {
        String errorMessage;
        switch (response.statusCode) {
          case 701:
            errorMessage = 'Tasdiqlash kodin noto\'g\'ri kiritildi.';
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
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white, // Matching background color
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "${box.read('message') ?? 'Tasdiqlash kodi sizning raqamingizga yuborildi. Kodni kiriting.'}",
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(5, (index) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  child: SizedBox(
                    width: 50, // Adjust width as needed
                    height: 50, // Adjust height as needed
                    child: TextField(
                      controller: _controllers[index],
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(vertical: 14),
                      ),
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      inputFormatters: [
                        // Limit input to one character
                        LengthLimitingTextInputFormatter(1),
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      onChanged: (value) => _handleTextChange(value, index),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 20),
            if (_remainingTime > 0)
              Text(
                '$_remainingTime s',
                style: const TextStyle(fontSize: 16, color: Colors.red),
              ),
            if (_remainingTime == 0)
              SizedBox(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    // Light blue button
                    foregroundColor: Color(0xff00BDF7), // White text
                    shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(8), // Slight radius for button
                    ),
                    elevation: 5, // Button shadow
                  ),
                  onPressed: _resendCode, // Call _resendCode method
                  child: const Text(
                    'Qayta yuborish',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
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
                onPressed: _isLoading ? null : _verifyCode,
                child: _isLoading
                    ? const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                )
                    : const Text(
                  'Tasdiqlash',
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
