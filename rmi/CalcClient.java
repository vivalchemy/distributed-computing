import java.rmi.Naming;

public class CalcClient {
  public static void main(String[] args) {
    try {
      String url = System.getenv("REMOTE_URL");
      if (url == null || url.isEmpty()) {
        url = "rmi://localhost:1099/CalcService";
      }

      CalcInterface calc = (CalcInterface) Naming.lookup(url);

      System.out.println("Addition: 10 + 5 : " + calc.add(10, 5));
      System.out.println("Subtraction: 10 - 5 : " + calc.sub(10, 5));
      System.out.println("Multiplication: 10 * 5 : " + calc.mul(10, 5));
      System.out.println("Division: 10 / 5 : " + calc.div(10, 5));
    } catch (Exception e) {
      e.printStackTrace();
    }
  }
}
