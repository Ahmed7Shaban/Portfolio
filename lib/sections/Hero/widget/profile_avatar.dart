import 'package:flutter/material.dart';

class ProfileAvatar extends StatelessWidget {
  final String imagePath;

  const ProfileAvatar({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    final bool isNetworkImage = imagePath.startsWith('http');

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: CircleAvatar(
        radius: 60,
        backgroundColor: Theme.of(context).primaryColor.withOpacity(0.2),
        backgroundImage: imagePath.isNotEmpty
            ? (isNetworkImage
            ? NetworkImage(imagePath)
            : AssetImage(imagePath) as ImageProvider)
            : null,
        child: imagePath.isEmpty
            ? const Icon(
          Icons.person,
          size: 70,
          color: Colors.black54,
        )
            : null,
      ),
    );
  }
}
