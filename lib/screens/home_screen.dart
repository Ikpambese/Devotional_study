// ignore_for_file: library_private_types_in_public_api

import 'package:adminnewlifedevotion/screens/today.dart';
import 'package:flutter/material.dart';

import '../services/service_model.dart';
import 'upload_pdf.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Service> services = [
    Service('Upload today', 'assets/imgs/studying.png'),
    Service('Upload Pdf', 'assets/imgs/january.png'),
    Service('All', 'assets/imgs/schedule.png'),
    Service('Update church ', 'assets/imgs/church1.png'),
  ];

  int selectedService = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          actions: const [
            CircleAvatar(
              backgroundImage: AssetImage('assets/imgs/church.png'),
            ),
            SizedBox(width: 15)
          ],
        ),
        backgroundColor: Colors.white,
        floatingActionButton: selectedService >= 0
            ? FloatingActionButton(
                foregroundColor: Colors.white,
                onPressed: () {
                  if (selectedService == 0) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UploadDevotionalDataPage(),
                      ),
                    );
                  } else if (selectedService == 1) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UploadPdfScreen(),
                      ),
                    );
                  } else if (selectedService == 2) {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => const RegistrationPage(),
                    //   ),
                    // );
                  } else if (selectedService == 3) {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => const RegistrationPage(),
                    //   ),
                    // );
                  }
                },
                backgroundColor: const Color.fromARGB(255, 13, 71, 161),
                child: const Icon(
                  Icons.arrow_forward_ios,
                  size: 20,
                ),
              )
            : null,
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 120.0, right: 20.0, left: 20.0),
                  child: Text(
                    'Angel Gabriel\n Daily Devotional',
                    style: TextStyle(
                      fontSize: 40,
                      color: Colors.grey.shade900,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
            ];
          },
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 1.0,
                          crossAxisSpacing: 20.0,
                          mainAxisSpacing: 20.0,
                        ),
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: services.length,
                        itemBuilder: (BuildContext context, int index) {
                          return serviceContainer(services[index].imageURL,
                              services[index].name, index);
                        }),
                  ),
                ]),
          ),
        ));
  }

  serviceContainer(String image, String name, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (selectedService == index) {
            selectedService = -1;
          } else {
            selectedService = index;
          }
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: selectedService == index
              ? Colors.blue.shade50
              : Colors.grey.shade100,
          border: Border.all(
            color: selectedService == index
                ? const Color.fromARGB(255, 13, 71, 161)
                : const Color.fromARGB(255, 13, 71, 161).withOpacity(0),
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(image, height: 80),
              const SizedBox(
                height: 20,
              ),
              Text(
                name,
                style: const TextStyle(fontSize: 20),
              )
            ]),
      ),
    );
  }
}
