import java.util.Arrays;
import java.util.Queue;
import java.util.LinkedList;

public class SuzukiKasami implements ClockSyncAlgorithm {

  private int[] RN = new int[N];
  private int[] LN = new int[N];
  private Queue<Integer> queue = new LinkedList<>();
  private int tokenHolder = 0;

  @Override
  public String getName() {
    return "Suzuki–Kasami";
  }

  @Override
  public void reset() {
    Arrays.fill(RN, 0);
    Arrays.fill(LN, 0);
    queue.clear();
    tokenHolder = 0;
  }

  private void requestCS(int pid) {
    System.out.println("P" + pid + " requests CS");
    RN[pid]++;

    for (int i = 0; i < N; i++) {
      RN[i] = Math.max(RN[i], RN[pid]);
    }

    processPendingRequests();

    if (tokenHolder == pid) {
      enterCS(pid);
      exitCS(pid);
      processPendingRequests();
    }
  }

  private void processPendingRequests() {
    int holder = tokenHolder;

    for (int j = 0; j < N; j++) {
      if (j != holder && RN[j] == LN[j] + 1) {
        if (!queue.contains(j))
          queue.add(j);
      }
    }

    if (!queue.isEmpty() && tokenHolder == holder) {
      int next = queue.poll();
      System.out.println("Token passed P" + holder + " → P" + next);
      tokenHolder = next;
    }
  }

  private void enterCS(int pid) {
    System.out.println("P" + pid + " ENTER CS");
    LN[pid] = RN[pid];
  }

  private void exitCS(int pid) {
    System.out.println("P" + pid + " EXIT CS");
  }

  @Override
  public void simulate() {
    reset();

    requestCS(1);
    requestCS(0);
    requestCS(2);
    requestCS(1);
  }
}
