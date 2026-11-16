import 'package:demo1/features/resources/data/models/water_io.dart';

abstract class IrrigationRepository {
  Future<IrrigationSnapshot> getSnapshot();
}
