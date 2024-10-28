import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 18,
            color: Colors.blue,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: Colors.white,
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarColor: Colors.white),
        title: Container(
          height: 35,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.white70,
            borderRadius: BorderRadius.circular(5),
          ),
          child: const Text('Menu'),
        ),
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            const SizedBox(height: 20),
            // menus Row

            Padding(
              padding: const EdgeInsets.only(left: 18, right: 18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // first column

                  Column(
                    children: [
                      // employees
                      Container(
                        height: 167,
                        width: 170,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          color: Color.fromARGB(25, 133, 143, 233),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        height: 167,
                        width: 170,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          color: Color.fromARGB(35, 255, 228, 228),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        height: 167,
                        width: 170,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          color: Color.fromARGB(25, 133, 143, 233),
                        ),
                      ),

                      const SizedBox(height: 16),
                    ],
                  ),

                  //2nd column

                  Column(
                    children: [
                      // employees
                      Container(
                        height: 167,
                        width: 170,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          color: Color.fromARGB(25, 127, 201, 231),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // employees
                      Container(
                        height: 167,
                        width: 170,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          color: Color.fromARGB(35, 203, 249, 216),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // employees
                      Container(
                        height: 167,
                        width: 170,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          color: Color.fromARGB(35, 255, 228, 228),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
