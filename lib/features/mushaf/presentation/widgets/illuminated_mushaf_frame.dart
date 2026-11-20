import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/arabic_numbers.dart';

class IlluminatedMushafFrame extends StatelessWidget {
  final Widget child;
  final String surahName;
  final int juzNumber;
  final int pageNumber;
  final bool isOpeningPage;

  const IlluminatedMushafFrame({
    super.key,
    required this.child,
    required this.surahName,
    required this.juzNumber,
    required this.pageNumber,
    this.isOpeningPage = false,
  });

  @override
  Widget build(BuildContext context) {
    final p = context.palette;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: p.mushafBg,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: p.isDark ? 0.35 : 0.14),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: CustomPaint(
        painter: MushafBorderPainter(isOpeningPage: isOpeningPage),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isOpeningPage ? 24.0 : 18.0,
            vertical: isOpeningPage ? 22.0 : 14.0,
          ),
          child: Column(
            children: [
              _buildPageHeader(),
              const SizedBox(height: 8),
              Expanded(child: child),
              const SizedBox(height: 8),
              _buildPageFooter(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPageHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppColors.mushafBorderGold.withValues(alpha: 0.4),
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              "سُورَةُ $surahName",
              style: const TextStyle(
                fontFamily: 'Amiri',
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: AppColors.mushafBorderNavy,
              ),
              overflow: TextOverflow.ellipsis,
              textDirection: TextDirection.rtl,
            ),
          ),
          Text(
            "الْجُزْءُ ${ArabicNumbers.convert(juzNumber)}",
            style: const TextStyle(
              fontFamily: 'Amiri',
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: AppColors.mushafBorderNavy,
            ),
            textDirection: TextDirection.rtl,
          ),
        ],
      ),
    );
  }

  Widget _buildPageFooter() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
            decoration: BoxDecoration(
              border: Border.all(
                color: AppColors.mushafBorderGold.withValues(alpha: 0.55),
                width: 0.9,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              "${ArabicNumbers.convert(pageNumber)} ($pageNumber)",
              style: const TextStyle(
                fontFamily: 'Amiri',
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppColors.mushafBorderNavy,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MushafBorderPainter extends CustomPainter {
  final bool isOpeningPage;

  MushafBorderPainter({this.isOpeningPage = false});

  @override
  void paint(Canvas canvas, Size size) {
    final goldPaint = Paint()
      ..color = AppColors.mushafBorderGold
      ..style = PaintingStyle.stroke
      ..strokeWidth = isOpeningPage ? 3.0 : 1.5;

    final tealPaint = Paint()
      ..color = AppColors.mushafBorderTeal
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final outerRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(6, 6, size.width - 12, size.height - 12),
      const Radius.circular(12),
    );
    canvas.drawRRect(outerRect, goldPaint);

    final innerRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(10, 10, size.width - 20, size.height - 20),
      const Radius.circular(8),
    );
    canvas.drawRRect(innerRect, tealPaint);

    if (isOpeningPage) {
      _drawCornerOrnament(canvas, 10, 10, 1, 1);
      _drawCornerOrnament(canvas, size.width - 10, 10, -1, 1);
      _drawCornerOrnament(canvas, 10, size.height - 10, 1, -1);
      _drawCornerOrnament(canvas, size.width - 10, size.height - 10, -1, -1);
    }
  }

  void _drawCornerOrnament(
      Canvas canvas, double x, double y, double sx, double sy) {
    final path = Path();
    path.moveTo(x, y);
    path.lineTo(x + (sx * 24), y);
    path.quadraticBezierTo(x + (sx * 12), y + (sy * 12), x, y + (sy * 24));
    path.close();

    final paint = Paint()
      ..color = AppColors.mushafBorderGold
      ..style = PaintingStyle.fill;
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant MushafBorderPainter oldDelegate) =>
      oldDelegate.isOpeningPage != isOpeningPage;
}
