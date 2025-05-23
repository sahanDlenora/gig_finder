import 'dart:ui';

import 'package:flutter/material.dart';

class ProfileElement extends StatelessWidget {
  final String profileElementName;
  final IconData iconName;
  const ProfileElement({
    super.key,
    required this.profileElementName,
    required this.iconName,
  });

  @override
 
            SizedBox(
              width: 12,
            ),
         Text(
              profileElementName,
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.black54),
            ),
          ],
        ),
        Text(
          ">",
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w600,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }
}
