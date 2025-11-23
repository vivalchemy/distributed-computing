public interface ClockSyncAlgorithm {

  // Common number of processes
  int N = 3;

  String getName();

  void reset();

  void simulate();

}
