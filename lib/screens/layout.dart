// lib/screens/naviagtion/presentation/layout.dart
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_portfolio/core/app/constants.dart';
import 'package:my_portfolio/core/app/cubit/app_cubit.dart';
// Ensure these imports point to your actual file locations
import 'package:my_portfolio/screens/naviagtion/presentation/navbar.dart';
import 'package:my_portfolio/screens/naviagtion/presentation/sidebar.dart';

class Layout extends StatefulWidget {
  const Layout({super.key});

  @override
  State<Layout> createState() => _LayoutState();
}

class _LayoutState extends State<Layout> {
  final ScrollController _scrollController = ScrollController();
  final double _pageHeight = 800;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final cubit = AppCubit.of(context);
    final currentIndex = (_scrollController.offset / _pageHeight).round();

    if (currentIndex != cubit.state.selectedPageIndex &&
        currentIndex >= 0 &&
        currentIndex < 6) {
      cubit.changePage(currentIndex);
    }
  }

  void _scrollToPage(int index) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          index * _pageHeight,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // -----------------------------------------------------------
    // 🛠️ NEW 3-STATE RESPONSIVE LOGIC
    // -----------------------------------------------------------
    final bool isMobile = screenWidth < mobileBreakpoint;
    final bool isTablet =
        screenWidth >= mobileBreakpoint && screenWidth < tabletBreakpoint;

    // Determine target width for the spacer
    final double sidebarSpacerWidth = isMobile
        ? 0
        : (isTablet ? iconSidebarWidth : sidebarWidth);

    final pages = const [
      HomePage(),
      ProjectsPage(),
      SkillsPage(),
      AboutPage(),
      TestimonialsPage(),
      ContactPage(),
    ];

    return Stack(
      children: [
        // Background
        Positioned.fill(
          child: Image.asset(
            'assets/images/background-image.png',
            fit: BoxFit.cover,
          ),
        ),
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
            child: Container(color: blackColor.withAlpha((0.1 * 255).round())),
          ),
        ),
        Positioned.fill(
          child: Opacity(
            opacity: 0.2,
            child: Image.asset(
              'assets/images/background-shapes.png',
              fit: BoxFit.cover,
            ),
          ),
        ),

        // Main scaffold
        Scaffold(
          backgroundColor: Colors.transparent,
          body: Row(
            children: [
              Sidebar(onPageSelected: _scrollToPage),
              Expanded(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Column(
                    children: pages
                        .map(
                          (page) => SizedBox(
                            height: _pageHeight,
                            width: double.infinity,
                            child: page,
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Floating NavBar
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Center(child: NavBar(onPageSelected: _scrollToPage)),
        ),
      ],
    );
  }
}

// ... Keep your page widgets as before ...

// ... (All page widgets remain the same) ...
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        '🏠 Home Page',
        style: Theme.of(context).textTheme.headlineMedium,
      ),
    );
  }
}

class ProjectsPage extends StatelessWidget {
  const ProjectsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        '💼 Projects Page',
        style: Theme.of(context).textTheme.headlineMedium,
      ),
    );
  }
}

class SkillsPage extends StatelessWidget {
  const SkillsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        '👤 Skills Page',
        style: Theme.of(context).textTheme.headlineMedium,
      ),
    );
  }
}

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        '👤 About Me Page',
        style: Theme.of(context).textTheme.headlineMedium,
      ),
    );
  }
}

class TestimonialsPage extends StatelessWidget {
  const TestimonialsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        '📩 Testimonials Page',
        style: Theme.of(context).textTheme.headlineMedium,
      ),
    );
  }
}

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        '📩 Contact Page',
        style: Theme.of(context).textTheme.headlineMedium,
      ),
    );
  }
}
