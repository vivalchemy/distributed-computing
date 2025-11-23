import java.util.ArrayList;
import java.util.List;

public class Bully implements ElectionAlgorithm {

  private final List<Process> processes;
  private int coordinatorId;

  public Bully(int count) {
    processes = new ArrayList<>();
    for (int i = 1; i <= count; i++) {
      processes.add(new Process(i));
    }
    coordinatorId = count; // highest ID starts as coordinator
  }

  @Override
  public String getName() {
    return "Bully";
  }

  @Override
  public void startElection(int initiatorId) {
    System.out.println("\n[Bully] Election started by P" + initiatorId);

    boolean higherFound = false;

    for (int id = initiatorId + 1; id <= processes.size(); id++) {
      Process p = processes.get(id - 1);
      if (p.isActive()) {
        System.out.println("P" + id + " responds: OK");
        higherFound = true;
        startElection(id);
        return;
      }
    }

    if (!higherFound) {
      coordinatorId = initiatorId;
      System.out.println("P" + initiatorId + " becomes the NEW Coordinator!");
    }
  }

  @Override
  public int getCoordinator() {
    return coordinatorId;
  }

  @Override
  public void crash(int processId) {
    processes.get(processId - 1).crash();
  }

  @Override
  public void recover(int processId) {
    processes.get(processId - 1).recover();
  }

  @Override
  public void printStatus() {
    System.out.println("\n=== Bully Algorithm Status ===");
    processes.forEach(System.out::println);
    System.out.println("Coordinator: P" + coordinatorId);
  }
}
