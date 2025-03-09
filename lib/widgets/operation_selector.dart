import 'package:flutter/material.dart';

class OperationSelector extends StatelessWidget {
  final String selectedOperation;
  final void Function(String) onOperationSelected;

  const OperationSelector({
    super.key,
    required this.selectedOperation,
    required this.onOperationSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildOperationButton('+'),
        _buildOperationButton('-'),
      ],
    );
  }

  Widget _buildOperationButton(String operation) {
    final isSelected = operation == selectedOperation;
    return InkWell(
      onTap: () => onOperationSelected(operation),
      borderRadius: BorderRadius.circular(30),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Text(
          operation,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.white : Colors.blue,
          ),
        ),
      ),
    );
  }
} 