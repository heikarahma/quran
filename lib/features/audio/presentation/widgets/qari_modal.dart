import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/services/audio_player_service.dart';
import '../../../../data/datasources/quran_dataset.dart';

class QariModal extends StatelessWidget {
  const QariModal({super.key});

  static void show(BuildContext context) {
    final p = context.palette;
    showModalBottomSheet(
      context: context,
      backgroundColor: p.card,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => const QariModal(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final audio = Provider.of<AudioPlayerService>(context);
    final p = context.palette;

    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: p.textDim.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Icon(Icons.record_voice_over_rounded,
                      color: p.accent, size: 22),
                  const SizedBox(width: 10),
                  Text(
                    "Pilih Qari Murottal",
                    style: AppTypography.headingMedium(color: p.textPrimary),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              ...QuranDataset.allQaris.map((qari) {
                final isSelected = audio.currentQari.id == qari.id;
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? p.accent.withValues(alpha: 0.12)
                        : p.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? p.accent : p.border,
                      width: isSelected ? 1.2 : 1,
                    ),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: isSelected ? p.accent : p.border,
                      child: Text(
                        qari.name.substring(0, 1),
                        style: TextStyle(
                          color: isSelected
                              ? (p.isDark ? Colors.black : Colors.white)
                              : p.textPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Text(
                      qari.name,
                      style: AppTypography.title(
                        color: isSelected ? p.accentLight : p.textPrimary,
                      ).copyWith(fontSize: 14),
                    ),
                    subtitle: Text(
                      qari.englishName,
                      style: AppTypography.caption(color: p.textDim),
                    ),
                    trailing: isSelected
                        ? Icon(Icons.check_circle_rounded, color: p.accent)
                        : null,
                    onTap: () {
                      audio.setQari(qari);
                      Navigator.pop(context);
                    },
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
