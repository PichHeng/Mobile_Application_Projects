import 'package:demo1/features/resources/data/models/usage_series.dart';

String comparisonLabel(UsagePeriod period) => switch (period) {
  UsagePeriod.today => 'vs yesterday',
  UsagePeriod.week => 'vs previous 7 days',
  UsagePeriod.month => 'vs previous 30 days',
};
