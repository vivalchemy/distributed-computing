import java.io.*;
import java.net.*;
import java.util.Scanner;

public class ChatClient {
  private static final String SERVER_ADDRESS = "localhost";
  private static final int SERVER_PORT = 8888;

  // ANSI color codes
  private static final String RESET = "\u001B[0m";
  private static final String CURRENT_USER_COLOR = "\u001B[32m"; // Green
  private static final String SYSTEM_COLOR = "\u001B[33m"; // Yellow
  private static final String DELETE_PREVIOUS_LINE = "\u001B[F\u001B[2K";

  private static String currentUserHash;

  public static void main(String[] args) {
    try {
      Socket socket = new Socket(SERVER_ADDRESS, SERVER_PORT);
      System.out.println(SYSTEM_COLOR + "Connected to chat server" + RESET);

      BufferedReader in = new BufferedReader(new InputStreamReader(socket.getInputStream()));
      PrintWriter out = new PrintWriter(socket.getOutputStream(), true);

      // Start thread to receive messages from server
      Thread receiverThread = new Thread(() -> {
        try {
          String message;
          while ((message = in.readLine()) != null) {
            if (message.startsWith("QUIT")) {
              System.out.println(SYSTEM_COLOR + "Server went offline ;(" + RESET);
              break;
            }

            if (message.startsWith("USERID:")) {
              currentUserHash = message.substring(7);
              String userId = currentUserHash.substring(0, 6);
              System.out.println(SYSTEM_COLOR + "Your user ID: " + userId + RESET);
            } else if (message.startsWith("HISTORY:")) {
              String historyMsg = message.substring(8);
              printColoredMessage(historyMsg);
            } else if (message.startsWith("MESSAGE:")) {
              String chatMessage = message.substring(8);
              printColoredMessage(chatMessage);
            }
          }
        } catch (IOException e) {
          System.err.println("Disconnected from server");
        }
      });
      receiverThread.start();

      // Main thread reads user input and sends messages
      Scanner scanner = new Scanner(System.in);
      System.out.println(SYSTEM_COLOR + "You can start chatting now. Type your messages below:" + RESET);

      while (true) {
        String userInput = scanner.nextLine();
        if (userInput.equalsIgnoreCase("/quit")) {
          break;
        }
        System.out.print(DELETE_PREVIOUS_LINE);
        out.println("MSG:" + userInput);
      }

      socket.close();
      System.out.println(SYSTEM_COLOR + "Disconnected" + RESET);

      scanner.close();
    } catch (IOException e) {
      System.err.println("Error connecting to server: " + e.getMessage());
    }
  }

  private static void printColoredMessage(String message) {
    if (currentUserHash == null) {
      System.out.println(message);
      return;
    }

    // Extract user ID from message (first 6 characters before colon)
    if (message.contains(":")) {
      String userId = message.substring(0, Math.min(6, message.indexOf(":")));
      String currentUserId = currentUserHash.substring(0, 6);

      if (userId.equals(currentUserId)) {
        // Current user's message - green
        System.out.println(CURRENT_USER_COLOR + message + RESET);
      } else {
        // Other user's message - cyan
        System.out.println(message);
      }
    } else {
      System.out.println(message);
    }
  }
}
