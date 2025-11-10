import java.io.*;
import java.net.*;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.time.Instant;
import java.util.*;
import java.util.concurrent.*;

public class ChatServer {
  private static final int PORT = 8888;
  // thread safe ds
  private static final Set<ClientHandler> clients = ConcurrentHashMap.newKeySet();
  private static final List<String> messageHistory = new CopyOnWriteArrayList<>();

  public static void main(String[] args) {
    System.out.println("Chat Server starting on port " + PORT);

    // handle ctrl+c and stuff

    try (ServerSocket serverSocket = new ServerSocket(PORT)) {
      System.out.println("Server is running. Waiting for clients...");

      Runtime.getRuntime().addShutdownHook(new Thread(() -> {
        System.out.println("\n[Server] Shutting down...");
        shutdownServer(serverSocket);
      }));

      while (true) {
        Socket clientSocket = serverSocket.accept();
        System.out.println("New client connected: " + clientSocket.getInetAddress());

        // multithreaded client handler
        Thread.startVirtualThread(() -> {
          try {
            handleClient(clientSocket);
          } catch (Exception e) {
            System.err.println("Error handling client: " + e.getMessage());
          }
        });
      }
    } catch (IOException e) {
      System.err.println("Server error: " + e.getMessage());
    }
  }

  private static void handleClient(Socket socket) {
    try {
      BufferedReader in = new BufferedReader(new InputStreamReader(socket.getInputStream()));
      PrintWriter out = new PrintWriter(socket.getOutputStream(), true);

      // Generate unique hash based on current time
      String userHash = generateHash(Instant.now().toString() + socket.getInetAddress());
      String userId = userHash.substring(0, 6);

      // Send user ID to client
      out.println("USERID:" + userHash);

      // Send message history to new client
      for (String message : messageHistory) {
        out.println("HISTORY:" + message);
      }

      ClientHandler handler = new ClientHandler(socket, out, userId, userHash);
      clients.add(handler);

      // Announce user joined
      String joinMessage = userId + ": [joined the chat]";
      broadcastMessage(joinMessage, handler);
      messageHistory.add(joinMessage);

      // Read messages from client
      String message;
      while ((message = in.readLine()) != null) {
        if (message.startsWith("MSG:")) {
          String chatMessage = message.substring(4);
          String formattedMessage = userId + ": " + chatMessage;
          messageHistory.add(formattedMessage);
          broadcastMessage(formattedMessage, handler);
        }
      }
    } catch (IOException e) {
      System.err.println("Client disconnected: " + e.getMessage());
    } finally {
      ClientHandler handlerToRemove = null;
      for (ClientHandler handler : clients) {
        if (handler.socket == socket) {
          handlerToRemove = handler;
          break;
        }
      }
      if (handlerToRemove != null) {
        clients.remove(handlerToRemove);
        String leaveMessage = handlerToRemove.userId + ": [left the chat]";
        messageHistory.add(leaveMessage);
        broadcastMessage(leaveMessage, handlerToRemove);
      }
      try {
        socket.close();
      } catch (IOException e) {
        System.err.println("Error closing socket: " + e.getMessage());
      }
    }
  }

  private static void broadcastMessage(String message, ClientHandler sender) {
    for (ClientHandler client : clients) {
      client.out.println("MESSAGE:" + message);
    }
  }

  private static String generateHash(String input) {
    try {
      MessageDigest digest = MessageDigest.getInstance("SHA-256");
      byte[] hash = digest.digest(input.getBytes());
      StringBuilder hexString = new StringBuilder();
      for (byte b : hash) {
        String hex = Integer.toHexString(0xff & b);
        if (hex.length() == 1) hexString.append('0');
        hexString.append(hex);
      }
      return hexString.toString();
    } catch (NoSuchAlgorithmException e) {
      throw new RuntimeException(e);
    }
  }

  private static void shutdownServer(ServerSocket serverSocket) {
    try {
      if (serverSocket != null && !serverSocket.isClosed()) {
        serverSocket.close();
      }

      // Notify clients
      for (ClientHandler client : clients) {
        try {
          client.out.println("QUIT");
          client.socket.close();
        } catch (IOException ignoreException) {}
      }
      clients.clear();
      System.out.println("[Server] All clients disconnected.");
    } catch (Exception e) {
      System.err.println("[Server] Error during shutdown: " + e.getMessage());
    }
  }


  // static class has to be inside another class
  static class ClientHandler {
    Socket socket;
    PrintWriter out;
    String userId;
    String userHash;

    ClientHandler(Socket socket, PrintWriter out, String userId, String userHash) {
      this.socket = socket;
      this.out = out;
      this.userId = userId;
      this.userHash = userHash;
    }
  }
}

