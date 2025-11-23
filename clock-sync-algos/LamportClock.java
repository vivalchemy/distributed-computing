import java.util.Arrays;

public class LamportClock implements ClockSyncAlgorithm {

  private int[] clock = new int[N];

  @Override
  public String getName() {
    return "Lamport Clock";
  }

  @Override
  public void reset() {
    Arrays.fill(clock, 0);
  }

  private void local(int pid, String msg) {
    clock[pid]++;
    System.out.println("P" + pid + " local: " + msg + " | Clock=" + clock[pid]);
  }

  private void send(int sender, int receiver) {
    clock[sender]++;
    System.out.println("P" + sender + " → P" + receiver + " | ts=" + clock[sender]);
    receive(receiver, clock[sender]);
  }

  private void receive(int receiver, int ts) {
    clock[receiver] = Math.max(clock[receiver], ts) + 1;
    System.out.println("P" + receiver + " received | Clock=" + clock[receiver]);
  }

  @Override
  public void simulate() {
    reset();
    local(0, "Start");
    send(0, 1);
    local(1, "Process");
    send(1, 2);
    local(2, "Finalize");
    send(2, 0);
    local(0, "Done");
  }
}
