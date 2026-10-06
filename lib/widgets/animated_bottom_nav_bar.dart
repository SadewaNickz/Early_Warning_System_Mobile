import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class NavItemData {
  final IconData icon;
  final IconData activeIcon;
  final String label;

  const NavItemData({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}

class AnimatedEwsNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final List<NavItemData> items;

  const AnimatedEwsNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: const Border(
          top: BorderSide(color: AppTheme.border, width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 12,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(items.length, (index) {
              final isSelected = currentIndex == index;
              final item = items[index];

              return Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    if (!isSelected) {
                      HapticFeedback.selectionClick();
                      onTap(index);
                    }
                  },
                  child: AnimatedNavButton(
                    item: item,
                    isSelected: isSelected,
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class AnimatedNavButton extends StatelessWidget {
  final NavItemData item;
  final bool isSelected;

  const AnimatedNavButton({
    super.key,
    required this.item,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Animated Circular Bubble with Float/Elevation & Scale
        TweenAnimationBuilder<double>(
          tween: Tween<double>(
            begin: isSelected ? 0.0 : 1.0,
            end: isSelected ? 1.0 : 0.0,
          ),
          duration: const Duration(milliseconds: 280),
          curve: Curves.easeOutBack,
          builder: (context, value, child) {
            // value is 0.0 when inactive, 1.0 when active
            final translateY = -4.0 * value; // lift up by 4px
            final scale = 1.0 + (0.12 * value); // scale up to 1.12x

            return Transform.translate(
              offset: Offset(0, translateY),
              child: Transform.scale(
                scale: scale,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: isSelected
                        ? const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color(0xFF138568),
                              Color(0xFF1EA885),
                            ],
                          )
                        : null,
                    color: isSelected ? null : Colors.transparent,
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: AppTheme.brandGreen.withOpacity(0.35 * value),
                              blurRadius: 10 * value,
                              offset: Offset(0, 4 * value),
                            ),
                          ]
                        : null,
                  ),
                  child: Center(
                    child: Icon(
                      isSelected ? item.activeIcon : item.icon,
                      size: 21,
                      color: isSelected ? Colors.white : AppTheme.textMuted,
                    ),
                  ),
                ),
              ),
            );
          },
        ),

        const SizedBox(height: 3),

        // Animated Text Label
        AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeInOut,
          style: GoogleFonts.dmSans(
            fontSize: 10.5,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected ? AppTheme.brandGreen : AppTheme.textMuted,
          ),
          child: Text(
            item.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),

        const SizedBox(height: 2),

        // Animated Active Dot Indicator
        AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          width: isSelected ? 4 : 0,
          height: isSelected ? 4 : 0,
          decoration: BoxDecoration(
            color: isSelected ? AppTheme.brandGreen : Colors.transparent,
            shape: BoxShape.circle,
          ),
        ),
      ],
    );
  }
}
