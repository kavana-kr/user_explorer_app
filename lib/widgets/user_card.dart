import 'package:flutter/material.dart';
import 'package:user_explorer_app/utils/app_colors.dart';
import '../models/user_model.dart';

// reusable card widget to display summary info of a user
class UserCard extends StatelessWidget {
  final UserModel user;            // user data to display
  final bool isFavorite;           // whether this user is marked favorite
  final bool isDark;               // theme flag
  final VoidCallback onFavoriteTap; // callback for favorite icon tap

  const UserCard({
    super.key,
    required this.user,
    required this.isFavorite,
    required this.isDark,
    required this.onFavoriteTap,
  });

  @override
  Widget build(BuildContext context) {
    // check theme dynamically (ensures consistent UI across screens)
    final bool isDark =
        Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),

      // card styling with shadow + border adapting to theme
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.primary.withOpacity(isDark ? 0.25 : 0.18),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.20 : 0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // circle avatar using first letter of user's name
            CircleAvatar(
              radius: 28,
              backgroundColor: AppColors.primary.withOpacity(0.12),
              child: Text(
                user.name[0],
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ),

            const SizedBox(width: 16),

            // user details: name, email, city
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // user name
                  Text(
                    user.name,
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                  ),

                  const SizedBox(height: 6),

                  // email row
                  Row(
                    children: [
                      Icon(Icons.email_outlined,
                          size: 16,
                          color: (isDark
                                  ? AppColors.textLight
                                  : AppColors.textDark)
                              .withOpacity(0.6)),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          user.email,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                                color: (isDark
                                        ? AppColors.textLight
                                        : AppColors.textDark)
                                    .withOpacity(0.75),
                              ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 4),

                  // city row
                  Row(
                    children: [
                      Icon(Icons.location_on_outlined,
                          size: 16,
                          color: (isDark
                                  ? AppColors.textLight
                                  : AppColors.textDark)
                              .withOpacity(0.6)),
                      const SizedBox(width: 6),
                      Text(
                        user.city,
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: (isDark
                                      ? AppColors.textLight
                                      : AppColors.textDark)
                                  .withOpacity(0.75),
                            ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // favorite icon toggle
            IconButton(
              icon: Icon(
                isFavorite
                    ? Icons.favorite
                    : Icons.favorite_border, // filled if favorite
                size: 28,
                color: isFavorite
                    ? AppColors.accent
                    : (isDark
                            ? AppColors.textLight
                            : AppColors.textDark)
                        .withOpacity(0.45),
              ),
              onPressed: onFavoriteTap, // trigger callback on tap
            ),
          ],
        ),
      ),
    );
  }
}
