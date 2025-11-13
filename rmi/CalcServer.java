import java.rmi.RemoteException;
import java.rmi.server.UnicastRemoteObject;
import java.rmi.Naming;
import java.rmi.registry.LocateRegistry;

class CalcService extends UnicastRemoteObject implements CalcInterface {
  public CalcService() throws RemoteException {
    super();
  }

  public long add(long a, long b) throws RemoteException {
    return a + b;
  }

  public long sub(long a, long b) throws RemoteException {
    return a - b;
  }

  public long mul(long a, long b) throws RemoteException {
    return a * b;
  }

  public long div(long a, long b) throws RemoteException {
    return a / b;
  }
}

public class CalcServer {
  public static void main(String[] args) {
    String url = System.getenv("REMOTE_URL");
    if (url == null || url.isEmpty()) {
      url = "rmi://localhost:1099/CalcService";
    }
    try {
      LocateRegistry.createRegistry(1099);
      CalcService calc = new CalcService();

      Naming.rebind(url, calc);
      System.out.println("Calculator Server is running...");
    } catch (Exception e) {
      e.printStackTrace();
    }
  }
}
