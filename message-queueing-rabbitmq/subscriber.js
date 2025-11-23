import { connect, disconnect, exchange } from "./utils.js";

const receiveFromChannel = async (channel, exchange) => {
  try {
    const q = await channel.assertQueue("", { exclusive: true });

    console.log(`Waiting for messages in ${q.queue}. Press CTRL+C to exit.`);

    channel.bindQueue(q.queue, exchange, "");

    channel.consume(
      q.queue,
      (msg) => {
        if (msg?.content) {
          console.log("Received:", msg.content.toString());
        }
      },
      { noAck: true },
    );
  } catch (err) {
    console.error("Failed to receive messages:", err);
  }
};

const main = async () => {
  const { connection, channel } = await connect();
  await receiveFromChannel(channel, exchange);

  process.on("SIGINT", async () => {
    await disconnect(connection);
    process.exit(0);
  });
};

main();

