import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../controllers/counter_controller.dart';

class CounterPage extends ConsumerWidget {
  const CounterPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    // Watch the counter state
    final count = ref.watch(counterControllerProvider);
    final counterText = ref.watch(counterTextProvider);
    final asyncCount = ref.watch(asyncCounterProvider);
    final countWithOffset = ref.watch(counterWithOffsetProvider(5));

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.counterExample),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Main Counter Display
            Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Text(
                      counterText,
                      style: Theme.of(context).textTheme.headlineMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            ref.read(counterControllerProvider.notifier).decrement();
                          },
                          child: const Icon(Icons.remove),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            ref.read(counterControllerProvider.notifier).reset();
                          },
                          child: Text(l10n.reset),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            ref.read(counterControllerProvider.notifier).increment();
                          },
                          child: const Icon(Icons.add),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Async Counter Display
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      l10n.asyncCounter,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    asyncCount.when(
                      data: (value) => Text(
                        '${l10n.value}: $value',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      loading: () => const CircularProgressIndicator(),
                      error: (error, stack) => Text(
                        'خطأ: $error',
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Counter with Offset Display
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      l10n.counterWithOffset,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${l10n.value}: $countWithOffset',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Set Value Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      l10n.setCustomValue,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: l10n.enterValue,
                              border: const OutlineInputBorder(),
                            ),
                            onSubmitted: (value) {
                              final intValue = int.tryParse(value);
                              if (intValue != null) {
                                ref.read(counterControllerProvider.notifier)
                                    .setValue(intValue);
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () {
                            ref.read(counterControllerProvider.notifier).setValue(100);
                          },
                          child: Text(l10n.set100),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 