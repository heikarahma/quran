import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/services/audio_player_service.dart';
import '../../../../data/repositories/quran_repository.dart';
import 'qari_modal.dart';

class MiniAudioPlayer extends StatelessWidget {
  const MiniAudioPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.palette;

    return Consumer<AudioPlayerService>(
      builder: (context, audio, child) {
        if (audio.currentAyah == null) {
          return const SizedBox.shrink();
        }

        final ayah = audio.currentAyah!;
        final surah = QuranRepository().getSurahByNumber(ayah.surahNumber);
        final surahLabel = surah?.nameLatin ?? "Surah #${ayah.surahNumber}";
        final progress = audio.duration.inMilliseconds > 0
            ? (audio.position.inMilliseconds / audio.duration.inMilliseconds)
                .clamp(0.0, 1.0)
            : 0.0;

        return SafeArea(
          top: false,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: p.cardElevated,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: audio.errorMessage != null
                    ? AppColors.rubyRed.withValues(alpha: 0.7)
                    : p.accent.withValues(alpha: 0.45),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: p.isDark ? 0.4 : 0.16),
                  blurRadius: 14,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(16)),
                  child: LinearProgressIndicator(
                    value: audio.isLoading ? null : progress,
                    backgroundColor: p.border,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      audio.errorMessage != null ? AppColors.rubyRed : p.accent,
                    ),
                    minHeight: 3,
                  ),
                ),
                if (audio.errorMessage != null)
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    child: Row(
                      children: [
                        const Icon(Icons.wifi_off_rounded,
                            size: 18, color: AppColors.rubyRed),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            audio.errorMessage!,
                            style: AppTypography.caption(color: p.textPrimary),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        TextButton(
                          onPressed: () => audio.retryCurrent(),
                          child: Text("Coba Lagi",
                              style: TextStyle(color: p.accent)),
                        ),
                        IconButton(
                          icon:
                              Icon(Icons.close_rounded, size: 18, color: p.textDim),
                          onPressed: () => audio.stop(),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                  )
                else
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () => QariModal.show(context),
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: p.accent.withValues(alpha: 0.15),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.person_pin_circle_rounded,
                                size: 20, color: p.accent),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: InkWell(
                            onTap: () => QariModal.show(context),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "$surahLabel : Ayat ${ayah.ayahNumber}",
                                  style:
                                      AppTypography.title(color: p.textPrimary)
                                          .copyWith(fontSize: 13),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  audio.currentQari.name,
                                  style:
                                      AppTypography.caption(color: p.accentSoft)
                                          .copyWith(fontSize: 11),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () => audio.cycleSpeed(),
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 3),
                            decoration: BoxDecoration(
                              color: p.surface,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: p.border),
                            ),
                            child: Text(
                              "${audio.speed}x",
                              style: TextStyle(
                                color: p.accentLight,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        IconButton(
                          icon: Icon(
                            Icons.repeat_one_rounded,
                            size: 19,
                            color: audio.repeatAyah ? p.accent : p.textDim,
                          ),
                          tooltip: "Ulangi Ayat",
                          onPressed: () => audio.toggleRepeatAyah(),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                        const SizedBox(width: 6),
                        IconButton(
                          icon: Icon(
                            Icons.skip_previous_rounded,
                            size: 22,
                            color: audio.hasPrevious ? p.textPrimary : p.textDim,
                          ),
                          onPressed: audio.hasPrevious
                              ? () => audio.previousAyah()
                              : null,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                        const SizedBox(width: 6),
                        IconButton(
                          icon: audio.isLoading
                              ? SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: p.accent,
                                  ),
                                )
                              : Icon(
                                  audio.isPlaying
                                      ? Icons.pause_circle_filled_rounded
                                      : Icons.play_circle_filled_rounded,
                                  size: 34,
                                  color: p.accent,
                                ),
                          onPressed: () => audio.togglePlayPause(),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                        const SizedBox(width: 6),
                        IconButton(
                          icon: Icon(
                            Icons.skip_next_rounded,
                            size: 22,
                            color: audio.hasNext ? p.textPrimary : p.textDim,
                          ),
                          onPressed:
                              audio.hasNext ? () => audio.nextAyah() : null,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                        const SizedBox(width: 4),
                        IconButton(
                          icon:
                              Icon(Icons.close_rounded, size: 18, color: p.textDim),
                          onPressed: () => audio.stop(),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
