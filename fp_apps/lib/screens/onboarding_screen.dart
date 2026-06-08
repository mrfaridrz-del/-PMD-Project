import 'package:flutter/material.dart';
import 'login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() =>
      _OnboardingScreenState();
}

class _OnboardingScreenState
    extends State<OnboardingScreen> {

  final PageController _pageController =
      PageController();

  int currentIndex = 0;

  final Color primaryColor =
      const Color(0xFF4F46E5);

  final List<Map<String, dynamic>> onboardingData = [

    {
      "image": "assets/images/schedule.jpg",
      "title": "Manage Your Schedule",
      "description":
          "Organize your classes, study time, and activities in one smart planner.",
    },

    {
      "image": "assets/images/track.jpg",
      "title": "Track Assignments Easily",
      "description":
          "Never miss deadlines again with task tracking and reminders.",
    },

    {
      "image": "assets/images/progress.jpg",
      "title": "Improve Productivity",
      "description":
          "Build better study habits and stay focused every day.",
    },
  ];

  void nextPage() {

    if (currentIndex < onboardingData.length - 1) {

      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );

    } else {

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    final bool isTablet =
        MediaQuery.of(context).size.width > 600;

    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: Column(
          children: [

            // SKIP BUTTON
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),

              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.end,

                children: [

                  TextButton(
                    onPressed: () {

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const LoginScreen(),
                        ),
                      );
                    },

                    child: Text(
                      "Skip",
                      style: TextStyle(
                        color: primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // PAGEVIEW
            Expanded(
              child: PageView.builder(
                controller: _pageController,

                onPageChanged: (index) {

                  setState(() {
                    currentIndex = index;
                  });
                },

                itemCount: onboardingData.length,

                itemBuilder: (context, index) {

                  final item =
                      onboardingData[index];

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 28,
                    ),

                    child: Column(
                      mainAxisAlignment:
                          MainAxisAlignment.center,

                      children: [

                        // IMAGE
                        Container(
                          height: isTablet ? 420 : 300,

                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(30),

                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),

                          child: ClipRRect(
                            borderRadius:
                                BorderRadius.circular(30),

                            child: Image.asset(
                              item["image"],
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),

                        const SizedBox(height: 50),

                        // TITLE
                        Text(
                          item["title"],
                          textAlign: TextAlign.center,

                          style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F172A),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // DESCRIPTION
                        Text(
                          item["description"],
                          textAlign: TextAlign.center,

                          style: const TextStyle(
                            fontSize: 16,
                            height: 1.7,
                            color: Color(0xFF475569),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // INDICATOR
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.center,

              children: List.generate(
                onboardingData.length,
                (index) {

                  final bool isActive =
                      currentIndex == index;

                  return AnimatedContainer(
                    duration:
                        const Duration(milliseconds: 300),

                    margin: const EdgeInsets.symmetric(
                      horizontal: 4,
                    ),

                    width: isActive ? 28 : 10,
                    height: 10,

                    decoration: BoxDecoration(
                      color: isActive
                          ? primaryColor
                          : Colors.grey.shade300,

                      borderRadius:
                          BorderRadius.circular(20),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 40),

            // BUTTON
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 28,
              ),

              child: SizedBox(
                width: double.infinity,
                height: 60,

                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,

                    elevation: 0,

                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(20),
                    ),
                  ),

                  onPressed: nextPage,

                  child: Text(
                    currentIndex ==
                            onboardingData.length - 1
                        ? "Get Started"
                        : "Next",

                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}