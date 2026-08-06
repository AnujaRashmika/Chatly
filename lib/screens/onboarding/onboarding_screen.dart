import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../utils/preferences.dart';
import '../auth/login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController controller = PageController();
  int currentIndex = 0;

  final List<Map<String, String>> pages = [
    {
      "title": "Connect With Friends",
      "description": "Chat instantly with your friends anytime anywhere",
      "animation": "https://lottie.host/4f0bc830-6a92-4720-ac6d-8fe153050ff2/zA97IkcUBJ.json"
    },
    {
      "title": "Fast And Secure",
      "description": "Your messages are private and secure",
      "animation": "https://lottie.host/2b60a438-b83c-4317-b78f-201c35c792da/WrpEF9cYUf.json"
    },
    {
      "title": "Start Messaging",
      "description": "Enjoy real time messaging experience",
      "animation": "https://lottie.host/e6e92a1c-932b-4078-a1f5-b4f10a56f83a/3Im4FYAK76.json"
    },
  ];

  void finishOnboarding() async {
    await Preferences.setOnboardingCompleted();
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
    );
  }

  void goToNextPage() {
    controller.nextPage(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOutCubic,
    );
  }

  // Single handler for the round arrow button:
  // - on any page except the last -> go to next page
  // - on the last page -> finish onboarding (no separate "Start Messaging" button)
  void onArrowPressed() {
    final bool isLastPage = currentIndex == pages.length - 1;
    if (isLastPage) {
      finishOnboarding();
    } else {
      goToNextPage();
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isLastPage = currentIndex == pages.length - 1;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // ---------- Page content ----------
            Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    controller: controller,
                    itemCount: pages.length,
                    onPageChanged: (index) {
                      setState(() {
                        currentIndex = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Lottie animation, capped so it never
                          // shows at the asset's full default size.
                          SizedBox(
                            width: 260,
                            height: 260,
                            child: Lottie.network(
                              pages[index]["animation"]!,
                              width: 260,
                              height: 260,
                              fit: BoxFit.contain,
                              repeat: true,
                              animate: true,
                              frameRate: FrameRate.max,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(
                                  Icons.image_not_supported_outlined,
                                  size: 80,
                                  color: Colors.grey,
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 36),
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            transitionBuilder: (child, animation) =>
                                FadeTransition(
                                  opacity: animation,
                                  child: SlideTransition(
                                    position: Tween<Offset>(
                                      begin: const Offset(0, 0.2),
                                      end: Offset.zero,
                                    ).animate(animation),
                                    child: child,
                                  ),
                                ),
                            child: Text(
                              pages[index]["title"]!,
                              key: ValueKey(pages[index]["title"]),
                              style: const TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),
                          Padding(
                            padding:
                            const EdgeInsets.symmetric(horizontal: 30),
                            child: Text(
                              pages[index]["description"]!,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                                height: 1.4,
                              ),
                            ),
                          )
                        ],
                      );
                    },
                  ),
                ),

                // ---------- Smooth animated dots (follows the drag live) ----------
                AnimatedBuilder(
                  animation: controller,
                  builder: (context, _) {
                    // controller.page is a fractional value (e.g. 0.35) that
                    // updates on every frame while swiping, so the dots move
                    // in perfect sync with the finger — not just on settle.
                    double page = currentIndex.toDouble();
                    if (controller.hasClients && controller.page != null) {
                      page = controller.page!;
                    }
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        pages.length,
                            (index) {
                          final double distance =
                          (page - index).abs().clamp(0.0, 1.0);
                          final double width = 28 - (20 * distance);
                          final Color color = Color.lerp(
                            const Color(0xFF1da1f2),
                            Colors.grey.shade300,
                            distance,
                          )!;
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                            height: 8,
                            width: width,
                            decoration: BoxDecoration(
                              color: color,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
                const SizedBox(height: 30),

                // ---------- Bottom action area ----------
                // Always just the round arrow-forward button, bottom-right.
                // On the last page it triggers finishOnboarding instead of
                // moving to the next page — no separate "Start Messaging"
                // full-width button.
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SizedBox(
                    height: 56,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: SizedBox(
                        width: 56,
                        height: 56,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1da1f2),
                            foregroundColor: Colors.white,
                            elevation: 3,
                            shadowColor:
                            const Color(0xFF1da1f2).withOpacity(0.4),
                            shape: const CircleBorder(),
                            padding: EdgeInsets.zero,
                          ),
                          onPressed: onArrowPressed,
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 200),
                            transitionBuilder: (child, animation) =>
                                ScaleTransition(
                                    scale: animation, child: child),
                            child: Icon(
                              isLastPage
                                  ? Icons.check_rounded
                                  : Icons.arrow_forward_rounded,
                              key: ValueKey(isLastPage),
                              size: 26,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),

            // ---------- Skip button (top-right, hidden on last slide) ----------
            Positioned(
              top: 8,
              right: 8,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                transitionBuilder: (child, animation) => FadeTransition(
                  opacity: animation,
                  child: ScaleTransition(scale: animation, child: child),
                ),
                child: isLastPage
                    ? const SizedBox.shrink(key: ValueKey('no-skip'))
                    : TextButton(
                  key: const ValueKey('skip'),
                  onPressed: finishOnboarding,
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.grey.shade600,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                  ),
                  child: const Text(
                    "Skip",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
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