import 'package:flutter/material.dart';
import 'package:my_portfolio/core/app/constants.dart';

class HireMeCard extends StatelessWidget {
  const HireMeCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
        border: Border.all(
          color: screenBg.withAlpha((0.2 * 255).round()),
          strokeAlign: BorderSide.strokeAlignOutside,
        ),
      ),
      child: Column(
        spacing: 15,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              Text(
                "+152.4K",
                style: TextStyle(
                  fontSize: 25,
                  color: screenBg,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                "Working Hours",
                style: TextStyle(
                  color: screenBg.withAlpha((0.5 * 255).round()),
                  fontWeight: FontWeight.w300,
                ),
              ),
            ],
          ),
          InkWell(
            onTap: () {},
            borderRadius: BorderRadius.circular(10),
            child: SizedBox(
              width: double.infinity,
              child: Material(
                color: primaryColor,
                borderRadius: BorderRadius.circular(10),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      "Hire Me",
                      style: TextStyle(
                        fontSize: 16,
                        color: screenBg,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
