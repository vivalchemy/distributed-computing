import java.util.ArrayList;
import java.util.List;

public class Ring implements ElectionAlgorithm {

  private final List<Process> processes;
  private int coordinatorId;

  public Ring(int count) {
    processes = new ArrayList<>();
    for (int i = 1; i <= count; i++) {
      processes.add(new Process(i));
    }
    coordinatorId = count;
  }

  @Override
  public String getName() {
    return "Ring";
  }

  @Override
  public void startElection(int initiatorId) {
    System.out.println("\n[Ring] Election started by P" + initiatorId);

    List<Integer> electionMessage = new ArrayList<>();
    int n = processes.size();
    int current = initiatorId - 1;

    do {
      Process p = processes.get(current);

      if (p.isActive()) {
        electionMessage.add(p.getId());
        System.out.println("P" + p.getId() + " adds itself to election message.");
      }

      current = (current + 1) % n;

    } while (current != initiatorId - 1);

    coordinatorId = electionMessage.stream().max(Integer::compare).orElse(-1);
    System.out.println("[Ring] Coordinator elected: P" + coordinatorId);
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
    System.out.println("\n=== Ring Algorithm Status ===");
    processes.forEach(System.out::println);
    System.out.println("Coordinator: P" + coordinatorId);
  }
}
