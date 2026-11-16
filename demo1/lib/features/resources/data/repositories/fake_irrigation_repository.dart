import 'package:demo1/features/resources/data/models/water_io.dart';
import 'package:demo1/features/resources/data/repositories/irrigation_repository.dart';

class FakeIrrigationRepository implements IrrigationRepository {
  @override
  Future<IrrigationSnapshot> getSnapshot() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return const IrrigationSnapshot(
      inputs: WaterInputs(
        reservoirLitres: 620,
        reservoirCapacityLitres: 1000,
        linePressureBar: 2.1,
        flowLitresPerMin: 0,
      ),
      outputs: [
        OutputDef(
          id: 'pump',
          title: 'Main irrigation pump',
          code: 'OUT 01 · P-01',
        ),
        OutputDef(
          id: 'valve_b',
          title: 'Zone B valve',
          code: 'OUT 03 · V-B · Tomatoes',
        ),
      ],
    );
  }
}
