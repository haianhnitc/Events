import 'package:flutter/material.dart';

class FeatureEvent extends StatelessWidget {
  const FeatureEvent({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Sự kiện nổi bật',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  height: 28 / 18,
                  fontWeight: FontWeight.w700),
            ),
            Row(
              children: [
                Text('Tất cả',
                    style: TextStyle(
                        color: Color(0xff06B6D4),
                        fontSize: 14,
                        height: 20 / 14,
                        fontWeight: FontWeight.w400)),
                Icon(Icons.chevron_right_rounded,
                    color: Color(0xff06B6D4), size: 16)
              ],
            )
          ],
        ),
        SizedBox(height: 16),
      ],
    );
  }
}
