import amqp from "amqplib";

export const amqpUrl = "amqp://user:password@localhost:5672";
export const exchange = "logs";

export const connect = async () => {
  try {
    const connection = await amqp.connect(amqpUrl);
    const channel = await connection.createChannel();

    await channel.assertExchange(exchange, "fanout", { durable: false });

    console.log("Connected to RabbitMQ.");

    return { connection, channel };
  } catch (err) {
    console.error("Failed to connect to RabbitMQ:", err);
    process.exit(1);
  }
};

export const disconnect = async (connection) => {
  if (!connection) return;

  // amqplib sets this when closing starts
  if (connection.connectionClosing) {
    console.log("Connection already closing.");
    return;
  }

  console.log("Closing RabbitMQ connection...");
  try {
    await connection.close();
  } catch (err) {
    if (err.message === "Connection closing") {
      console.log("Connection was already closing.");
    } else {
      console.log("Error while closing connection", err);
      process.exit(1);
    }
  }
};

