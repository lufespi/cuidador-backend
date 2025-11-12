import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class StepIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const StepIndicator({
    super.key,
    required this.currentStep,
    this.totalSteps = 3,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalSteps, (index) {
        // Step está ativo se for menor ou igual ao currentStep
        final isActive = index <= currentStep;
        return Container(
          width: 32,
          height: 4,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: isActive ? AppColors.buttonPrimary : AppColors.textDisabled.withAlpha(76),
            borderRadius: BorderRadius.circular(2),
          ),
        );
      }),
    );
  }
}