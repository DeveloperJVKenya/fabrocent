import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';
import '../../../core/services/app_logger.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  // Logo: scale in + fade in
  late final Animation<double> _logoScale;
  late final Animation<double> _logoFade;

  // Wordmark: slide up + fade in
  late final Animation<double> _wordFade;
  late final Animation<Offset> _wordSlide;

  // Tagline: fade in
  late final Animation<double> _tagFade;

  // Loading dots: fade in
  late final Animation<double> _dotsFade;

  @override
  void initState() {
    super.initState();

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.light,
    ));

    AppLogger.ui('SplashScreen: initializing animation (1800ms)');

    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    _logoScale = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(
          parent: _ctrl,
          curve: const Interval(0.08, 0.48, curve: Curves.easeOutBack)),
    );
    _logoFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
          parent: _ctrl,
          curve: const Interval(0.08, 0.38, curve: Curves.easeOut)),
    );
    _wordFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
          parent: _ctrl,
          curve: const Interval(0.38, 0.62, curve: Curves.easeOut)),
    );
    _wordSlide = Tween<Offset>(
            begin: const Offset(0, 0.5), end: Offset.zero)
        .animate(CurvedAnimation(
            parent: _ctrl,
            curve: const Interval(0.38, 0.62, curve: Curves.easeOutCubic)));
    _tagFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
          parent: _ctrl,
          curve: const Interval(0.57, 0.80, curve: Curves.easeOut)),
    );
    _dotsFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
          parent: _ctrl,
          curve: const Interval(0.75, 1.0, curve: Curves.easeOut)),
    );

    _ctrl.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        AppLogger.ui('SplashScreen: animation complete — waiting for router redirect');
      }
    });

    _ctrl.forward();
    AppLogger.ui('SplashScreen: animation started');
  }

  @override
  void dispose() {
    AppLogger.ui('SplashScreen: disposed');
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Scaffold(
      backgroundColor: const Color(0xFF0A2912),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF071B0C),
              Color(0xFF0E3D1E),
              Color(0xFF1A5C31),
            ],
            stops: [0.0, 0.45, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // â”€â”€ Decorative orbs (match welcome screen language) â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
            Positioned(
              top: -size.width * 0.28,
              right: -size.width * 0.28,
              child: _Orb(diameter: size.width * 0.9, opacity: 0.045),
            ),
            Positioned(
              bottom: size.height * 0.18,
              left: -size.width * 0.22,
              child: _Orb(diameter: size.width * 0.55, opacity: 0.035),
            ),
            // Accent dot (M-Pesa gold)
            Positioned(
              top: size.height * 0.60,
              right: size.width * 0.08,
              child: _Orb(
                  diameter: size.width * 0.18,
                  opacity: 0.07,
                  color: const Color(0xFFE09810)),
            ),

            // â”€â”€ Main content â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
            SafeArea(
              child: Column(
                children: [
                  SizedBox(height: size.height * 0.14),

                  // Logo
                  FadeTransition(
                    opacity: _logoFade,
                    child: ScaleTransition(
                      scale: _logoScale,
                      child: _LogoBadge(),
                    ),
                  ),

                  SizedBox(height: size.height * 0.038),

                  // Wordmark
                  SlideTransition(
                    position: _wordSlide,
                    child: FadeTransition(
                      opacity: _wordFade,
                      child: const Text(
                        'FabroCent',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 38,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -1.2,
                          height: 1.0,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Tagline
                  FadeTransition(
                    opacity: _tagFade,
                    child: Text(
                      'M-PESA INTELLIGENCE',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.55),
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 3.5,
                      ),
                    ),
                  ),

                  const Spacer(),

                  // Loading indicator
                  FadeTransition(
                    opacity: _dotsFade,
                    child: const _PulsingDots(),
                  ),

                  SizedBox(height: size.height * 0.065),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// â”€â”€â”€ Logo badge â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class _LogoBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 112,
      height: 112,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const RadialGradient(
          colors: [Color(0xFF2E7D4F), Color(0xFF1A5C31)],
          center: Alignment(-0.3, -0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1A5C31).withValues(alpha: 0.6),
            blurRadius: 40,
            spreadRadius: 4,
          ),
          BoxShadow(
            color: Colors.white.withValues(alpha: 0.08),
            blurRadius: 1,
            spreadRadius: 1,
          ),
        ],
      ),
      padding: const EdgeInsets.all(18),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Image.asset(
          'assets/images/logo.jpeg',
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

// â”€â”€â”€ Decorative orb â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class _Orb extends StatelessWidget {
  final double diameter;
  final double opacity;
  final Color color;

  const _Orb({
    required this.diameter,
    required this.opacity,
    this.color = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: diameter,
      height: diameter,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withValues(alpha: opacity),
      ),
    );
  }
}

// â”€â”€â”€ Pulsing dots â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class _PulsingDots extends StatefulWidget {
  const _PulsingDots();

  @override
  State<_PulsingDots> createState() => _PulsingDotsState();
}

class _PulsingDotsState extends State<_PulsingDots>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (i) {
        final start = i * 0.22;
        final pulse = Tween<double>(begin: 0.28, end: 1.0).animate(
          CurvedAnimation(
            parent: _ctrl,
            curve: Interval(start, start + 0.5, curve: Curves.easeInOut),
          ),
        );
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.5),
          child: FadeTransition(
            opacity: pulse,
            child: Container(
              width: 7,
              height: 7,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.85),
              ),
            ),
          ),
        );
      }),
    );
  }
}
