public class Process {
  private final int id;
  private boolean active;

  public Process(int id) {
    this.id = id;
    this.active = true;
  }

  public int getId() {
    return id;
  }

  public boolean isActive() {
    return active;
  }

  public void crash() {
    active = false;
    System.out.println("P" + id + " crashed.");
  }

  public void recover() {
    active = true;
    System.out.println("P" + id + " recovered.");
  }

  @Override
  public String toString() {
    return "P" + id + (active ? " (active)" : " (inactive)");
  }
}
