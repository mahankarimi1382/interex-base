// A self-contained, modern visual design for a single recent-transaction row.
//
// This widget intentionally defines its own colour palette and typography
// instead of pulling from the global app theme, so the "Recent Transactions"
// section can have a distinct, polished look. Sizing still uses ScreenUtil so
// it stays responsive across devices.

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../language/language_controller.dart';

class RecentTransactionCard extends StatelessWidget {
  const RecentTransactionCard({
    super.key,
    required this.type,
    required this.amount,
    required this.payableAmount,
    required this.status,
    required this.dateText,
    required this.monthText,
    required this.trx,
    this.onTap,
  });

  /// Raw transaction type from the API (e.g. `add-money`, `send-money`).
  final String type;
  final String amount, payableAmount, status, dateText, monthText, trx;
  final VoidCallback? onTap;

  bool get _isDark => Get.isDarkMode;

  @override
  Widget build(BuildContext context) {
    final visual = _TxVisual.fromType(type);
    final statusStyle = _StatusStyle.fromStatus(status);

    final cardColor = _isDark
        ? const Color(0xFF161A33)
        : Colors.white;
    final titleColor = _isDark ? Colors.white : const Color(0xFF1B2138);
    final subtitleColor = _isDark
        ? Colors.white.withValues(alpha: 0.45)
        : const Color(0xFF8A90A6);

    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20.r),
          onTap: onTap,
          child: Ink(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(
                color: _isDark
                    ? Colors.white.withValues(alpha: 0.06)
                    : const Color(0xFFEDEFF5),
              ),
              boxShadow: [
                BoxShadow(
                  color: visual.gradient.first.withValues(
                    alpha: _isDark ? 0.0 : 0.08,
                  ),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              children: [
                _leadingIcon(visual),
                SizedBox(width: 12.w),
                Expanded(child: _middle(titleColor, subtitleColor)),
                SizedBox(width: 8.w),
                _trailing(visual, statusStyle, titleColor),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _leadingIcon(_TxVisual visual) {
    return Container(
      width: 46.w,
      height: 46.w,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: visual.gradient,
        ),
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: [
          BoxShadow(
            color: visual.gradient.last.withValues(alpha: 0.35),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Icon(visual.icon, color: Colors.white, size: 22.r),
    );
  }

  Widget _middle(Color titleColor, Color subtitleColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          _translatedTitle(),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: titleColor,
          ),
        ),
        SizedBox(height: 4.h),
        Row(
          children: [
            Icon(
              Icons.calendar_today_rounded,
              size: 11.r,
              color: subtitleColor,
            ),
            SizedBox(width: 4.w),
            Text(
              '$dateText $monthText',
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w500,
                color: subtitleColor,
              ),
            ),
            if (trx.isNotEmpty) ...[
              SizedBox(width: 6.w),
              Container(
                width: 3.r,
                height: 3.r,
                decoration: BoxDecoration(
                  color: subtitleColor,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 6.w),
              Flexible(
                child: Text(
                  trx,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w500,
                    color: subtitleColor,
                  ),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }

  Widget _trailing(
    _TxVisual visual,
    _StatusStyle statusStyle,
    Color titleColor,
  ) {
    final amountText = amount.isNotEmpty ? amount : payableAmount;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '${visual.isCredit ? '+' : '-'} $amountText',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w700,
            color: visual.isCredit
                ? const Color(0xFF1FAE6F)
                : titleColor,
          ),
        ),
        SizedBox(height: 6.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
          decoration: BoxDecoration(
            color: statusStyle.color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 5.r,
                height: 5.r,
                decoration: BoxDecoration(
                  color: statusStyle.color,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 4.w),
              Text(
                statusStyle.label,
                style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w600,
                  color: statusStyle.color,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _translatedTitle() {
    if (type.isEmpty) return '';
    final camel = _snakeCaseToCamelCase(
      type == 'transfer-money' ? 'transferMoneyAppL' : type,
    );
    return Get.find<LanguageController>().getTranslation(camel);
  }

  String _snakeCaseToCamelCase(String input) {
    final parts = input.split(RegExp(r'[-_]'));
    if (parts.isEmpty) return input;
    return parts.first.toLowerCase() +
        parts
            .sublist(1)
            .map((p) => p.isEmpty
                ? ''
                : p[0].toUpperCase() + p.substring(1).toLowerCase())
            .join();
  }
}

/// Maps a transaction type to an icon, a gradient and a credit/debit hint.
class _TxVisual {
  const _TxVisual(this.icon, this.gradient, this.isCredit);

  final IconData icon;
  final List<Color> gradient;
  final bool isCredit;

  factory _TxVisual.fromType(String rawType) {
    final t = rawType.toLowerCase().replaceAll(RegExp(r'[-_]'), ' ');

    bool has(List<String> keys) => keys.any(t.contains);

    if (has(['add money', 'deposit', 'receive', 'add sub'])) {
      return const _TxVisual(
        Icons.south_west_rounded,
        [Color(0xFF2BD67B), Color(0xFF14A55C)],
        true,
      );
    }
    if (has(['request'])) {
      return const _TxVisual(
        Icons.request_page_rounded,
        [Color(0xFFFF8FB1), Color(0xFFE84393)],
        true,
      );
    }
    if (has(['send', 'transfer'])) {
      return const _TxVisual(
        Icons.north_east_rounded,
        [Color(0xFF5B8DEF), Color(0xFF2F6BFF)],
        false,
      );
    }
    if (has(['withdraw', 'money out', 'moneyout', 'out'])) {
      return const _TxVisual(
        Icons.account_balance_outlined,
        [Color(0xFFFFB35C), Color(0xFFF7861F)],
        false,
      );
    }
    if (has(['bill'])) {
      return const _TxVisual(
        Icons.receipt_long_rounded,
        [Color(0xFFB48CFF), Color(0xFF8155F1)],
        false,
      );
    }
    if (has(['top up', 'topup', 'mobile'])) {
      return const _TxVisual(
        Icons.smartphone_rounded,
        [Color(0xFF4FD1C5), Color(0xFF14B8A6)],
        false,
      );
    }
    if (has(['card', 'virtual'])) {
      return const _TxVisual(
        Icons.credit_card_rounded,
        [Color(0xFF7C8CF8), Color(0xFF4F5BD5)],
        false,
      );
    }
    if (has(['remittance'])) {
      return const _TxVisual(
        Icons.public_rounded,
        [Color(0xFF45C4F0), Color(0xFF1E9FF2)],
        false,
      );
    }
    if (has(['exchange', 'swap'])) {
      return const _TxVisual(
        Icons.swap_horiz_rounded,
        [Color(0xFFFFC857), Color(0xFFF4AB2A)],
        false,
      );
    }
    if (has(['trade'])) {
      return const _TxVisual(
        Icons.trending_up_rounded,
        [Color(0xFF2BD67B), Color(0xFF0E9F6E)],
        false,
      );
    }
    if (has(['gift'])) {
      return const _TxVisual(
        Icons.card_giftcard_rounded,
        [Color(0xFFFF7A7A), Color(0xFFE84545)],
        false,
      );
    }
    if (has(['pay', 'payment', 'merchant', 'market'])) {
      return const _TxVisual(
        Icons.shopping_bag_outlined,
        [Color(0xFFA78BFA), Color(0xFF7C3AED)],
        false,
      );
    }
    return const _TxVisual(
      Icons.swap_vert_rounded,
      [Color(0xFF5B8DEF), Color(0xFF0C56DB)],
      false,
    );
  }
}

/// Maps a status string (textual or numeric) to a colour + label.
class _StatusStyle {
  const _StatusStyle(this.color, this.label);

  final Color color;
  final String label;

  factory _StatusStyle.fromStatus(String rawStatus) {
    final s = rawStatus.trim().toLowerCase();

    const green = Color(0xFF1FAE6F);
    const amber = Color(0xFFF4AB2A);
    const red = Color(0xFFDC3A3A);

    if (['success', 'successful', 'completed', 'complete', 'approved', '1']
        .contains(s)) {
      return const _StatusStyle(green, 'Success');
    }
    if (['pending', 'processing', 'progress', 'hold', '2', '0'].contains(s)) {
      return const _StatusStyle(amber, 'Pending');
    }
    if (['rejected', 'failed', 'cancel', 'cancelled', 'declined', '4', '3']
        .contains(s)) {
      return const _StatusStyle(red, 'Failed');
    }
    if (s.isEmpty) return const _StatusStyle(amber, 'Pending');
    // Unknown but non-empty: show it as-is with a neutral amber tone.
    return _StatusStyle(amber, rawStatus);
  }
}
