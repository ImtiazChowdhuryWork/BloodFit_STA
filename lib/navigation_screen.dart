// import 'package:bloodfit/features/home/presentation/home_screen.dart';
// import 'package:bloodfit/features/meal_plan_feature_options/presentation/meal_plan_feature_options.dart';
// import 'package:bloodfit/features/meal_scanner/presentation/meal_scanner_screen.dart';
// import 'package:bloodfit/features/work_out/presentation/work_out_screen.dart';
// import 'package:bloodfit/gen/assets.gen.dart';
// import 'package:bloodfit/helper/ui_helpers.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/svg.dart';
// import '../../../gen/colors.gen.dart';

// class NavigationScreen extends StatefulWidget {
//   const NavigationScreen({super.key});

//   @override
//   State<NavigationScreen> createState() => _NavigationScreenState();
// }

// class _NavigationScreenState extends State<NavigationScreen> {
//   int _selectedIndex = 0;
//   late PageController _pageController;

//   final List<Widget> _pages = [
//     HomeScreen(),
//     MealPlanFeatureOptions(),
//     MealScannerScreen(),
//     WorkOutScreen(),
//     HomeScreen(),
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _pageController = PageController(initialPage: _selectedIndex);
//   }

//   @override
//   void dispose() {
//     _pageController.dispose();
//     super.dispose();
//   }

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//       _pageController.animateToPage(
//         index,
//         duration: const Duration(milliseconds: 300),
//         curve: Curves.ease,
//       );
//     });
//   }

//   void _onPageChanged(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.scaffoldBackgroundColor,
//       body: SafeArea(
//         child: PageView(
//           controller: _pageController,
//           onPageChanged: _onPageChanged,
//           children: _pages,
//         ),
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
//       floatingActionButton: Padding(
//         padding: EdgeInsets.symmetric(horizontal: UIHelper.kDefaulutPadding()),
//         child: Container(
//           height: 72.h, // Optimal height for navigation bar
//           width: 1.sw,
//           padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 8.h),
//           decoration: BoxDecoration(
//             color: AppColors.c3c3c3c,
//             borderRadius: BorderRadius.circular(16.r),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.1),
//                 blurRadius: 25.r,
//                 offset: const Offset(0, 4),
//               ),
//             ],
//           ),
//           child: AnimatedNavigationBar(
//             selectedIndex: _selectedIndex,
//             onItemTapped: _onItemTapped,
//           ),
//         ),
//       ),
//     );
//   }
// }

// class AnimatedNavigationBar extends StatelessWidget {
//   final int selectedIndex;
//   final Function(int) onItemTapped;

//   const AnimatedNavigationBar({
//     super.key,
//     required this.selectedIndex,
//     required this.onItemTapped,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceAround,
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         _buildNavItem(0, Assets.icons.homeIcon, "Home"),
//         _buildNavItem(1, Assets.icons.mealIcon, "Meal"),
//         _buildMiddleNavItem(2, Assets.icons.scanIcon, "Scanner"),
//         _buildNavItem(3, Assets.icons.workoutIcon, "Workout"),
//         _buildNavItem(4, Assets.icons.progressIcon, "Progress"),
//       ],
//     );
//   }

//   Widget _buildNavItem(int index, String icon, String title) {
//     return GestureDetector(
//       onTap: () => onItemTapped(index),
//       child: Container(
//         height: 56.h, // Fixed height for regular items
//         width: 52.w, // Fixed width to prevent expansion
//         alignment: Alignment.center,
//         child: NavItem(
//           icon: icon,
//           title: title,
//           currentIndex: index,
//           selectedIndex: selectedIndex,
//         ),
//       ),
//     );
//   }

//   Widget _buildMiddleNavItem(int index, String icon, String title) {
//     return GestureDetector(
//       onTap: () => onItemTapped(index),
//       child: Container(
//         height: 64.h, // Slightly taller for  middlebutton
//         width: 70.w, // Slightly wider for middle button
//         alignment: Alignment.center,
//         padding: EdgeInsets.only(top: 8.h, bottom: 4.h),
//         decoration: BoxDecoration(
//           color: AppColors.cc6c6c6,
//           borderRadius: BorderRadius.only(
//             topLeft: Radius.circular(8.r),
//             topRight: Radius.circular(8.r),
//           ),
//         ),
//         child: NavItem(
//           icon: icon,
//           title: title,
//           currentIndex: index,
//           selectedIndex: selectedIndex,
//           isCenter: true,
//         ),
//       ),
//     );
//   }
// }

// class NavItem extends StatefulWidget {
//   final String icon;
//   final String title;
//   final int currentIndex;
//   final int selectedIndex;
//   final bool isCenter;

//   const NavItem({
//     super.key,
//     required this.icon,
//     required this.title,
//     required this.currentIndex,
//     required this.selectedIndex,
//     this.isCenter = false,
//   });

//   @override
//   State<NavItem> createState() => _NavItemState();
// }

// class _NavItemState extends State<NavItem> with TickerProviderStateMixin {
//   late AnimationController _scaleController;
//   late Animation<double> _scaleAnimation;

//   @override
//   void initState() {
//     super.initState();

//     _scaleController = AnimationController(
//       duration: const Duration(milliseconds: 200),
//       vsync: this,
//     );

//     _scaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
//       CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
//     );
//   }

//   @override
//   void dispose() {
//     _scaleController.dispose();
//     super.dispose();
//   }

//   @override
//   void didUpdateWidget(NavItem oldWidget) {
//     super.didUpdateWidget(oldWidget);

//     if (widget.selectedIndex == widget.currentIndex &&
//         oldWidget.selectedIndex != widget.currentIndex) {
//       _scaleController.forward();
//     } else if (widget.selectedIndex != widget.currentIndex &&
//         oldWidget.selectedIndex == widget.currentIndex) {
//       _scaleController.reverse();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final bool isSelected = widget.selectedIndex == widget.currentIndex;

//     return AnimatedBuilder(
//       animation: _scaleAnimation,
//       builder: (context, child) {
//         return Transform.scale(
//           scale: isSelected ? _scaleAnimation.value : 1.0,
//           child: Container(
//             height: double.infinity, // Take full available height
//             width: double.infinity, // Take full available width
//             child: Column(
//               mainAxisSize: MainAxisSize.max,
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 // Icon
//                 SvgPicture.asset(
//                   widget.icon,
//                   height: 22.h,
//                   width: 22.w,
//                   color: widget.isCenter
//                       ? AppColors.c3c3c3c
//                       : isSelected
//                       ? AppColors.cFFFFFF
//                       : AppColors.c727272,
//                 ),

//                 // Spacing
//                 UIHelper.verticalSpace(4.h),

//                 // Text - Constrained with Expanded
//                 Expanded(
//                   child: FittedBox(
//                     fit: BoxFit.scaleDown,
//                     child: Text(
//                       widget.title,
//                       style: TextStyle(
//                         color: widget.isCenter
//                             ? AppColors.c3c3c3c
//                             : isSelected
//                             ? AppColors.cFFFFFF
//                             : AppColors.c727272,
//                         fontSize: 11.sp, // Good readable size
//                         fontWeight: FontWeight.w500,
//                         height: 1.0,
//                       ),
//                       maxLines: 1,
//                     ),
//                   ),
//                 ),

//                 // Spacing
//                 UIHelper.verticalSpace(2.h),

//                 // Indicator
//                 AnimatedContainer(
//                   duration: const Duration(milliseconds: 300),
//                   curve: Curves.easeInOut,
//                   width: isSelected ? 64.w : 0,
//                   height: isSelected ? 8.h : 0,
//                   decoration: BoxDecoration(
//                     color: isSelected ? AppColors.cb20000 : Colors.transparent,
//                     borderRadius: BorderRadius.only(
//                       topLeft: Radius.circular(10.r),
//                       topRight: Radius.circular(10.r),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

import 'package:bloodfit/features/home/presentation/home_screen.dart';
import 'package:bloodfit/features/meal_plan_feature_options/presentation/meal_plan_feature_options.dart';
import 'package:bloodfit/features/meal_scanner/presentation/meal_scanner_screen.dart';
import 'package:bloodfit/features/weight_history/presentation/weight_history_screen.dart';
import 'package:bloodfit/features/work_out/presentation/work_out_screen.dart';
import 'package:bloodfit/gen/assets.gen.dart';
import 'package:bloodfit/helper/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../../../gen/colors.gen.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  int _selectedIndex = 0;
  late PageController _pageController;

  // Remove MealScannerScreen from pages - it will be a separate screen
  final List<Widget> _pages = [
    HomeScreen(),
    MealPlanFeatureOptions(),
    Container(), // Placeholder for scanner index
    WorkOutScreen(),
    WeightHistoryScreen(), // Replace with your Progress screen
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectedIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    if (index == 2) {
      // Scanner button tapped - navigate to MealScannerScreen
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MealScannerScreen()),
      );
    } else {
      setState(() {
        _selectedIndex = index;
        _pageController.animateToPage(
          index,
          duration: const Duration(milliseconds: 300),
          curve: Curves.ease,
        );
      });
    }
  }

  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundColor,
      body: SafeArea(
        child: PageView(
          controller: _pageController,
          onPageChanged: _onPageChanged,
          children: _pages,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: EdgeInsets.symmetric(horizontal: UIHelper.kDefaulutPadding()),
        child: Container(
          height: 72.h,
          width: 1.sw,
          padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 8.h),
          decoration: BoxDecoration(
            color: AppColors.c3c3c3c,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 25.r,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: AnimatedNavigationBar(
            selectedIndex: _selectedIndex,
            onItemTapped: _onItemTapped,
          ),
        ),
      ),
    );
  }
}

class AnimatedNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const AnimatedNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildNavItem(0, Assets.icons.homeIcon, "Home"),
        _buildNavItem(1, Assets.icons.mealIcon, "Meal"),
        _buildMiddleNavItem(2, Assets.icons.scanIcon, "Scanner"),
        _buildNavItem(3, Assets.icons.workoutIcon, "Workout"),
        _buildNavItem(4, Assets.icons.progressIcon, "Progress"),
      ],
    );
  }

  Widget _buildNavItem(int index, String icon, String title) {
    return GestureDetector(
      onTap: () => onItemTapped(index),
      child: Container(
        height: 56.h,
        width: 52.w,
        alignment: Alignment.center,
        child: NavItem(
          icon: icon,
          title: title,
          currentIndex: index,
          selectedIndex: selectedIndex,
        ),
      ),
    );
  }

  Widget _buildMiddleNavItem(int index, String icon, String title) {
    return GestureDetector(
      onTap: () => onItemTapped(index),
      child: Container(
        height: 64.h,
        width: 70.w,
        alignment: Alignment.center,
        padding: EdgeInsets.only(top: 8.h, bottom: 4.h),
        decoration: BoxDecoration(
          color: AppColors.cc6c6c6,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(8.r),
            topRight: Radius.circular(8.r),
          ),
        ),
        child: NavItem(
          icon: icon,
          title: title,
          currentIndex: index,
          selectedIndex: selectedIndex,
          isCenter: true,
        ),
      ),
    );
  }
}

class NavItem extends StatefulWidget {
  final String icon;
  final String title;
  final int currentIndex;
  final int selectedIndex;
  final bool isCenter;

  const NavItem({
    super.key,
    required this.icon,
    required this.title,
    required this.currentIndex,
    required this.selectedIndex,
    this.isCenter = false,
  });

  @override
  State<NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<NavItem> with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(NavItem oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.selectedIndex == widget.currentIndex &&
        oldWidget.selectedIndex != widget.currentIndex) {
      _scaleController.forward();
    } else if (widget.selectedIndex != widget.currentIndex &&
        oldWidget.selectedIndex == widget.currentIndex) {
      _scaleController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isSelected = widget.selectedIndex == widget.currentIndex;

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: isSelected ? _scaleAnimation.value : 1.0,
          child: Container(
            height: double.infinity,
            width: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  widget.icon,
                  height: 22.h,
                  width: 22.w,
                  color: widget.isCenter
                      ? AppColors.c3c3c3c
                      : isSelected
                      ? AppColors.cFFFFFF
                      : AppColors.c727272,
                ),
                UIHelper.verticalSpace(4.h),
                Expanded(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      widget.title,
                      style: TextStyle(
                        color: widget.isCenter
                            ? AppColors.c3c3c3c
                            : isSelected
                            ? AppColors.cFFFFFF
                            : AppColors.c727272,
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w500,
                        height: 1.0,
                      ),
                      maxLines: 1,
                    ),
                  ),
                ),
                UIHelper.verticalSpace(2.h),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  width: isSelected ? 64.w : 0,
                  height: isSelected ? 8.h : 0,
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.cb20000 : Colors.transparent,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10.r),
                      topRight: Radius.circular(10.r),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
