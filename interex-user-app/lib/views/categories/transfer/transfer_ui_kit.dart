// A self-contained, modern UI kit built specifically for the money-transfer
// section (Send Money + Remittance). It intentionally does NOT reuse any of
// the app's existing input / button / card widgets — it is a fresh, standard
// design layer. It is purely presentational and never talks to any API.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:qrpaypro/language/language_controller.dart';
import 'package:qrpaypro/utils/custom_color.dart';

// ---------------------------------------------------------------------------
//  Design tokens
// ---------------------------------------------------------------------------
class TransferTokens {
  static bool get isDark => Get.isDarkMode;

  static Color get primary => CustomColor.primaryLightColor;
  static const Color accent = Color(0xFF1E9FF2);

  static Color get scaffoldBg =>
      isDark ? const Color(0xFF0B0E26) : const Color(0xFFEEF2FB);

  static Color get card => isDark ? const Color(0xFF161B3D) : Colors.white;

  static Color get field =>
      isDark ? Colors.white.withValues(alpha: 0.06) : const Color(0xFFF3F6FD);

  static Color get textPrimary =>
      isDark ? const Color(0xFFEAEEF9) : CustomColor.primaryLightTextColor;

  static Color get textMuted => textPrimary.withValues(alpha: 0.55);

  static Color get border => isDark
      ? Colors.white.withValues(alpha: 0.08)
      : primary.withValues(alpha: 0.07);

  static LinearGradient get brand => LinearGradient(
    colors: [primary, accent],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const double radius = 18;
  static const double pad = 18;

  static List<BoxShadow> get softShadow => [
    BoxShadow(
      color: primary.withValues(alpha: isDark ? 0.0 : 0.06),
      blurRadius: 24,
      offset: const Offset(0, 10),
    ),
  ];

  static TextStyle heading({double size = 16, FontWeight weight = FontWeight.w700, Color? color}) =>
      GoogleFonts.inter(fontSize: size, fontWeight: weight, color: color ?? textPrimary);

  static TextStyle body({double size = 14, FontWeight weight = FontWeight.w500, Color? color}) =>
      GoogleFonts.inter(fontSize: size, fontWeight: weight, color: color ?? textPrimary);
}

// ---------------------------------------------------------------------------
//  Translated text (mirrors the app's language pipeline, but stand-alone)
// ---------------------------------------------------------------------------
class TText extends StatelessWidget {
  const TText(
    this.textKey, {
    super.key,
    this.style,
    this.maxLines,
    this.overflow,
    this.textAlign,
  });

  final String textKey;
  final TextStyle? style;
  final int? maxLines;
  final TextOverflow? overflow;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    final lang = Get.put(LanguageController());
    return Obx(
      () => lang.isLoading
          ? const SizedBox.shrink()
          : Text(
              lang.getTranslation(textKey),
              style: style ?? TransferTokens.body(),
              maxLines: maxLines,
              overflow: overflow,
              textAlign: textAlign,
            ),
    );
  }
}

// ---------------------------------------------------------------------------
//  App bar
// ---------------------------------------------------------------------------
class TransferAppBar extends StatelessWidget implements PreferredSizeWidget {
  const TransferAppBar({super.key, required this.titleKey, this.subtitleKey});

  final String titleKey;
  final String? subtitleKey;

  @override
  Size get preferredSize => const Size.fromHeight(70);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 6),
        child: Row(
          children: [
            _CircleButton(
              icon: Icons.arrow_back_ios_new_rounded,
              onTap: () => Get.back(),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TText(titleKey, style: TransferTokens.heading(size: 18)),
                  if (subtitleKey != null)
                    TText(
                      subtitleKey!,
                      style: TransferTokens.body(
                        size: 12,
                        color: TransferTokens.textMuted,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CircleButton extends StatelessWidget {
  const _CircleButton({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: TransferTokens.card,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Icon(icon, size: 18, color: TransferTokens.textPrimary),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
//  Section card
// ---------------------------------------------------------------------------
class SectionCard extends StatelessWidget {
  const SectionCard({
    super.key,
    required this.child,
    this.titleKey,
    this.icon,
    this.trailing,
    this.padding,
  });

  final Widget child;
  final String? titleKey;
  final IconData? icon;
  final Widget? trailing;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 14),
      padding: padding ?? const EdgeInsets.all(TransferTokens.pad),
      decoration: BoxDecoration(
        color: TransferTokens.card,
        borderRadius: BorderRadius.circular(TransferTokens.radius + 6),
        border: Border.all(color: TransferTokens.border),
        boxShadow: TransferTokens.softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (titleKey != null) ...[
            Row(
              children: [
                if (icon != null) ...[
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: TransferTokens.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, size: 18, color: TransferTokens.primary),
                  ),
                  const SizedBox(width: 10),
                ],
                Expanded(
                  child: TText(
                    titleKey!,
                    style: TransferTokens.heading(size: 15),
                  ),
                ),
                if (trailing != null) trailing!,
              ],
            ),
            const SizedBox(height: 16),
          ],
          child,
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
//  Field label
// ---------------------------------------------------------------------------
class FieldLabel extends StatelessWidget {
  const FieldLabel(this.textKey, {super.key, this.trailing});
  final String textKey;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TText(
            textKey,
            style: TransferTokens.body(
              size: 12.5,
              weight: FontWeight.w600,
              color: TransferTokens.textMuted,
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
//  Plain text field (filled, borderless modern style)
// ---------------------------------------------------------------------------
class TransferTextField extends StatelessWidget {
  const TransferTextField({
    super.key,
    required this.controller,
    required this.hintKey,
    this.prefixIcon,
    this.suffix,
    this.keyboardType,
    this.inputFormatters,
    this.onChanged,
    this.onSubmitted,
    this.onTapOutside,
    this.maxLines = 1,
    this.bigText = false,
  });

  final TextEditingController controller;
  final String hintKey;
  final IconData? prefixIcon;
  final Widget? suffix;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final ValueChanged<PointerDownEvent>? onTapOutside;
  final int maxLines;
  final bool bigText;

  @override
  Widget build(BuildContext context) {
    final lang = Get.put(LanguageController());
    return Container(
      decoration: BoxDecoration(
        color: TransferTokens.field,
        borderRadius: BorderRadius.circular(TransferTokens.radius),
        border: Border.all(color: TransferTokens.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (prefixIcon != null)
            Padding(
              padding: const EdgeInsets.only(left: 14, right: 2),
              child: Icon(
                prefixIcon,
                size: 20,
                color: TransferTokens.textMuted,
              ),
            ),
          Expanded(
            child: Obx(
              () => TextField(
                controller: controller,
                keyboardType: keyboardType,
                inputFormatters: inputFormatters,
                onChanged: onChanged,
                onSubmitted: onSubmitted,
                onTapOutside: onTapOutside,
                maxLines: maxLines,
                cursorColor: TransferTokens.primary,
                style: bigText
                    ? TransferTokens.heading(size: 24, weight: FontWeight.w700)
                    : TransferTokens.body(size: 15, weight: FontWeight.w600),
                decoration: InputDecoration(
                  isDense: true,
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: prefixIcon != null ? 8 : 16,
                    vertical: maxLines > 1 ? 16 : 18,
                  ),
                  hintText: lang.isLoading ? '' : lang.getTranslation(hintKey),
                  hintStyle: TransferTokens.body(
                    size: bigText ? 22 : 15,
                    color: TransferTokens.textMuted.withValues(alpha: 0.7),
                  ),
                ),
              ),
            ),
          ),
          if (suffix != null) suffix!,
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
//  Currency pill (tap to open a picker, or static when onTap is null)
// ---------------------------------------------------------------------------
class CurrencyPill extends StatelessWidget {
  const CurrencyPill({super.key, required this.code, this.onTap});
  final String code;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
          decoration: BoxDecoration(
            gradient: TransferTokens.brand,
            borderRadius: BorderRadius.circular(TransferTokens.radius - 4),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                code.isEmpty ? '--' : code,
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (onTap != null)
                const Padding(
                  padding: EdgeInsets.only(left: 2),
                  child: Icon(
                    Icons.expand_more_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
//  Selector field (tap to open a picker)
// ---------------------------------------------------------------------------
class SelectorField extends StatelessWidget {
  const SelectorField({
    super.key,
    required this.value,
    required this.onTap,
    this.leadingIcon,
    this.badge,
  });

  final String value;
  final VoidCallback onTap;
  final IconData? leadingIcon;
  final String? badge;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 15),
        decoration: BoxDecoration(
          color: TransferTokens.field,
          borderRadius: BorderRadius.circular(TransferTokens.radius),
          border: Border.all(color: TransferTokens.border),
        ),
        child: Row(
          children: [
            if (leadingIcon != null) ...[
              Icon(leadingIcon, size: 20, color: TransferTokens.primary),
              const SizedBox(width: 10),
            ],
            Expanded(
              child: Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TransferTokens.body(size: 15, weight: FontWeight.w600),
              ),
            ),
            if (badge != null && badge!.isNotEmpty) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                decoration: BoxDecoration(
                  color: TransferTokens.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  badge!,
                  style: TransferTokens.body(
                    size: 12,
                    weight: FontWeight.w700,
                    color: TransferTokens.primary,
                  ),
                ),
              ),
              const SizedBox(width: 8),
            ],
            Icon(
              Icons.expand_more_rounded,
              color: TransferTokens.textMuted,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
//  Flow divider (directional indicator between two fields)
// ---------------------------------------------------------------------------
class FlowDivider extends StatelessWidget {
  const FlowDivider({super.key, this.icon = Icons.arrow_downward_rounded});
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        children: [
          Expanded(child: Divider(color: TransferTokens.border, thickness: 1)),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 12),
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: TransferTokens.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 16, color: TransferTokens.primary),
          ),
          Expanded(child: Divider(color: TransferTokens.border, thickness: 1)),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
//  Status pill (recipient validity)
// ---------------------------------------------------------------------------
class StatusPill extends StatelessWidget {
  const StatusPill({super.key, required this.valid, required this.message});
  final bool valid;
  final String message;

  @override
  Widget build(BuildContext context) {
    final color = valid ? const Color(0xFF2D845F) : CustomColor.redColor;
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            valid ? Icons.check_circle_rounded : Icons.error_rounded,
            size: 16,
            color: color,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: TransferTokens.body(size: 12.5, weight: FontWeight.w600, color: color),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
//  Stat row (key / value) for the limits card
// ---------------------------------------------------------------------------
class StatRow extends StatelessWidget {
  const StatRow({
    super.key,
    required this.labelKey,
    required this.value,
    this.emphasize = false,
  });

  final String labelKey;
  final String value;
  final bool emphasize;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            child: TText(
              labelKey,
              style: TransferTokens.body(
                size: 13,
                color: TransferTokens.textMuted,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TransferTokens.body(
                size: 13.5,
                weight: emphasize ? FontWeight.w700 : FontWeight.w600,
                color: emphasize
                    ? TransferTokens.primary
                    : TransferTokens.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
//  Gradient call-to-action button
// ---------------------------------------------------------------------------
class GradientButton extends StatelessWidget {
  const GradientButton({
    super.key,
    required this.labelKey,
    required this.onTap,
    this.enabled = true,
    this.loading = false,
  });

  final String labelKey;
  final VoidCallback onTap;
  final bool enabled;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final active = enabled && !loading;
    return Opacity(
      opacity: active ? 1 : 0.45,
      child: GestureDetector(
        onTap: active ? onTap : null,
        child: Container(
          height: 56,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            gradient: TransferTokens.brand,
            borderRadius: BorderRadius.circular(TransferTokens.radius),
            boxShadow: active
                ? [
                    BoxShadow(
                      color: TransferTokens.primary.withValues(alpha: 0.35),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                    ),
                  ]
                : null,
          ),
          child: loading
              ? const SizedBox(
                  height: 22,
                  width: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.4,
                    valueColor: AlwaysStoppedAnimation(Colors.white),
                  ),
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TText(
                      labelKey,
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.arrow_forward_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
//  Sticky bottom bar that hosts the CTA
// ---------------------------------------------------------------------------
class StickyBottomBar extends StatelessWidget {
  const StickyBottomBar({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
      decoration: BoxDecoration(
        color: TransferTokens.card,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(26)),
        boxShadow: [
          BoxShadow(
            color: TransferTokens.primary.withValues(alpha: 0.08),
            blurRadius: 24,
            offset: const Offset(0, -8),
          ),
        ],
      ),
      child: SafeArea(top: false, child: child),
    );
  }
}

// ---------------------------------------------------------------------------
//  Modern bottom-sheet picker
// ---------------------------------------------------------------------------
Future<void> showTransferPicker<T>({
  required BuildContext context,
  required String titleKey,
  required List<T> items,
  required String Function(T) labelOf,
  required ValueChanged<T> onSelected,
  String Function(T)? subtitleOf,
  String Function(T)? badgeOf,
}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (sheetContext) {
      return Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(sheetContext).size.height * 0.7,
        ),
        decoration: BoxDecoration(
          color: TransferTokens.card,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(26)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 42,
              height: 5,
              decoration: BoxDecoration(
                color: TransferTokens.textMuted.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Row(
                children: [
                  Expanded(
                    child: TText(
                      titleKey,
                      style: TransferTokens.heading(size: 16),
                    ),
                  ),
                  _CircleButton(
                    icon: Icons.close_rounded,
                    onTap: () => Navigator.pop(sheetContext),
                  ),
                ],
              ),
            ),
            if (items.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 36),
                child: Text(
                  '—',
                  style: TransferTokens.body(color: TransferTokens.textMuted),
                ),
              )
            else
              Flexible(
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                  shrinkWrap: true,
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (_, index) {
                    final item = items[index];
                    return Material(
                      color: TransferTokens.field,
                      borderRadius: BorderRadius.circular(TransferTokens.radius),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(
                          TransferTokens.radius,
                        ),
                        onTap: () {
                          Navigator.pop(sheetContext);
                          onSelected(item);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      labelOf(item),
                                      style: TransferTokens.body(
                                        size: 15,
                                        weight: FontWeight.w600,
                                      ),
                                    ),
                                    if (subtitleOf != null &&
                                        subtitleOf(item).isNotEmpty)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 3),
                                        child: Text(
                                          subtitleOf(item),
                                          style: TransferTokens.body(
                                            size: 12,
                                            color: TransferTokens.textMuted,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              if (badgeOf != null && badgeOf(item).isNotEmpty)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 5,
                                  ),
                                  decoration: BoxDecoration(
                                    gradient: TransferTokens.brand,
                                    borderRadius: BorderRadius.circular(9),
                                  ),
                                  child: Text(
                                    badgeOf(item),
                                    style: GoogleFonts.inter(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      );
    },
  );
}
