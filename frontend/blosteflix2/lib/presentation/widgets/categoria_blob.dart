import 'package:flutter/material.dart';

class CategoriaBlob extends StatelessWidget {
  final String nombre;
  final bool isSelected;
  final VoidCallback? onTap;
  //Constructor
  const CategoriaBlob({
    super.key,
    required this.nombre,
    required this.isSelected,
    this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4.0),
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        decoration: BoxDecoration(color: isSelected ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(20.0),
          border: Border.all(
            color: isSelected ? Theme.of(context).colorScheme.onPrimary : Theme.of(context).colorScheme.onSurfaceVariant,
            width: 1.5,
          ),
        ),
        child: Text(nombre),
      ));
  }
}