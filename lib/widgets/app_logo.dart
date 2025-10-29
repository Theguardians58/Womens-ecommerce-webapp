import 'package:flutter/material.dart';

/// AppLogo renders the brand mark from assets and adapts its appearance
/// to the current theme. It tints the image to harmonize with the
/// color scheme while preserving contrast.
class AppLogo extends StatelessWidget {
  const AppLogo({super.key, this.size = 160, this.assetPath = 'assets/icons/dreamflow_icon.jpg', this.monochrome = false});

  /// Visual size of the logo square.
  final double size;

  /// Path to the logo asset (PNG/JPG). Default uses assets/icons/dreamflow_icon.jpg
  final String assetPath;

  /// If true, applies a single-color tint based on theme primary.
  /// If false, uses a subtle modulation to keep some original tones.
  final bool monochrome;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final baseTint = scheme.brightness == Brightness.dark
        ? scheme.primary
        : scheme.tertiary; // warmer tint in light mode

    // Background panel for elegance and consistency across screens
    return Semantics(
      label: 'Brand logo',
      image: true,
      child: Container(
        height: size,
        width: size,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(size * 0.18),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              baseTint.withValues(alpha: 0.16),
              scheme.secondary.withValues(alpha: 0.10),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 22,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        alignment: Alignment.center,
        child: ColorFiltered(
          colorFilter: ColorFilter.mode(
            monochrome ? baseTint : baseTint.withValues(alpha: 0.65),
            monochrome ? BlendMode.srcATop : BlendMode.modulate,
          ),
          child: Image.asset(
            assetPath,
            fit: BoxFit.cover,
            filterQuality: FilterQuality.high,
            errorBuilder: (context, error, stackTrace) {
              // Graceful fallback if the asset isn't available yet
              return _LogoFallback(size: size * 0.5);
            },
          ),
        ),
      ),
    );
  }
}

class _LogoFallback extends StatelessWidget {
  const _LogoFallback({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      color: scheme.surface,
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.auto_awesome, color: scheme.primary, size: size * 0.6),
          SizedBox(width: size * 0.08),
          Text(
            'ShéaRose',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: scheme.onSurface,
                  fontWeight: FontWeight.w700,
                ),
          ),
        ],
      ),
    );
  }
}
