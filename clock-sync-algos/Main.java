public class Main {
  private static void simulateAlgorithm(ClockSyncAlgorithm algo) {
    System.out.println("\n====== Simulating " + algo.getName() + " Algorithm ======");
    algo.reset();
    algo.simulate();
    System.out.println("===================================================");
  }

  public static void main(String[] args) {
    ClockSyncAlgorithm suzuki = new SuzukiKasami();
    ClockSyncAlgorithm lamport = new LamportClock();

    simulateAlgorithm(lamport);
    simulateAlgorithm(suzuki);
  }
}
