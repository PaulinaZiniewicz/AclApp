import 'package:flutter/material.dart';
import '../../../theme/app_decoration.dart';
import '../../../theme/custom_text_style.dart';
import '../../../theme/theme_helper.dart';
import '../../../widgets/custom_image_view.dart';

class GlobeSectionItemWidget extends StatelessWidget {
  final String iconPath;
  final String? analysisText;
  final VoidCallback? onInfoPressed;

  const GlobeSectionItemWidget({
    super.key,
    required this.iconPath,
    this.analysisText,
    this.onInfoPressed, 
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: appTheme.blueGray100,
        borderRadius: BorderRadiusStyle.roundedBorder16,
        border: Border.all(
          color: theme.colorScheme.primary, // Border color matching icon
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomImageView(
                imagePath: iconPath,
                height: 30,
                width: 30,
              ),
              if (onInfoPressed != null)
                IconButton(
                  icon: Icon(Icons.info_outline, color: theme.colorScheme.primary),
                  //Icon(Icons.more_horiz, color: Colors.grey);
                  onPressed: onInfoPressed,
                ),
            ],
          ),
          if (analysisText != null) ...[
            const SizedBox(height: 5),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  analysisText!,
                  style: CustomTextStyles.bodySmallBlueGray300,
                  overflow: TextOverflow.ellipsis, // Ellipsis for long text
                  maxLines: 10,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}



class GlobeSection extends StatelessWidget {
  final List<Map<String, String>> items; 

  const GlobeSection({
    super.key,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Liczba kolumn
        crossAxisSpacing: 16, // Odstępy między kolumnami
        mainAxisSpacing: 16, // Odstępy między wierszami
      ),
      physics: const AlwaysScrollableScrollPhysics(),
      shrinkWrap: true, // Dopasowanie do zawartości
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return GlobeSectionItemWidget(
          iconPath: item['iconPath']!,
          analysisText: item['analysisText'],
          onInfoPressed: () {
            // Akcja po kliknięciu [i]
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Info: ${item['analysisText']}')),
            );
          },
        );
      },
    );
  }
}


