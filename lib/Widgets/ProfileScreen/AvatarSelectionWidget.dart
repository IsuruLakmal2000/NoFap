import 'package:flutter/material.dart';
import 'package:nofap/Theme/colors.dart';

class AvatarSelectionSheet extends StatelessWidget {
  final Function(String) onAvatarSelected;

  AvatarSelectionSheet({required this.onAvatarSelected});

  @override
  Widget build(BuildContext context) {
    final List<String> avatars = [
      'Assets/Avatars/avatar1.jpg',
      'Assets/Avatars/avatar2.jpg',
      'Assets/Avatars/avatar3.jpg',
      'Assets/Avatars/avatar4.jpg',
      'Assets/Avatars/avatar5.jpg',
      'Assets/Avatars/avatar6.jpg',
      'Assets/Avatars/avatar7.jpg',
    ];

    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Select an Avatar',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.darkGray,
            ),
          ),
          SizedBox(height: 20),
          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 10,
              mainAxisSpacing: 20,
            ),
            itemCount: avatars.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap:
                    () => onAvatarSelected(
                      avatars[index].split('/').last.split('.').first,
                    ),
                child: CircleAvatar(
                  backgroundImage: AssetImage(avatars[index]),
                  radius: 40,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
