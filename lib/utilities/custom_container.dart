import 'package:flutter/material.dart';

class CustomContainer extends StatelessWidget {
  // Styling Properties
  final String? text;
  final String? title;
  final Widget? child;

  // Container Styling
  final double borderRadius;
  final Color? backgroundColor;
  final Color? borderColor;
  final double? borderWidth;

  // Inner Stroke Properties
  final double? innerStrokeWidth;
  final Color? innerStrokeColor;
  final bool innerStrokeInset;

  // Shadow Properties
  final BoxShadow? outerShadow;
  final List<BoxShadow>? innerShadows;

  // Gradient Options
  final Gradient? gradient;

  // Text Styling
  final TextStyle? titleStyle;
  final TextStyle? textStyle;

  // Layout Properties
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;
  final BoxConstraints? constraints;

  // Alignment and Positioning
  final AlignmentGeometry? alignment;
  final CrossAxisAlignment? crossAxisAlignment;

  // Interaction Properties
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  // Animation Properties
  final Duration? animationDuration;
  final Curve? animationCurve;

  const CustomContainer({
    Key? key,
    this.text,
    this.title,
    this.child,
    this.borderRadius = 8.0,
    this.backgroundColor,
    this.borderColor,
    this.borderWidth,
    this.innerStrokeWidth,
    this.innerStrokeColor,
    this.innerStrokeInset = false,
    this.outerShadow,
    this.innerShadows,
    this.gradient,
    this.titleStyle,
    this.textStyle,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.constraints,
    this.alignment = Alignment.centerLeft,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.onTap,
    this.onLongPress,
    this.animationDuration = const Duration(milliseconds: 300),
    this.animationCurve = Curves.easeInOut,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Create content widget
    Widget content = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: crossAxisAlignment!,
      children: [
        // Title section
        if (title != null)
          Text(
            title!,
            style: titleStyle ??
                TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.titleLarge?.color,
                ),
          ),

        // Spacing between title and content
        if (title != null && (text != null || child != null))
          const SizedBox(height: 8),

        // Text section
        if (text != null)
          Text(
            text!,
            style: textStyle ??
                TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                ),
          ),

        // Child widget
        if (child != null) child!,
      ],
    );

    // Wrap with gesture detector if interactions are defined
    Widget containerWidget = GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: AnimatedContainer(
        duration: animationDuration!,
        curve: animationCurve!,
        width: width,
        height: height,
        margin: margin ?? const EdgeInsets.all(8.0),
        padding: padding ?? const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: backgroundColor,
          gradient: gradient,
          borderRadius: BorderRadius.circular(borderRadius),

          // Outer Shadow
          boxShadow: [
            // Outer shadow if provided, else default subtle shadow
            if (outerShadow != null) outerShadow!,
            if (outerShadow == null)
              BoxShadow(
                color: Colors.black12,
                offset: const Offset(0, 4),
                blurRadius: 6,
                spreadRadius: 1,
              ),
          ],

          // Border Styling
          border: _buildBorderStyle(),
        ),
        child: Container(
          decoration: BoxDecoration(
            // Inner shadows
            boxShadow: innerShadows ?? [],
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          child: content,
        ),
      ),
    );

    return containerWidget;
  }

  // Build border style with optional inner stroke
  Border? _buildBorderStyle() {
    // Outer border
    Border? outerBorder = borderColor != null
        ? Border.all(
            color: borderColor!,
            width: borderWidth ?? 1.0,
          )
        : null;

    // Inner stroke
    Border? innerStroke = innerStrokeWidth != null && innerStrokeColor != null
        ? Border.all(
            color: innerStrokeColor!,
            width: innerStrokeWidth!,
            strokeAlign: innerStrokeInset
                ? BorderSide.strokeAlignInside
                : BorderSide.strokeAlignCenter,
          )
        : null;

    // Combine borders if both exist
    if (outerBorder != null && innerStroke != null) {
      return Border.merge(outerBorder, innerStroke);
    }

    return outerBorder ?? innerStroke;
  }

  // Advanced shadow builders
  static BoxShadow softOuterShadow({
    Color? color,
    double elevation = 4.0,
  }) {
    return BoxShadow(
      color: color ?? Colors.black26,
      offset: Offset(0, elevation),
      blurRadius: elevation * 1.5,
      spreadRadius: 1,
    );
  }

  static BoxShadow innerShadowTop({
    Color? color,
    double elevation = 2.0,
  }) {
    return BoxShadow(
      color: color ?? Colors.black12,
      offset: Offset(0, -elevation),
      blurRadius: elevation,
      spreadRadius: -elevation,
    );
  }

  static BoxShadow innerShadowBottom({
    Color? color,
    double elevation = 2.0,
  }) {
    return BoxShadow(
      color: color ?? Colors.black12,
      offset: Offset(0, elevation),
      blurRadius: elevation,
      spreadRadius: -elevation,
    );
  }
}
