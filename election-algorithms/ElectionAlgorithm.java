public interface ElectionAlgorithm {
  String getName();

  void startElection(int initiatorId);

  int getCoordinator();

  void crash(int processId);

  void recover(int processId);

  void printStatus();
}
