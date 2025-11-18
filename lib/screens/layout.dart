import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iconly/iconly.dart';
import 'package:my_portfolio/core/app/constants.dart';
import 'package:my_portfolio/core/app/cubit/app_cubit.dart';
import 'package:my_portfolio/core/widgets.dart';
import 'package:my_portfolio/screens/naviagtion/presentation/navbar.dart';
import 'package:my_portfolio/screens/naviagtion/presentation/sidebar.dart';

class Layout extends StatefulWidget {
  const Layout({super.key});

  @override
  State<Layout> createState() => _LayoutState();
}

class _LayoutState extends State<Layout> {
  final ScrollController _scrollController = ScrollController();
  final List<GlobalKey> _pageKeys = List.generate(6, (_) => GlobalKey());

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

    double offset = 0;
    for (int i = 0; i < _pageKeys.length; i++) {
      final keyContext = _pageKeys[i].currentContext;
      if (keyContext != null) {
        final box = keyContext.findRenderObject() as RenderBox;
        final pageHeight = box.size.height;

        if (_scrollController.offset < offset + pageHeight / 2) {
          if (cubit.state.selectedPageIndex != i) {
            cubit.changePage(i);
          }
          break;
        }

        offset += pageHeight;
      }
    }
  }

  void _scrollToPage(int index) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      double offset = 0;
      for (int i = 0; i < index; i++) {
        final keyContext = _pageKeys[i].currentContext;
        if (keyContext != null) {
          final box = keyContext.findRenderObject() as RenderBox;
          offset += box.size.height;
        }
      }

      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          offset,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isMobile = screenWidth < mobileBreakpoint;
    final bool isTablet =
        screenWidth >= mobileBreakpoint && screenWidth < tabletBreakpoint;

    final pages = [
      const HomePage(),
      const ProjectsPage(),
      const SkillsPage(),
      const AboutPage(),
      const TestimonialsPage(),
      const ContactPage(),
    ];

    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            'assets/images/background-image.png',
            fit: BoxFit.cover,
          ),
        ),
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
            child: Container(color: blackColor.withOpacity(0.1)),
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
        Scaffold(
          backgroundColor: Colors.transparent,
          body: Row(
            children: [
              Sidebar(onPageSelected: _scrollToPage),
              Expanded(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: List.generate(pages.length, (i) {
                      return SizedBox(
                        key: _pageKeys[i],
                        width: double.infinity,
                        child: pages[i],
                      );
                    }),
                  ),
                ),
              ),
            ],
          ),
        ),
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

// ----------------- HomePage -----------------
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final bool isMobile = size.width > mobileBreakpoint;
    final bool isTablet = size.width > tabletBreakpoint;

    return isMobile
        ? Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isTablet ? 80 : 30,
                  vertical: 80,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(flex: 5, child: _HomeContent(theme: theme)),
                    Expanded(flex: 4, child: _HomeImage(theme: theme)),
                  ],
                ),
              ),
              // Container(
              //   padding: EdgeInsets.symmetric(vertical: 10),
              //   color: primaryColor,
              //   child: MarqueeLoop(
              //     speed: Duration(seconds: 18),
              //     gap: 40,
              //     items: [
              //       marqueeItem("Adaptive"),
              //       marqueeItem("Responsive Design"),
              //       marqueeItem("Clean Code"),
              //       marqueeItem("Fast & Fluid"),
              //       marqueeItem("Scalable Apps"),
              //       marqueeItem("Pixel Perfect"),
              //     ],
              //   ),
              // ),
            ],
          )
        : Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isTablet ? 80 : 30,
                  vertical: 80,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _HomeContent(theme: theme),
                    Center(child: _HomeImage(theme: theme)),
                  ],
                ),
              ),
              // Container(
              //   padding: EdgeInsets.symmetric(vertical: 10),
              //   color: primaryColor,
              //   child: MarqueeLoop(
              //     speed: Duration(seconds: 18),
              //     gap: 40,
              //     items: [
              //       marqueeItem("Adaptive"),
              //       marqueeItem("Responsive Design"),
              //       marqueeItem("Clean Code"),
              //       marqueeItem("Fast & Fluid"),
              //       marqueeItem("Scalable Apps"),
              //       marqueeItem("Pixel Perfect"),
              //     ],
              //   ),
              // ),
            ],
          );
  }
}

class _HomeContent extends StatelessWidget {
  final ThemeData theme;
  const _HomeContent({required this.theme});

  @override
  Widget build(BuildContext context) {
    // Check specifically for mobile size to stack buttons
    final isMobile = MediaQuery.of(context).size.width < mobileBreakpoint;

    // Define buttons here to reuse them cleanly
    final primaryButton = ElevatedButton.icon(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: theme.colorScheme.primary.withOpacity(0.2),
        foregroundColor: theme.colorScheme.primary,
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 0,
      ),
      icon: const Text(
        "View My Work",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      label: const Icon(IconlyLight.arrow_right, size: 18),
    );

    final secondaryButton = OutlinedButton.icon(
      onPressed: () {},
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        side: BorderSide(color: theme.dividerColor),
        foregroundColor: theme.colorScheme.onSurface,
      ),
      label: const Icon(IconlyLight.message, size: 18),
      icon: const Text(
        "Get In Touch",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "I'm Kareem Ehab, a design-driven developer building beautiful experiences.",
          style: theme.textTheme.displaySmall?.copyWith(
            fontWeight: FontWeight.w900,
            fontSize: _getResponsiveFontSize(context, 42),
          ),
        ),
        const SizedBox(height: 15),
        Text(
          "Flutter Development & UI UX Design",
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w300,
            color: theme.colorScheme.onSurface.withOpacity(0.8),
          ),
        ),
        const SizedBox(height: 40),
        Text(
          "Development Tools",
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface.withOpacity(0.8),
          ),
        ),
        const SizedBox(height: 15),
        Wrap(
          spacing: 20,
          runSpacing: 15,
          children: const [
            _ToolItem(label: "Flutter", asset: "assets/icons/flutter-logo.svg"),
            _ToolItem(
              label: "Firebase",
              asset: "assets/icons/firebase-logo.svg",
            ),
            _ToolItem(label: "Figma", asset: "assets/icons/figma-logo.svg"),
            _ToolItem(label: "Github", asset: "assets/icons/github-logo.svg"),
          ],
        ),
        const SizedBox(height: 50),

        // --- Responsive Action Buttons ---
        if (isMobile)
          // Mobile: Stack vertically and stretch to full width
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              primaryButton,
              const SizedBox(height: 15),
              secondaryButton,
            ],
          )
        else
          // Desktop/Tablet: Wrap side-by-side
          Wrap(
            spacing: 20,
            runSpacing: 15,
            children: [primaryButton, secondaryButton],
          ),
        const SizedBox(height: 50),
      ],
    );
  }

  double _getResponsiveFontSize(BuildContext context, double baseSize) {
    double width = MediaQuery.of(context).size.width;
    if (width < 600) return baseSize * 0.7;
    if (width < 1000) return baseSize * 0.85;
    return baseSize;
  }
}

class _HomeImage extends StatelessWidget {
  final ThemeData theme;
  const _HomeImage({required this.theme});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 500, maxHeight: 500),
      child: Stack(
        alignment: Alignment.center,
        children: [
          SvgPicture.asset(
            'assets/images/mobile-background-shape.svg',
            width: 350,
            height: 350,
            color: theme.colorScheme.onSurface,
          ),
          Image.asset('assets/images/phone.png', width: 500),
        ],
      ),
    );
  }
}

class _ToolItem extends StatelessWidget {
  final String label;
  final String asset;

  const _ToolItem({required this.label, required this.asset});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset(
          asset,
          height: 20,
          width: 20,
          color: Theme.of(context).colorScheme.onSurface,
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}

// ----------------- Dummy Pages -----------------
class ProjectsPage extends StatelessWidget {
  const ProjectsPage({super.key});
  @override
  Widget build(BuildContext context) => Center(
    child: SizedBox(
      height: 950,
      child: Text(
        '💼 Projects Page',
        style: Theme.of(context).textTheme.headlineMedium,
      ),
    ),
  );
}

class SkillsPage extends StatelessWidget {
  const SkillsPage({super.key});
  @override
  Widget build(BuildContext context) => Center(
    child: SizedBox(
      height: 350,
      child: Text(
        '👤 Skills Page',
        style: Theme.of(context).textTheme.headlineMedium,
      ),
    ),
  );
}

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});
  @override
  Widget build(BuildContext context) => Center(
    child: Text(
      '👤 About Me Page',
      style: Theme.of(context).textTheme.headlineMedium,
    ),
  );
}

class TestimonialsPage extends StatelessWidget {
  const TestimonialsPage({super.key});
  @override
  Widget build(BuildContext context) => Center(
    child: Text(
      '📩 Testimonials Page',
      style: Theme.of(context).textTheme.headlineMedium,
    ),
  );
}

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});
  @override
  Widget build(BuildContext context) => Center(
    child: Text(
      '📩 Contact Page',
      style: Theme.of(context).textTheme.headlineMedium,
    ),
  );
}
