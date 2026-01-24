import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:share_plus/share_plus.dart';
import '../config/theme.dart';
import '../models/quote.dart';

class ActionButtons extends StatefulWidget {
  final Quote quote;
  final bool isLiked;
  final bool isRefreshing;
  final VoidCallback onRefresh;
  final VoidCallback onLike;

  const ActionButtons({
    super.key,
    required this.quote,
    required this.isLiked,
    required this.isRefreshing,
    required this.onRefresh,
    required this.onLike,
  });

  @override
  State<ActionButtons> createState() => _ActionButtonsState();
}

class _ActionButtonsState extends State<ActionButtons>
    with SingleTickerProviderStateMixin {
  bool _copied = false;
  late AnimationController _refreshController;

  @override
  void initState() {
    super.initState();
    _refreshController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  void didUpdateWidget(ActionButtons oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isRefreshing && !oldWidget.isRefreshing) {
      _refreshController.repeat();
    } else if (!widget.isRefreshing && oldWidget.isRefreshing) {
      _refreshController.stop();
      _refreshController.reset();
    }
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  Future<void> _handleCopy() async {
    final shareText = '"${widget.quote.text}" - ${widget.quote.author}';
    await Clipboard.setData(ClipboardData(text: shareText));
    setState(() => _copied = true);

    // Reset after 2 seconds
    Future.delayed(const Duration(milliseconds: 2000), () {
      if (mounted) {
        setState(() => _copied = false);
      }
    });
  }

  Future<void> _handleShare() async {
    final shareText = '"${widget.quote.text}" - ${widget.quote.author}';
    await Share.share(shareText);
  }

  @override
  Widget build(BuildContext context) {
    final showText = AppTheme.showButtonText(context);
    final locale = Localizations.localeOf(context).languageCode;

    return Padding(
      padding: const EdgeInsets.only(top: AppDimensions.spacing32), // mt-8
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center, // justify-center
        children: [
          // New Quote Button
          // rounded-full px-6 gap-2 bg-transparent, variant="outline" size="lg"
          _OutlineButton(
            onTap: widget.isRefreshing ? null : widget.onRefresh,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                RotationTransition(
                  turns: _refreshController,
                  child: Icon(
                    LucideIcons.refreshCw,
                    size: AppDimensions.iconSm, // 16px
                    color: AppColors.foreground,
                  ),
                ),
                if (showText) ...[
                  const SizedBox(width: AppDimensions.spacing8), // gap-2
                  Text(
                    locale == 'ko' ? '새 명언' : 'New Quote',
                    style: const TextStyle(
                      fontSize: AppTypography.textSm,
                      fontWeight: FontWeight.w500,
                      color: AppColors.foreground,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: AppDimensions.spacing12), // gap-3

          // Heart Button
          _CircularIconButton(
            icon: widget.isLiked ? LucideIcons.heart : LucideIcons.heart,
            filled: widget.isLiked,
            fillColor: AppColors.heartRed,
            onTap: widget.onLike,
            semanticLabel: 'Like quote',
          ),
          const SizedBox(width: AppDimensions.spacing12),

          // Copy Button
          _CircularIconButton(
            icon: _copied ? LucideIcons.check : LucideIcons.copy,
            iconColor: _copied ? AppColors.checkGreen : null,
            onTap: _handleCopy,
            semanticLabel: 'Copy quote',
          ),
          const SizedBox(width: AppDimensions.spacing12),

          // Share Button
          _CircularIconButton(
            icon: LucideIcons.share2,
            onTap: _handleShare,
            semanticLabel: 'Share quote',
          ),
        ],
      ),
    );
  }
}

class _OutlineButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;

  const _OutlineButton({
    required this.child,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppDimensions.buttonHeightLg / 2),
      child: Container(
        height: AppDimensions.buttonHeightLg, // 44px
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.spacing24, // px-6
        ),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(AppDimensions.buttonHeightLg / 2),
          border: Border.all(color: AppColors.border),
        ),
        alignment: Alignment.center,
        child: child,
      ),
    );
  }
}

class _CircularIconButton extends StatefulWidget {
  final IconData icon;
  final bool filled;
  final Color? fillColor;
  final Color? iconColor;
  final VoidCallback? onTap;
  final String semanticLabel;

  const _CircularIconButton({
    required this.icon,
    this.filled = false,
    this.fillColor,
    this.iconColor,
    this.onTap,
    required this.semanticLabel,
  });

  @override
  State<_CircularIconButton> createState() => _CircularIconButtonState();
}

class _CircularIconButtonState extends State<_CircularIconButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeOut),
    );
  }

  @override
  void didUpdateWidget(_CircularIconButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Animate scale when heart is filled
    if (widget.filled && !oldWidget.filled) {
      _scaleController.forward().then((_) => _scaleController.reverse());
    }
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: widget.semanticLabel,
      button: true,
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(AppDimensions.buttonSizeLg / 2),
        child: Container(
          width: AppDimensions.buttonSizeLg, // 48px
          height: AppDimensions.buttonSizeLg, // 48px
          decoration: BoxDecoration(
            color: Colors.transparent,
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.border),
          ),
          alignment: Alignment.center,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Icon(
              widget.icon,
              size: AppDimensions.iconMd, // 20px
              color: widget.iconColor ??
                  (widget.filled ? widget.fillColor : AppColors.foreground),
              fill: widget.filled ? 1.0 : 0.0,
            ),
          ),
        ),
      ),
    );
  }
}
