import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../controllers/converter_controller.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ConverterController(),
      child: const _HomePageView(),
    );
  }
}

class _HomePageView extends StatefulWidget {
  const _HomePageView();

  @override
  State<_HomePageView> createState() => _HomePageViewState();
}

class _HomePageViewState extends State<_HomePageView> {
  final TextEditingController _inputController = TextEditingController();
  final TextEditingController _classNameController = TextEditingController(
    text: 'MyModel',
  );

  @override
  void dispose() {
    _inputController.dispose();
    _classNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ConverterController>();
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('JsonConverter')),
      body: Row(
        children: [
          // Left Side: Input
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.all(16),
              color: Theme.of(context).scaffoldBackgroundColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text('JSON Input', style: textTheme.titleLarge),
                      const SizedBox(width: 16),
                      // Class Name Input
                      Expanded(
                        child: TextField(
                          decoration: const InputDecoration(
                            labelText: 'Class Name',
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            isDense: true,
                          ),
                          onChanged: controller.updateClassName,
                          controller: _classNameController,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: TextField(
                      controller: _inputController,
                      onChanged: controller.updateInput,
                      maxLines: null,
                      expands: true,
                      textAlignVertical: TextAlignVertical.top,
                      style: TextStyle(
                        fontFamily: 'Consolas',
                        color: colorScheme.onSurface,
                        fontSize: 14,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Paste your JSON here...',
                        errorText: controller.error, // Shows format error
                        errorStyle: const TextStyle(
                          color: Colors.redAccent,
                          fontSize: 13,
                        ),
                        errorBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.redAccent),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Divider
          Container(width: 1, color: Colors.white12),

          // Right Side: Output
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.all(16),
              color: colorScheme.surface,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Dart Output', style: textTheme.titleLarge),
                      ElevatedButton.icon(
                        onPressed: controller.dartOutput.isEmpty
                            ? null
                            : () {
                                Clipboard.setData(
                                  ClipboardData(text: controller.dartOutput),
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Copied to clipboard!'),
                                  ),
                                );
                              },
                        icon: const Icon(Icons.copy, size: 18),
                        label: const Text('Copy'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.transparent),
                      ),
                      child: SingleChildScrollView(
                        child: SelectableText(
                          controller.dartOutput.isEmpty
                              ? '// Generated code will appear here...'
                              : controller.dartOutput,
                          style: TextStyle(
                            fontFamily: 'Consolas',
                            color: colorScheme.onSurface,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
