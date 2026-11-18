import 'package:demo1/features/resources/data/models/usage_series.dart';
import 'package:demo1/features/resources/presentation/widgets/usage_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

const _series = UsageSeries(
  points: [UsagePoint('a', 1.5), UsagePoint('b', 2.5)],
  previousTotal: 5,
);

Widget _card({
  UsageSeries? series = _series,
  bool hasError = false,
  ValueChanged<UsagePeriod>? onPeriodChanged,
  VoidCallback? onRetry,
  Widget? Function(UsageSeries)? trailingBuilder,
  String? Function(UsageSeries)? captionBuilder,
  Widget? Function(UsageSeries)? footerBuilder,
}) {
  return MaterialApp(
    home: Scaffold(
      body: SingleChildScrollView(
        child: UsageCard(
          title: 'Test usage',
          period: UsagePeriod.today,
          onPeriodChange: onPeriodChanged ?? (_) {},
          series: series,
          hasError: hasError,
          onRetry: onRetry ?? () {},
          unit: 'kWh',
          chartBuilder: (_) => const Text('the chart'),
          trailingBuilder: trailingBuilder,
          captionBuilder: captionBuilder,
          footerBuilder: footerBuilder,
        ),
      ),
    ),
  );
}

void main() {
  testWidgets('shows a spinner while the series is null', (tester) async {
    await tester.pumpWidget(_card(series: null));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('the chart'), findsNothing);
  });

  testWidgets('shows the total, the unit and the chart', (tester) async {
    await tester.pumpWidget(_card());

    expect(find.text('4'), findsOneWidget);
    expect(find.text('kWh'), findsOneWidget);
    expect(find.text('the chart'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('an error shows Try again which calls onRetry', (tester) async {
    var retries = 0;
    await tester.pumpWidget(
      _card(hasError: true, series: null, onRetry: () => retries++),
    );

    expect(find.text('Could not load data'), findsOneWidget);
    expect(find.text('the chart'), findsNothing);

    await tester.tap(find.text('Try again'));

    expect(retries, 1);
  });

  testWidgets('tapping 7 days reports the week period', (tester) async {
    UsagePeriod? chosen;
    await tester.pumpWidget(_card(onPeriodChanged: (p) => chosen = p));

    await tester.tap(find.text('7 days'));

    expect(chosen, UsagePeriod.week);
  });

  testWidgets('optional parts appear when given', (tester) async {
    await tester.pumpWidget(
      _card(
        trailingBuilder: (_) => const Text('the trailing'),
        captionBuilder: (_) => 'the caption',
        footerBuilder: (_) => const Text('the footer'),
      ),
    );

    expect(find.text('the trailing'), findsOneWidget);
    expect(find.text('the caption'), findsOneWidget);
    expect(find.text('the footer'), findsOneWidget);
  });

  testWidgets('optional parts that return null are not shown', (tester) async {
    await tester.pumpWidget(
      _card(
        trailingBuilder: (_) => null,
        captionBuilder: (_) => null,
        footerBuilder: (_) => null,
      ),
    );

    expect(find.text('the chart'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
