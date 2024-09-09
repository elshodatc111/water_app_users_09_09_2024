import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Water",style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold,color: Colors.white),
                ),
                const SizedBox(width: 10),
              ],
            ),
          ],
        ),
        backgroundColor: const Color(0xFF3498db), // Och ko'k
        elevation: 0,
      ),
      body: Column(
        children: [
          // Geolokatsiya tugmasi
          Container(
            color: Colors.blue.shade400,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Joriy joylashuv",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.location_on, color: Color(0xFF000000)),
                  onPressed: () {
                    // Geolokatsiyani aniqlash funksiyasi
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Yetkazib beruvchi tashkilotlar ro'yxati (Karta formatida)
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              itemCount: 15, // Tashkilotlar soni
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 3,
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8), // Rounded corners
                      child: Image.asset(
                        'assets/logo.jpg', // Tashkilot rasmi
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Tashkilot nomi', style: TextStyle(fontWeight: FontWeight.bold,),),
                        Row(
                          children: [
                            const Icon(Icons.star, color: Colors.amber, size: 20),
                            const SizedBox(width: 4),
                            Text('4.5', style: TextStyle(color: Colors.grey[600])),
                          ],
                        ),
                      ],
                    ),
                    subtitle: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [

                                SizedBox(width: 4),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(Icons.access_time, color: Color(0xFF3498db), size: 20),
                                        Text('Ish vaqti', style: TextStyle(color: Color(0xFF3498db))),
                                      ],
                                    ),

                                    Text('09:00 - 20:00', style: TextStyle(color: Colors.grey)),
                                  ],
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                SizedBox(width: 4),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(Icons.monetization_on, color: Color(0xFF3498db), size: 16),
                                        Text('Narxi', style: TextStyle(color: Color(0xFF3498db))),
                                      ],
                                    ),

                                    Text('10 000 so\'m', style: TextStyle(color: Colors.grey)),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      // Tashkilot haqida batafsil ma'lumot
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
