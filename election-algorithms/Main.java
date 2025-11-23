public class Main {
  public static void main(String[] args) {
    ElectionAlgorithm bully = new Bully(5);
    simulate(bully);

    ElectionAlgorithm ring = new Ring(5);
    simulate(ring);
  }

  public static void simulate(ElectionAlgorithm algorithm) {
    System.out.println("\n\n----- " + algorithm.getName() + " Election Algorithm Demo -----");

    algorithm.printStatus();

    System.out.println("\nSimulating P5 crash...");
    algorithm.crash(5);
    algorithm.startElection(2);

    algorithm.printStatus();

    System.out.println("\nSimulating P5 recovery...");
    algorithm.recover(5);
    algorithm.startElection(5);

    algorithm.printStatus();
  }
}
