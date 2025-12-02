import 'package:flutter/material.dart';
import 'package:user_explorer_app/utils/app_colors.dart';
import 'package:user_explorer_app/utils/app_constants.dart';

// custom reusable search bar widget
class MySearchBar extends StatefulWidget {
  final Function(String) onChanged;            // callback on text change
  final bool isDark;                           // theme flag
  final TextEditingController controller;      // search input controller

  const MySearchBar({
    super.key,
    required this.isDark,
    required this.onChanged,
    required this.controller,
  });

  @override
  State<MySearchBar> createState() => _MySearchBarState();
}

class _MySearchBarState extends State<MySearchBar> {
  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDark;
    final controller = widget.controller;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface, // background
        borderRadius: BorderRadius.circular(12), // rounded container
      ),
      child: TextField(
        controller: controller,

        // passes search text up to parent
        onChanged: (value) {
          widget.onChanged(value);
          setState(() {}); // updates suffix icon
        },

        decoration: InputDecoration(
          hintText: AppConstants.seachBar, // placeholder text

          // left search icon
          prefixIcon: Icon(
            Icons.search,
            color: isDark ? AppColors.textLight : Colors.black,
          ),

          // clear button when text is not empty
          suffixIcon: controller.text.isNotEmpty
              ? IconButton(
                  icon: Icon(
                    Icons.close,
                    color: isDark ? AppColors.textLight : Colors.black,
                  ),
                  onPressed: () {
                    controller.clear();        // clear text
                    widget.onChanged("");      // notify parent
                    setState(() {});           // rebuild
                  },
                )
              : null,

          border: InputBorder.none,            // clean borderless look
          contentPadding: const EdgeInsets.symmetric(horizontal: 12),
        ),

        // adapts text color to theme
        style: TextStyle(
          color: isDark ? AppColors.textLight : Colors.black,
        ),
      ),
    );
  }
}
