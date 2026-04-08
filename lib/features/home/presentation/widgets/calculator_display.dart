import 'package:flutter/material.dart';

class CalculatorDisplay extends StatelessWidget {
  final String currentInput;
  final String result;
  final String expression;
  final bool isError;

  const CalculatorDisplay({
    super.key,
    required this.currentInput,
    required this.result,
    required this.expression,
    required this.isError,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Expression display
          if (expression.isNotEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                reverse: true,
                child: Semantics(
                  label: 'Current expression: $expression',
                  child: Text(
                    expression,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontFamily: 'monospace',
                    ),
                    textAlign: TextAlign.end,
                  ),
                ),
              ),
            ),
          
          const SizedBox(height: 8),
          
          // Main display
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              reverse: true,
              child: Semantics(
                label: isError 
                    ? 'Error: $currentInput'
                    : result.isNotEmpty 
                        ? 'Result: $result'
                        : 'Input: ${currentInput.isEmpty ? "0" : currentInput}',
                child: Text(
                  _getDisplayText(),
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    color: isError 
                        ? Theme.of(context).colorScheme.error
                        : result.isNotEmpty
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.w300,
                    fontFamily: 'monospace',
                  ),
                  textAlign: TextAlign.end,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
          
          // Small indicators
          if (!isError && result.isNotEmpty && currentInput != result)
            Container(
              margin: const EdgeInsets.only(top: 8),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Tap = to confirm',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _getDisplayText() {
    if (isError) {
      return currentInput.isEmpty ? 'Error' : currentInput;
    }
    
    if (result.isNotEmpty) {
      return result;
    }
    
    return currentInput.isEmpty ? '0' : currentInput;
  }
}