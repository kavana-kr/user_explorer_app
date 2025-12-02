import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../utils/app_colors.dart';

// screen showing full details of a selected user
class UserDetailScreen extends StatefulWidget {
  final UserModel user; // user to display details for
  const UserDetailScreen({super.key, required this.user});

  @override
  State<UserDetailScreen> createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen> {
  bool showShimmer = true; // enables shimmer animation on load

  @override
  void initState() {
    super.initState();

    // small delay to show shimmer effect before real data
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) setState(() => showShimmer = false);
    });
  }

  // reusable shimmer widget for animated placeholder boxes
  Widget shimmerBox({double height = 18, double width = double.infinity}) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: -2.0, end: 2.0),
      duration: const Duration(milliseconds: 1300),
      builder: (context, value, child) {
        return ShaderMask(
          shaderCallback: (rect) {
            return LinearGradient(
              begin: Alignment(-1 + value, 0),
              end: Alignment(1 + value, 0),
              colors: [
                Colors.white.withOpacity(0.15),
                Colors.white.withOpacity(0.45),
                Colors.white.withOpacity(0.15),
              ],
              stops: const [0.3, 0.5, 0.7],
            ).createShader(rect);
          },
          blendMode: BlendMode.srcATop,
          child: Container(
            height: height,
            width: width,
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.25),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      },
    );
  }

  // fade + slide animation used across profile fields
  Widget fadeSlide({required Widget child, required int ms}) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: ms),
      builder: (context, value, childWidget) => Transform.translate(
        offset: Offset(0, 26 * (1 - value.clamp(0.0, 1.0))),
        child: Opacity(opacity: value.clamp(0.0, 1.0), child: childWidget),
      ),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = widget.user; // selected user
    final isDark = Theme.of(context).brightness == Brightness.dark; // theme check
    final text = isDark ? AppColors.textLight : AppColors.textDark;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,

        // back button
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: text),
          onPressed: () => Navigator.pop(context),
        ),

        // show shimmer blank title or real name
        title: Text(
          showShimmer ? "" : user.name,
          style: TextStyle(color: text, fontWeight: FontWeight.bold),
        ),

        // gradient app bar background
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isDark
                  ? [AppColors.gradientDarkTop, AppColors.gradientDarkBottom]
                  : [AppColors.gradientLightTop, AppColors.gradientLightBottom],
            ),
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // profile picture or shimmer
            fadeSlide(
              ms: 300,
              child: Center(
                child: showShimmer
                    ? shimmerBox(height: 90, width: 90)
                    : CircleAvatar(
                        radius: 45,
                        backgroundColor: AppColors.primary.withOpacity(0.12),
                        child: Text(
                          user.name[0], // first letter as avatar
                          style: const TextStyle(
                            fontSize: 34,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
              ),
            ),

            const SizedBox(height: 26),

            // "User Details" heading
            fadeSlide(
              ms: 400,
              child: showShimmer
                  ? shimmerBox(height: 22, width: 140)
                  : Text(
                      "USER DETAILS",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: text,
                      ),
                    ),
            ),

            const SizedBox(height: 14),

            // details card (username, email, phone, website)
            _card(
              fadeDelay: 450,
              isDark: isDark,
              child: Column(
                children: showShimmer
                    ? shimmerList()
                    : realUserInfo(user, text),
              ),
            ),

            const SizedBox(height: 22),

            // "Address" heading
            fadeSlide(
              ms: 550,
              child: showShimmer
                  ? shimmerBox(height: 22, width: 120)
                  : Text(
                      "ADDRESS",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: text,
                      ),
                    ),
            ),

            const SizedBox(height: 14),

            // details card (city, street, suite, zip)
            _card(
              fadeDelay: 600,
              isDark: isDark,
              child: Column(
                children: showShimmer
                    ? shimmerList()
                    : realAddressInfo(user, text),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // common card container for details and address sections
  Widget _card({
    required bool isDark,
    required int fadeDelay,
    required Widget child,
  }) {
    return fadeSlide(
      ms: fadeDelay,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: AppColors.primary.withOpacity(isDark ? 0.25 : 0.18),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.20 : 0.06),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: child,
      ),
    );
  }

  // shimmer placeholders for list layout
  List<Widget> shimmerList() {
    return [
      shimmerBox(height: 16, width: 200),
      const SizedBox(height: 16),
      shimmerBox(height: 16, width: 160),
      const SizedBox(height: 16),
      shimmerBox(height: 16, width: 180),
      const SizedBox(height: 16),
      shimmerBox(height: 16, width: 140),
    ];
  }

  // actual user information list
  List<Widget> realUserInfo(UserModel u, Color text) {
    return [
      info("Username", u.username, Icons.person, 500, text),
      info("Email", u.email, Icons.email, 550, text),
      info("Phone", u.phone, Icons.phone, 600, text),
      info("Website", u.website, Icons.language, 650, text),
    ];
  }

  // actual address information list
  List<Widget> realAddressInfo(UserModel u, Color text) {
    return [
      info("Street", u.street, Icons.location_on, 650, text),
      info("Suite", u.suite, Icons.apartment, 700, text),
      info("City", u.city, Icons.location_city, 750, text),
      info("Zipcode", u.zipcode, Icons.pin_drop, 800, text),
    ];
  }

  // reusable widget for displaying a single detail row
  Widget info(
    String label,
    String value,
    IconData icon,
    int delay,
    Color text,
  ) {
    return fadeSlide(
      ms: delay,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            // icon background
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withOpacity(0.12),
              ),
              child: Icon(icon, size: 26, color: AppColors.primary),
            ),

            const SizedBox(width: 14),

            // label + value text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: text,
                    ),
                  ),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 14,
                      color: text.withOpacity(0.75),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
