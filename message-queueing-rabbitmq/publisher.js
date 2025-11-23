import { connect, disconnect, exchange} from "./utils.js";

const sendMessageToChannel = (channel, msg) => {
  if (channel) {
    channel.publish(exchange, "", Buffer.from(msg));
  } else {
    console.error("Channel is not available. Cannot send message.");
  }
};

const main = async () => {
  const { connection, channel } = await connect();

  process.stdin.on("data", (data) => {
    const msg = data.toString().trim();
    if (msg) sendMessageToChannel(channel, msg);
  });

  process.on("SIGINT", async () => {
    await disconnect(connection);
    process.exit(0);
  });
};

main();
