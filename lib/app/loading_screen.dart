import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  final String message;
  final bool hasError;
  final String? errorDetails;

  const LoadingScreen({
    super.key,
    required this.message,
    this.hasError = false,
    this.errorDetails,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFFEF3C7), // amber-50
                Colors.white,
                Color(0xFFFED7AA), // orange-50
              ],
            ),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (!hasError) ...[
                    const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF78350F)),
                    ),
                    const SizedBox(height: 32),
                  ] else ...[
                    const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                  ],
                  Text(
                    message,
                    style: TextStyle(
                      fontSize: hasError ? 20 : 16,
                      fontWeight: hasError ? FontWeight.bold : FontWeight.normal,
                      color: const Color(0xFF78350F),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  if (errorDetails != null) ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        errorDetails!,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.red,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
