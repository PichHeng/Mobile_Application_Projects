import 'package:demo1/features/resources/data/models/fertilizer_dosing.dart';

abstract class DosingRepository {
  Future<DosingSnapshot> getSnapshot();
}
