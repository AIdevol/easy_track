import 'package:app_task/constants/colors.dart';
import 'package:app_task/constants/images.dart';
import 'package:app_task/utilities/custom_container.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColor,
      floatingActionButton: _buttonView(context),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [Gap(70), _headerDetailsView(context)],
        ),
      ),
    );
  }
}

/// Header view
_headerDetailsView(BuildContext context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Easy Track",
            style: TextStyle(
                fontSize: 25, color: Colors.black, fontWeight: FontWeight.bold),
          ),
          Text(
            "Welcome, Devesh",
            style: TextStyle(
              fontSize: 16,
              color: Colors.black,
            ),
          ),
        ],
      ),
      GestureDetector(
        onTap: () => context.go('/profile'),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            // borderRadius: BorderRadius.circular(20),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                offset: const Offset(4, 4),
                blurRadius: 10,
              ),
              BoxShadow(
                color: Colors.white.withOpacity(0.8),
                offset: const Offset(-4, -4),
                blurRadius: 10,
              ),
            ],
          ),
          child: CircleAvatar(
            radius: 30,
            backgroundImage: AssetImage(appIcon),
          ),
        ),
      )
    ],
  );
}

///button view

_buttonView(BuildContext context) {
  return InkWell(
      onTap: () {
        context.go("/createTask");
      },
      child: Stack(
        children: [
          // Outer Container
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: Colors.white,
              // borderRadius: BorderRadius.circular(20),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  offset: const Offset(4, 4),
                  blurRadius: 10,
                ),
                BoxShadow(
                  color: Colors.white.withOpacity(0.8),
                  offset: const Offset(-4, -4),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Center(
              child: Image.asset(
                addIcon,
                height: 30,
                width: 30,
                fit: BoxFit.contain,
                color: Colors.black,
              ),
            ),
          ),

          // Inner Shadow Layer
          ClipRRect(
            borderRadius: BorderRadius.circular(75),
            child: Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                // borderRadius: BorderRadius.circular(20),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    offset: const Offset(-4, -4),
                    blurRadius: 10,
                    spreadRadius: 3,
                  ),
                  BoxShadow(
                    color: Colors.white.withOpacity(0.8),
                    offset: const Offset(4, 4),
                    blurRadius: 10,
                    spreadRadius: 3,
                  ),
                ],
              ),
              child: Center(
                child: Image.asset(
                  addIcon,
                  height: 30,
                  width: 30,
                  fit: BoxFit.contain,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ));
}
