import 'package:flutter/material.dart';
import 'package:nofap/Theme/colors.dart';

class Frameselectionwidget extends StatelessWidget {
  final Function(String) onFrameSelected;

  Frameselectionwidget({required this.onFrameSelected});

  @override
  Widget build(BuildContext context) {
    final List<String> frames = [
      'Assets/Frames/frame1.png',
      'Assets/Frames/frame2.png',
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
            itemCount: frames.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap:
                    () => onFrameSelected(
                      frames[index].split('/').last.split('.').first,
                    ),
                child: CircleAvatar(
                  backgroundImage: AssetImage(frames[index]),
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
