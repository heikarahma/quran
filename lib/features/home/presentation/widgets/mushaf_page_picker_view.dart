import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../mushaf/presentation/screens/mushaf_page_screen.dart';

class MushafPagePickerView extends StatelessWidget {
  final double bottomPadding;

  const MushafPagePickerView({
    super.key,
    this.bottomPadding = 16,
  });

  @override
  Widget build(BuildContext context) {
    final p = context.palette;

    return GridView.builder(
      padding: EdgeInsets.fromLTRB(16, 16, 16, bottomPadding),
      physics: const BouncingScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 0.9,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: 604,
      itemBuilder: (context, index) {
        final pageNum = index + 1;
        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => MushafPageScreen(initialPage: pageNum),
              ),
            );
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            decoration: BoxDecoration(
              color: p.card,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: p.border,
                width: 1,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.auto_stories_rounded,
                  size: 20,
                  color: p.accent,
                ),
                const SizedBox(height: 6),
                Text(
                  "$pageNum",
                  style: TextStyle(
                    color: p.textPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                Text(
                  "Hal.",
                  style: AppTypography.caption(color: p.textDim)
                      .copyWith(fontSize: 10),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
